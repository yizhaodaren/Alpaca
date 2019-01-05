//
//  SearchTagModel.m
//  freestyleAction
//
//  Created by ACTION on 2017/12/20.
//  Copyright © 2017年 xiaoling li. All rights reserved.
//

#import "SearchTagModel.h"

@implementation SearchTagModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"_id" : @"id", // event_id 替换key   id 被替换id
             
             };
    
}

@end
