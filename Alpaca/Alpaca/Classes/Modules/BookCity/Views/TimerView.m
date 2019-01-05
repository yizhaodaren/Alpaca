//
//  TimerView.m
//  Alpaca
//
//  Created by xujin on 2018/11/26.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "TimerView.h"


static const NSTimeInterval kSecond=1;

@interface TimerView()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeUserValue;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, weak) UILabel *hourLabel;
@property (nonatomic, weak) UILabel *minuteLabel;
@property (nonatomic, weak) UILabel *secondLabel;
@property (nonatomic, assign) CGRect kFrame;
@end
@implementation TimerView

- (void)dealloc {
    [self stop];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.kFrame =frame;
        if (frame.size.width>0 && frame.size.height>0) {
            [self setup];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.kFrame =frame;
    if (frame.size.width>0 && frame.size.height>0) {
        [self setup];
    }
    
}

- (void)setRemainTime:(NSTimeInterval)remainTime{
    _remainTime = (remainTime < 0)? 0 : remainTime;
    if(_remainTime > 0){
        [self stop];
        [self start];
    }
}


#pragma mark - Timer Control Method
- (void)start{
    [self stop];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kSecond target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _counting = YES;
    [_timer fire];
}

- (void)stop{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Private method

-(void)setup{
    
    self.classNames = @[@"HourLabel",@"ColonOneLabel",@"MinuteLabel",@"ColonTwoLabel",@"SecondLabel"];
    
    CGFloat kLeftMargin =10.0;
    CGFloat kSpace =5.0;
    CGFloat kWidth =14.0;
    CGFloat kHeight =14.0;
    CGFloat kCorner =2.0;
    CGFloat kOringY =(self.kFrame.size.height -kHeight)/2.0;
    
    for (NSInteger i=0; i<self.classNames.count; i++) {
        
        UILabel *label = UILabel.new;
        [label setFont:SEMIBOLD_FONT(10)];
        [label setTextColor: HEX_COLOR(0xffffff)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        
        if (i == 0) {
            [label setBackgroundColor:HEX_COLOR(0xED424B)];
            [label setText:[STSystemHelper getNumberString:[STSystemHelper getHour:_remainTime]]];
            
            self.hourLabel =label;
        }else if (i==2 || i==4){
            [label setBackgroundColor:HEX_COLOR(0x4A4A4A)];
            
            if (i==2) {
                self.minuteLabel =label;
                [label setText:[STSystemHelper getNumberString:[STSystemHelper getMinute:_remainTime]]];
            }else{
                self.secondLabel =label;
                [label setText:[STSystemHelper getNumberString:[STSystemHelper getSecond:_remainTime]]];
            }
            
        }else{
            [label setText:@":"];
            [label setTextColor:HEX_COLOR(0x4A4A4A)];
            [label setBackgroundColor:HEX_COLOR(0xffffff)];
        }
        
        
        if (i==0) {
            [label setFrame:CGRectMake(kLeftMargin,kOringY,kWidth,kHeight)];
        }else if (i==1){
            [label setFrame:CGRectMake(self.hourLabel.right,kOringY,kSpace,kHeight)];
        }else if (i==2){
            [label setFrame:CGRectMake(self.hourLabel.right+kSpace,kOringY,kWidth,kHeight)];
        }else if (i==3){
            [label setFrame:CGRectMake(self.minuteLabel.right,kOringY,kSpace,kHeight)];
        }else if (i==4){
            [label setFrame:CGRectMake(self.minuteLabel.right+kSpace,kOringY,kWidth,kHeight)];
        }
        
        
        if (i!=1 && i!=3) {
            [label.layer setMasksToBounds:YES];
            [label.layer setCornerRadius:kCorner];
        }
        
    }
    
}

- (void)updateLabel{
    
    if (_remainTime<0) {
        [self stop];
    }else{
        [self.hourLabel setText:[STSystemHelper getNumberString:[STSystemHelper getHour:_remainTime]]];
        [self.minuteLabel setText:[STSystemHelper getNumberString:[STSystemHelper getMinute:_remainTime]]];
        [self.secondLabel setText:[STSystemHelper getNumberString:[STSystemHelper getSecond:_remainTime]]];
    }
    
    _remainTime--;
}

#pragma mark - Cleanup

- (void) removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    for (id views in self.subviews) {
        [views removeFromSuperview];
    }
    
    [super removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
