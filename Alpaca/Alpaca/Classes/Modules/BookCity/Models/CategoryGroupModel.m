//
//  CategoryGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "CategoryGroupModel.h"
#import "CategoryModel.h"
@implementation CategoryGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[CategoryModel class]
             };
}
@end
