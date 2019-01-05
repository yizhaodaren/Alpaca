//
//  WelfareViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;

#import "WelfareViewController.h"
#import "WelfareApi.h"
#import "WelfareGroupModel.h"
#import "WelfareModel.h"
#import "WelfareLongCell.h"
#import "WelfareShortCell.h"
#import "MOLWebViewController.h"

@interface WelfareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *goupArr; //组信息

@end

@implementation WelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    
}


- (void)login_success{
    [self refresh];
    
}

- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.goupArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    [self getWelfareNetworkData];

    
}

- (void)layoutUI{
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat KTableHeight =self.hidesBottomBarWhenPushed?KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight:KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight-KTabbarHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KTableHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself refresh];
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets =NO;
        }
        
    }
    return _tableView;
}

#pragma mark -
#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goupArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WelfareModel *model=[WelfareModel new];
    NSArray *arr;
    if (section < self.goupArr.count) {
        arr =self.goupArr[section];
        model =[arr firstObject];
    }
    if (model.type == 2) {
        return arr.count;
    }else if (model.type ==1){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10+20+10+100+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WelfareModel *model=[WelfareModel new];
    NSArray *arr;
    if (indexPath.section < self.goupArr.count) {
        arr =self.goupArr[indexPath.section];
        
        if (indexPath.row < arr.count) {
            model = arr[indexPath.row];
        }
    }
    
    if (model.type ==2) {
        static NSString * const welfareLongCellID =@"welfareLongCell";
        WelfareLongCell *welfareLongCell =[tableView dequeueReusableCellWithIdentifier:welfareLongCellID];
        if (!welfareLongCell) {
            welfareLongCell =[[WelfareLongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:welfareLongCellID];
            welfareLongCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [welfareLongCell cellContent:model indexPath:indexPath];
        
        return welfareLongCell;
        
    }else{
        static NSString * const welfareShortCellID =@"welfareShortCell";
        WelfareShortCell *welfareShortCell =[tableView dequeueReusableCellWithIdentifier:welfareShortCellID];
        if (!welfareShortCell) {
            welfareShortCell =[[WelfareShortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:welfareShortCellID];
            welfareShortCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [welfareShortCell cellContent:arr indexPath:indexPath];
       
        return welfareShortCell;
    }
    
   

}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WelfareModel *model;
    NSArray *arr;
    if (indexPath.section < self.goupArr.count) {
        arr =self.goupArr[indexPath.section];
        
        if (indexPath.row < arr.count) {
            model = arr[indexPath.row];
        }
    }
    
    if (model.type==2) {
        
        if (![UserManagerInstance user_isLogin]) {
            [[GlobalManager shareGlobalManager] global_modalLogin];
            return;
        }
        
        MOLWebViewController *web =[MOLWebViewController new];
        web.urlString =model.url?model.url:@"";
        [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:web animated:YES];
    }
    
   
}


#pragma mark- 网络请求

- (void)refresh{
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getWelfareNetworkData];
};

- (void)getWelfareNetworkData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    __weak typeof(self) wself = self;
    [[[WelfareApi alloc] initWelfareListWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        [self hiddenNoNetwork];
        
        if (code == SUCCESS_REQUEST) {
            WelfareGroupModel *groupModel =(WelfareGroupModel *)responseModel;
            
            if (wself.refreshType != UIBehaviorTypeStyle_More) {
                [wself.dataSourceArr removeAllObjects];
                [wself.goupArr removeAllObjects];
            }
            [wself.dataSourceArr addObjectsFromArray:groupModel.resBody];
            
            //////////实现分组//////////
            
            NSMutableArray *arr;
            NSInteger upType = 0; //无
           
            for (WelfareModel *model in wself.dataSourceArr) {
                
                if (model.type == upType) { //一组
                    if (!arr) {
                        arr =[NSMutableArray array];
                    }
                    [arr addObject: model];
                    
                    if (wself.dataSourceArr.lastObject == model) {//表示最后一条
                        [wself.goupArr addObject:arr];
                        
                    }
                    
                }else{//新组
                    if (arr.count) {
                        [wself.goupArr addObject: arr];
                    }
                    arr =[NSMutableArray array];
                    [arr addObject:model];
                }
                upType =model.type;
            }
            
            [wself.tableView reloadData];
           
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [hud hideAnimated:YES];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!wself.dataSourceArr.count) {
            [self hiddenNoNetwork];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [OMGToast showWithText:@"网络不给力，请稍后重试"];
                
                [self showNoNetwork];
                
            });
        }
    }];
}



- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:nil centerTitle:@"福利" titleColor:HEX_COLOR(0x000000) rightItemImageName:nil rightItemColor:nil];
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
