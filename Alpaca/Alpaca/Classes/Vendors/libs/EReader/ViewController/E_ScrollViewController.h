//
//  E_ScrollViewController.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSViewController.h"
/**
 *  放置阅读页的控制器
 */
@class BookModel;
@interface E_ScrollViewController : BSViewController

@property (nonatomic, strong)BookModel *model;
@end


