//
//  BookCityModelGroup.m
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCityModelGroup.h"
#import "BookCityModel.h"
@implementation BookCityModelGroup
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[BookCityModel class]
             };
}
@end
