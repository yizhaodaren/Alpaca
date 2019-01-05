//
//  BadgeNumber.h
//  BadgeNumberDemo
//
//  Created by ios on 15/1/17.
//  Copyright (c) 2015年 NB. All rights reserved.
//

//#import <UIKit/UIKit.h>

@interface BadgeNumber : UIView{
    CGRect      _rect;
    UILabel     *_label;
    UIImageView *_bgImageView;
}
@property (nonatomic, retain) NSString *badgeString;
@property (nonatomic, retain) UIFont   *font;
@property (nonatomic, retain) UIColor  *textColor;
@end
