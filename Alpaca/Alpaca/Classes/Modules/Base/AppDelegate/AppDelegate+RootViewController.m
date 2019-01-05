//
//  AppDelegate+RootViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/17.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
#import "BSTabBarController.h"
#import "PreferenceSetView.h"
#import "MOLUpdateView.h"
#import "MOLAppStartRequest.h"
#import "BSNavigationController.h"
#import "WelfareViewController.h"
#import "MOLWebViewController.h"
#import "BMSHelper.h"


@interface AppDelegate ()
@property (nonatomic, weak) MOLUpdateView *updateView;  // 更新view
@property (nonatomic, strong)NSArray *controllerArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *picArr;


@end

@implementation AppDelegate (RootViewController)

/// 设置首页跟控制器
- (void)setRootViewController{
    
    [Defaults setInteger:1 forKey: ISDEBUG];
    [self launch_checkVersionUpdate];
    [self launch_checkVersionInfo];

    
////    //试图数组
//    self.controllerArr = @[@"BookcaseViewController",@"BookCityViewController",@"MineViewController"];
//
//
//    //标题数组
//    self.titleArr = @[@"Bookcase",@"BookCity",@"Mine"];
//    //图片数组
//    self.picArr = @[@"bookshelf",@"welfare",@"user"];
//
    
    //    //试图数组
    self.controllerArr = @[@"BookcaseViewController",@"BookCityViewController",@"MOLWebViewController",@"MineViewController"];
    
    
    //标题数组 STR_Recommend Welfare
    self.titleArr = @[@"Bookcase",@"BookCity",@"STR_Recommend",@"Mine"];
    //图片数组
    self.picArr = @[@"bookshelf",@"welfare",@"featured",@"user"];
    
    self.window =[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
//
    self.tabC = BSTabBarController.new;
    [self initSystem];
    
}

- (void)initSystem{
    [self initMainTab];
    self.window.rootViewController = self.tabC;
    
    if (![Defaults integerForKey:CHANNEL]) {
        PreferenceSetView *preference =[PreferenceSetView new];
        [preference setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        [self.window.rootViewController.view addSubview: preference];
    }
    
    [self.window makeKeyAndVisible];
    
}

- (void)updateVersionInfo{
    // 获取当前版本
    NSString *version = [STSystemHelper getApp_version];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platForm"] = @"iOS";
    dic[@"version"] = version;
    
    __weak typeof(self) wself = self;
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_getSwitchActionCommentWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == SUCCESS_REQUEST) {
            
            ///////////
            NSDictionary *dic = request.responseObject[@"resBody"];
            
            NSInteger isDebug =[dic mol_jsonInteger:@"isDebug"];
            
            [Defaults setInteger:isDebug forKey:ISDEBUG];
            
            if (!isDebug) { //非提供审核模式
                
                for (NSInteger i=0; i<4; i++) {
                    if (i==2) {
                        BSNavigationController *nv =self.tabC.viewControllers[2];
                        nv.tabBarItem.title =@"福利";
                        MOLWebViewController *welfare =nv.viewControllers.firstObject;
                        welfare.from =101;
                        NSString *url =[BMSHelper getBaseUrl];
                        welfare.urlString =[NSString stringWithFormat:@"%@%@",url,WELFARE];
                        
                    }
                }
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SGAdvertScrollView" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatecontrollerUI" object:nil];
                
                
            }
        }
        
        
    } failure:^(__kindof BSNetRequest *request) {
        
    }];
    
    
}

