//
//  BookGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/11/22.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookGroupModel.h"
#import "BookModel.h"
@implementation BookGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[BookModel class]
             };
}
@end
