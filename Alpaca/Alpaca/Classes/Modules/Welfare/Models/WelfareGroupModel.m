//
//  WelfareGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareGroupModel.h"
#import "WelfareModel.h"
@implementation WelfareGroupModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[WelfareModel class]
             };
}

@end
