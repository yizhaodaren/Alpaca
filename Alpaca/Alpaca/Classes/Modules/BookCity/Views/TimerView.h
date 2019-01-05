//
//  TimerView.h
//  Alpaca
//
//  Created by xujin on 2018/11/26.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerView : UIView

@property (nonatomic, assign)NSTimeInterval remainTime;
/*Is The Timer Running?*/
@property (assign,readonly,getter=isCounting) BOOL counting;


/*--------Timer control methods to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

@end

NS_ASSUME_NONNULL_END
