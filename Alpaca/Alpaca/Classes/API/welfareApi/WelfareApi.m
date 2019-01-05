//
//  WelfareApi.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareApi.h"
#import "WelfareGroupModel.h"
#import "UserWalletModel.h"
#import "BookGroupModel.h"
#import "IMGroupModel.h"

typedef NS_ENUM(NSUInteger, WelfareApiType) {
    WelfareApi_List, //福利列表
    WelfareApi_Wallet, //我的钱包💰
    WelfareApi_Records, //我的钱包💰
    WelfareApi_PushMsg, //消息通知
    
};

@interface  WelfareApi()
@property (nonatomic, assign) WelfareApiType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation WelfareApi

///POST /pushMsg/info 消息通知
- (id)initPushMsgWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =WelfareApi_PushMsg;
        _parameter = parameter;
    }
    return self;
}

///POST /user/bookViewRecords 用户浏览记录
- (id)initUserBookViewRecordsWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =WelfareApi_Records;
        _parameter = parameter;
    }
    return self;
}

///POST /welfare/list 福利列表
- (id)initWelfareListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =WelfareApi_List;
        _parameter = parameter;
    }
    return self;
}

///POST /user/wallet 我的钱包
- (id)initUserWalletWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =WelfareApi_Wallet;
        _parameter = parameter;
    }
    return self;
}

- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type == WelfareApi_List) {
        return [WelfareGroupModel class];
    }else if (_type == WelfareApi_Wallet){
        return [UserWalletModel class];
    }else if (_type == WelfareApi_Records){
        return [BookGroupModel class];
    }else if (_type == WelfareApi_PushMsg){
        return [IMGroupModel class];
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
        case WelfareApi_List:
        {
            NSString *url = @"/welfare/list";
            return url;
        }
            break;
        case WelfareApi_Wallet:
        {
            NSString *url = @"/user/wallet";
            return url;
        }
            break;
        case WelfareApi_Records:
        {
            NSString *url = @"/user/bookViewRecords";
            return url;
        }
            break;
        case WelfareApi_PushMsg:
        {
            NSString *url = @"/pushMsg/info";
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
