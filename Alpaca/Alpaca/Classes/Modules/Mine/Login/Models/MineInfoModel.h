//
//  MineInfoModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineInfoModel : BSModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)float money;

@end

NS_ASSUME_NONNULL_END
