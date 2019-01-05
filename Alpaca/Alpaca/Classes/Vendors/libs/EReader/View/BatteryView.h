//
//  BatteryView.h
//  Alpaca
//
//  Created by xujin on 2018/12/12.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatteryView : UIView
/**
 value:0 - 100
 */
- (void)setBatteryValue:(NSInteger)value;
@end

NS_ASSUME_NONNULL_END
