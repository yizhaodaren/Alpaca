//
//  UIViewController+NoNetwork.m
//  Alpaca
//
//  Created by xujin on 2018/12/17.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "UIViewController+NoNetwork.h"
#import "MineViewController.h"
#import "SearchViewController.h"
#import "EmptyTipView.h"

@implementation UIViewController (NoNetwork)

- (void)showNoNetwork
{
#if 0
    BOOL isExist =NO;
    for (id views in self.view.subviews) {
        if ([views isKindOfClass:[EmptyTipView class]]) {

            isExist =YES;
        }
    }
    
    if (isExist) {
        return;
    }
    
    if ([self isKindOfClass:[MineViewController class]] ||
        [self isKindOfClass:[SearchViewController class]]
        ) {
        return;
    }
    
    EmptyTipView *emptyView =[EmptyTipView new];
    [emptyView setFrame:CGRectMake(0,StatusBarAndNavigationBarHeight+90, KSCREEN_WIDTH,120+20+20)];
    [emptyView contentImage:@"noNet" title:@"无可用网络，请检查网络再试"];
    [self.view addSubview:emptyView];
#endif
}

- (void)hiddenNoNetwork
{
#if 0
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[EmptyTipView class]]) {
            [view removeFromSuperview];
        }
    }
#endif
}


@end
