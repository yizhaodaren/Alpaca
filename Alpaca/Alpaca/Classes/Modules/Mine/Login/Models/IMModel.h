//
//  IMModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMModel : BSModel
@property (nonatomic, copy)  NSString *info;
@property (nonatomic, assign)  NSInteger msgType;
@property (nonatomic, copy)  NSString *content;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy)  NSString *title;



@end

NS_ASSUME_NONNULL_END
