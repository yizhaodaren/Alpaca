//
//  NewUserBenefitsView.h
//  Alpaca
//
//  Created by xujin on 2018/11/30.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WarnLoginView;
@protocol WarnLoginViewDelegate <NSObject>

- (void)WarnLoginViewCloseEvent:(WarnLoginView *)view;

- (void)WarnLoginViewlogin:(WarnLoginView *)view;

@end

@interface WarnLoginView : UIView
@property (nonatomic,weak)id<WarnLoginViewDelegate>delegate;

@property (nonatomic,strong )NSString * _Nullable moneyString;

- (void)removeEvent;

@end

NS_ASSUME_NONNULL_END
