//
//  MobileViewController.m
//  Alpaca
//
//  Created by ACTION on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "MobileViewController.h"
#import "LoginApi.h"

@interface MobileViewController ()<UITextFieldDelegate>
{
    NSInteger timeCount;    //获取验证码间隔秒数，目前定于60秒
    NSTimer *_timer;        //获取验证码定时器
}
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UITextField *verificationField;
@property (nonatomic, strong) UIButton *getVCBtn;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation MobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self layoutNavigationBar];
    [self layoutUI];
}

- (void)initData{
    
}

- (void)layoutNavigationBar{
   // self.showNavigation =YES;
    [self navigationLeftItemWithImageName:@"back" centerTitle:@"手机号快捷登录" titleColor:HEX_COLOR(0x000000)];
}

- (void)layoutUI{
    [self.view setBackgroundColor:HEX_COLOR(0xffffff)];
    [self layoutMobileUI];
    
}

/**
 
 */
- (void)layoutMobileUI{
    
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponderEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    YYLabel *mobileLalbel =[YYLabel new];
    [mobileLalbel setText:@"手机号"];
    [mobileLalbel setFont:REGULAR_FONT(15)];
    [mobileLalbel setTextColor:HEX_COLOR(0x9B9B9B)];
    [self.view addSubview:mobileLalbel];
    
    
    self.mobileTextField = [[UITextField alloc] init];
    self.mobileTextField.backgroundColor = [UIColor clearColor];
    [self.mobileTextField setTextColor:HEX_COLOR(0x000000)];
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.font = REGULAR_FONT(15);
    self.mobileTextField.delegate = self;
    self.mobileTextField.tag = 10000;
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.mobileTextField];
    
    UIView * mobileLine =[UIView new];
    [mobileLine setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.view addSubview:mobileLine];
    
    
    YYLabel *verificationLalbel =[YYLabel new];
    [verificationLalbel setText:@"验证码"];
    [verificationLalbel setFont:REGULAR_FONT(15)];
    [verificationLalbel setTextColor:HEX_COLOR(0x9B9B9B)];
    [self.view addSubview:verificationLalbel];
    
    
    self.verificationField = [[UITextField alloc] init];
    self.verificationField.backgroundColor = [UIColor clearColor];
    [self.verificationField setTextColor:HEX_COLOR(0x000000)];
    self.verificationField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationField.font = REGULAR_FONT(15);
    self.verificationField.delegate = self;
    self.verificationField.tag = 10001;
    self.verificationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview: self.verificationField];
    
    
    
    //获取验证码
    self.getVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.getVCBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getVCBtn setTitleColor:HEX_COLOR(0x4A90E2) forState:UIControlStateNormal];
    self.getVCBtn.enabled =YES;
    [self.getVCBtn setTitleColor:HEX_COLOR(0xE2E2E2) forState:UIControlStateDisabled];
    
    self.getVCBtn.titleLabel.font=REGULAR_FONT(15);
    
    [self.getVCBtn addTarget:self action:@selector(getVerificationCodeEvent:) forControlEvents:UIControlEventTouchUpInside];
    // self.getVCBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.getVCBtn];
    
    
    UIView * verificationLine =[UIView new];
    [verificationLine setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.view addSubview:verificationLine];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    self.loginButton.titleLabel.font=MEDIUM_FONT(15);
    [self.loginButton addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setBackgroundColor: HEX_COLOR(0x19B898)];
    self.loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.loginButton];
    
    
    /////////////////////////////////
    __weak typeof(self) wself = self;
    [mobileLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(11+21+11);
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+40-11);
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mobileLalbel.mas_centerY);
        make.left.mas_equalTo(mobileLalbel.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(11+21+11);
    }];
    
    [mobileLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(wself.mobileTextField.mas_bottom);
    }];
    
    [verificationLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mobileLine.mas_bottom).offset(40-11);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(11+21+11);
    }];
    
    
    
    [self.verificationField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(verificationLalbel.mas_centerY);
        make.left.mas_equalTo(verificationLalbel.mas_right).offset(15);
        make.right.mas_equalTo(wself.getVCBtn.mas_left);
        make.height.mas_equalTo(11+21+11);
    }];
    
    
    [self.getVCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(verificationLalbel.mas_centerY);
        make.width.mas_equalTo(96);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(11+21+11);
    }];
    
    
    [verificationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(wself.verificationField.mas_bottom);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(verificationLine.mas_bottom).offset(70);
    }];
    
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer setCornerRadius: 5];
    
    
}

