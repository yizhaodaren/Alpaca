//
//  IMGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "IMGroupModel.h"
#import "IMModel.h"

@implementation IMGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[IMModel class]
             };
}
@end
