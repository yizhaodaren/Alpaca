//
//  MineViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/17.
//  Copyright © 2018年 Moli. All rights reserved.
//
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                   佛祖保佑            永无Bug


#import "MineViewController.h"
#import "MineHeaderCell.h"
#import "MineRowCell.h"
#import "MineInfoModel.h"
#import "MOLWebViewController.h"
#import "WelfareApi.h"
#import "UserWalletModel.h"
#import "ReadPreferenceViewController.h"
#import "ReadRecordViewController.h"
#import "BMSHelper.h"
#import "BookcaseApi.h"
#import "BSTabBarController.h"
#import "UITabBar+Badge.h"
#import "IMViewController.h"
#import "SettingViewController.h"


@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)NSMutableArray *iconArr;
@property (nonatomic, strong)UserModel *userModel;
@property (nonatomic, assign)BOOL status; //no为无新消息 yes为有新消息
@property (nonatomic, assign)BOOL isTitle; //no为未展示title yes为展示title

@property (nonatomic, assign)NSInteger inviteNum; //有值表示无输入好友邀请码
@property (nonatomic, strong)NSMutableArray *titleArr1;
@property (nonatomic, strong)NSMutableArray *iconArr1;
@property (nonatomic, strong)NSMutableArray *titleArr2;
@property (nonatomic, strong)NSMutableArray *iconArr2;
@property (nonatomic, strong)NSMutableArray *titleArr3;
@property (nonatomic, strong)NSMutableArray *iconArr3;
@property (nonatomic, strong)NSMutableArray *titleArr4;
@property (nonatomic, strong)NSMutableArray *iconArr4;
@property (nonatomic, strong)NSMutableArray *infoArr;

/*+++++++++++NavigationBarCustom++++++++++*/
@property (nonatomic, weak)UIView *navBarView;
@property (nonatomic, weak)UIButton *leftButotn;
@property (nonatomic, weak)UILabel *centerTitle;
@property (nonatomic, weak)UIButton *rightButotn;



@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self initData];
    [self layoutNavigationBar];
    [self layoutUI];
    //[self getWalletData];
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent) name:SUCCESS_USER_LOGINOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imMessageStatus:) name:IM_NOTIF object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imMessageCancelStatus:) name:IM_CancelRedDot_NOTIF object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInviteNum) name:GET_MYWALLET_NOTIF object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIsDebugStatus) name:@"updatecontrollerUI" object:nil];
    
    

}

- (void)logOutEvent{
    [self loginOutEvent];
}


- (void)imMessageCancelStatus:(NSNotification *)notif{
    [Defaults setBool:NO forKey:IM_NOTIF];
    BSTabBarController *tabBarV=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
    [tabBarV.tabBar hideBadgeOnItemIndex:4];
    self.status =NO;
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self navigationShowStatus];
    
}
- (void)imMessageStatus:(NSNotification *)notif{
    self.status =YES;
    
    if (![Defaults integerForKey:ISDEBUG]) {
        BSTabBarController *tabBarV=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
        [tabBarV.tabBar showBadgeOnItemIndex:4];
    }
    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self navigationShowStatus];
}



- (void)refreshData{
    [self getUserInfo];
    [self.tableView reloadData];
}


- (void)login_success{
    [self refreshData];
    //[self getWalletData];
    
    if (![Defaults integerForKey:ISDEBUG]) {
        [self getInviteNum];
    }
}

- (void)getUserInfo{
    self.userModel =[UserManagerInstance user_getUserInfo];
    if (!self.userModel) {
        self.userModel =[UserModel new];
    }
}

