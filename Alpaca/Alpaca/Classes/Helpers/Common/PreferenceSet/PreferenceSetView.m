//
//  PreferenceSetView.m
//  Alpaca
//
//  Created by xujin on 2018/12/1.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "PreferenceSetView.h"
#import "BookcaseApi.h"
#import "BSTabBarController.h"
#import "UserModel.h"

@interface PreferenceSetView()
@property (nonatomic, strong)UIButton *boyAvatars;
@property (nonatomic, strong)UIButton *girlAvatars;
@property (nonatomic, strong)YYLabel *welcome;
@property (nonatomic, strong)YYLabel *benefits;
//@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UIButton *accountButton;

@end

@implementation PreferenceSetView

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
    
   // [self addSubview:self.closeButton];
    [self addSubview:self.welcome];
    [self addSubview:self.benefits];
    [self addSubview:self.boyAvatars];
    [self addSubview:self.girlAvatars];
    [self addSubview:self.accountButton];
    
    
}



//- (UIButton *)closeButton{
//    if (!_closeButton) {
//        _closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_closeButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [_closeButton addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _closeButton;
//}

- (UIButton *)boyAvatars{
    if (!_boyAvatars) {
        _boyAvatars=[UIButton buttonWithType:UIButtonTypeCustom];
        [_boyAvatars setImage:[UIImage imageNamed:@"boyDefault"] forState:UIControlStateNormal];
        [_boyAvatars setImage:[UIImage imageNamed:@"boySelected"] forState:UIControlStateSelected];
//        [_boyAvatars setTitle:@"男生频道" forState:UIControlStateNormal];
//        [_boyAvatars setTitle:@"男生频道" forState:UIControlStateSelected];
//        [_boyAvatars setTitleColor:HEX_COLOR_ALPHA(0xDEE2E8,1.0) forState:UIControlStateNormal];
//        [_boyAvatars setTitleColor:HEX_COLOR_ALPHA(0x000000,1.0) forState:UIControlStateSelected];
//        [_boyAvatars.titleLabel setFont:REGULAR_FONT(16)];
        [_boyAvatars addTarget:self action:@selector(boyAvatarsEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _boyAvatars;
}

- (UIButton *)girlAvatars{
    if (!_girlAvatars) {
        _girlAvatars=[UIButton buttonWithType:UIButtonTypeCustom];
        [_girlAvatars setImage:[UIImage imageNamed:@"girlDefault"] forState:UIControlStateNormal];
        [_girlAvatars setImage:[UIImage imageNamed:@"girlSelected"] forState:UIControlStateSelected];
//        [_girlAvatars setTitle:@"女生频道" forState:UIControlStateNormal];
//        [_girlAvatars setTitle:@"女生频道" forState:UIControlStateSelected];
//        [_girlAvatars setTitleColor:HEX_COLOR_ALPHA(0xDEE2E8,1.0) forState:UIControlStateNormal];
//        [_girlAvatars setTitleColor:HEX_COLOR_ALPHA(0x000000,1.0) forState:UIControlStateSelected];
//        [_girlAvatars.titleLabel setFont:REGULAR_FONT(16)];
        [_girlAvatars addTarget:self action:@selector(girlAvatarsEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _girlAvatars;
}

- (YYLabel *)welcome{
    if (!_welcome) {
        _welcome =[YYLabel new];
        [_welcome setTextColor: HEX_COLOR(0x000000)];
        [_welcome setFont: REGULAR_FONT(24)];
        [_welcome setTextAlignment:NSTextAlignmentCenter];
        [_welcome setText: @"请选择你的阅读偏好"];
    }
    return _welcome;
}

- (YYLabel *)benefits{
    if (!_benefits) {
        _benefits =[YYLabel new];
        [_benefits setTextColor: HEX_COLOR(0x979FAC)];
        [_benefits setFont: REGULAR_FONT(13)];
        [_benefits setTextAlignment:NSTextAlignmentCenter];
        [_benefits setText: @"根据阅读偏好为你推荐最合适的书籍"];
    }
    return _benefits;
}



- (UIButton *)accountButton{
    if (!_accountButton) {
        _accountButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_accountButton setTitle:@"开始阅读" forState:UIControlStateNormal];
        [_accountButton setTitle:@"开始阅读" forState:UIControlStateSelected];
        [_accountButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateSelected];
        [_accountButton setTitleColor:HEX_COLOR(0xDEE2E8) forState:UIControlStateNormal];
        [_accountButton setBackgroundColor:HEX_COLOR(0xF6F8FB)];
        [_accountButton.titleLabel setFont:MEDIUM_FONT(16)];
        [_accountButton addTarget:self action:@selector(accountEvnet:) forControlEvents:UIControlEventTouchUpInside];
        [_accountButton.layer setCornerRadius:5];
        [_accountButton.layer setMasksToBounds:YES];
    }
    return _accountButton;
}


- (void)calculatorUpdateViewFrame{
    __weak typeof(self) wself = self;
    
//    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(wself).mas_offset(StatusBarHeight);
//        make.width.mas_equalTo(44);
//        make.height.mas_equalTo(44);
//    }];
    
    
    [self.welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight+44+40);
        make.centerX.mas_equalTo(wself.mas_centerX);
        make.height.mas_equalTo(35);
    }];
    
    [self.benefits mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.welcome.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(wself.mas_centerX);
        make.height.mas_equalTo(18);
    }];
    
   // CGFloat leftWidth =(KSCREEN_WIDTH-114*2.0-41)/2.0;
    CGFloat leftWidth =(KSCREEN_WIDTH-100*2.0-55)/2.0;
    
    [self.boyAvatars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.benefits.mas_bottom).mas_offset(67);
        make.left.mas_equalTo(leftWidth);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [self.girlAvatars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.boyAvatars.mas_top);
        make.left.mas_equalTo(wself.boyAvatars.mas_right).mas_offset(55);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    
    [self.accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.girlAvatars.mas_bottom).mas_offset(141);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(50);
    }];
    
    
//    // 图片右移
//    CGFloat  imageHight = CGRectGetHeight(self.boyAvatars.imageView.bounds);
//    CGFloat  imageWidth = CGRectGetWidth(self.boyAvatars.imageView.bounds);
//    // 文字左移
//    CGFloat titleHight =CGRectGetHeight(self.boyAvatars.titleLabel.bounds);
//
//    self.boyAvatars.titleEdgeInsets = UIEdgeInsetsMake(imageHight/2.0,-imageWidth, -imageHight/2.0, 0.0);
//
//    self.boyAvatars.imageEdgeInsets = UIEdgeInsetsMake(-titleHight/2.0,0.0, titleHight/2.0, 0.0);
//
//
//    self.girlAvatars.titleEdgeInsets = UIEdgeInsetsMake(imageHight/2.0,-imageWidth, -imageHight/2.0, 0.0);
//
//    self.girlAvatars.imageEdgeInsets = UIEdgeInsetsMake(-titleHight/2.0,0.0, titleHight/2.0, 0.0);
    
    if (self.type == 100) { //表示来自我
        if ([Defaults integerForKey:CHANNEL] ==2) { //女
            [self.girlAvatars setSelected:YES];
        }else{//男
            [self.boyAvatars setSelected:YES];
        }
        
        [self accountSelectEvent];
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self calculatorUpdateViewFrame];
}

