//
//  NetworkCollectCenter.m
//  Alpaca
//
//  Created by xujin on 2018/12/11.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetworkCollectCenter.h"
#import "BookModel.h"
#import "GloabalApi.h"
#import "BookcaseApi.h"

@implementation NetworkCollectCenter

+(instancetype)shareInstance{
    static id instance=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = NetworkCollectCenter.new;
    });
    return  instance;
}

+ (void)chapterCollect:(BookModel *)model{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.bookId] forKey:@"bookId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.chapterNum] forKey:@"chapterNum"];
    
    [[[GloabalApi alloc] initChapterLaunchWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            NSLog(@"获取该章节成功");
        }else{
            NSLog(@"获取该章节失败");
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
    
}

+(void)configGlobalApi{
   
    [[[GloabalApi alloc] initGlobalConfigWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            NSInteger maxSpeed =[request.responseObject[@"resBody"][@"maxSpeed"] integerValue];
            NSInteger minSpeed =[request.responseObject[@"resBody"][@"minSpeed"] integerValue];
            NSInteger adStartChapterCount =[request.responseObject[@"resBody"][@"adStartChapterCount"] integerValue];
            
            [Defaults setInteger:maxSpeed forKey:READMAXSPEED];
            [Defaults synchronize];
            [Defaults setInteger:minSpeed forKey:READMINSPEED];
            [Defaults synchronize];
            [Defaults setInteger:adStartChapterCount forKey:ADSTARTCHAPTERCOUT];
            [Defaults synchronize];
            
        }else{
            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
    
}

+(void)dataLogAddLog:(NSDictionary *)dic{
    
    [[[GloabalApi alloc] initDataLogAddLogWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败");
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}

+(void)monitorLogAddLog:(NSDictionary *)dic{
    [[[GloabalApi alloc] initLogAddOperateLogWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败");
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}


/**
 用于缓存章节数据
 */
+ (void)getChapterDataWithBookId:(NSUInteger )bookId chapterNum:(NSUInteger)chapterNum{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",bookId] forKey:@"bookId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",chapterNum] forKey:@"chapterNum"];
#if 0
    NSString *signature =[NSString new];
    NSString *secretKey = @"PaQhbHy3XbH";
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
   // 随机函数arc4random()使用方法
    // 获取 0 ~ 10 随机数
    int x = arc4random() % 10;
    interval +=x;
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
    
    signature =[signature stringByAppendingString:dic[@"bookId"]];
    signature =[signature stringByAppendingString:secretKey];
    signature =[signature stringByAppendingString:timestamp];
    signature =[signature mol_md5WithOrigin];
    
    [dic setObject:signature forKey:@"signature"];
    [dic setObject:timestamp forKey:@"timestamp"];
#endif
    [[[BookcaseApi alloc] initChapterInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            
           
            BookModel *bookDto =(BookModel *)responseModel;
            
            //设置当前书籍章节名
            [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",bookDto.bookId,bookDto.chapterNum]];
            [Defaults synchronize];
            
           
            //设置书籍章节ID
            [Defaults setInteger:bookDto.chapterId forKey:[NSString stringWithFormat:@"chapterID_%ld_%ld",bookDto.bookId,bookDto.chapterNum]];
            [Defaults synchronize];
           
            
            NSString *filePath =[NSString stringWithFormat:@"Books/%ld",bookDto.bookId];
            NSString *fileDir =[NSString stringWithString: filePath];
            
            filePath =[filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld.txt",bookDto.chapterNum]];
            
            FileManager *fileManager =[FileManager getInstance];
            
            if (![fileManager isFileExists:fileDir]) {
                
                if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                    [fileManager createDirectory: [fileManager fullFileName:fileDir]];
                    // NSLog(@"创建文件夹失败");
                }else{
                    ///创建文件夹成功
                    //写到文件中
                    NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                    
                    //if (![fileManager isFileExists:filePath]) {
                    
                    if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                        /// 写入文件失败，尝试重新写入
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            //                                    NSLog(@"写入文件失败");
                            
                        }else{
                            ///写入文件成功
                            
//                            [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                            [Defaults synchronize];
                            
//                            [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                            [Defaults synchronize];
                            
                        }
                        
                        
                    }else{
                        //写入文件成功
                        
//                        [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                        [Defaults synchronize];
                        
//                        [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                        [Defaults synchronize];
                        
                    }
                }
                
            }else{
                
                ///文件夹存在
                //写到文件中
                NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                
                //if (![fileManager isFileExists:filePath]) {
                
                if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                    /// 写入文件失败，尝试重新写入
                    if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                        //                                    NSLog(@"写入文件失败");
                        
                    }else{
                        ///写入文件成功
                        
//                        [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                        [Defaults synchronize];
                        
//                        [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                        [Defaults synchronize];
                    }

                }else{
                    //写入文件成功
                   
//                    [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                    [Defaults synchronize];
                    
//                    [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                    [Defaults synchronize];

                }
                
                //  }
            }
 
        }else{
            
        }
 
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}

@end
