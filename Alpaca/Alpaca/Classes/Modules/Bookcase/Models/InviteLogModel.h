//
//  InviteLogModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviteLogModel : BSModel
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign)NSInteger msgType;
@property (nonatomic, assign)NSInteger num;
@end

NS_ASSUME_NONNULL_END