- (void)launch_checkVersionInfo{
    
    // 获取当前版本
    NSString *version = [STSystemHelper getApp_version];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platForm"] = @"iOS";
    dic[@"version"] = version;
    
    __weak typeof(self) wself = self;
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_getSwitchActionCommentWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == SUCCESS_REQUEST) {
            
            ///////////
            NSDictionary *dic = request.responseObject[@"resBody"];
            
            NSInteger isDebug =[dic mol_jsonInteger:@"isDebug"];
            
            [Defaults setInteger:isDebug forKey:ISDEBUG];
            
            if (!isDebug) { //非提供审核模式
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SGAdvertScrollView" object:nil];
                
                for (NSInteger i=0; i<4; i++) {
                    if (i==2) {
                        BSNavigationController *nv =self.tabC.viewControllers[2];
                        nv.tabBarItem.title =@"福利";
                        
                        MOLWebViewController *welfare =nv.viewControllers.firstObject;
                        welfare.from =101;
                        NSString *url =[BMSHelper getBaseUrl];
                        welfare.urlString =[NSString stringWithFormat:@"%@%@",url,WELFARE];
                    }
                }
                
                
                
               // WelfareViewController* controller = [WelfareViewController new];
                
#if 0
                MOLWebViewController *welfare =[MOLWebViewController new];
                welfare.from =101;
                NSString *url =[BMSHelper getBaseUrl];
                welfare.urlString =[NSString stringWithFormat:@"%@%@",url,WELFARE];
                
                BSNavigationController *nv =[[BSNavigationController alloc] initWithRootViewController:welfare];
                
                
                
                nv.tabBarItem.title =@"福利";
                nv.tabBarItem.image =[UIImage imageNamed:@""];
                nv.tabBarItem.image = [[UIImage imageNamed:@"featured"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                //设置选中时的图片
                nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",@"featured"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                //设置选中时字体的颜色(也可更改字体大小)
                [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x19B898)} forState:UIControlStateSelected];
                
                NSMutableArray *arr =[NSMutableArray arrayWithArray:self.tabC.viewControllers];
                [arr insertObject:nv atIndex:2];
                self.tabC.viewControllers =arr;
#endif
                
            }
        }

          
    } failure:^(__kindof BSNetRequest *request) {
        
    }];
}

#pragma mark - Update
- (void)launch_checkVersionUpdate
{
    
    // 获取当前版本
    NSString *version = [STSystemHelper getApp_version];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platForm"] = @"iOS";
    dic[@"version"] = version;
    
    __weak typeof(self) wself = self;
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_versionCheckWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == SUCCESS_REQUEST) {
            
           
            NSDictionary *dic = request.responseObject[@"resBody"];
            
            // 跟新内容
            NSString *content = [dic mol_jsonString:@"content"];
            
            // 最新版本号
            NSString *ver_new = [dic mol_jsonString:@"version"];
            
            // 判断是否需要跟新
            if ([ver_new compare:version options:NSNumericSearch] == NSOrderedDescending) { // 需要更新
                
                /// yes 强制更新 no非强制更新
                BOOL forceUpdate = [dic mol_jsonBool:@"isImpose"];
                
                if (self.updateView) {
                    [self.updateView removeFromSuperview];
                }
                
                MOLUpdateView *updateV = [[MOLUpdateView alloc] init];
                self.updateView = updateV;
                updateV.width = KSCREEN_WIDTH;
                updateV.height = KSCREEN_HEIGHT;
                [updateV showUpdateWithVersion:ver_new content:content force:forceUpdate];
                [[[[GlobalManager shareGlobalManager] global_rootViewControl] view] addSubview:updateV];
            }
        }else{
           
        }
    } failure:^(__kindof BSNetRequest *request) {
       
    }];
}

- (void)initMainTab{
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    for(int i=0; i<self.picArr.count; i++)
    {
        Class cl=NSClassFromString(self.controllerArr[i]);
        
        UIViewController* controller = [cl new];
        
        if ([controller isKindOfClass:[MOLWebViewController class]]) {
            MOLWebViewController *vc =(MOLWebViewController *)controller;
            vc.from =101;
            NSString *url =[BMSHelper getBaseUrl];
            
            if ([Defaults integerForKey:ISDEBUG]) {
                vc.urlString =[NSString stringWithFormat:@"%@%@",url,WELFAREDEBUG];
            }else{
               vc.urlString =[NSString stringWithFormat:@"%@%@",url,WELFARE];
            }
            
            
        }
        
        BSNavigationController *nv =[[BSNavigationController alloc] initWithRootViewController:controller];
        
        NSString *titleStr =self.titleArr[i];
        
        nv.tabBarItem.title =NSLocalizedString(titleStr, nil);
        nv.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时的图片
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",self.picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时字体的颜色(也可更改字体大小)
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x19B898)} forState:UIControlStateSelected];
        
        [array addObject:nv];
        
    }
    self.tabC.viewControllers = array;
}

@end
