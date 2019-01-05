//
//  AppDelegate+Register.m
//  Alpaca
//
//  Created by xujin on 2018/11/17.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "AppDelegate+Register.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "BookcaseApi.h"
#import "UITabBar+Badge.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define APPStore @"App Store"
#define UM_KEY  @"5bf2211bb465f52fe10001f5"
#define UM_WX_KEY @"wx8ab7e2a7fd7838e2"
#define UM_WX_SER @"a85bb23139e182e15cf6993de2a29bca"
#define UM_WB_KEY @"2303325118"
#define UM_WB_SER @"420c25ede85178c2ed5871afd8a59b02"
#define UM_QQ_KEY @"1107893797"


@implementation AppDelegate (Register)

/// 配置服务器HOST
- (void)configServerAddress{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    
#ifdef DEBUG
    config.baseUrl = DEBUG_SERVICE_HOST;  // 测试
    // config.cdnUrl = @"";
#else
    config.baseUrl = RELEASE_SERVICE_HOST;  // 正式
    // config.cdnUrl = @"";
#endif
}

/// 注册友盟
- (void)registUMSocial{
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
}

- (void)confitUShareSettings
{
    
    [[UMSocialManager defaultManager] openLog:NO];
    [UMConfigure initWithAppkey:UM_KEY channel:@"App Store"];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UM_WX_KEY appSecret:UM_WX_SER redirectURL:@"http://mobile.umeng.com/social"];
   
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UM_QQ_KEY/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UM_WB_KEY  appSecret:UM_WB_SER redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
   
}

#pragma mark - 极光
/// 注册极光
- (void)app_registJpush:(NSDictionary *)launchOptions
{
    
    // 初始化APNS
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

   
    // 初始化极光push
    NSString *jpushKey = @"dd58cf5f57e50ef6564e01ad";
    
    // 获取bundleId
    
    BOOL isP = YES; //生产证书
#ifdef DEBUG
    isP =NO; //开发证书
#else
    
    isP = YES; //生产证书
      jpushKey =@"03c52db3dd6ef06398416d94";
#endif
    
    
    [JPUSHService setupWithOption:launchOptions appKey:jpushKey
                          channel:APPStore
                 apsForProduction:isP
            advertisingIdentifier:nil];
    [JPUSHService setLogOFF];
    ///////////////
    
    
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification) {
        [self imStatusEvent:remoteNotification];
    }
    
    
    
    // 极光透传消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
   
}



- (void)imStatusEvent:(NSDictionary *)dic{
    
    [Defaults setBool:YES forKey:IM_NOTIF];
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_NOTIF object:dic];
    
    if (![Defaults integerForKey:ISDEBUG]) {
        [self.tabC.tabBar showBadgeOnItemIndex:4];
    }
    
}

// 极光透传
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    // 解析服务器数据
    NSDictionary *dic = notification.userInfo;
    
    [self imStatusEvent:dic];
    
    // msgType :1系统推送 2评论推送 3点赞推送 4私聊推送5关闭会话 6重新发起会话
    // type    : chat /
//    if (dic[@"_j_msgid"]) {
//        NSDictionary *ext = dic[@"extras"];
//        NSInteger type = [ext[@"msgType"] integerValue];
//        NSString *subtype = ext[@"type"];
//        NSString *chatId = ext[@"typeId"];
//
//        if (type == 4 || type == 5 || type == 6) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ALETTER_PUSH_MESSAGE" object:ext];
//        }
//        if (type != 5 && type != 6) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ALETTER_PUSH" object:nil];
//        }
//    }
    
}


#pragma mark- JPUSHRegisterDelegate



// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self imStatusEvent:userInfo];
    
   
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self imStatusEvent:userInfo];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         //[[NSNotificationCenter defaultCenter] postNotificationName:IM_NOTIF object:userInfo];
        //[JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self imStatusEvent:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:IM_NOTIF object:userInfo];
        //[JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [self imStatusEvent:userInfo];
   // [[NSNotificationCenter defaultCenter] postNotificationName:IM_NOTIF object:userInfo];
   // [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    //[[NSNotificationCenter defaultCenter] postNotificationName:IM_NOTIF object:userInfo];
   // [JPUSHService handleRemoteNotification:userInfo];
    [self imStatusEvent:userInfo];
}



// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


/// 书架初始化--app首次启动时候客户端调用加入推荐书
- (void)configInitShelfApi{
    [[[BookcaseApi alloc] initShelf:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
    
        if (code == SUCCESS_REQUEST) {
            
        }else{
           
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}



@end