#pragma mark-
#pragma action event

-(void)accountSelectEvent{
    
    if (self.boyAvatars.isSelected || self.girlAvatars.isSelected) {
        [self.accountButton setBackgroundColor:HEX_COLOR(0x19B898)];
        [self.accountButton setSelected:YES];
    }else{
        [self.accountButton setBackgroundColor:HEX_COLOR(0xF6F8FB)];
        [self.accountButton setSelected:NO];
    }
    
}

- (void)boyAvatarsEvent:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.isSelected) {
        if (self.girlAvatars.isSelected) {
            [self.girlAvatars setSelected:NO];
        }
        [Defaults setInteger:1 forKey:CHANNEL];
        
    }
    [self accountSelectEvent];
    
}

- (void)girlAvatarsEvent:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.isSelected) {
        if (self.boyAvatars.isSelected) {
            [self.boyAvatars setSelected:NO];
        }
        [Defaults setInteger:2 forKey:CHANNEL];
        
    }
    [self accountSelectEvent];
}

- (void)accountEvnet:(UIButton *)sender{
    if ([Defaults integerForKey:CHANNEL]>0) {
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)[Defaults integerForKey:CHANNEL]] forKey: @"channelCode"];
        
        __weak typeof(self) wself = self;
        [[[BookcaseApi alloc] initChannelSettingInfo:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
            
            if (code == SUCCESS_REQUEST) {
                
                if (![Defaults boolForKey:SetupInit]) { //第一次安装
                    [wself configInitShelfApi];
                }
                
               BSTabBarController *tabBar=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
                tabBar.selectedIndex =1;
                
                if (self.type == 100) {
                    
                    if ([UserManagerInstance user_isLogin]) {
                        UserModel *userModle =[UserManagerInstance user_getUserInfo];
                        userModle.userChannelVO.channelType =[Defaults integerForKey:CHANNEL];
                        // 登录成功
                        [UserManagerInstance user_saveUserInfoWithModel:userModle isLogin:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PREFERENCE_START_NOTIF object:nil];
                    
                }
                

                [self removeEvent];
            }else{
                [OMGToast showWithText: message];
            }
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            [OMGToast showWithText:@"无可用网络，请检查网络再试"];
        }];
    }
}

- (void)removeEvent{
    
    for (id views in self.subviews) {
        [views removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)closeEvent:(UIButton *)sender{
    [self removeEvent];
    //    if (_delegate && [_delegate respondsToSelector:@selector(newUserBenefitsViewCloseEvent:)]) {
    //        [_delegate newUserBenefitsViewCloseEvent:self];
    //    }
}

/// 书架初始化--app首次启动时候客户端调用加入推荐书
- (void)configInitShelfApi{
    [[[BookcaseApi alloc] initShelf:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"BookcaseViewController" object:nil];
        }else{
            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
