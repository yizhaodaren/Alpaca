//
//  BookcaseHeaderView.m
//  Alpaca
//
//  Created by xujin on 2018/12/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookcaseHeaderView.h"
#import "MOLWebViewController.h"
#import <SGAdvertScrollView/SGAdvertScrollView.h>
#import "BookcaseApi.h"
#import "BMSHelper.h"
#import "InviteLogGroupModel.h"
#import "InviteLogModel.h"
#import "BSTabBarController.h"
#import "UserModel.h"

@interface  BookcaseHeaderView()<SGAdvertScrollViewDelegate>
@property (nonatomic, weak)UIView *bgView;
@property (nonatomic, weak)UIImageView *contentBg;
@property (nonatomic, weak)UIButton *ruleButton;
@property (nonatomic, weak)UILabel *timeLable;
@property (nonatomic, weak)UILabel *timeTip;
@property (nonatomic, weak)UILabel *awardTip;
@property (nonatomic, weak)UIImageView *awardImageView;
@property (nonatomic, weak)UILabel *awardLable;
@property (nonatomic, weak)UIButton *goWithdraw;
@property (nonatomic, weak)SGAdvertScrollView *advertScrollView;
@property (nonatomic, weak)UIImageView *emojiImageView;
@property (nonatomic, weak)UIImageView *arrowsImageView;
@property (nonatomic, weak)UIView *lineView;
@property (nonatomic, weak)UIButton *loginButton;
@property (nonatomic, assign)BOOL status;



@end

@implementation BookcaseHeaderView

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
     
      [self layoutNotifcation];
      [self layoutUI];
      [self getInviteMasterLog];
    }
    return self;
}



- (void)layoutNotifcation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollStatus:) name:@"SGAdvertScrollView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent) name:SUCCESS_USER_LOGINOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIsDebugStatus) name:@"updatecontrollerUI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorEvent:) name:@"BookcaseViewControllerStatus" object:nil];
    
    
    
}



- (void)updateIsDebugStatus{
    [self getInviteMasterLog];
}


