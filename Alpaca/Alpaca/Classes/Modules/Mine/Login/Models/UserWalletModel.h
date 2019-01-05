//
//  UserWalletModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserWalletModel : BSModel
@property (nonatomic, assign) double canTxMoney; //现金
@property (nonatomic, assign) NSInteger inviteNum;
@property (nonatomic, assign) NSInteger unTxMoney;
@property (nonatomic, assign) NSInteger uuid;
@property (nonatomic, assign) NSInteger cleanTime;
@property (nonatomic, assign) NSInteger coin; //金币
@property (nonatomic, assign) double coinToMoney; //金币钱💰


@end

NS_ASSUME_NONNULL_END