/**
 回收键盘
 
 @param tap 单击手势对象
 */
- (void)resignFirstResponderEvent:(UITapGestureRecognizer *)tap{
    
    [self.mobileTextField resignFirstResponder];
    [self.verificationField resignFirstResponder];
    
}

/**
 获取验证码触发事件
 
 @param verification 获取验证码Button对像
 */
- (void)getVerificationCodeEvent:(UIButton *)verification{
    
    if (![STSystemHelper isMobileNumber:self.mobileTextField.text]) {//非手机号
        //提示：请输入正确的手机号
        [OMGToast showWithText:@"请输入正确的手机号" topOffset:64.0];
        return;
    }
    
    
    timeCount =60;
    
    [self changeUI];
    verification.enabled =NO;
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction:) userInfo:@"100" repeats:YES];
    
    
    NSString *mobilePhone =self.mobileTextField.text;
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    
    __weak typeof(self) wself = self;
    [[[LoginApi alloc] initGetPhoneCodeWithParameter:dic parameterId:mobilePhone?mobilePhone:@""] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code != SUCCESS_REQUEST) {
            [OMGToast showWithText:message topOffset:64];
            /**
             失败后的事件操作
             */
            //结束定时器
            [wself lDeallocTimer];
            [wself sourceUI];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        //结束定时器
        [wself lDeallocTimer];
        [wself sourceUI];
        
    }];
    
}


- (void)sourceUI{
    self.getVCBtn.enabled =YES;
}

- (void)changeUI{
    [self.getVCBtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)timeCount] forState:UIControlStateDisabled];
}



/**
 短信获取验证码定时器倒计时
 
 @param timer 定时器对象
 */
- (void)timerFunction:(NSTimer *)timer{
    
    // NSLog(@"%@",timer.userInfo);
    
    timeCount--;
    
    if (timeCount == 0) {
        
        [self lDeallocTimer];
        [self sourceUI];
        
    } else {
        
        [self changeUI];
        
    }
    
}


/**
 销毁定时器
 */
-(void) lDeallocTimer{
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer=nil;
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField{
    
    if ([textField isEqual:self.mobileTextField]) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.mobileTextField) { //手机号
        if (string.length == 0) return YES;
        
        if (self.mobileTextField.text.length > 10) {
            return NO;
        }
        
    }
    return YES;
}

- (void)loginEvent:(UIButton *)sender{
    
    NSString *mobilePhone=self.mobileTextField.text;
    
    if (!mobilePhone.length) {
        [OMGToast showWithText:@"手机号不能为空" topOffset:64];
        return;
    }
    
    if (!self.verificationField.text.length) {
        [OMGToast showWithText:@"验证码不能为空" topOffset:64];
        return;
    }
    
    if ([STSystemHelper isMobileNumber:mobilePhone] && self.verificationField.text.length>0) {
        sender.enabled =NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor =[UIColor whiteColor];
        [hud showAnimated:YES];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"loginType"] =@"5";
        dic[@"phone"] =mobilePhone;
        dic[@"phoneCode"] =self.verificationField.text;
        
        __weak typeof(self) wself = self;
        [[[LoginApi alloc] initLoginWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
            
            [hud hideAnimated:YES];
            
            UserModel *user = (UserModel *)responseModel;
            
            if (code == SUCCESS_REQUEST) {
                // 登录成功
                [UserManagerInstance user_saveUserInfoWithModel:user isLogin:YES];
                
                [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"lastLoginType"];

                [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_USER_LOGIN object:nil];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself.mobileTextField resignFirstResponder];
                    [wself.verificationField resignFirstResponder];
                    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else{
                [OMGToast showWithText: message];
            }
            
            sender.enabled =YES;
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            [hud hideAnimated:YES];
            sender.enabled =YES;
            
        }];
        
        
        
    }else{
        
        [OMGToast showWithText:@"手机号或验证码错误" topOffset:64];
        
    }
    
}

- (void)dealloc
{
    [self lDeallocTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
