//
//  MineHeaderCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "MineHeaderCell.h"
#import "UserModel.h"
//#import "IMViewController.h"
#import "MOLWebViewController.h"
#import "BMSHelper.h"

@interface  MineHeaderCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)UserModel *userModel;

@property (nonatomic, weak)UIView *bckgroundView;
@property (nonatomic, weak)YYLabel *goldLable;
@property (nonatomic, weak)YYLabel *moneyLable;
@property (nonatomic, weak)YYLabel *timeLable;
@property (nonatomic, weak)YYLabel *aboutMoney;
@property (nonatomic, weak)UIImageView *goldBackground;
@property (nonatomic, weak)UIButton *imButton;
@property (nonatomic, weak)UIImageView *avatar;
@property (nonatomic, weak)UIButton *userName;
@property (nonatomic, weak)YYLabel *goldAbout;
@property (nonatomic, weak)YYLabel *goldLableTip;
@property (nonatomic, weak)YYLabel *moneyTip;
@property (nonatomic, weak)YYLabel *timeLableTip;
@property (nonatomic, strong)UILabel *invitationCode;


@end

@implementation MineHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userModel =[UserModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    }
    return self;
}

- (void)cellContent:(UserModel *)model indexPath:(NSIndexPath *)indexPath status:(BOOL)status{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    UIView *backgroundView =[UIView new];
    [backgroundView setBackgroundColor:HEX_COLOR(0xffffff)];
    self.bckgroundView =backgroundView;
    [self.contentView addSubview: backgroundView];
    
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    
    if (model) {
        self.userModel =model;
    }
    
//    UIButton *imButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [imButton setImage:[UIImage imageNamed:@"Message"] forState:UIControlStateNormal];
//    [imButton setImage:[UIImage imageNamed:@"Message new"] forState:UIControlStateSelected];
//    [imButton addTarget:self action:@selector(imButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//    [imButton setSelected: status];
//
//    [imButton setHidden: [Defaults integerForKey:ISDEBUG]];
//    self.imButton =imButton;
//    [self.contentView addSubview:imButton];
    
    
    
    
    UIImageView *avatar=[UIImageView new];
    [avatar setUserInteractionEnabled:YES];
    avatar.contentMode =UIViewContentModeScaleAspectFill;
    [avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar?model.avatar:@""] placeholderImage:[UIImage imageNamed:@"headerD"] options:SDWebImageRetryFailed];
    self.avatar =avatar;
