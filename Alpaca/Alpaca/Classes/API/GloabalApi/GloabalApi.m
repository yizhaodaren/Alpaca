//
//  GloabalApi.m
//  Alpaca
//
//  Created by xujin on 2018/12/11.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "GloabalApi.h"

typedef NS_ENUM(NSUInteger, GloabalApiType) {
    GloabalApi_GlobalConfig, //全局配置
    GloabalApi_Chapter, //阅读章节统计
    GloabalApi_AddLog, //上报日志
    GloabalApi_MonitorLog, //埋点日志
};

@interface  GloabalApi()
@property (nonatomic, assign) GloabalApiType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation GloabalApi

///POST /log/addOperateLog 埋点日志
- (id)initLogAddOperateLogWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =GloabalApi_MonitorLog;
        _parameter = parameter;
    }
    return self;
}

///上报日志POST /dataLog/addLog
- (id)initDataLogAddLogWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =GloabalApi_AddLog;
        _parameter = parameter;
    }
    return self;
}

///POST /config/globalConfig 全局配置
- (id)initGlobalConfigWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type =GloabalApi_GlobalConfig;
        _parameter = parameter;
    }
    return self;
}

///缓存数据章节启动统计
- (id)initChapterLaunchWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type =GloabalApi_Chapter;
        _parameter = parameter;
    }
    return self;
}

- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type == GloabalApi_Chapter) {
       
    }else if (_type == GloabalApi_GlobalConfig){
        
    }else if (_type == GloabalApi_AddLog){
        
    }
    
    return [BSModel class];
}

- (NSString *)parameterId
{
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}

- (NSString *)requestUrl
{
    switch (_type) {
        case GloabalApi_GlobalConfig:
        {
            NSString *url = @"/config/globalConfig";
            return url;
        }
            break;
        case GloabalApi_Chapter:
        {
            NSString *url = @"/chapter/chapterLaunch";
            return url;
        }
            break;
        case GloabalApi_AddLog:
        {
            NSString *url = @"/dataLog/addLog";
            return url;
        }
            break;
        case GloabalApi_MonitorLog:
        {
            NSString *url = @"/log/addOperateLog";
            return url;
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}



@end
