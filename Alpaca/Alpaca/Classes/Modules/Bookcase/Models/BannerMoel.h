//
//  BannerMoel.h
//  Alpaca
//
//  Created by xujin on 2018/12/1.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerMoel : BSModel
@property (nonatomic, assign) NSInteger bannerType; //类型 0h5连接 1书籍 2分类
@property (nonatomic, copy) NSString *typeInfo;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger isPoint;

@end

NS_ASSUME_NONNULL_END