- (void)initData{
    
    [self getUserInfo];
    
    self.infoArr =[NSMutableArray array];
    
    self.titleArr =[NSMutableArray arrayWithObjects:@"邀请好友领现金",@"输入好友邀请码",@"我的钱包",@"我要提现",@"阅读记录",@"阅读偏好",@"常见问题", nil];
    self.iconArr =[NSMutableArray arrayWithObjects:@"friend",@"yaoqingma",@"money",@"tixian",@"history",@"like",@"question", nil];
    
    
    for (NSInteger i=0; i<self.titleArr.count; i++) {
        MineInfoModel *infoDto =[MineInfoModel new];
        infoDto.icon =self.iconArr[i];
        infoDto.title =self.titleArr[i];
        if ([infoDto.title isEqualToString: @"邀请好友领现金"]) {
            infoDto.info =@"限时活动,邀请好友立赚8元";
        }
        if ([infoDto.title isEqualToString: @"输入好友邀请码"]) {
            infoDto.info =@"领现金红包,注册后3日内可领取";
        }
        [self.infoArr addObject: infoDto];
    }
    
    //测试红点
    self.status = [Defaults boolForKey:IM_NOTIF];
    self.isTitle =NO;
    
}



- (void)layoutUI{
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KSCREEN_HEIGHT-KTabbarHeight-StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (![Defaults integerForKey:ISDEBUG]) {
           return 157;
        }
        return 148-44;
    }
    return 55;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) wself = self;
    if (indexPath.section!=0) {
        
        if (![Defaults integerForKey:ISDEBUG]) {
            switch (indexPath.section) {
                case 1:
                {
                    if (indexPath.row ==0) { //邀请好友领现金
                        if (![UserManagerInstance user_isLogin]) {
                            [[GlobalManager shareGlobalManager] global_modalLogin];
                            return;
                        }
                        MOLWebViewController *webView =[MOLWebViewController new];
                        NSString *url =[BMSHelper getBaseUrl];
                        webView.urlString =[NSString stringWithFormat:@"%@%@",url,WIDTHDRAW];
                    
                        [self.navigationController pushViewController:webView animated:YES];
                        
                    }else if (indexPath.row==1){ //输入好友邀请码
                        if (![UserManagerInstance user_isLogin]) {
                            [[GlobalManager shareGlobalManager] global_modalLogin];
                            return;
                        }
                        
                        MOLWebViewController *webView =[MOLWebViewController new];
                        webView.from=100;
                        NSString *url =[BMSHelper getBaseUrl];
                        webView.urlString =[NSString stringWithFormat:@"%@%@",url,INVITE];
                        [self.navigationController pushViewController:webView animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    if (indexPath.row == 0) {//我的钱包💰
                        if (![UserManagerInstance user_isLogin]) {
                            [[GlobalManager shareGlobalManager] global_modalLogin];
                            return;
                        }
                        
                        MOLWebViewController *webView =[MOLWebViewController new];
                        NSString *url =[BMSHelper getBaseUrl];
                        webView.urlString =[NSString stringWithFormat:@"%@%@",url,MYWALLETHTMl];
                        [self.navigationController pushViewController:webView animated:YES];
                        
                    }else if(indexPath.row ==1){//我要提现
                        if (![UserManagerInstance user_isLogin]) {
                            [[GlobalManager shareGlobalManager] global_modalLogin];
                            return;
                        }
                        
                        MOLWebViewController *webView =[MOLWebViewController new];
                                                    NSString *url =[BMSHelper getBaseUrl];
                                                    webView.urlString =[NSString stringWithFormat:@"%@%@",url,WALLETWIDTHDRAW];
                        
                        [self.navigationController pushViewController:webView animated:YES];
                    }
                    
                }
                    break;
                case 3:
                {
                    if (indexPath.row==0) {//阅读记录
                        ReadRecordViewController *readRecord=[ReadRecordViewController new];
                        [self.navigationController pushViewController:readRecord animated:YES];
                    }else if(indexPath.row ==1){//阅读偏好
                        ReadPreferenceViewController *readPreference=[ReadPreferenceViewController new];
                        [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:readPreference animated:YES];
                    }
                }
                    break;
                case 4:
                {
                    if (indexPath.row ==0) {//常见问题
                        MOLWebViewController *webView =[MOLWebViewController new];
                        NSString *url =[BMSHelper getBaseUrl];
                        webView.urlString =[NSString stringWithFormat:@"%@%@",url,HELPCENTER];
                        
                        [self.navigationController pushViewController:webView animated:YES];
                    }else if(indexPath.row ==1){//退出登录
                        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [wself loginOutEvent];
                        
                        }];
                        
                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                        
                        [alert addAction:confirm];
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:^{}];
                    }
                    
                }
                    break;
                    
                    
            }
            
            
        }else{
            
            switch (indexPath.section) {
                case 1:
                {
                    if (indexPath.row==0) {//阅读记录
                        ReadRecordViewController *readRecord=[ReadRecordViewController new];
                        [self.navigationController pushViewController:readRecord animated:YES];
                    }else if(indexPath.row ==1){//阅读偏好
                        ReadPreferenceViewController *readPreference=[ReadPreferenceViewController new];
                        [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:readPreference animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    if (indexPath.row ==0) {//常见问题
                        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [wself loginOutEvent];
                        }];
                        
                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                        
                        [alert addAction:confirm];
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:^{}];
                    }

                }
                    break;
                    
            }
            
        }
    }
    
}

