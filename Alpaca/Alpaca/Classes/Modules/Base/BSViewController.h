//
//  BSViewController.h
//  Alpaca
//
//  Created by xujin on 2018/11/15.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBehaviorTypeStyle) {
    UIBehaviorTypeStyle_Normal,     //初始化
    UIBehaviorTypeStyle_Refresh,    //下拉刷新
    UIBehaviorTypeStyle_More,        //上拉加载更多
};

typedef NS_ENUM(NSInteger, CategoryTypeStyle) {
    CategoryTypeStyle_Undefine,
    CategoryTypeStyle_Male,     //
    CategoryTypeStyle_Female,    //
};

typedef NS_ENUM(NSInteger,FromFunctionTypeStyle) {
    FromFunctionType_TabBar,     //来自tabBar
    FromFunctionType_Category,   //来自分类
    FromFunctionType_Ranking,    //来自排行
};

NS_ASSUME_NONNULL_BEGIN

@interface BSViewController : UIViewController
@property (nonatomic, assign) BOOL showNavigation;

- (void)navigationLeftItemWithImageName:(NSString * _Nullable)leftImageName;

- (void)navigationLeftItemWithImageName:(NSString * _Nullable)leftImageName centerTitle:(NSString * _Nullable ) title titleColor:(UIColor * _Nullable)color;

- (void)navigationLeftItemWithImageName:(NSString * _Nullable)leftImageName centerTitle:(NSString * _Nullable)title titleColor:(UIColor * _Nullable)color rightItemImageName:(NSString * _Nullable)rightImageName;

- (void)navigationLeftItemWithImageName:(NSString * _Nullable)leftImageName centerTitle:(NSString *_Nullable)title titleColor:(UIColor *_Nullable)color rightItemImageName:(NSString *_Nullable)rightImageName rightItemColor:(UIColor * _Nullable)rightColor;


- (void)leftItemEvent;
- (void)rightItemEvent;


@end

NS_ASSUME_NONNULL_END