- (void)layoutUI{
    
    UserModel *userModel =[UserManagerInstance user_getUserInfo];
    if (!userModel) {
        userModel =[UserModel new];
    }
    
    UIView *bgView =[UIView new];
    [bgView setBackgroundColor:HEX_COLOR(0xffffff)];
    self.bgView =bgView;
    [self addSubview:bgView];
    
    UIImageView *contentBgView =[UIImageView new];
    [contentBgView setImage:[UIImage imageNamed:@"bookCaseH"]];
    self.contentBg =contentBgView;
    [contentBgView setContentMode:UIViewContentModeScaleAspectFill];
    [bgView addSubview:contentBgView];
    
    UIButton *ruleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [ruleButton addTarget:self action:@selector(ruleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [ruleButton setImage:[UIImage imageNamed:@"Description"] forState:UIControlStateNormal];
    [ruleButton setTitle:@"查看奖励规则" forState:UIControlStateNormal];
    [ruleButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    [ruleButton.titleLabel setFont:REGULAR_FONT(10)];
    self.ruleButton =ruleButton;
    
    [ruleButton setHidden:YES];
    
    [bgView addSubview:ruleButton];
    
    
    UILabel *timeLable =[UILabel new];
    [timeLable setTextColor: HEX_COLOR(0x4A4A4A)];
    [timeLable setFont: MEDIUM_FONT(60)];
    [timeLable setText:[NSString stringWithFormat:@"%ld",(long)userModel.userTodayVO.readTime]];
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    self.timeLable =timeLable;
    [bgView addSubview:timeLable];
    
    UILabel *timeTip =[UILabel new];
    [timeTip setTextColor: HEX_COLOR(0x4A4A4A)];
    [timeTip setFont: REGULAR_FONT(12)];
    [timeTip setText:@"今日阅读时长/分钟"];
    [timeTip setTextAlignment:NSTextAlignmentCenter];
    self.timeTip =timeTip;
    [bgView addSubview:timeTip];
    
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(loginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:REGULAR_FONT(20)];
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setBorderWidth:1];
    [loginButton.layer setBorderColor:[HEX_COLOR(0x4A4A4A) CGColor]];
    [loginButton.layer setCornerRadius: 25];
    [loginButton setHidden:YES];
    self.loginButton =loginButton;
    [bgView addSubview:loginButton];
    
    UILabel *awardTip =[UILabel new];
    [awardTip setTextColor: HEX_COLOR(0x4A4A4A)];
    [awardTip setFont: REGULAR_FONT(14)];
    [awardTip setText:@"已获得奖励："];
    self.awardTip =awardTip;
    [awardTip setHidden:YES];
    [bgView addSubview:awardTip];
    
    UIImageView *awardImageView =[UIImageView new];
    [awardImageView setImage:[UIImage imageNamed:@"gold"]];
    self.awardImageView =awardImageView;
    [awardImageView setHidden:YES];
    [bgView addSubview:awardImageView];
    
    
    UILabel *awardLable =[UILabel new];
    [awardLable setTextColor: HEX_COLOR(0x4A4A4A)];
    [awardLable setFont: SEMIBOLD_FONT(16)];
    [awardLable setText:[STSystemHelper getNum:500]];
    self.awardLable =awardLable;
    [awardLable setText:[NSString stringWithFormat:@"%ld",userModel.userTodayVO.coin]];
    [awardLable setHidden:YES];
    [bgView addSubview:awardLable];
    
    UIButton *goWithdraw=[UIButton buttonWithType:UIButtonTypeCustom];
    [goWithdraw addTarget:self action:@selector(goWithdrawEvent:) forControlEvents:UIControlEventTouchUpInside];
    [goWithdraw setTitle:@"去提现" forState:UIControlStateNormal];
    [goWithdraw setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    [goWithdraw.titleLabel setFont:REGULAR_FONT(12)];
    self.goWithdraw =goWithdraw;
    NSLog(@"%ld",[Defaults integerForKey:ISDEBUG]);
    [goWithdraw setHidden:YES];
    [bgView addSubview:goWithdraw];
    [goWithdraw.layer setCornerRadius: 10];
    [goWithdraw.layer setMasksToBounds:YES];
    [goWithdraw.layer setBorderWidth: 1];
    [goWithdraw.layer setBorderColor:[HEX_COLOR(0x4A4A4A) CGColor]];
    
   
    SGAdvertScrollView *advertScrollView =[SGAdvertScrollView new];
    [advertScrollView setHidden:YES];
    [advertScrollView setBackgroundColor:HEX_COLOR(0xffffff)];
    //        [_advertScrollView.layer setCornerRadius:15];
    //        [_advertScrollView.layer setMasksToBounds:YES];
    advertScrollView.textAlignment = NSTextAlignmentCenter;
    // 例二
    //        _advertScrollView.signImages = @[@"emoji", @"emoji", @"emoji"];
    //        _advertScrollView.titles = @[@"7分钟前，颠覆人文提现了6.89元", @"7分钟前，颠覆人文提现了6.89元", @"7分钟前，颠覆人文提现了6.89元"];
    advertScrollView.titleColor =HEX_COLOR(0x979FAC);
    advertScrollView.titleFont =REGULAR_FONT(14);
    advertScrollView.scrollTimeInterval = 2;
    advertScrollView.delegate =self;
    self.advertScrollView =advertScrollView;
    [bgView addSubview:advertScrollView];
    
    
    UIImageView *emojiImageView =[UIImageView new];
    [emojiImageView setImage:[UIImage imageNamed:@"emoji"]];
    self.emojiImageView =emojiImageView;
    [advertScrollView addSubview:emojiImageView];
    
    
    UIImageView *arrowsImageView =[UIImageView new];
    [arrowsImageView setImage:[UIImage imageNamed:@"bookcasemore"]];
    self.arrowsImageView =arrowsImageView;
    [advertScrollView addSubview:arrowsImageView];
    
    
    UIView *lineView =[UIView new];
    [lineView setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    self.lineView =lineView;
    [bgView addSubview:lineView];
    
    [self loginEdShowEvent];

}

- (void)dynamicCalculateLayout{
    
    __weak typeof(self) wself = self;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(wself);
        make.left.mas_equalTo(-15);
        make.right.mas_equalTo(15);
    }];
    
    [self.contentBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(wself);
        make.height.mas_equalTo(KSCALEHeight(180));
    }];
    
    [self.ruleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(KSCALEHeight(5+14+5));
    }];
    
    [self.timeLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.ruleButton.mas_bottom);
        make.centerX.mas_equalTo(wself);
        make.height.mas_equalTo(KSCALEHeight(60));
    }];
    
    [self.timeTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.timeLable.mas_bottom).offset(10);
        make.centerX.mas_equalTo(wself);
        make.height.mas_equalTo(KSCALEHeight(12));
    }];
    
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentBg).offset(40);
        make.centerX.mas_equalTo(wself);
        make.height.mas_equalTo(KSCALEHeight(50));
        make.width.mas_equalTo(KSCALEHeight(170));
    }];
    
    
    
    [self.awardTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentBg.mas_bottom).offset(-10);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(KSCALEHeight(20));
        make.width.mas_equalTo(84);
    }];
    
    [self.awardImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentBg.mas_bottom).offset(-12);
        make.left.mas_equalTo(wself.awardTip.mas_right);
        make.right.mas_lessThanOrEqualTo(wself.awardLable.mas_left);
        make.height.width.mas_equalTo(KSCALEHeight(16));
    }];
    
    [self.awardLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentBg.mas_bottom).offset(-12);
        make.left.mas_equalTo(wself.awardImageView.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(wself.goWithdraw.mas_left);
        make.height.mas_equalTo(KSCALEHeight(16));
    }];
    
    [self.goWithdraw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentBg.mas_bottom).offset(-11);
        make.left.mas_greaterThanOrEqualTo(wself.awardTip.mas_right);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(KSCALEHeight(20));
        make.width.mas_equalTo(KSCALEWidth(50));
    }];


}

