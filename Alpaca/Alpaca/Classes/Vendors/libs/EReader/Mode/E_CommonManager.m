//
//  E_CommonManager.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_CommonManager.h"
#import "E_ContantFile.h"
#import "E_Mark.h"
#import "E_ReaderDataSource.h"


@implementation E_CommonManager


+ (E_ColorModel *)Manager_getReadTheme{
   
    E_ColorModel *themeModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SAVETHEME]];
   
    return themeModel;
}


+ (void)saveCurrentThemeColor:(E_ColorModel *)colorModel{
    
    [Defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:colorModel] forKey:SAVETHEME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (E_ColorModel *)Manager_getLastTheme{
    
    E_ColorModel *themeModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SAVETHEMELAST]];
    
    return themeModel;
}


+ (void)saveLastThemeColor:(E_ColorModel *)colorModel{
    
    [Defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:colorModel] forKey:SAVETHEMELAST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSUInteger)Manager_getPageBefore{
    
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVEPAGE];
    
    if (pageID == nil) {
        
        return 0;
        
    }else{
        
        return [pageID integerValue];
        
    }

}

+ (void)saveCurrentPage:(NSInteger)currentPage{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:SAVEPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (NSUInteger)Manager_getChapterBefore
{
    NSString *chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:OPEN];
    
    if (chapterID == nil) {
        
        return 0;
        
    }else{
        
        return [chapterID integerValue];
    
    }

}

+ (void)saveCurrentChapter:(NSInteger)currentChapter{
   
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (UIColor *)contentColor
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:COLOR_CONTENT];
    UIColor *color =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!color) {
        color =HEX_COLOR_ALPHA(0x000000,0.8);
    }
    return color;
}

+ (void)saveContentColor:(UIColor*)contentColor
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:contentColor] forKey:COLOR_CONTENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSUInteger)fontSize
{
    NSUInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE];
    if (fontSize == 0) {
        fontSize = 20;
    }
    return fontSize;
}

+ (void)saveFontSize:(NSUInteger)fontSize
{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:FONT_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSUInteger)lineSpace
{
    NSInteger lineSpace = [[NSUserDefaults standardUserDefaults] integerForKey:LINE_SPACE];
    if (lineSpace == 0) {
        lineSpace = 2;
    }
    return lineSpace;
}

+ (void)saveLineSpace:(NSUInteger)lineSpace
{
    [[NSUserDefaults standardUserDefaults] setValue:@(lineSpace) forKey:LINE_SPACE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 存储阅读时屏幕亮度
 
 @param readBrightness 屏幕亮度值 0 -1
 */
+ (void)saveBrightness_read:(CGFloat)readBrightness{
    [[NSUserDefaults standardUserDefaults] setValue:@(readBrightness) forKey:ERBRIGHTNESS_Read];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/**
 * 保存章节名称
 */
+ (void)saveChapterName:(NSString *)name{
    
    NSLog(@"%ld---%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterId);
    [[NSUserDefaults standardUserDefaults] setObject:name?name:@"" forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取章节名称
 */
+ (NSString *)chapterNameStr{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:CHAPTER_NAME];
    return str;
}


/**
 获取书的屏幕亮度值
 
 @return 书的屏幕亮度值
 */
+ (CGFloat)readBrightness{
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:ERBRIGHTNESS_Read];
   
    return fontSize;
}

/**
 存储手机屏幕亮度
 
 @param readBrightness 屏幕亮度值 0 -1
 */
+ (void)saveBrightness:(CGFloat)brightness{
    [[NSUserDefaults standardUserDefaults] setValue:@(brightness) forKey:BRIGHTNESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 获取屏幕亮度值
 
 @return 屏幕亮度值
 */
+ (CGFloat)brightness_{
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:BRIGHTNESS];
    
    return fontSize;
}

#pragma mark- 书签保存

+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    E_Mark *eMark = [[E_Mark alloc] init];
    eMark.markRange   = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%d",currentChapter];
    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    
    NSLog(@"chapterRange == %@",NSStringFromRange(chapterRange));
    
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:epubBookName];
            
        }else{
        
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
        }
       
       [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
           
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) && (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) && ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%d",currentChapter]])) {
        
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
                
            }
        }
    }
    
}

+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        int k = 0;
        for (int i = 0; i < oldSaveArray.count; i ++) {
             E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
            
            if ((NSRangeFromString(e.markRange).location >= currentRange.location) && (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) && [e.markChapter isEqualToString:[NSString stringWithFormat:@"%d",currentChapter]]) {
                k++;
            }else{
               // k++;
            }
        }
        if (k >= 1) {
           return YES;
        }else{
           return NO;
        }
}

+ (NSMutableArray *)Manager_getMark{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
    
    }

}



@end
