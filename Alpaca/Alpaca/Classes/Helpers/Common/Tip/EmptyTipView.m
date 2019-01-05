//
//  EmptyTipView.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "EmptyTipView.h"

@interface EmptyTipView()
@property (nonatomic, strong)UIImageView *covorImage;
@property (nonatomic, strong)YYLabel *tipLable;

@end
@implementation EmptyTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:HEX_COLOR_ALPHA(0xffffff,1.0)];
        [self layoutUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutUI{

    [self addSubview:self.covorImage];
    [self addSubview:self.tipLable];
    

}

- (UIImageView *)covorImage{
    if (!_covorImage) {
        _covorImage=[UIImageView new];
        [_covorImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _covorImage;
}



- (YYLabel *)tipLable{
    if (!_tipLable) {
        _tipLable =[YYLabel new];
        [_tipLable setTextColor: HEX_COLOR(0x979FAC)];
        [_tipLable setFont: REGULAR_FONT(14)];
        [_tipLable setTextAlignment:NSTextAlignmentCenter];
       
    }
    return _tipLable;
}


- (void)calculatorUpdateViewFrame{
    __weak typeof(self) wself = self;
    [self.covorImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself);
        make.centerX.mas_equalTo(wself.mas_centerX);
        make.height.width.mas_equalTo(120);
    }];
    
    [self.tipLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.covorImage.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(wself.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)contentImage:(NSString *)imageS title:(NSString *)title{
    [self.covorImage setImage: [UIImage imageNamed:imageS]];
    [self.tipLable setText:title];
    [self calculatorUpdateViewFrame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self calculatorUpdateViewFrame];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
