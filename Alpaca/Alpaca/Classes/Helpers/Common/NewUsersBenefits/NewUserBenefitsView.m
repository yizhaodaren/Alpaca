//
//  NewUserBenefitsView.m
//  Alpaca
//
//  Created by xujin on 2018/11/30.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NewUserBenefitsView.h"
#import "MOLWebViewController.h"
#import "BookcaseApi.h"
#import "UserModel.h"
#import "BMSHelper.h"

@interface NewUserBenefitsView()
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)YYLabel *titileLabel;
@property (nonatomic, weak)YYLabel *money;
@property (nonatomic, weak)YYLabel *add;
@property (nonatomic, weak)YYLabel *gold;
@property (nonatomic, weak)YYLabel *accountedTip;
@property (nonatomic, weak)UIButton *lookMore;


@property (nonatomic, weak)UIImageView *topView;
@property (nonatomic, weak)YYLabel *tipLable;
@property (nonatomic, weak)YYLabel *openTitle;
@property (nonatomic, weak)YYLabel *addTip;
@property (nonatomic, weak)YYLabel *allLable;
@property (nonatomic, weak)YYLabel *getMoneyL;
@property (nonatomic, weak)UIImageView *bestLable;


@property (nonatomic, weak)UIImageView *bottomView;

@property (nonatomic, weak)UIButton *openButton;


@property (nonatomic, strong)UIButton *avatars;
@property (nonatomic, strong)YYLabel *welcome;
@property (nonatomic, strong)YYLabel *benefits;
@property (nonatomic, strong)UIImageView *redPacket;
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

- (void)layoutBaseUI{
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];
    
    UIView *contentView =[UIView new];
    [contentView setBackgroundColor: HEX_COLOR(0xFDE7E1)];
    [contentView.layer setCornerRadius:10];
    [contentView.layer setMasksToBounds:YES];
    self.contentView =contentView;
    [self addSubview:contentView];
    
    YYLabel *titileLabel = [[YYLabel alloc] init];
    self.titileLabel = titileLabel;
    titileLabel.text = @"恭喜您获得";
    titileLabel.textColor = HEX_COLOR(0xFFFFFF);
    titileLabel.font = REGULAR_FONT(20);
    [contentView addSubview:titileLabel];
    
    YYLabel *moneyLabel = [[YYLabel alloc] init];
    self.money = moneyLabel;
    moneyLabel.textColor = HEX_COLOR(0x000000);
   
    
    
    
   
    
    moneyLabel.font = SEMIBOLD_FONT(35);
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:moneyLabel];
    
    
    YYLabel *add = [[YYLabel alloc] init];
    self.add = add;
    add.textColor = HEX_COLOR(0x000000);
    add.text = @"+";
    add.font = SEMIBOLD_FONT(35);
    add.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:add];
    
    YYLabel *introduceLabel = [[YYLabel alloc] init];
    self.gold = introduceLabel;
   // introduceLabel.text = @"10000金币";
    introduceLabel.textColor = HEX_COLOR(0x000000);
    introduceLabel.font = SEMIBOLD_FONT(35);
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:introduceLabel];
    

    
    YYLabel *accountedTip= [[YYLabel alloc] init];
    self.accountedTip = accountedTip;
    accountedTip.text = @"已存入账户";
    accountedTip.textColor = HEX_COLOR_ALPHA(0x000000,0.7);
    accountedTip.font = REGULAR_FONT(12);
    accountedTip.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:accountedTip];
    
    
    
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookMore = getButton;
    getButton.backgroundColor = HEX_COLOR(0xCD4238);
    [getButton setTitle:@"查看更多赚钱方式" forState:UIControlStateNormal];
    [getButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    getButton.titleLabel.font = REGULAR_FONT(18);
    
    getButton.layer.cornerRadius = 25;
    [getButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:getButton];
    
}

- (void)layoutTopUI{
    UIImageView *topView =[UIImageView new];
    [topView setImage:[UIImage imageNamed:@"top"]];
    self.topView =topView;
    [self.contentView addSubview:topView];
    
}

