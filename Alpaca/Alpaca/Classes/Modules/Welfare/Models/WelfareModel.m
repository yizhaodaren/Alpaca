//
//  WelfareModel.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareModel.h"

@implementation WelfareModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"welfareId" : @"id", // welfareId 替换key   id 被替换id
             
             };
}


@end
