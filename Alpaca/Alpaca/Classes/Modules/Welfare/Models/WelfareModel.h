//
//  WelfareModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelfareModel : BSModel
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger type; //1短 2长
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign) NSInteger welfareId;

@end

NS_ASSUME_NONNULL_END
