//
//  BMSHelper.h
//  Alpaca
//
//  Created by xujin on 2018/12/1.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMSHelper : NSObject
/**
 全局获取channel
 
 @return channel 1男 2女 
 */
+ (NSInteger)getChannel;

/**
 全局获取获取Url
 
 @return channel 1男 2女
 */
+ (NSString *)getBaseUrl;

@end

NS_ASSUME_NONNULL_END
