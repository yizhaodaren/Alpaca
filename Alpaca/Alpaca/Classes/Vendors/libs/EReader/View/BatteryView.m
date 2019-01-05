//
//  BatteryView.m
//  Alpaca
//
//  Created by xujin on 2018/12/12.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BatteryView.h"
#import "E_ColorModel.h"
#import "E_CommonManager.h"

@interface  BatteryView()
///电池宽度
@property (nonatomic,assign) CGFloat b_width;
///电池高度
@property (nonatomic,assign) CGFloat b_height;
///电池外线宽
@property (nonatomic,assign) CGFloat b_lineW;
@property (nonatomic,strong) UIView *batteryView;

@property (nonatomic,strong)E_ColorModel *themeID ;
@end

@implementation BatteryView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawBattery];

    }
    return self;
}
///画图标
- (void)drawBattery{
    ///x坐标
    CGFloat b_x = 1;
    ///y坐标
    CGFloat b_y = 1;
    _b_height = self.bounds.size.height - 2;
    _b_width = self.bounds.size.width - 5;
    _b_lineW = 1;
    
    //画电池【左边电池】
    UIBezierPath *pathLeft = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(b_x, b_y, _b_width, _b_height) cornerRadius:2];
    CAShapeLayer *batteryLayer = [CAShapeLayer layer];
    batteryLayer.lineWidth = _b_lineW;
    
    self.themeID =[E_ColorModel new];
    self.themeID =[E_CommonManager Manager_getReadTheme];
    if (!self.themeID) {
        self.themeID =[E_ColorModel new];
    }
    
    if (self.themeID.colorType == E_colorType_Night) {
         batteryLayer.strokeColor = HEX_COLOR_ALPHA(0xffffff, 0.3).CGColor;
        
    }else{
        
        batteryLayer.strokeColor = HEX_COLOR_ALPHA(0x000000, 0.3).CGColor;
        
    }
   
    batteryLayer.fillColor = [UIColor clearColor].CGColor;
    batteryLayer.path = [pathLeft CGPath];
    [self.layer addSublayer:batteryLayer];
    
    //画电池【右边电池箭头】
    UIBezierPath *pathRight = [UIBezierPath bezierPath];
    [pathRight moveToPoint:CGPointMake(b_x + _b_width+2, b_y + _b_height/3)];
    [pathRight addLineToPoint:CGPointMake(b_x + _b_width+2, b_y + _b_height * 2/3)];
    CAShapeLayer *layerRight = [CAShapeLayer layer];
    layerRight.lineWidth = 2;
    if (self.themeID.colorType == E_colorType_Night) {
        layerRight.strokeColor = HEX_COLOR_ALPHA(0xffffff, 0.3).CGColor;
        
    }else{
        
        layerRight.strokeColor = HEX_COLOR_ALPHA(0x000000, 0.3).CGColor;
        
    }
    layerRight.fillColor = [UIColor clearColor].CGColor;
    layerRight.path = [pathRight CGPath];
    [self.layer addSublayer:layerRight];
    
    ///电池内填充
    _batteryView = [[UIView alloc]initWithFrame:CGRectMake(b_x + 1,b_y + _b_lineW, 0, _b_height - _b_lineW * 2)];
    _batteryView.layer.cornerRadius = 2;
    if (self.themeID.colorType == E_colorType_Night) {
        _batteryView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.3);
        
    }else{
        
        _batteryView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.3);
        
    }
    
    [self addSubview:_batteryView];
}
///控制电量显示
- (void)setBatteryValue:(NSInteger)value{
//    if (value<10) {
//        _batteryView.backgroundColor = [UIColor redColor];
//    }else{
    //[UIColor colorWithRed:0.324 green:0.941 blue:0.413 alpha:1.000];
//    }
    
    if (self.themeID.colorType == E_colorType_Night) {
        _batteryView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.3);
    }else{
       _batteryView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.3);
    }
    
    CGRect rect = _batteryView.frame;
    rect.size.width = (_b_width - _b_lineW * 2)*(value/100.0);
    _batteryView.frame  = rect;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
