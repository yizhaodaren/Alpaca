//
//  GlobalManager.m
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "GlobalManager.h"
#import "BSNavigationController.h"
#import "BSTabBarController.h"
#import "LoginViewController.h"

@implementation GlobalManager

+ (instancetype)shareGlobalManager
{
    static GlobalManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[GlobalManager alloc] init];
            
        }
    });
    return instance;
}

// 登录控制器
- (void)global_modalLogin
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:vc];
    //这个不知道是什么鬼，后期研究
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    //转场模态效果
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   
    [[self global_rootViewControl] presentViewController:nav animated:YES completion:nil];
}

// 获取根控制器
- (BSTabBarController *)global_rootViewControl
{
    BSTabBarController *tabBar = (BSTabBarController *)AppDelegateWindow.rootViewController;
    return tabBar;
}

// 获取当前控制器
- (UIViewController *)global_currentViewControl
{
    return [self currentViewController];
}

- (UIViewController *) currentViewController {
    BSTabBarController *vc = [[GlobalManager shareGlobalManager] global_rootViewControl];
    return [self findBestViewController:vc];
}

- (UINavigationController *)global_currentNavigationViewControl
{
    return [self global_currentViewControl].navigationController;
}







// 获取当前控制器
- (UIViewController *) findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}



@end
