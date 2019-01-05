//
//  BannerGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/12/1.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BannerGroupModel.h"
#import "BannerMoel.h"
@implementation BannerGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[BannerMoel class]
             };
}
@end
