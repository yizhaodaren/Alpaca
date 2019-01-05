//
//  LoginApi.h
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginApi : NetRequest

/// 获取验证码
- (id)initGetPhoneCodeWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 登录（快捷登录、三方登录、密码登录、找回密码登录）
- (id)initLoginWithParameter:(NSDictionary *)parameter;

/// 用户绑定信息接口--绑定手机号和第三方
- (id)initBindUserInfoWithParameter:(NSDictionary *)parameter;

/// 用户解除绑定信息接口-1手机 2wx 3wb 4qq
- (id)initRemoveLoginInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

@end

NS_ASSUME_NONNULL_END