- (void)lauoutFrame{
    __weak typeof(self) wself = self;
    
    [self.advertScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(wself.bgView);
        make.top.mas_equalTo(wself.contentBg.mas_bottom);
        make.height.mas_equalTo([Defaults integerForKey:ISDEBUG]?0:40);
    }];
    
    [self.emojiImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wself.advertScrollView.mas_centerY);
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(wself.bgView).offset(16);

    }];
    
    [self.arrowsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wself.advertScrollView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.advertScrollView.mas_bottom);
        make.left.right.mas_equalTo(wself.bgView);
        make.height.mas_equalTo(KSCALEHeight(5));
        
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self dynamicCalculateLayout];
    [self lauoutFrame];
}


- (void)showEvent{
    [self.ruleButton setHidden:[Defaults integerForKey:ISDEBUG]];
    [self.awardTip setHidden:[Defaults integerForKey:ISDEBUG]];
    [self.awardImageView setHidden:[Defaults integerForKey:ISDEBUG]];
    [self.awardLable setHidden:[Defaults integerForKey:ISDEBUG]];
    [self.goWithdraw setHidden:[Defaults integerForKey:ISDEBUG]];
    
    if ([Defaults integerForKey:ISDEBUG]) {
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        [self.loginButton setTitle:@"登录阅读得金币" forState:UIControlStateNormal];
    }
    
    if (![UserManagerInstance user_isLogin]) {
       [self.loginButton setHidden:[Defaults integerForKey:ISDEBUG]];
    }
    
}

- (void)loginEdShowEvent{
    
    if (![UserManagerInstance user_isLogin]) {//未登录
        [self.timeTip setHidden:YES];
        [self.timeLable setHidden:YES];
        [self.loginButton setHidden:NO];
//        [self.loginButton setHidden:[Defaults integerForKey:ISDEBUG]];
        [self.awardLable setText:[STSystemHelper getNum:0]];
        
    }else{//已登录
        [self.timeTip setHidden:NO];
        [self.timeLable setHidden:NO];
        [self.loginButton setHidden:YES];
    }
    
}