#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([Defaults integerForKey:ISDEBUG]) {
        if (section == 0) {
            return 1;
        }else if (section ==1){
            return 2;
        }else if(section ==2){
    
//            if ([UserManagerInstance user_isLogin]) {
//                return 1;
//            }

        }
        return 0;
        
    }else{
        if(section ==0){
            return 1;
        }else if (section ==1){
            if (self.inviteNum) {
                return 1;
            }
        }else if(section ==4){
            //if (![UserManagerInstance user_isLogin]) {
                return 1;
            //}
        }
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString * const kheaderCellIdentifier = @"MineHeaderCell";
        
        MineHeaderCell *headerCell =[tableView dequeueReusableCellWithIdentifier:kheaderCellIdentifier];
        if (!headerCell) {
            headerCell =[[MineHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kheaderCellIdentifier];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [headerCell cellContent:self.userModel indexPath:indexPath status:self.status];
        return headerCell;
    }
    
    static NSString * const kMineRowCellIdentifier = @"mineRowCell";
    
    MineRowCell *mineRowCell =[tableView dequeueReusableCellWithIdentifier:kMineRowCellIdentifier];
    if (!mineRowCell) {
        mineRowCell =[[MineRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMineRowCellIdentifier];
        mineRowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MineInfoModel *model =[MineInfoModel new];
    
    
    if ([Defaults integerForKey:ISDEBUG]) {
        
        if (indexPath.section ==1) {
            if (indexPath.row==0) {//阅读记录
                model =self.infoArr[4];
            }else if (indexPath.row==1){//阅读偏好
                model =self.infoArr[5];
            }
            
        }else if (indexPath.section==2){
            model =self.infoArr[7];
        }
        
    }else{
        
        NSInteger idx =(indexPath.row+(indexPath.section-1)*2.0);
        
        if (idx < self.infoArr.count) {
            
            model = self.infoArr[idx];
            if ([model.title isEqualToString:@"我的钱包"]) {
                if ([UserManagerInstance user_isLogin]) {
                    model.type =100;
                    model.money =self.userModel.userWalletVO.unTxMoney+self.userModel.userWalletVO.canTxMoney;
                    if ((self.userModel.userWalletVO.unTxMoney+self.userModel.userWalletVO.canTxMoney) <=0) {
                        model.money =0;
                    }
                }
                
            }else if([model.title isEqualToString:@"输入好友邀请码"]){
                model.type =101;
            }
        }
        
    }
    
    
    
    [mineRowCell cellContent:model indexPath:indexPath];
    return mineRowCell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Defaults integerForKey:ISDEBUG]) {
//        if ([UserManagerInstance user_isLogin]) {
//            return 3;
//        }
        return 2;
    }
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{

    if ([Defaults integerForKey:ISDEBUG]) {
        if ([UserManagerInstance user_isLogin]) {
            
            if (section ==2) {
                return 0.000;
            }
        }
        if (section ==1) {
            return 0.000;
        }
    }
    
    if (section ==4) {
        return 0.000;
    }
    
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    UIView *footerView =[UIView new];
    [footerView setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    return footerView;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)getWalletData{
    
    __weak typeof(self) wself = self;
    [[[WelfareApi alloc] initUserWalletWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            UserWalletModel *walletModel =(UserWalletModel *)responseModel;
            wself.userModel.userWalletVO =walletModel;
            // 登录成功
            [UserManagerInstance user_saveUserInfoWithModel:wself.userModel isLogin:YES];
            [wself getUserInfo];
            [wself.tableView reloadData];
            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
        
    }];
}

- (void)getInviteNum{
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initUserInfoWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        if (code ==SUCCESS_REQUEST) {
            
            UserModel *model =(UserModel *)responseModel;
            if (model.userId.length) {
                // 登录成功
                [UserManagerInstance user_saveUserInfoWithModel:model isLogin:YES];
                wself.userModel =model;
                wself.inviteNum =model.inviteSign;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.tableView reloadData];
                });
            }
            
        }
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([UserManagerInstance user_isLogin]) {
        if (![Defaults integerForKey:ISDEBUG]) {
            [self getInviteNum];
        }
    }

}

