//
//  GloabalApi.h
//  Alpaca
//
//  Created by xujin on 2018/12/11.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GloabalApi : NetRequest

///POST /config/globalConfig 全局配置
- (id)initGlobalConfigWithParameter:(NSDictionary *)parameter;

///缓存数据章节启动统计 POST /chapter/chapterLaunch
- (id)initChapterLaunchWithParameter:(NSDictionary *)parameter;

///上报日志POST /dataLog/addLog
- (id)initDataLogAddLogWithParameter:(NSDictionary *)parameter;

- (id)initLogAddOperateLogWithParameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
