//
//  BookcaseApi.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookcaseApi.h"
#import "BookModel.h"
#import "BookGroupModel.h"
#import "InviteLogGroupModel.h"
#import "UserModel.h"



typedef NS_ENUM(NSUInteger, BookcaseApiType) {
    BookcaseApi_BookList, //我的书架
    BookcaseApi_Put, //加入书架
    BookcaseApi_Synchronous,//同步书架
    BookcaseApi_BookDetail, //书籍详情页
    BookcaseApi_ChapterInfo, //章节内容
    BookcaseApi_Remove, //移除书架
    BookcaseApi_InitShelf, //POST /shelf/init书架初始化--app首次启动时候客户端调用加入推荐书
    BookcaseApi_NewBagInfo, //新手红包金额
    BookcaseApi_OpenNewBag, //领取新手红包
    BookcaseApi_ChannelSetting, //设置用户频道 同步服务器
    BookCityApi_RelateRecomBooks,///POST /book/relateRecomBooks 相关推荐列表
    BookCityApi_InviteMasterLog, //InviteMasterLog书架提示信息
    
    BookCityApi_ReadUpdateReadInfo, //阅读行为
    BookCityApi_UserWallet, //我的钱包
    BookcaseApi_UserInfo, //获取用户信息
    
};

@interface  BookcaseApi()
@property (nonatomic, assign) BookcaseApiType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation BookcaseApi

///获取用户信息
- (id)initUserInfoWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookcaseApi_UserInfo;
        _parameter = parameter;
    }
    return self;
}

///POST /user/wallet 我的钱包
- (id)initUserWalletWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_UserWallet;
        _parameter = parameter;
    }
    return self;
}

/// 阅读行为 POST /read/updateReadInfo
- (id)initReadUpdateReadInfoWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_ReadUpdateReadInfo;
        _parameter = parameter;
    }
    return self;
}

///POST 提现记录 /invite/masterLog
- (id)initInviteMasterLogWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_InviteMasterLog;
        _parameter = parameter;
    }
    return self;
}

///POST /book/relateRecomBooks 相关推荐列表
- (id)initRelateRecomBooksWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_RelateRecomBooks;
        _parameter = parameter;
    }
    return self;
}

///POST /banner/infos/{channelCode} //获取banner信息列表
- (id)initBannerInfosWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
       // _type =;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}

/// POST /channel/channelSetting //设置用户频道 同步服务器
- (id)initChannelSettingInfo:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_ChannelSetting;
        _parameter = parameter;
        
    }
    return self;
}

/// POST /user/openNewBag 领取新手红包
- (id)initOpenNewBagInfo:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_OpenNewBag;
        _parameter = parameter;
        
    }
    return self;
}

/// POST /user/newBagInfo 新手红包金额
- (id)initNewBagInfo:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_NewBagInfo;
        _parameter = parameter;
        
    }
    return self;
}

/// POST /shelf/init书架初始化--app首次启动时候客户端调用加入推荐书
- (id)initShelf:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_InitShelf;
        _parameter = parameter;
        
    }
    return self;
}

/// 移除书架
- (id)initRemoveBookcase:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_Remove;
        _parameter = parameter;
        
    }
    return self;
}

/// 我的书架
- (id)initGetBookListWithParameter:(NSDictionary *)parameter {
    self = [super init];
    if (self) {
        _type = BookcaseApi_BookList;
        _parameter = parameter;
        
    }
    return self;
}

/// 同步
- (id)initSynchronousWithParameter:(NSDictionary *)parameter {
    self = [super init];
    if (self) {
        _type = BookcaseApi_Put;
        _parameter = parameter;
        
    }
    return self;
}



/// 加入书架
- (id)initPutWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = BookcaseApi_Put;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}


/// 书籍详情页
- (id)initBookDetailWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = BookcaseApi_BookDetail;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}

/// 章节内容 POST /chapter/chapterInfo
- (id)initChapterInfoWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookcaseApi_ChapterInfo;
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
    if (_type == BookcaseApi_BookList ||
        _type == BookCityApi_RelateRecomBooks) {
        return [BookGroupModel class];
        
    }else if (_type == BookcaseApi_BookDetail ||
              _type == BookcaseApi_ChapterInfo){
        return [BookModel class];
        
    }else if (_type == BookCityApi_InviteMasterLog){
        return [InviteLogGroupModel class];
    }else if (_type == BookcaseApi_UserInfo){
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
        case BookcaseApi_BookList:
        {
            NSString *url = @"/shelf/bookList";
            return url;
        }
            break;
        case BookcaseApi_Put:
        {
            NSString *url = @"/shelf/put/{bookId}";
            url = [url stringByReplacingOccurrencesOfString:@"{bookId}" withString:self.parameterId];
            return url;
        }
            break;
        case BookcaseApi_Synchronous:
        {
            NSString *url = @"/shelf/synchronous";
            return url;
        }
            break;
        case BookcaseApi_BookDetail:
        {
            NSString *url = @"/book/bookId/{bookId}";
            url = [url stringByReplacingOccurrencesOfString:@"{bookId}" withString:self.parameterId];
            return url;
        }
            break;
        case BookcaseApi_ChapterInfo:
        {
            NSString *url = @"/chapter/chapterInfo";
            return url;
        }
            break;
        case BookcaseApi_Remove:
        {
            NSString *url = @"/shelf/remove";
            return url;
        }
            break;
        case BookcaseApi_InitShelf:
        {
            NSString *url = @"/shelf/init";
            return url;
        }
            break;
        case BookcaseApi_NewBagInfo:
        {
            NSString *url = @"/user/newBagInfo";
            return url;
        }
            break;
        case BookcaseApi_OpenNewBag:
        {
            NSString *url = @"/user/openNewBag";
            return url;
        }
            break;
        case BookcaseApi_ChannelSetting:
        {
            NSString *url = @"/channel/channelSetting";
            return url;
        }
            break;
        case BookCityApi_RelateRecomBooks:
        {
            NSString *url = @"/book/relateRecomBooks";
            return url;
        }
            break;
            
        case BookCityApi_InviteMasterLog:
        {
            NSString *url = @"/invite/masterLog";
            return url;
        }
            break;
        case BookCityApi_ReadUpdateReadInfo:
        {
            NSString *url = @"/read/updateReadInfo";
            return url;
        }
            break;
        case BookCityApi_UserWallet:
        {
            NSString *url = @"/user/wallet";
            return url;
        }
            break;
        case BookcaseApi_UserInfo:
        {
            NSString *url = @"/user/info";
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
