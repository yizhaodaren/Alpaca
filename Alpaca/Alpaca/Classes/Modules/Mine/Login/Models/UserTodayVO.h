//
//  UserTodayVO.h
//  Alpaca
//
//  Created by xujin on 2018/12/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserTodayVO : BSModel
@property (nonatomic, assign) NSInteger readTime; //阅读时间
@property (nonatomic, assign) NSInteger coin; //金币钱💰

@end

NS_ASSUME_NONNULL_END
