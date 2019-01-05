//
//  InviteLogGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "InviteLogGroupModel.h"
#import "InviteLogModel.h"
@implementation InviteLogGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[InviteLogModel class]
             };
}

@end
