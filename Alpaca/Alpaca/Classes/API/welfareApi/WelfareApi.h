//
//  WelfareApi.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelfareApi : NetRequest

///POST /welfare/list 福利列表
- (id)initWelfareListWithParameter:(NSDictionary *)parameter;

///POST /user/wallet 我的钱包
- (id)initUserWalletWithParameter:(NSDictionary *)parameter;

///POST /user/bookViewRecords 用户浏览记录
- (id)initUserBookViewRecordsWithParameter:(NSDictionary *)parameter;

///POST /pushMsg/info 消息通知
- (id)initPushMsgWithParameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
