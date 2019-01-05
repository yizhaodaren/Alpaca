//
//  LoginViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginApi.h"
#import "MobileViewController.h"
#import "MOLWebViewController.h"


@interface LoginViewController ()<TYAttributedLabelDelegate>
@property (nonatomic ,strong)NSArray *iconArr;
@property (nonatomic ,strong)NSArray *deIconArr;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self layoutNavigationBar];
    [self layoutUI];
}

- (void)initData{
    
    self.iconArr =@[@"phone",@"QQ",@"web"];
    self.deIconArr =@[@"phone-1",@"QQ-1",@"web-1"];
    
    
}

- (void)layoutNavigationBar{
   // self.showNavigation =YES;
    [self navigationLeftItemWithImageName:@"back" centerTitle:@"登录" titleColor:HEX_COLOR(0x000000)];
}

- (void)layoutUI{
    [self.view setBackgroundColor:HEX_COLOR(0xffffff)];
    
    UIImageView *iconImage =[UIImageView new];
    [iconImage setImage: [UIImage imageNamed:@"headerD"]];
    
    [self.view addSubview:iconImage];
    
    UIButton *wxButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [wxButton setBackgroundColor:HEX_COLOR(0x19B898)];
    [wxButton setTitle:@"微信快捷登录" forState:UIControlStateNormal];
    [wxButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [wxButton.titleLabel setFont: MEDIUM_FONT(16)];
    [wxButton addTarget:self action:@selector(wxEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxButton];
    
    UIView *leftLine =[UIView new];
    [leftLine setBackgroundColor:HEX_COLOR(0xDFDFDF)];
    [self.view addSubview:leftLine];
    
    YYLabel *tipLable =[YYLabel new];
    [tipLable setFont: REGULAR_FONT(12)];
    [tipLable setTextColor: HEX_COLOR(0x585858)];
    [tipLable setText:@"其他登录方式"];
    [self.view addSubview:tipLable];
    
    UIView *rightLine =[UIView new];
    [rightLine setBackgroundColor:HEX_COLOR(0xDFDFDF)];
    [self.view addSubview:rightLine];
    
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    __weak typeof(self) wself = self;
    CGFloat iconY= StatusBarAndNavigationBarHeight+35;
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(wself.view.mas_centerX);
        make.width.height.mas_equalTo(110);
        make.top.mas_equalTo(iconY);
    }];
    
    [iconImage.layer setCornerRadius:20];
    [iconImage.layer setMasksToBounds:YES];
    
    [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImage.mas_bottom).offset(69);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [wxButton.layer setMasksToBounds:YES];
    [wxButton.layer setCornerRadius:5];
    
    
   
    
    [tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wxButton.mas_bottom).offset(192);
        make.centerX.mas_equalTo(wself.view.mas_centerX);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(72);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLable.mas_centerY);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(tipLable.mas_left).offset(-10);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLable.mas_centerY);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(tipLable.mas_right).offset(10);
        make.right.mas_equalTo(-30);
    }];
    
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    
    CGFloat leftX =(KSCREEN_WIDTH-30*self.iconArr.count-30*(self.iconArr.count-1))/2.0;
    CGFloat space =30;
    CGFloat width =30;
    
    for (NSInteger i=0; i<self.iconArr.count; i++) {
        UIButton *iconButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setImage:[UIImage imageNamed:self.iconArr[i]] forState:UIControlStateHighlighted];
        [iconButton setImage:[UIImage imageNamed:self.deIconArr[i]] forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(iconEvent:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag =1000+i;
        [iconButton setAlpha:1];
        [self.view addSubview:iconButton];
        
        if (![Defaults integerForKey:ISDEBUG]){//sh
            if (i==0 || i==2) {
                [iconButton setAlpha:0];
            }
        }
        
        [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipLable.mas_bottom).offset(20);
            make.height.width.mas_equalTo(30);
            make.left.mas_equalTo(leftX+(space+width)*i);
           
        }];
    
    }
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    //label.highlightedLinkColor = [UIColor redColor];
    [label setTextAlignment:kCTTextAlignmentRight];
    label.delegate =self;
    [label setBackgroundColor: [UIColor clearColor]];
    [self.view addSubview:label];
    
    
    NSString *text =@"登录即代表您同意羊驼小说 用户协议";
    
    
    // 属性文本生成器
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.textAlignment = NSTextAlignmentRight;
    [textContainer setStrokeColor: [UIColor clearColor]];
    [textContainer setTextColor:HEX_COLOR(0xDCDCDC)];
    [textContainer setFont: REGULAR_FONT(12)];
    
    [textContainer addLinkWithLinkData:@"用户协议" linkColor:HEX_COLOR(0xDCDCDC) underLineStyle:kCTUnderlineStyleSingle range:[text rangeOfString:@"用户协议"]];
    
    
    label.textContainer =textContainer;
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.view.mas_bottom).offset(-24);
        make.height.mas_equalTo(17);
        make.left.right.mas_equalTo(wself.view);
        
    }];
    
    
}

#pragma mark-
#pragma mark 各种事件触发
- (void)leftItemEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{

    __weak typeof(self) wself = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [OMGToast showWithText:@"" topOffset:64];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            // 发送登录请求
            UserManagerInstance.platType = 4;
            UserManagerInstance.platToken = resp.accessToken;
            UserManagerInstance.platUid = resp.uid;
            UserManagerInstance.platOpenid = nil;
            if (platformType == UMSocialPlatformType_WechatSession) {
                UserManagerInstance.platType = 2;
                UserManagerInstance.platOpenid = resp.openid;
                UserManagerInstance.platUid = resp.unionId;
            }else if (platformType == UMSocialPlatformType_Sina){
                UserManagerInstance.platType = 3;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"accessToken"] = UserManagerInstance.platToken;
            dic[@"loginType"] = @(UserManagerInstance.platType);
            dic[@"uid"] = UserManagerInstance.platUid;
            if (UserManagerInstance.platOpenid.length) {
                dic[@"openId"] = UserManagerInstance.platOpenid;
            }
            
            [wself loginEvent:dic];
            
            
        }
    }];
}

- (void)loginEvent:(NSMutableDictionary *)dic{
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    [[[LoginApi alloc] initLoginWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        
        UserModel *user = (UserModel *)responseModel;
        if (code == SUCCESS_REQUEST) {
            // 登录成功
            [UserManagerInstance user_saveUserInfoWithModel:user isLogin:YES];
            
            NSInteger loginType = (NSInteger)[dic objectForKey:@"loginType"];
            [Defaults setInteger:loginType forKey:@"lastLoginType"];
            [Defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_USER_LOGIN object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [OMGToast showWithText:message topOffset:64];
        }
        
        
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [hud hideAnimated:YES];
    }];
}


///微信登录事件
- (void)wxEvent:(UIButton *)sender{
    
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    
}

// 手机登录、QQ登录、微博登录
- (void)iconEvent:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1000://手机登录
        {
            [self.navigationController pushViewController:MobileViewController.new animated:YES];
        }
            break;
        case 1001://QQ登录
        {
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }
            break;
        case 1002://微博登录
        {
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        }
            break;
            
    }
    
}


- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        NSString *string = ((TYLinkTextStorage*)textStorage).linkData;
        if (string && [string isKindOfClass: [NSString class]] && string.length) {
            NSLog(@"跳转到用户协议");
            MOLWebViewController *webView =[MOLWebViewController new];
            webView.urlString =@"http://www.5molihua.cn/static/views/app/about/userAgreement.html";
            [self.navigationController pushViewController:webView animated:YES];
            
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
