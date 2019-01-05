//
//  NewUserBenefitsView.m
//  Alpaca
//
//  Created by xujin on 2018/11/30.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WarnLoginView.h"

@interface WarnLoginView()
@property(nonatomic,strong)UIImageView  *bgImageView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *closeButton;


@property(nonatomic,strong)UILabel  *titleLable;
@property(nonatomic,strong)UILabel  *titleLable1;
@property(nonatomic,strong)UILabel  *detalLable1;
@property(nonatomic,strong)UILabel  *titleLable2;
@property(nonatomic,strong)UILabel  *detalLable2;
@property (nonatomic, strong)UIButton *loginButton;

@property(nonatomic,strong)UIImageView  *tagImage1;
@property(nonatomic,strong)UIImageView  *tagImage2;
@property(nonatomic,strong)UIImageView  *tagImage3;
@property(nonatomic,strong)UIImageView  *tagImage4;


@end

@implementation WarnLoginView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.3)];
        [self layoutUI];
        
        NSLog(@"init");
    }
    return self;
}

- (void)layoutUI{
    [self addSubview:self.bgImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.closeButton];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];

    [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.titleLable1];
        [self.contentView addSubview:self.detalLable1];
        [self.contentView addSubview:self.titleLable2];
        [self.contentView addSubview:self.detalLable2];
     [self.contentView addSubview:self.tagImage1];
     [self.contentView addSubview:self.tagImage2];
     [self.contentView addSubview:self.tagImage3];
     [self.contentView addSubview:self.tagImage4];
    
    [self.contentView addSubview:self.loginButton];
    
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView  = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        
        
    }
    return _bgImageView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView =[UIView new];
        [_contentView setBackgroundColor: HEX_COLOR(0xffffff)];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
    }
    return _contentView;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleLable.text = @"- 登录阅读得金币 -";
        _titleLable.textColor = HEX_COLOR(0x4A4A4A);
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}
-(UILabel *)titleLable1{
    if (!_titleLable1) {
        _titleLable1 = [UILabel new];
        _titleLable1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLable1.text = @"登录阅读奖励";
        _titleLable1.textColor = HEX_COLOR(0x4A4A4A);
        _titleLable1.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable1;
}
-(UILabel *)detalLable1{
    if (!_detalLable1) {
        _detalLable1 = [UILabel new];
        _detalLable1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _detalLable1.text = @"登录后,在线阅读可得金币,30秒奖励一次,每次最高可得50金币";
        _detalLable1.textColor = HEX_COLOR(0x4A4A4A);
        _detalLable1.textAlignment = NSTextAlignmentLeft;
        _detalLable1.numberOfLines = 2;
    }
    return _detalLable1;
}
-(UILabel *)titleLable2{
    if (!_titleLable2) {
        _titleLable2 = [UILabel new];
        _titleLable2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLable2.text = @"什么是金币奖励?";
        _titleLable2.textColor = HEX_COLOR(0x4A4A4A);
        _titleLable2.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable2;
}

-(UILabel *)detalLable2{
    if (!_detalLable2) {
        _detalLable2 = [UILabel new];
        _detalLable2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _detalLable2.text = @"金币是用户在阅读或完成其他任务后获得的奖励,可直接兑换为现金提现";
        _detalLable2.textColor = HEX_COLOR(0x4A4A4A);
        _detalLable2.textAlignment = NSTextAlignmentLeft;
         _detalLable2.numberOfLines = 2;
    }
    return _detalLable2;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"launchclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}




- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"点击登录赚钱" forState:UIControlStateNormal];
        [_loginButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:HEX_COLOR(0x19B898)];
        [_loginButton.titleLabel setFont:MEDIUM_FONT(16)];
        [_loginButton addTarget:self action:@selector(accountEvnet:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton.layer setCornerRadius:5];
        [_loginButton.layer setMasksToBounds:YES];
    }
    return _loginButton;
}
-(UIImageView *)tagImage1{
    if (!_tagImage1) {
        _tagImage1 = [[UIImageView alloc] init];
        _tagImage1.image = [UIImage imageNamed:@"E_warnLeft"];
    }
    return _tagImage1;
}
-(UIImageView *)tagImage2{
    if (!_tagImage2) {
        _tagImage2 = [[UIImageView alloc] init];
        _tagImage2.image = [UIImage imageNamed:@"E_warnRight"];
    }
    return _tagImage2;
}
-(UIImageView *)tagImage3{
    if (!_tagImage3) {
        _tagImage3 = [[UIImageView alloc] init];
        _tagImage3.image = [UIImage imageNamed:@"E_warnLeft"];
    }
    return _tagImage3;
}
-(UIImageView *)tagImage4{
    if (!_tagImage4) {
        _tagImage4 = [[UIImageView alloc] init];
        _tagImage4.image = [UIImage imageNamed:@"E_warnRight"];
    }
    return _tagImage4;
}


#pragma mark-
#pragma action event
- (void)accountEvnet:(UIButton *)sender{
        if (_delegate && [_delegate respondsToSelector:@selector(WarnLoginViewlogin:)]) {
            [_delegate WarnLoginViewlogin:self];
        }
}
- (void)removeEvent{
    self.moneyString =nil;
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)close{
    if (_delegate && [_delegate respondsToSelector:@selector(WarnLoginViewCloseEvent:)]) {
        [_delegate WarnLoginViewCloseEvent:self];
    }
}

- (void)closeEvent:(UIButton *)sender{
    [self close];
}


- (void)calculatorUpdateViewFrame{
    
    
    __weak typeof(self) wself = self;
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(wself.height);
    }];
    
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-27);
        make.top.mas_equalTo((wself.height-440)/2.0);
        make.bottom.mas_equalTo(-(wself.height-440)/2.0);
    }];
    


    [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.titleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(25);
        
    }];

        CGFloat tagimageH = 14;
    self.titleLable1.top = 113;
    [self.titleLable1 sizeToFit];
    self.titleLable1.centerX =(KSCREEN_WIDTH - 28 -27)/ 2;
    
    
    self.tagImage1.width = tagimageH;
    self.tagImage1.height = tagimageH;
    self.tagImage1.centerY = self.titleLable1.centerY;
    self.tagImage1.right = self.titleLable1.x;
  

    self.tagImage2.width = tagimageH;
    self.tagImage2.height = tagimageH;
    self.tagImage2.centerY = self.titleLable1.centerY;
    self.tagImage2.left = self.titleLable1.right;
    
    
 
//    [self.titleLable1 mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(113);
//        make.height.mas_equalTo(25);
//
//    }];
    [self.detalLable1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(143);
        make.height.mas_equalTo(40);
        
    }];
    

    
    self.titleLable2.top = 227;
    [self.titleLable2 sizeToFit];
    
    self.titleLable2.centerX =(KSCREEN_WIDTH - 28 -27)/ 2;
    
    
    self.tagImage3.width = tagimageH;
    self.tagImage3.height = tagimageH;
    self.tagImage3.centerY = self.titleLable2.centerY;
    self.tagImage3.right = self.titleLable2.x;
   
    
    self.tagImage4.width = tagimageH;
    self.tagImage4.height = tagimageH;
    self.tagImage4.centerY = self.titleLable2.centerY;
    self.tagImage4.left = self.titleLable2.right;

    
//    [self.titleLable2 mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(227);
//        make.height.mas_equalTo(25);
//
//    }];
    [self.detalLable2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(257);
        make.height.mas_equalTo(40);
        
    }];
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom).mas_offset(-33);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(45);
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self calculatorUpdateViewFrame];
}


- (void)dealloc{
    NSLog(@"NewUserBenefitsView---dealloc");
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