- (BOOL)showNavigation{
    return YES;
}

#pragma mark 退出登录情况数据
- (void)loginOutEvent{
    self.inviteNum =0;
    [UserManagerInstance user_resetUserInfo];
    [self refreshData];
}

- (void)layoutNavigationBar{
    
    UIView *navBarView =[UIView new];
    [navBarView setBackgroundColor: HEX_COLOR(0xffffff)];
    //[navBarView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:navBarView];
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Message"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftItemEvent) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setAlpha:0];
    [navBarView addSubview:leftButton];
    
    UILabel *title =[UILabel new];
    [title setFont:REGULAR_FONT(17)];
    [title setTextColor: HEX_COLOR(0x000000)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setText:@"我的"];
    [title setAlpha:0];
    [navBarView addSubview:title];
    
    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"Setting"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightItemEvent) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightButton];
    
    
    self.leftButotn =leftButton;
    self.centerTitle =title;
    self.rightButotn =rightButton;
    
    __weak typeof(self) wself = self;
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(wself.view);
        make.height.mas_equalTo(StatusBarAndNavigationBarHeight);
    }];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(StatusBarHeight);
        make.height.width.mas_equalTo(44);
        make.right.mas_equalTo(title.mas_left);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftButton.mas_right);
        make.top.mas_equalTo(leftButton.mas_top);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(rightButton.mas_left);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right);
        make.top.mas_equalTo(leftButton.mas_top);
        make.height.width.mas_equalTo(44);
        make.right.mas_equalTo(-4);
    }];
    
    
//    [leftButton setBackgroundColor: [UIColor redColor]];
//    [title setBackgroundColor:[UIColor blueColor]];
//    [rightButton setBackgroundColor:[UIColor redColor]];
    

    [self navigationShowStatus];
    
}

- (void)navigationShowStatus{
    
    if (self.isTitle) {
        [self.centerTitle setAlpha:1];
    }else{
        [self.centerTitle setAlpha:0];
    }
    
    if ([Defaults integerForKey:ISDEBUG]) {
        [self.leftButotn setAlpha:0];
    }else{
        [self.leftButotn setAlpha:1];
    }
   
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= 20) {
        self.isTitle =YES;
        
    }else{
        self.isTitle =NO;
    }
    
    [self navigationShowStatus];
}


-(void)leftItemEvent{
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    IMViewController *im =[IMViewController new];
    [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:im animated:YES];
}

-(void)rightItemEvent{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

- (void)updateIsDebugStatus{
    [self.tableView reloadData];
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
