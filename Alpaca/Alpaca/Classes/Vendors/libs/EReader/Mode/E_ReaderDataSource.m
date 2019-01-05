//
//  E_ReaderDataSource.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderDataSource.h"
#import "E_CommonManager.h"
#import "E_HUDView.h"
#import "E_ReaderDataSource.h"
#import "BookcaseApi.h"


@implementation E_ReaderDataSource

+ (E_ReaderDataSource *)shareInstance{
    
    static E_ReaderDataSource *dataSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        dataSource = [[E_ReaderDataSource alloc] init];
        
        
    });
    
    return dataSource;
}

- (E_EveryChapter *)openChapterModel:(BookModel *)model{
    NSUInteger index = [E_CommonManager Manager_getChapterBefore];
    
    _currentChapterIndex = index;
    
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    
    
    NSString *filePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",model.bookId,model.chapterNum];
    
    
    chapter.chapterContent = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
    
    return chapter;
}



- (E_EveryChapter *)openChapter:(NSInteger)clickChapter{
    
    ///本地存储本书当前阅读章节
    [Defaults setInteger:clickChapter forKey:[NSString stringWithFormat:@"Chapter_%ld",[E_ReaderDataSource shareInstance].currentBookId]];
    [Defaults synchronize];
    
    
    
    NSLog(@"%ld--->",[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",[E_ReaderDataSource shareInstance].currentBookId]]);
    
    ///当前章节
    _currentChapterIndex = clickChapter;
    NSLog(@"bookid:%ld---%ld",[E_ReaderDataSource shareInstance].currentBookId,_currentChapterIndex);
    
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    
    NSString *filePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,_currentChapterIndex];
    
    
    NSLog(@"%@---",[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL]);
    
    ///获取当前阅读章节信息
    chapter.chapterContent = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
    
    chapter.chapterContent =[chapter.chapterContent stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\r"];
    
    chapter.chapterContent =[NSString stringWithFormat:@"%@\n\n\b%@",[E_ReaderDataSource shareInstance].currentChapterName,chapter.chapterContent];
    
    return chapter;
    
}





- (NSUInteger)openPage{
    
    NSUInteger index = [E_CommonManager Manager_getPageBefore];
    return index;
    
}


- (E_EveryChapter *)nextChapter{
    
    if (_currentChapterIndex >= _totalChapter) {
//        [E_HUDView showMsg:@"没有更多内容了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex++;
        
        NSLog(@"第几章^^^%ld^^^",_currentChapterIndex);
        [Defaults setBool:YES forKey:DIRECTION];
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        
        return chapter;
        
    }
    
}

- (E_EveryChapter *)preChapter{
    
    if (_currentChapterIndex <= 1) {
        [E_HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex --;
        [Defaults setBool:NO forKey:DIRECTION];
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        
        return chapter;
    }
}

- (void)resetTotalString{
    
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i <  INT_MAX; i ++) {
        
        if (readTextData(i) != nil) {
            
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
            
            
        }else{
            break;
        }
    }
    
}

- (NSInteger)getChapterBeginIndex:(NSInteger)page{
    
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        
        if (readTextData(i) != nil) {
            
            index += readTextData(i).length;
            // NSLog(@"index == %ld",index);
            
        }else{
            break;
        }
    }
    return index;
}

- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
        
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
            
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++) {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                    temp ++;
                }else{
                    break;
                }
                
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
            
        }else{
            break;
        }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
    
}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender
{
    //获取1到x之间的整数
    if (sender == YES) {
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        
        return location;
        
    }
    else
    {
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
            
        }
        
        return value;
        
    }
    
    
}

static NSString *readTextData(NSUInteger index){
    
    NSUInteger nextIndex =index;
    NSUInteger upIndex =index;
    // 判断当前章节是否存在
    // 存在则直接获取本地内容
    // 不存在则获取网络数据且同步到本地
    
    NSString *filePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,index];
    
    [Defaults setInteger:index forKey:[NSString stringWithFormat:@"Chapter_%ld",[E_ReaderDataSource shareInstance].currentBookId]];
    [Defaults synchronize];
    
    __block NSString *content=@"";
    BookModel *model =[BookModel new];
    model.bookId =[E_ReaderDataSource shareInstance].currentBookId;
    model.chapterNum =index;
    
    //统计章节去重处理
    if ([Defaults integerForKey:REPEATLOGO] != index) {
        [Defaults setInteger:index forKey:REPEATLOGO];
        [NetworkCollectCenter chapterCollect:model];
    }
    
   
#pragma mark- 预缓存左中右三章
    if (index <=1) { //表示第一章
        nextIndex ++;
        for (NSInteger i= nextIndex; i<=2; i++) { //表示获取下下章节数据
            NSString *nextFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",model.bookId,i];
            
            if (![[FileManager getInstance] isFileExists:nextFilePath]) {
                [NetworkCollectCenter getChapterDataWithBookId:model.bookId chapterNum:i];
            }
        }

    }else if(index >= ([E_ReaderDataSource shareInstance].totalChapter)){ //表示最后一章
        upIndex--;
        for (NSInteger i= upIndex; i >= index-2; i--) { //表示获取下下章节数据
            NSString *upFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,i];
            
            if (![[FileManager getInstance] isFileExists:upFilePath]) {
            
                [NetworkCollectCenter getChapterDataWithBookId:model.bookId chapterNum:i];
            }

        }
        
    }else{ //表示其它章节
        upIndex--;
        nextIndex++;
        
        NSString *upFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,upIndex];
        
        if (![[FileManager getInstance] isFileExists:upFilePath]) {
            [NetworkCollectCenter getChapterDataWithBookId:model.bookId chapterNum:upIndex];
        }
        
        NSString *nextFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,nextIndex];
        
        if (![[FileManager getInstance] isFileExists:nextFilePath]) {
            [NetworkCollectCenter getChapterDataWithBookId:model.bookId chapterNum:nextIndex];
        }
    }
    
    printf("index :%ld ---%ld",index,[E_ReaderDataSource shareInstance].totalChapter);
    
    
    
    if (![[FileManager getInstance] isFileExists:filePath]) {
        

        [[NSNotificationCenter defaultCenter] postNotificationName:@"readTextData" object:[NSNumber numberWithUnsignedLong:index]];
        
        
        return content;

        
    }else{
        
        
        [E_ReaderDataSource shareInstance].currentChapterName =[Defaults objectForKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,index]];
        
         [E_ReaderDataSource shareInstance].currentChapterId =[Defaults integerForKey:[NSString stringWithFormat:@"chapterID_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,index]];
        
        
        content = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
        
        content =[content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\r"];
        
        content =[NSString stringWithFormat:@"%@\n\n\b%@",[E_ReaderDataSource shareInstance].currentChapterName,content];
        return content;
    }
    
}



@end
