//
//  CircularProgressBar.m
//  圆形进度条
//
//  Created by xiaolong li on 15/3/26.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "CircularProgressBar.h"

@implementation CircularProgressBar

@synthesize startBtn;


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:HEX_COLOR(0xFFEEB9)];
      
        PI = 3.14;
        _angle = -90;
        
        R = (frame.size.width-4)/2.0;
        
        _center.x = frame.size.width/2.0;
        _center.y = frame.size.width/2.0;
        
        startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 2*R,2*R)];
        [startBtn setCenter:CGPointMake(_center.x, _center.y)];
        
        [startBtn setBackgroundImage:[UIImage imageNamed:@"circleA"] forState:UIControlStateNormal];
        
      //  [startBtn addTarget:self action:@selector(startTimer:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:startBtn];
    }
    return self;
}

-(void)addCountTime:(float)time{
    _plusNum = 360/(time/1.0);
}

- (void)startTimerAnimation
{
    [self stopState];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startProgressBar) userInfo:nil repeats:YES];
    self.isAnimation =YES;
}

- (void)stopTimerAnimation
{
    [self stopState];
}

- (void)pauseTimerAnimation
{
    
}

//-(void)startTimer:(UIButton *)btn
//{
//
//    if (!isDefault) {
//        isDefault=YES;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startProgressBar) userInfo:nil repeats:YES];
//
//    }else{
//        isDefault=NO;
//        [self stopState];
//
//    }
//
//
//    if (_delegate) {
//        [_delegate responseCircularButtonAction:btn andWith:isDefault];
//    }
//}

-(void)stopState{
    self.isAnimation =NO;
    [_timer invalidate];
    _timer=nil;
//    if (!self.isInit) {
//       _angle=-90;
//    }
   
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 248/250.f, 189/250.f, 3/250.f, 1.0);//线颜色

    CGContextSetLineWidth(context, 4.0);//线的宽度
    //-90*PI/180
    
    //此处使用的是弧度  1度＝3.14/180弧度
    CGContextAddArc(context, _center.x, _center.y, R, -90*PI/180,_angle*PI/180 , 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
}

-(void)startProgressBar
{
    _angle = _angle + _plusNum;
    if (_angle>270) {

        if (_delegate && [_delegate respondsToSelector:@selector(responseCircularEventCoin)]) {
            [_delegate responseCircularEventCoin];
        }
        _angle=-90;
        [self setNeedsDisplay];
        return;
    }
    [self setNeedsDisplay];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rectBig =CGRectInset(self.bounds,-16, -16);
    if (CGRectContainsPoint(rectBig, point)) {
        return self;
    }else{
        return nil;
    }
}

@end
