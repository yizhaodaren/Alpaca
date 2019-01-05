//
//  BSNetRequest.m
//  Alpaca
//
//  Created by xujin on 2018/11/15.
//  Copyright © 2018年 Moli. All rights reserved.
//
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                   佛祖保佑            永无Bug



#import "BSNetRequest.h"
#import "BSModel.h"
#import "UserModel.h"



@implementation BSNetRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    
    NSMutableDictionary *headerDictionary =[NSMutableDictionary dictionary];

    /*+++++++++++++自定义协议+++++++++++++*/
    UserModel *user = [UserManagerInstance user_getUserInfo];
    
    NSString *version = [STSystemHelper getApp_version];
    NSString *distinctId = [STSystemHelper getDeviceID];
   
     //md5(md5(secretKey+accessToken)+md5(version+platform)+md5(deviceId+userId)+timestamp)
    
    NSString *secretKey = @"PaQhbHy3XbH";
    
    
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    // 随机函数arc4random()使用方法
    // 获取 0 ~ 10 随机数
    int x = arc4random() % 10;
    interval +=x;
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
    
   
    
    NSString *str1 = [secretKey mol_md5WithOrigin];
    
    NSString *str2 = [[NSString stringWithFormat:@"%@%@",version,@"iOS"] mol_md5WithOrigin];
    NSString *str3 = [[NSString stringWithFormat:@"%@%@",distinctId.length?distinctId:@"",user.userId.length?user.userId:@"0"] mol_md5WithOrigin];
    NSString *ticket = [[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,timestamp] mol_md5WithOrigin];
    
    if (user && user.userId.length) {
        headerDictionary[@"x-user-id"] = user.userId;//@"1"
    }else{
        headerDictionary[@"x-user-id"] = @"0";
    }
    
    headerDictionary[@"x-version"] = version;
    headerDictionary[@"x-platform"] = @"iOS";
    headerDictionary[@"x-device-id"] = distinctId;
    headerDictionary[@"x-timestamp"] = timestamp;
    headerDictionary[@"x-ticket"] = ticket;
    headerDictionary[@"x-access-token"] = user.accessToken;
   
    /*++++++++++++++++++++++++++++++++++*/
    
    return headerDictionary;
    
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

- (BOOL)statusCodeValidator {
    return YES;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}


- (Class)modelClass
{
    return [BSModel class];
}




@end


