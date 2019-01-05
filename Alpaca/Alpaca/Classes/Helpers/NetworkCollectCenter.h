//
//  NetworkCollectCenter.h
//  Alpaca
//
//  Created by xujin on 2018/12/11.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BookModel;
NS_ASSUME_NONNULL_BEGIN

@interface NetworkCollectCenter : NSObject

+(instancetype)shareInstance;

+(void)chapterCollect:(BookModel *)model;

+(void)configGlobalApi;

+(void)dataLogAddLog:(NSDictionary *)dic;

+(void)monitorLogAddLog:(NSDictionary *)dic;


/**
 用于缓存章节数据

 @param  参数
 */
+ (void)getChapterDataWithBookId:(NSUInteger )bookId chapterNum:(NSUInteger)chapterNum;

@end

NS_ASSUME_NONNULL_END