- (void)layoutBottomUI{
    UIImageView *bottomView =[UIImageView new];
    [bottomView setImage:[UIImage imageNamed:@"bottom"]];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event)];
    [bottomView addGestureRecognizer:tap];
    [bottomView setUserInteractionEnabled:YES];
    self.bottomView =bottomView;
    [self.contentView insertSubview:self.bottomView belowSubview:self.topView];
   
    
    YYLabel *label5 = [[YYLabel alloc] init];
    self.getMoneyL = label5;
    label5.text = @"当天即可提现";
    label5.textColor = HEX_COLOR_ALPHA(0xFFFFFF,0.7);
    label5.font = REGULAR_FONT(12);
    label5.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:label5];
}

- (void)setUpViewSubViews
{
    
    YYLabel *label1 = [[YYLabel alloc] init];
    self.tipLable = label1;
    label1.text = @"恭喜你获得一个新手红包";
    label1.textColor = HEX_COLOR_ALPHA(0xFFFFFF,0.5);
    label1.font = REGULAR_FONT(15);
    label1.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label1];
    
    YYLabel *label2 = [[YYLabel alloc] init];
    self.openTitle = label2;
    label2.text = @"打开得18元现金";
    label2.textColor = HEX_COLOR(0xFFFFFF);
    label2.font = REGULAR_FONT(25);
    label2.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label2];
    
    YYLabel *label3 = [[YYLabel alloc] init];
    self.addTip = label3;
    label3.text = @"+";
    label3.textColor = HEX_COLOR(0xFFFFFF);
    label3.font = REGULAR_FONT(25);
    label3.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label3];
    
    YYLabel *label4 = [[YYLabel alloc] init];
    self.allLable = label4;
    label4.text = @"全场小说永久免费";
    label4.textColor = HEX_COLOR(0xFFFFFF);
    label4.font = REGULAR_FONT(25);
    label4.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label4];
    
    
    
    UIImageView *label6 = [[UIImageView alloc] init];
    self.bestLable = label6;
    [label6 setImage:[UIImage imageNamed:@"best"]];
    [self.topView addSubview:label6];
    
}

- (void)layoutUI{
    
    [self layoutBaseUI];
    [self layoutTopUI];
    [self layoutBottomUI];
    [self setUpViewSubViews];
    
    
    UIButton *closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"launchclose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton =closeButton;
    [self.contentView addSubview:closeButton];
   
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openButton = openBtn;
    [openBtn setImage:[UIImage imageNamed:@"packet_open"] forState:UIControlStateNormal];
    
    [openBtn addTarget:self action:@selector(openPacket) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:openBtn];
    
    
}


#pragma mark-
#pragma action event

