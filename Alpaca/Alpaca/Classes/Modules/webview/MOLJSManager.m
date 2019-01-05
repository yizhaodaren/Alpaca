//
//  MOLJSManager.m
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLJSManager.h"
#import "STSystemHelper.h"
#import "MOLShareManager.h"
#import "MOLWebViewController.h"
#import "BookDetailViewController.h"
#import "BookModel.h"
#import "BSTabBarController.h"


@implementation MOLJSManager

#pragma mark - h5启动传值用户给h5
- (void)js_startWithUser {
    NSString *jsFun = [NSString stringWithFormat:@"APP_data('%@')",[self activityGetUserInfo]];
    [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}

- (NSString *)activityGetUserInfo
{
    UserModel *user = [UserManagerInstance user_getUserInfo];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"userId"] = user.userId;
    dic[@"userName"] = user.userName;
    dic[@"userAvatar"] = user.avatar;
    dic[@"userSex"] = @(user.gender);
    dic[@"userBirthday"] = user.birthDay;
    dic[@"userAge"] = user.age;
    dic[@"userUuid"] = user.userUuid;
    dic[@"appVersion"] = [STSystemHelper getApp_version];
    dic[@"accessToken"] = user.accessToken;
    dic[@"deviceId"] =[STSystemHelper getDeviceID];
    dic[@"deviceType"] =[STSystemHelper getDeviceModel];
    return [dic mj_JSONString];
}

//#pragma mark - JS调用 复制文字
- (void)shareWithCopyWord:(NSString *)jsonString
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [jsonString mj_JSONObject];
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSString *boardString = dic[@"copyString"];
        
        if (boardString.length) {
            [board setString:boardString];
            if (board == nil) {
                [OMGToast showWithText:@"复制失败!"];
                
            }else {
                [OMGToast showWithText:@"复制成功!"];
                
            }
        }

    });
}


//#pragma mark - 2.6.4 分享
- (void)shareActive:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        ShareMsgModel *moldel = [ShareMsgModel mj_objectWithKeyValues:dic];

        [[MOLShareManager share] shareWithModel:moldel];
    });
}

// js 打开 app
/*
 pageType: 1. 跳转到图书详情页 2.跳转到书城页面 3.调起微信 4.未登录  5.跳转URL
 typeId:   bookId / 跳转到书城页面1 男 2女 / 2微信
 */
- (void)openAppWithPage:(NSString *)jsonString
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        NSInteger pageType = [dic[@"pageType"] integerValue];
        NSString *typeId = dic[@"typeId"];
        NSString *pageUrl =dic[@"pageUrl"];

        if (pageType == 1) { // 图书详情
            

            BookDetailViewController *vc = [[BookDetailViewController alloc] init];
            BookModel *bookModel =[BookModel new];
            bookModel.bookId =typeId.integerValue;
            vc.model =bookModel;
            
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *str = [dic mj_JSONString];
//                NSString *jsFun = [NSString stringWithFormat:@"APP_record('%@')",str];
//                [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
//
//                }];
//            });
            
            [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
            
        }else if (pageType == 2){  // 跳转到书城页面
            
            BSTabBarController *tabBar=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
            tabBar.selectedIndex =1;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *str = [dic mj_JSONString];
//                NSString *jsFun = [NSString stringWithFormat:@"APP_record('%@')",str];
//                [self.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
//                    
//                }];
//            });
            
            
            
        }else if (pageType == 3){  // 调起微信
            
            __weak typeof(self) wself = self;
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    [OMGToast showWithText:@"" topOffset:64];
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    // 第三方登录数据(为空表示平台未提供)
                    // 发送登录请求
                   
//                    UserManagerInstance.platToken = resp.accessToken;
//                    UserManagerInstance.platUid = resp.uid;
//
//
//                    UserManagerInstance.platType = 2;
//                    UserManagerInstance.platOpenid = resp.openid;
//                    UserManagerInstance.platUid = resp.unionId;
                    
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"accessToken"] = resp.accessToken;
                    dic[@"loginType"] = @(2);
                    dic[@"uid"] = resp.uid;
                    if (resp.openid.length) {
                        dic[@"openId"] = resp.openid;
                    }
                    
                    NSString *str = [dic mj_JSONString];
                    NSString *jsFun = [NSString stringWithFormat:@"APP_record('%@')",str];
                    [wself.webView evaluateJavaScript:jsFun completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                        
                    }];
                    
                    
                }
            }];
            
            
        }else if (pageType == 4){ //未登录
            
            if (![UserManagerInstance user_isLogin]) {
                [[GlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            
        }else if (pageType == 5){ //未登录
            
            MOLWebViewController *web =[MOLWebViewController new];
            web.urlString =pageUrl;
            [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:web animated:YES];
        }
        
    });

}

///返回事件
- (void)goBackEvent:(NSString *)jsonString{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        NSInteger type = [dic[@"type"] integerValue];
        if (type ==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackToRootViewController" object:nil];
        }else{
            [self.webView goBack];
        }
    
    });
}



@end
