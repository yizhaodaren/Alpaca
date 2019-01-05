//
//  CategoryModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryModel : BSModel

@property (nonatomic,assign)NSInteger cateId;//
@property (nonatomic,copy)NSString *cateName; //
@property (nonatomic,assign)NSInteger bookCount; //
@property (nonatomic,assign)BOOL selectStatus;

@end

NS_ASSUME_NONNULL_END
