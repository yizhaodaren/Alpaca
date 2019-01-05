//
//  SettingViewController.m
//  Alpaca
//
//  Created by xujin on 2019/1/4.
//  Copyright © 2019年 Moli. All rights reserved.
//

#import "SettingViewController.h"
#import "MineInfoModel.h"
#import "SettingCell.h"
#import "MOLWebViewController.h"
#import "BMSHelper.h"
#import "EditViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSMutableArray *infoArr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    [self layoutUI];
    
}

- (void)registNotification{
    
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back" centerTitle:NSLocalizedString(@"STR_Setting",nil) titleColor:HEX_COLOR(0x000000)];
}

- (void)initData{
    self.infoArr =[NSMutableArray array];
    self.titleArr =@[@"编辑个人资料",@"关于我们",@"清理缓存",@"退出登录"];
    for (NSInteger i=0; i<self.titleArr.count; i++) {
        
        MineInfoModel *infoDto =[MineInfoModel new];
        infoDto.title =self.titleArr[i];
        
        if ([infoDto.title isEqualToString:@"清理缓存"]) {
            infoDto.info =@"463M";
        }
        
        [self.infoArr addObject: infoDto];
    }
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
    
    return 52;
    
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {//编辑个人资料
        
        if (![UserManagerInstance user_isLogin]) {
            [[GlobalManager shareGlobalManager] global_modalLogin];
            return;
        }
        
        [self.navigationController pushViewController:[EditViewController new] animated:YES];
        
    }else if (indexPath.row ==1){//关于我们
        MOLWebViewController *webView =[MOLWebViewController new];
        NSString *url =[BMSHelper getBaseUrl];
        webView.urlString =[NSString stringWithFormat:@"%@%@",url,ABOUTUS];
        
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if (indexPath.row ==2){//清除缓存
        
        
    }else if(indexPath.row ==3){//退出登录
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_USER_LOGINOUT object:nil];
            
        }];
        
        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
    
}

#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (![UserManagerInstance user_isLogin]) {
        return self.infoArr.count?(self.infoArr.count-1):0;
    }
    
    return self.infoArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * const cellId = @"cell";
    
    SettingCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MineInfoModel *model =[MineInfoModel new];
    
    if (self.infoArr.count > indexPath.row) {
        model = self.infoArr[indexPath.row];
    }
    
    [cell cell:model indexPath:indexPath];
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
