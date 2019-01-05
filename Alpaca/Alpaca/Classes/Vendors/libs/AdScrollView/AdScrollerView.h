//
//  DemoScrollerView.h
//  GunDongDemo
//
//  Created by Lemon on 15/4/21.
//  Copyright (c) 2015年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  AdScrollerViewDelegate <NSObject>
@optional
-(void)adScrollerViewDidClicked:(NSUInteger)index;
@end

@interface AdScrollerView : UIView<UIScrollViewDelegate>

@property(nonatomic,retain)id<AdScrollerViewDelegate> delegate;

@property(nonatomic,assign)int currentPageIndex;
@property(nonatomic,assign)int currentPageIdx;

-(void) setContent:(NSArray *)arr;

-(void) lDeallocTimer;

- (void)startTimerEvent;



@end

