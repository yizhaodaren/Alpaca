//
//  ChapterItemGroupModel.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "ChapterItemGroupModel.h"
#import "ChapterItemModel.h"
@implementation ChapterItemGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[ChapterItemModel class]
             };
}
@end
