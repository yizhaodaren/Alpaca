//
//  NewUserBenefitsView.h
//  Alpaca
//
//  Created by xujin on 2018/11/30.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NewUserBenefitsView;
@protocol NewUserBenefitsViewDelegate <NSObject>

- (void)newUserBenefitsViewCloseEvent:(NewUserBenefitsView *)view;

- (void)newUserBenefitsViewSaveMoney:(NewUserBenefitsView *)view;

@end

@interface NewUserBenefitsView : UIView
@property (nonatomic,weak)id<NewUserBenefitsViewDelegate>delegate;

@property (nonatomic,strong )NSString * _Nullable moneyString;

- (void)removeEvent;

@end

NS_ASSUME_NONNULL_END
