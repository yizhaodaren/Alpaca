//
//  AppDelegate+Register.h
//  Alpaca
//
//  Created by xujin on 2018/11/17.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Register)<JPUSHRegisterDelegate>
/// 注册友盟
- (void)registUMSocial;

/// 配置服务器HOST
- (void)configServerAddress;

/// 书架初始化--app首次启动时候客户端调用加入推荐书
- (void)configInitShelfApi;

#pragma mark - 极光
/// 注册极光
- (void)app_registJpush:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
