//
//  BookcaseApi.h
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookcaseApi : NetRequest

///获取用户信息
- (id)initUserInfoWithParameter:(NSDictionary *)parameter;

///POST /user/wallet 我的钱包
- (id)initUserWalletWithParameter:(NSDictionary *)parameter;

///POST 提现记录 /invite/masterLog
- (id)initInviteMasterLogWithParameter:(NSDictionary *)parameter;

///POST /book/relateRecomBooks 相关推荐列表
- (id)initRelateRecomBooksWithParameter:(NSDictionary *)parameter;

/// POST /channel/channelSetting //设置用户频道 同步服务器
- (id)initChannelSettingInfo:(NSDictionary *)parameter;

/// POST /user/openNewBag 领取新手红包
- (id)initOpenNewBagInfo:(NSDictionary *)parameter;

/// POST /user/newBagInfo 新手红包金额
- (id)initNewBagInfo:(NSDictionary *)parameter;

/// POST /shelf/init书架初始化--app首次启动时候客户端调用加入推荐书
- (id)initShelf:(NSDictionary *)parameter;

/// 加入书架
- (id)initRemoveBookcase:(NSDictionary *)parameter;

/// 获取书架列表
- (id)initGetBookListWithParameter:(NSDictionary *)parameter;

/// 同步书架
- (id)initSynchronousWithParameter:(NSDictionary *)parameter;

/// 加入书架
- (id)initPutWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 书籍详情页
- (id)initBookDetailWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 章节内容 POST /chapter/chapterInfo
- (id)initChapterInfoWithParameter:(NSDictionary *)parameter;

/// 阅读行为 POST /read/updateReadInfo
- (id)initReadUpdateReadInfoWithParameter:(NSDictionary *)parameter;


@end

NS_ASSUME_NONNULL_END
