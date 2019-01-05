//
//  LoginApi.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "LoginApi.h"
#import "BSModel.h"

typedef NS_ENUM(NSUInteger, LoginApiType) {
    LoginApiType_phoneCode,
    LoginApiType_login,
    LoginRequestType_bind,
    LoginRequestType_removeBind,

};

@interface LoginApi ()
@property (nonatomic, assign) LoginApiType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;

@end

@implementation LoginApi
/// 获取验证码
- (id)initGetPhoneCodeWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = LoginApiType_phoneCode;
        _parameter = parameter;
        _parameterId = parameterId;
        
    }
    return self;
}

/// 登录（快捷登录、三方登录、密码登录、找回密码登录）
- (id)initLoginWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = LoginApiType_login;
        _parameter = parameter;
    }
    return self;
}

/// 用户绑定信息接口--绑定手机号和第三方
- (id)initBindUserInfoWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = LoginRequestType_bind;
        _parameter = parameter;
    }
    return self;
}

/// 用户解除绑定信息接口-1手机 2wx 3wb 4qq
- (id)initRemoveLoginInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = LoginRequestType_removeBind;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}


- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type == LoginApiType_login) {
        return [UserModel class];
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
        case LoginApiType_login:
        {
            NSString *url = @"/login/phone";
            return url;
        }
            break;
        case LoginApiType_phoneCode:
        {
            NSString *url = @"/login/getPhoneCode/{phone}";
            url = [url stringByReplacingOccurrencesOfString:@"{phone}" withString:self.parameterId];
            return url;
        }
            break;
        case LoginRequestType_bind:
        {
            NSString *url = @"/login/bindUserInfo";
            return url;
        }
            break;
        case LoginRequestType_removeBind:
        {
            NSString *url = @"/login/removeLoginInfo/{loginType}";
            url = [url stringByReplacingOccurrencesOfString:@"{loginType}" withString:self.parameterId];
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