//    [avatar setBackgroundColor:[UIColor redColor]];
    
    [self.contentView addSubview:avatar];
    
    
    UIButton *userName=[UIButton buttonWithType:UIButtonTypeCustom];
    [userName setTitle:@"立即登录" forState:UIControlStateNormal];
    [userName setTitle:model.userName?model.userName:@"" forState:UIControlStateSelected];
    [userName setTitleColor:HEX_COLOR(0x19B898) forState:UIControlStateNormal];
    [userName setTitleColor:HEX_COLOR(0x000000) forState:UIControlStateSelected];
    [userName.titleLabel setFont:REGULAR_FONT(17)];
    //[userName.titleLabel setBackgroundColor:[UIColor redColor]];
    [userName addTarget:self action:@selector(userNameEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    self.userName =userName;
    [self.contentView addSubview:userName];
    
    
    /*+++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    UILabel *invitCode =[UILabel new];
    [invitCode setUserInteractionEnabled:YES];
    [invitCode setTextColor: HEX_COLOR(0x9B9B9B)];
    [invitCode setFont:REGULAR_FONT(11)];
    self.invitationCode =invitCode;
    [invitCode setAlpha:0];
    [self.contentView addSubview:invitCode];
    
    if (model.uuid) {
        
        if (![Defaults integerForKey:ISDEBUG]) {
            [invitCode setAlpha:1];
            NSString *code =[NSString stringWithFormat:@"点击复制邀请码:%ld",model.uuid];
            [invitCode setText:code?code:@""];
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invitCodeEvent)];
            [invitCode addGestureRecognizer:tap];
        }
        
        
       
#if 0
        
        // 多属性字符串
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:code];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:@(NSUnderlineStyleSingle)
                                range:(NSRange){0,[attributeString length]}];
        //此时如果设置字体颜色要这样
        [attributeString addAttribute:NSForegroundColorAttributeName value:HEX_COLOR(0x9B9B9B)  range:NSMakeRange(0,[attributeString length])];
        
        //设置下划线颜色...
        [attributeString addAttribute:NSUnderlineColorAttributeName value:HEX_COLOR(0x9B9B9B) range:(NSRange){0,[attributeString length]}];
        invitCode.attributedText =attributeString;
#endif
       
        
    }
    
    if (![UserManagerInstance user_isLogin]) {//未登录
      
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarEvent:)];
        [avatar addGestureRecognizer:tap];
        
    }else{ //已登录
        
        [userName setUserInteractionEnabled:NO];
        [userName setSelected:YES];
        
        
    }

    
    UIImageView *goldBackground =[UIImageView new];
    [goldBackground setImage:[UIImage imageNamed:@"goldBackground"]];
    self.goldBackground =goldBackground;
    
    [backgroundView addSubview:goldBackground];
    
    
  //  goldBackground
    YYLabel *goldAbout =[YYLabel new];
    //[goldAbout setHidden:NO];
    
    
    double money =(model.userWalletVO.coin/1.0)/model.userWalletVO.coinToMoney;
    
    if (money>0.01) {
        [goldAbout setText:[NSString stringWithFormat:@"约%.2lf元",money]];
    }else{
        [goldAbout setHidden:YES];
    }
    
   // [goldAbout setText:@"约1.23元"];
    [goldAbout setTextColor:HEX_COLOR(0xD16710)];
    [goldAbout setFont:REGULAR_FONT(10)];
    [goldAbout setBackgroundColor: HEX_COLOR(0xFFEE9A)];
    [goldAbout setTextAlignment:NSTextAlignmentCenter];
    self.aboutMoney =goldAbout;
    [backgroundView addSubview:goldAbout];
    
    
    
    YYLabel *goldLableTip =[YYLabel new];
    [goldLableTip setText:@"金币"];
    [goldLableTip setTextColor:HEX_COLOR(0x9B9B9B)];
    [goldLableTip setFont:REGULAR_FONT(12)];
    self.goldLableTip =goldLableTip;
    [backgroundView addSubview:goldLableTip];
    
    YYLabel *goldLable =[YYLabel new];
    [goldLable setText: @"-"];
    if (model.userWalletVO.coin) {
       [goldLable setText: [NSString stringWithFormat:@"%ld",model.userWalletVO.coin]];
    }
    
    //[goldLable setText:@"123123"];
    [goldLable setTextColor:HEX_COLOR(0x454444)];
    [goldLable setFont:REGULAR_FONT(20)];
    self.goldLable =goldLable;
    [goldLable setTextAlignment:NSTextAlignmentCenter];
    [backgroundView addSubview:goldLable];
    
    YYLabel *moneyTip =[YYLabel new];
    [moneyTip setText:@"现金"];
    [moneyTip setTextColor:HEX_COLOR(0x9B9B9B)];
    [moneyTip setFont:REGULAR_FONT(12)];
    self.moneyTip =moneyTip;
    [backgroundView addSubview:moneyTip];
    
    YYLabel *moneyLable =[YYLabel new];
    [moneyLable setText:@"-"];
    if (model.userWalletVO.canTxMoney) {
        [moneyLable setText:[NSString stringWithFormat:@"%.2lf",model.userWalletVO.canTxMoney]];
    }
    
    [moneyLable setTextColor:HEX_COLOR(0x454444)];
    [moneyLable setFont:REGULAR_FONT(20)];
    self.moneyLable =moneyLable;
    [moneyLable setTextAlignment:NSTextAlignmentCenter];
    [backgroundView addSubview:moneyLable];
    
    YYLabel *timeLableTip =[YYLabel new];
    [timeLableTip setText:@"今日阅读/分钟"];
    [timeLableTip setTextColor:HEX_COLOR(0x9B9B9B)];
    [timeLableTip setFont:REGULAR_FONT(12)];
    self.timeLableTip =timeLableTip;
    [backgroundView addSubview:timeLableTip];
    
    YYLabel *timeLable =[YYLabel new];
    [timeLable setText:@"-"];
    if (model.userTodayVO.readTime) {
        [timeLable setText:[NSString stringWithFormat:@"%ld",model.userTodayVO.readTime/60]];
    }
    
    [timeLable setTextColor:HEX_COLOR(0x454444)];
    [timeLable setFont:REGULAR_FONT(20)];
    self.timeLable =timeLable;
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    [backgroundView addSubview:timeLable];
    
    
    
    if ([Defaults integerForKey:ISDEBUG]) {
        [goldAbout setHidden:YES];
        [goldBackground setHidden:YES];
        [goldLableTip setHidden:YES];
        [goldLable setHidden:YES];
        
        [moneyTip setHidden:YES];
        [moneyLable setHidden:YES];
        
        [timeLableTip setHidden:YES];
        [timeLable setHidden:YES];
    }
    
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMoney)];
    [goldLableTip addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMoney)];
    [goldLable addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMoney)];
    [goldAbout addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMoney)];
    [moneyLable addGestureRecognizer:tap4];
    UITapGestureRecognizer *tap5 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpMoney)];
    [moneyTip addGestureRecognizer:tap5];
   
  
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self dynamicCalculate];
  //  [self.goldBackground.image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    
    [self layoutIfNeeded];
    //这里设置的是左上和左下角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.aboutMoney.bounds   byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight |  UIRectCornerBottomRight    cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.aboutMoney.bounds;
    maskLayer.path = maskPath.CGPath;
    self.aboutMoney.layer.mask = maskLayer;
}

- (void)dynamicCalculate{
    __weak typeof(self) wself = self;
    
   // [self.imButton setBackgroundColor: [UIColor redColor]];
//    [self.imButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(wself.contentView);
//        make.left.mas_equalTo(wself.contentView).offset(16);
//        make.width.height.mas_equalTo(44);
//
//    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(wself.contentView.mas_left).offset(16);
        make.width.height.mas_equalTo(50);
        
    }];
    
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius: 50/2.0];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.avatar.mas_right).offset(11.5);
        
        if (![UserManagerInstance user_isLogin]){
            make.centerY.mas_equalTo(wself.avatar.mas_centerY);
        }else{
            make.top.mas_equalTo(12);
        }
        make.height.mas_equalTo(24);
        make.right.mas_lessThanOrEqualTo(-16);
    }];
    
    [self.invitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.userName.mas_left);
        make.top.mas_equalTo(wself.userName.mas_bottom).offset(3);
        make.height.mas_equalTo(14);
        make.right.mas_lessThanOrEqualTo(-16);
    }];
    
    
    CGFloat kHeight =157;
    
    if ([Defaults integerForKey:ISDEBUG]) {
        kHeight =148-44;
    }
    
    [self.bckgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(kHeight);
    }];
    
    CGFloat width =(KSCREEN_WIDTH- KSCALEWidth(16)*2.0)/3.0;
    
    CGFloat aboutHeight =18;
    CGFloat aboutWidth =0.0;
    
    NSMutableAttributedString *aboutStr =[STSystemHelper attributedContent:self.aboutMoney.text?self.aboutMoney.text:@"" color:HEX_COLOR(0xD16710) font:REGULAR_FONT(10)];
    
    aboutWidth =[aboutStr mol_getAttributedTextHeightWithMaxWith:aboutHeight font:REGULAR_FONT(10)];
    
    [self.aboutMoney mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.goldLableTip.mas_right);
        make.height.mas_equalTo(aboutHeight);
        make.width.mas_equalTo(4+aboutWidth+4);
        make.bottom.mas_equalTo(wself.goldLableTip.mas_top).offset(-5);
    }];
    
    
    
    
    
//    [self.goldBackground mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(wself.goldAbout.mas_left).offset(-6);
//        make.right.mas_equalTo(wself.goldAbout.mas_right).offset(4);
//        make.height.mas_equalTo(2+aboutHeight+2);
//        make.width.mas_equalTo(4+aboutWidth+4);
//        make.centerY.mas_equalTo(wself.goldAbout.mas_centerY);
//    }];
    
    
    [self.goldLableTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(59);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(12);
        make.centerX.mas_equalTo(wself.goldLable.mas_centerX);
        make.top.mas_equalTo(wself.avatar.mas_bottom).offset(41);
    }];
    
    
    [self.goldLable mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(KSCALEWidth(16));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(wself.goldLableTip.mas_bottom).offset(8);
    }];
    
    [self.moneyTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.goldLableTip.mas_right).offset(KSCALEWidth(92));
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(12);
        make.centerX.mas_equalTo(wself.moneyLable.mas_centerX);
        make.top.mas_equalTo(wself.avatar.mas_bottom).offset(41);
    }];
    
    [self.moneyLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.goldLable.mas_right);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(wself.moneyTip.mas_bottom).offset(8);
    }];
    
    [self.timeLableTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-KSCALEWidth(30));
        make.left.mas_greaterThanOrEqualTo(wself.moneyTip.mas_right);
        make.height.mas_equalTo(12);
       // make.centerX.mas_equalTo(wself.timeLable.mas_centerX);
        make.top.mas_equalTo(wself.avatar.mas_bottom).offset(41);
    }];
    
    [self.timeLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(wself.moneyLable.mas_right);
        make.right.mas_equalTo(-KSCALEWidth(16));
        make.width.mas_equalTo(KSCALEWidth(16+78+16));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(wself.moneyTip.mas_bottom).offset(8);
    }];
    
    
}


- (void)userEvent{
    
}

- (void)userNameEvent:(UIButton *)sender{
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
}

- (void)avatarEvent:(UITapGestureRecognizer *)sender{
    
}

//- (void)imButtonEvent{
//    if (![UserManagerInstance user_isLogin]) {
//        [[GlobalManager shareGlobalManager] global_modalLogin];
//        return;
//    }
//    IMViewController *im =[IMViewController new];
//    [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:im animated:YES];
//}

- (void)jumpMoney{
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    MOLWebViewController *webView =[MOLWebViewController new];
    NSString *url =[BMSHelper getBaseUrl];
    webView.urlString =[NSString stringWithFormat:@"%@%@",url,WALLETWIDTHDRAW];
   
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:webView animated:YES];
   
}

- (void)invitCodeEvent{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *boardString = [NSString stringWithFormat:@"%ld",self.userModel.uuid];
    [board setString:boardString];
    [OMGToast showWithText: @"复制邀请码成功"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
