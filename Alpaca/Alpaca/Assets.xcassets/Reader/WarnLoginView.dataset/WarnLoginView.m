//
//  NewUserBenefitsView.m
//  Alpaca
//
//  Created by xujin on 2018/11/30.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NewUserBenefitsView.h"

@interface NewUserBenefitsView()
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *avatars;
@property (nonatomic, strong)YYLabel *welcome;
@property (nonatomic, strong)YYLabel *benefits;
@property (nonatomic, strong)UIImageView *redPacket;
@property (nonatomic, strong)YYLabel *money;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UIButton *accountButton;



@end

@implementation NewUserBenefitsView
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

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSLog(@"initWithFrame");
//    }
//    return self;
//}

- (void)layoutUI{
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.avatars];
    [self.contentView addSubview:self.welcome];
    [self.contentView addSubview:self.benefits];
    [self.contentView addSubview:self.redPacket];
    [self.redPacket addSubview:self.money];
    [self.contentView addSubview:self.accountButton];
    
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

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"launchclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)avatars{
    if (!_avatars) {
        _avatars =[UIButton buttonWithType:UIButtonTypeCustom];
        [_avatars setImage:[UIImage imageNamed:@"headerD"] forState:UIControlStateNormal];
    }
    return _avatars;
}

- (YYLabel *)welcome{
    if (!_welcome) {
        _welcome =[YYLabel new];
        [_welcome setTextColor: HEX_COLOR(0x000000)];
        [_welcome setFont: REGULAR_FONT(17)];
        [_welcome setTextAlignment:NSTextAlignmentCenter];
        [_welcome setText: @"欢迎你来到羊驼小说"];
    }
    return _welcome;
}

- (YYLabel *)benefits{
    if (!_benefits) {
        _benefits =[YYLabel new];
        [_benefits setTextColor: HEX_COLOR(0xF5A623)];
        [_benefits setFont: REGULAR_FONT(14)];
        [_benefits setTextAlignment:NSTextAlignmentCenter];
        [_benefits setText: @"初次见面，送你一个新手红包"];
    }
    return _benefits;
}

- (UIImageView *)redPacket{
    if (!_redPacket) {
        _redPacket =[UIImageView new];
        [_redPacket setImage:[UIImage imageNamed:@"redPacket"]];
        [_redPacket setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _redPacket;
}

- (YYLabel *)money{
    if (!_money) {
        _money =[YYLabel new];
        [_money setTextColor: HEX_COLOR(0xFFF1CF)];
        [_money setTextAlignment:NSTextAlignmentCenter];
        [_money setFont: SEMIBOLD_FONT(30)];
    }
    return _money;
}

- (UIButton *)accountButton{
    if (!_accountButton) {
        _accountButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_accountButton setTitle:@"存入我的账户" forState:UIControlStateNormal];
        [_accountButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
        [_accountButton setBackgroundColor:HEX_COLOR(0x19B898)];
        [_accountButton.titleLabel setFont:MEDIUM_FONT(16)];
        [_accountButton addTarget:self action:@selector(accountEvnet:) forControlEvents:UIControlEventTouchUpInside];
        [_accountButton.layer setCornerRadius:5];
        [_accountButton.layer setMasksToBounds:YES];
    }
    return _accountButton;
}

#pragma mark-
#pragma action event
- (void)accountEvnet:(UIButton *)sender{
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(newUserBenefitsViewSaveMoney:)]) {
            [_delegate newUserBenefitsViewSaveMoney:self];
        }
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

- (void)closeEvent:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(newUserBenefitsViewCloseEvent:)]) {
        [_delegate newUserBenefitsViewCloseEvent:self];
    }
}


- (void)calculatorUpdateViewFrame{
    
    
    __weak typeof(self) wself = self;
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
    
    [self.avatars mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [self.welcome mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.avatars.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(25);
    }];
    
    [self.benefits mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.welcome.mas_bottom).mas_offset(4);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    
    [self.redPacket mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.benefits.mas_bottom);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(200);
    }];
    

    [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(wself.redPacket.mas_bottom).mas_offset(-32);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(42);
    }];
    
    [self.accountButton mas_updateConstraints:^(MASConstraintMaker *make) {
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

- (void)setMoneyString:(NSString *)moneyString{
    [self.money setText: [NSString stringWithFormat:@"%@元",moneyString]];
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
