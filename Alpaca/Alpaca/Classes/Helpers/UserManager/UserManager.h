//
//  UserManager.h
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define UserManagerInstance [UserManager shareInstance]

@class UserModel;
@interface UserManager : NSObject
@property (nonatomic, strong) NSString *platUserId;
@property (nonatomic, strong, nullable) NSString *platOpenid;
@property (nonatomic, strong) NSString *platUid;
@property (nonatomic, strong) NSString *platToken;
@property (nonatomic, assign) NSInteger platType;

+ (instancetype)shareInstance;


/// 获取用户是否登录
- (BOOL)user_isLogin;


/// 保存用户信息
- (void)user_saveUserInfoWithModel:(UserModel *)user isLogin:(BOOL)login;

/// 获取用户信息
- (UserModel *)user_getUserInfo;

/// 清除用户信息
- (void)user_resetUserInfo;

/// 获取用户id
- (NSString *)user_getUserId;
@end

NS_ASSUME_NONNULL_END