- (void)openPacket{
    ///开红包
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    self.openButton.userInteractionEnabled = NO;
   
    [UIView transitionWithView:self.openButton duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveLinear animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];//动画的重复次数
        
    } completion:^(BOOL finished) {}];
    
    
        __weak typeof(self) wself = self;
        [[[BookcaseApi alloc] initOpenNewBagInfo:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {

            if (code == SUCCESS_REQUEST) {
                
                NSString *moneyStr=[NSString stringWithFormat:@"%.2lf",[request.responseObject[@"resBody"][@"money"] doubleValue]];
                
                
                if (moneyStr.length) {
                   
                   moneyStr =[moneyStr stringByAppendingString:@"元"];
                    
                   NSMutableAttributedString *moneyAtt =[[NSMutableAttributedString alloc] initWithString:moneyStr];
                    
                   NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    
                    paragraphStyle.alignment = NSTextAlignmentCenter;
                    
                    [moneyAtt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, moneyAtt.length)];
                    
                    
                    [moneyAtt addAttribute:NSFontAttributeName value:SEMIBOLD_FONT(35) range:NSMakeRange(0, moneyStr.length-1)];
                    [moneyAtt addAttribute:NSFontAttributeName value:REGULAR_FONT(15) range:NSMakeRange(moneyStr.length-1, 1)];
                    
                    wself.money.attributedText =moneyAtt;
                }
                
                
                NSString *coinStr =[NSString stringWithFormat:@"%.2lf",[request.responseObject[@"resBody"][@"coin"] doubleValue]];
                
                if (coinStr.length) {
                    
                    coinStr =[coinStr stringByAppendingString:@"金币"];
                    
                    NSMutableAttributedString *goldAtt =[[NSMutableAttributedString alloc] initWithString:coinStr];
                    
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    
                    paragraph.alignment = NSTextAlignmentCenter;
                    
                    [goldAtt addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, goldAtt.length)];
                    
                    
                    [goldAtt addAttribute:NSFontAttributeName value:SEMIBOLD_FONT(35) range:NSMakeRange(0, coinStr.length-1)];
                    [goldAtt addAttribute:NSFontAttributeName value:REGULAR_FONT(15) range:NSMakeRange(coinStr.length-2, 2)];
                    
                    wself.gold.attributedText =goldAtt;
                }
                
                
               
                __weak typeof(self) wself = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UserModel *userModel =[UserManagerInstance user_getUserInfo];
                    if (!userModel) {
                        userModel =[UserModel new];
                    }
                    userModel.newBagSign =1;
                    // 登录成功
                    [UserManagerInstance user_saveUserInfoWithModel:userModel isLogin:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:GET_MYWALLET_NOTIF object:nil];
                    
                    [wself.openButton.layer removeAllAnimations];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        [wself.openButton setAlpha:0];
                        wself.allLable.bottom = wself.topView.bottom-35-28;
                        wself.allLable.text = @"恭喜你获得";
                        wself.allLable.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.5);
                        wself.topView.y = 118-wself.topView.height;
                        wself.bottomView.y = wself.contentView.bottom;
                        
                    }];
                });

                
            }else{
                
                if (self->_delegate && [self->_delegate respondsToSelector:@selector(newUserBenefitsViewSaveMoney:)]) {
                    [self->_delegate newUserBenefitsViewSaveMoney:self];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [OMGToast showWithText:message];
                });
                
            }

        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            [wself.openButton.layer removeAllAnimations];
            wself.openButton.userInteractionEnabled = YES;
            [OMGToast showWithText:@"红包开启失败，请重试"];
            
        }];

                   
}

- (void)clickButton{
    
    MOLWebViewController *webView =[MOLWebViewController new];
    NSString *url =[BMSHelper getBaseUrl];
    webView.urlString =[NSString stringWithFormat:@"%@%@",url,WIDTHDRAW];
    
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:webView animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(newUserBenefitsViewSaveMoney:)]) {
            [self->_delegate newUserBenefitsViewSaveMoney:self];
        }
    });
  
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
    [self close];
}

- (void)close{
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
    
    [self.openButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.allLable.mas_bottom).offset(47);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    

    [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(28);
    }];
    
    [self.add mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.money.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.width.mas_equalTo(28);
    }];
    
    [self.gold mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.add.mas_bottom).mas_offset(26);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(28);
    }];
    
    [self.accountedTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.gold.mas_bottom).offset(39);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(17);
        make.left.right.mas_equalTo(wself.contentView);
    }];
    

    [self.lookMore mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(wself.accountedTip.mas_bottom).mas_offset(35);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    [self.accountButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom).mas_offset(-33);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(45);
    }];
    
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(334+22);
        make.top.mas_equalTo(wself.contentView.mas_top);
        
    }];
    
    
    [self.tipLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(wself.topView);
        make.height.mas_equalTo(21);
    }];
    
    
    
    [self.openTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.tipLable.mas_bottom).offset(60);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(25);
    }];
    
    [self.bestLable mas_updateConstraints:^(MASConstraintMaker *make) {
    
    make.bottom.mas_equalTo(wself.openTitle.mas_top).offset(-7);
        make.right.mas_equalTo(-66);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(32);
    }];
    
    
    
    [self.addTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.openTitle.mas_bottom).mas_offset(28);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.width.mas_equalTo(21);
    }];
    
    [self.allLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.addTip.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(25);
    }];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.topView.mas_bottom).offset(-66);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(106+44);
        make.width.mas_equalTo(wself.contentView);
    }];
    
    [self.getMoneyL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-29);
        make.centerX.mas_equalTo(wself.contentView.mas_centerX);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(wself.contentView);
    }];
    
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self calculatorUpdateViewFrame];
}

- (void)setMoneyString:(NSString *)moneyString{
  //  [self.money setText: [NSString stringWithFormat:@"%@元",moneyString]];
}

- (void)event{
    
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