#pragma mark -SGAdvertScrollViewDelegate
/// 代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    
    if (self.status) {
        return;
    }
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    
    MOLWebViewController *webView =[MOLWebViewController new];
    NSString *url =[BMSHelper getBaseUrl];
    webView.urlString =[NSString stringWithFormat:@"%@%@",url,WIDTHDRAW];
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:webView animated:YES];
    
    
    
//    [[[BookcaseApi alloc] initUserWalletWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
//        if (code ==SUCCESS_REQUEST) {
//
//            NSInteger inviteNum =[request.responseObject[@"resBody"][@"inviteNum"] integerValue];
//
//            MOLWebViewController *webView =[MOLWebViewController new];
//            NSString *url =[BMSHelper getBaseUrl];
//
//            if (inviteNum) {
//
//                webView.urlString =[NSString stringWithFormat:@"%@%@",url,WIDTHDRAW];
//
//            }else{
//
//                webView.urlString =[NSString stringWithFormat:@"%@%@",url,MYWALLETHTMl];
//
//            }
//
//            [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:webView animated:YES];
//
//        }
//    } failure:^(__kindof BSNetRequest * _Nonnull request) {
//
//    }];
}

- (void)getInviteMasterLog{
    
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initInviteMasterLogWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        
        if (code == SUCCESS_REQUEST) {
            InviteLogGroupModel *group =(InviteLogGroupModel *)responseModel;
            
            NSMutableArray *titleArr =[NSMutableArray array];
            for (InviteLogModel *modle in group.resBody) {
                
               //  NSString *timeStr =@"刚刚";
                
                if (modle.msgType ==1) {
                    
                    [titleArr addObject: [NSString stringWithFormat:@"%@刚刚邀请了%ld位好友将获得%ld元",modle.userName,modle.num,4*modle.num]];
                    
                }else{
                   // X刚刚提现了Y元到微信
                    [titleArr addObject: [NSString stringWithFormat:@"%@刚刚提现了%ld元到微信",modle.userName,modle.money]];
                }
//                if (modle.minute) {
//                    timeStr =[NSString stringWithFormat:@"%ld分钟前",modle.minute];
//                }
//                [titleArr addObject: [NSString stringWithFormat:@"%@,%@提现了%@元",timeStr,modle.userName,modle.money]];
                
            }
            wself.advertScrollView.titles =titleArr;
            
        }else{
            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
    
}

- (void)content{
    UserModel *userModel =[UserManagerInstance user_getUserInfo];
    if (!userModel) {
        userModel =[UserModel new];
    }
    [self.timeLable setText:[NSString stringWithFormat:@"%ld",(long)userModel.userTodayVO.readTime/60]];
    [self.awardLable setText:[NSString stringWithFormat:@"%ld",(long)userModel.userTodayVO.coin]];
}


#pragma mark -NSNotification
- (void)refreshScrollStatus:(NSNotification *)notif{
    if (self.advertScrollView && self.advertScrollView.isHidden) {
        [self.advertScrollView setHidden:NO];
        [self lauoutFrame];
    }
    [self showEvent];
}

- (void)logOutEvent{
    [self loginEdShowEvent];
}

- (void)login_success{
    [self loginEdShowEvent];
}

- (void)editorEvent:(NSNotification *)notif{
    NSNumber *number =(NSNumber *)notif.object;
    self.status = !number.boolValue;
}


#pragma mark - action event
- (void)ruleButtonEvent:(UIButton *)sender{
    
    if (self.status) {
        return;
    }
    
    BSTabBarController *tabBar=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
    tabBar.selectedIndex =2;
}

- (void)goWithdrawEvent:(UIButton *)sender{
    
    if (self.status) {
        return;
    }
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    MOLWebViewController *webView =[MOLWebViewController new];
    NSString *url =[BMSHelper getBaseUrl];
    webView.urlString =[NSString stringWithFormat:@"%@%@",url,WALLETWIDTHDRAW];
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:webView animated:YES];

}

- (void)loginButtonEvent:(UIButton *)sender{
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
