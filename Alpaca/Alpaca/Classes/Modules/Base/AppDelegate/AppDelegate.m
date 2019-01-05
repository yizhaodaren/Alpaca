//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "AppDelegate+RootViewController.h"
#import "AppDelegate+Register.h"
#import "MOLUpdateView.h"
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate ()
@property (nonatomic, strong)NSArray *controllerArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *picArr;
@property (nonatomic, weak) MOLUpdateView *updateView;  // 更新view
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configServerAddress];
    
    [NetworkCollectCenter configGlobalApi];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    NSDictionary *dicinfo =[self addLog];
    dic[@"info"] =[dicinfo mj_JSONString];
    //////////////////////
    
    if (![Defaults boolForKey:SetupInit]) { //第一次安装
     //  [self configInitShelfApi];
       dic[@"dataType"]=@"2";
        
    }else{
       dic[@"dataType"]=@"1";
        
    }
    
    [NetworkCollectCenter dataLogAddLog:dic];
    
    
    [self registUMSocial];
    
    [self setRootViewController];
    
    [self app_registJpush:launchOptions];
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself listenNetWorkingPort];  // 网络监听
    });
    
    
    return YES;
}

#pragma mark - 网络监听
- (void)listenNetWorkingPort
{
    __weak typeof(self) wself = self;
    // 设置网络状态变化回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if ([Defaults integerForKey:ISDEBUG]) {
                    [wself updateVersionInfo];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkHave" object:nil];
                
            }
                NSLog(@"有网");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                if ([Defaults integerForKey:ISDEBUG]) {
                    [wself updateVersionInfo];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkHave" object:nil];
                
            }
                NSLog(@"有网");
                break;
            default:
                break;
        }
    }];
    // 启动网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}





- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self readShearPlate];
    
}

// 读取剪切板
- (void)readShearPlate
{
    NSString *pasteboardStr = [UIPasteboard generalPasteboard].string;
    NSString *code = nil;
    if ([pasteboardStr containsString:@"reward:"]) {
        code = [pasteboardStr stringByReplacingOccurrencesOfString:@"reward:" withString:@""];
    }
    
    if (code.length) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"reward_invite"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)addLog{
    
    //{"platformId":"渠道号","networdType":"连接网络的类型","phoneType":"手机型号","phoneId":"设备ID","edition":"版本号","system":"访问系统","clientPackageName":"客户端包名","type":"手机号、QQ、微信、微博"}
    
    //////////////////////
    NSMutableDictionary *dicinfo = [NSMutableDictionary dictionary];
    
    dicinfo[@"phoneId"] = [STSystemHelper getDeviceID];
    dicinfo[@"platformId"] = @"iOS";
    dicinfo[@"networdType"] = [STSystemHelper getNetworkType];
    dicinfo[@"phoneType"] = [STSystemHelper getDeviceModel];
    dicinfo[@"phoneId"] = [STSystemHelper getDeviceID];
    dicinfo[@"edition"] = [STSystemHelper getApp_version];
    dicinfo[@"system"] = [STSystemHelper getiOSSDKVersion];
    dicinfo[@"clientPackageName"] = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSInteger lastLoginType =(NSInteger)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginType"];
    
    NSString *typeStr = @"";
    
    
    switch (lastLoginType) {
            
        case 2:
            typeStr = @"微信";
            break;
        case 3:
            typeStr = @"微博";
            break;
        case 4:
            typeStr = @"qq";
            break;
        case 5:
            typeStr = @"手机号";
            break;
            
        default:
            break;
    }
    
    if (typeStr.length) {
        dicinfo[@"type"] = typeStr;
    }
    return dicinfo;
}





@end
