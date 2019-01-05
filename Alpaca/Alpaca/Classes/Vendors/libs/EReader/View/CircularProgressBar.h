//
//  CircularProgressBar.h
//  圆形进度条
//
//  Created by xiaolong li on 15/3/26.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircularProgressBarDelegate <NSObject>

@optional

- (void)responseCircularButtonAction:(UIButton *)btn andWith:(BOOL)boolState;

- (void)responseCircularEventCoin;


@end

@interface CircularProgressBar : UIView
{
    float PI;//为圆周率
    float  R;//圆半径
    NSTimer * _timer;//更新当前角度计时器
    float _angle;//当前角度
    float _plusNum;//当前角度自数
    
    CGPoint _center;//圆,按钮中心点
    CGContextRef context;
    
}

@property (nonatomic,retain) UIButton *startBtn;
@property (nonatomic,weak) id<CircularProgressBarDelegate>delegate;
@property (nonatomic,assign)BOOL isAnimation;
@property (nonatomic,assign)BOOL isInit; //YES 非初始化 NO初始化

- (id)initWithFrame:(CGRect)frame;

- (void)addCountTime:(float)time;

- (void)startTimerAnimation;

- (void)stopTimerAnimation;

- (void)pauseTimerAnimation;

@end
