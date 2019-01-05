//
//  TagsModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagsModel : BSModel

@property (nonatomic, copy)   NSString *color;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, assign) NSInteger type; //1完结 2分类


@end

NS_ASSUME_NONNULL_END
