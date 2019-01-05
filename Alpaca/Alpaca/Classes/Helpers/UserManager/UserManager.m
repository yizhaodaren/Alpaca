//
//  UserManager.m
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"


@implementation UserManager

+ (instancetype)shareInstance
{
    static UserManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[UserManager alloc] init];
            
        }
    });
    return instance;
}

- (BOOL)user_isLogin
{
    BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:@"user_loginStatus"];
    UserModel *user = [self user_getUserInfo];
    return status && user.userId.length;
   
}

/// 保存用户信息
- (void)user_saveUserInfoWithModel:(UserModel *)user isLogin:(BOOL)login
{
    UserModel *oldUser = [self user_getUserInfo];
    if (!user.accessToken.length && oldUser.userId.length && oldUser.accessToken.length) {
        user.accessToken = oldUser.accessToken;
    }
    if (login) {
        [Defaults setBool:login forKey:@"user_loginStatus"];
        [Defaults synchronize];
    }
    
    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"]; // 用户异常退出的bug
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:filename];
    
    
    if (status) {
        if (login) {
           // [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_USER_LOGIN object:nil];
        }
    }
    
    if (login) {
        
        NSString *alia = [NSString stringWithFormat:@"novel%@",user.userId];
        [JPUSHService setAlias:alia completion:nil seq:0];
    }else{
        [JPUSHService deleteAlias:nil seq:0];
    }

}

/// 获取用户信息
- (UserModel *)user_getUserInfo
{
    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"]; // 用户异常退出的bug
    // 读取本地缓存数据
    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    if (user) {
        return user;
    }else{
        return nil;
    }
}

/// 获取用户id
- (NSString *)user_getUserId
{
    UserModel *user = [self user_getUserInfo];
    return user.userId;
}

/// 清除用户信息
- (void)user_resetUserInfo
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_loginStatus"];
 
    NSString *filename = [NSString mol_creatNSDocumentFileWithFileName:@"mol_userInfo"];  
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:filename];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:filename error:&err];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_USER_LOGINOUT object:nil];
    [JPUSHService deleteAlias:nil seq:0];
}

@end
