//
//  UITabBar+Badge.m
//  reward
//
//  Created by moli-2017 on 2018/10/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "UITabBar+Badge.h"
#import "BadgeNumber.h"
#define TabbarItemNums 5.0
@implementation UITabBar (Badge)

//显示红点
- (void)showBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    BadgeNumber *bview = [[BadgeNumber alloc]init];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 4;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    bview.badgeString =@"99+";
    float percentX = (index+0.68)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.15*tabFram.size.height);
    bview.frame = CGRectMake(x-15, y, 8, 8);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
