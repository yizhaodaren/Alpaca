//
//  BMSHelper.m
//  Alpaca
//
//  Created by xujin on 2018/12/1.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BMSHelper.h"
#import "UserModel.h"
@implementation BMSHelper
/**
 全局获取channel
 
 @return channel 1男 2女 字符串
 */
+ (NSInteger)getChannel{
    NSString *channel =@"";
    UserModel *userModel =[UserManagerInstance user_getUserInfo];
    if (userModel.userChannelVO.channelType) {
        channel =[NSString stringWithFormat:@"%ld",userModel.userChannelVO.channelType];
    }else{
        
        if ([Defaults integerForKey:CHANNEL]) {
            channel =[NSString stringWithFormat:@"%ld",[Defaults integerForKey:CHANNEL]];
        }

    }
    
    return channel.integerValue;
}

/**
 全局获取获取Url
 
 
 */
+ (NSString *)getBaseUrl{
    
    NSString *url=nil;
#ifdef DEBUG
    url = DEBUG_SERVICE_HOST;  // 测试
    // config.cdnUrl = @"";
#else
    url= RELEASE_SERVICE_H5_HOST;  // 正式
    // config.cdnUrl = @"";
#endif
    return url;
}

@end
