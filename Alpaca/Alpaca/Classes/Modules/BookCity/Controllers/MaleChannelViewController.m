//
//  MaleChannelViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
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

#import "MaleChannelViewController.h"
#import "BookCityModelGroup.h"
#import "BookCityApi.h"
#import "AdScrollerView.h"
#import "BookCityModel.h"
#import "BookInfoHCell.h"
#import "BookInfoVTopCell.h"
#import "BookInfoCCell.h"
#import "BookModel.h"
#import "BookDetailViewController.h"
#import "TimerView.h"
#import "BookCityHeaderView.h"
#import "BookListViewController.h"
#import "BookCityViewController.h"
#import "BMSHelper.h"
#import "BannerGroupModel.h"
#import "BookcaseApi.h"
#import "UserModel.h"
#import "MOLWebViewController.h"
#import "NewUserBenefitsView.h"
#import "GlobalManager.h"
#import "BSTabBarController.h"
#import "BannerMoel.h"


static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;
static const CGFloat KHeaderViewHeight  = 216;
static const CGFloat KADSCROLLHeight = 140;

@interface MaleChannelViewController ()<AdScrollerViewDelegate,UITableViewDelegate,UITableViewDataSource,NewUserBenefitsViewDelegate>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)AdScrollerView *adScrollView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray *adArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *itemArr;

@property (nonatomic, strong)UIButton *redPacket;
@property (nonatomic, strong)NewUserBenefitsView *benefitsView;
@property (nonatomic, assign)BOOL saveMoneyStatus; //默认不需要保存 yes 需要
@property (nonatomic, strong)UserModel *userModel;
@end

@implementation MaleChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    
    [self layoutUI];
    [self getRecomClassifies];
    [self getBannerNetworkInfo];
    
    if ([BMSHelper getChannel]) {
        if (![UserManagerInstance user_isLogin]) {//未登录
            if (![Defaults boolForKey:SetupInit]) { //安装第一次启动
                [Defaults setBool:YES forKey:SetupInit];
                [self getRedPackageInfo];
                
            }
        }
    }
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent) name:SUCCESS_USER_LOGINOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIsDebugStatus) name:@"updatecontrollerUI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:@"NetworkHave" object:nil];

}

- (void)layoutNavigationBar{
    
    //[self navigationLeftItemWithImageName:nil centerTitle:@"书城" titleColor:HEX_COLOR(0x000000)];
}

- (void)updateIsDebugStatus{
    
    
    
    for (id views in self.adScrollView.subviews) {
        [views removeFromSuperview];
    }
    [self.adScrollView removeFromSuperview];
    self.adScrollView =nil;
    
    for (id views in self.headerView.subviews) {
        [views removeFromSuperview];
    }
    
    [self.headerView addSubview:self.adScrollView];
    
    [self getRecomClassifies];
    [self getBannerNetworkInfo];
    
    [self headerFrame];
    [self layoutSubUI];
    [self.tableView reloadData];
    [self redPacketHiddenEvent];
    
}


- (void)logOutEvent{
    [self refresh];
    [self getUserInfo];
    [self redPacketHiddenEvent];
}

- (void)login_success{
    [self refresh];
    [self getUserInfo];
    [self redPacketHiddenEvent];
    
    if (self.saveMoneyStatus) {
        
        if (!self.userModel.newBagSign) {
            [self openNewBagInfo];
            
        }else{
            [self removeRedPacketEvent];
 
            self.redPacket.alpha =0;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (![Defaults integerForKey:ISDEBUG]) {
                    [OMGToast showWithText:@"你已领取过新手红包"];
                }
                
            });
            
        }
    }
   
}

- (void)getUserInfo{
    self.userModel =[UserManagerInstance user_getUserInfo];
    if (!self.userModel) {
        self.userModel =[UserModel new];
    }
}


- (void)redPacketHiddenEvent{
    if (![UserManagerInstance user_isLogin]) {//未登录
        if (![Defaults integerForKey:ISDEBUG]) {
           [self.redPacket setAlpha:1];
        }
        
    }else{ //登录
        if (self.userModel.newBagSign) {//已领取

            [self.redPacket setAlpha:0];

        }else{//未领取
            if (![Defaults integerForKey:ISDEBUG]) {
              [self.redPacket setAlpha:1];
            }
        }
        
    }
}

- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.adArr =[NSMutableArray new];
    self.itemArr =@[@"classification",@"List",@"end",@"newbook"];
    self.userModel =[UserModel new];
    [self getUserInfo];
}

- (void)layoutUI{
    
    [self.headerView addSubview:self.adScrollView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.redPacket];
    
    [self redPacketHiddenEvent];
    
    [self layoutSubUI];
    
    __weak typeof(self) wself = self;
    [self.redPacket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wself.view);
        make.bottom.mas_equalTo(wself.view).offset(-35-49);
        make.width.height.mas_equalTo(100);
    }];
    
}

- (void)layoutSubUI{
    __weak typeof(self) wself = self;
    //    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.left.top.mas_equalTo(wself.tableView.tableHeaderView);
    //        make.height.mas_equalTo(KHeaderViewHeight);
    //    }];
    
    CGFloat kLeftX =46;
    CGFloat kWidth =34;
    CGFloat kHeight =48;
    
    CGFloat kSpacer= (KSCREEN_WIDTH-kLeftX*2.0-kWidth*self.itemArr.count)/(self.itemArr.count-1);
    
    for (NSInteger i=0; i<self.itemArr.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:self.itemArr[i]] forState:UIControlStateNormal];
        [button setTag:1000+i];
        [button addTarget:self action:@selector(itemEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftX+(kWidth+kSpacer)*i);
            make.top.mas_equalTo(wself.adScrollView.mas_bottom).offset(16);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(kHeight);
        }];
    }
    
    UIView *bottomLine =[UIView new];
    [bottomLine setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.headerView addSubview:bottomLine];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(wself.headerView.mas_bottom).offset(-1);
        make.width.mas_equalTo(KSCREEN_WIDTH-15*2.0);
        make.height.mas_equalTo(1);
    }];
}



- (NewUserBenefitsView *)benefitsView{
    if (!_benefitsView) {
        _benefitsView =[[NewUserBenefitsView alloc] init];
        [_benefitsView setAlpha:0];
        [_benefitsView setHidden: [Defaults integerForKey:ISDEBUG]];
        [[[[GlobalManager shareGlobalManager] global_rootViewControl] view] addSubview:_benefitsView];
    
        [_benefitsView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        _benefitsView.delegate =self;
        
    }
    return _benefitsView;
}

- (UIButton *)redPacket{
    if (!_redPacket) {
        _redPacket =[UIButton buttonWithType:UIButtonTypeCustom];
        [_redPacket setImage:[UIImage imageNamed:@"pendant"] forState:UIControlStateNormal];
        [_redPacket addTarget:self action:@selector(redPacketEvent:) forControlEvents:UIControlEventTouchUpInside];

        [_redPacket setAlpha:0];

    }
    return _redPacket;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView =[UIView new];
        [self headerFrame];
    }
    return _headerView;
}

- (void)headerFrame{
   // [self.headerView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, [Defaults integerForKey:ISDEBUG]?KHeaderViewHeight-KADSCROLLHeight:KHeaderViewHeight)];
    [self.headerView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH,KHeaderViewHeight)];
}



- (AdScrollerView *)adScrollView{
    
    if (!_adScrollView) {
      //  _adScrollView =[[AdScrollerView alloc] initWithFrame:CGRectMake(15, 0, KSCREEN_WIDTH-15*2.0,[Defaults integerForKey:ISDEBUG]?0:KADSCROLLHeight)];
        _adScrollView =[[AdScrollerView alloc] initWithFrame:CGRectMake(15, 0, KSCREEN_WIDTH-15*2.0,KADSCROLLHeight)];
        _adScrollView.delegate =self;
        
     //   [_adScrollView setHidden: [Defaults integerForKey:ISDEBUG]];
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_adScrollView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = _adScrollView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        _adScrollView.layer.mask = maskLayer1;
       
    }
    
    return _adScrollView;
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat KTableHeight =self.hidesBottomBarWhenPushed?KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight:KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight-KTabbarHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KTableHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
       
        _tableView.tableHeaderView =self.headerView;
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself refresh];
        }];
        
        _tableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMore];
        } ];
        
        _tableView.mj_footer.hidden =YES;
        
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section

{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 49;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BookCityModel *model=[BookCityModel new];
    if (section<self.dataSourceArr.count) {
        model =self.dataSourceArr[section];
        
    }
    
    switch (model.recomAlign) {
        case 1:
        {
            return model.books.count;
        }
            break;
        case 2:
        case 3:
        {
            return 1;
        }
            break;
        case 4:
        {
            return model.books.count > 1?2:1;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCityModel *model=[BookCityModel new];
    if (indexPath.section<self.dataSourceArr.count) {
        model =self.dataSourceArr[indexPath.section];
        
    }
    
    if (model.recomAlign ==4) {
        
        if (indexPath.row ==0 ) {
            
            // 上间距15+内容高度116+下间距15+底线1
           CGFloat cellHeight = 15+116+15+1;
            
           return cellHeight;
            
        }else if (indexPath.row==1) {
            BOOL isExist =NO;
            for (BookModel *model_ in model.books) {
                NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model_.bookName?model_.bookName:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
                
                CGFloat bookDescHeight =0.0;
                
                bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:KSCALEWidth(80) font:REGULAR_FONT(14)];
                
                if (bookDescHeight >=20*2.0) {
                    isExist =YES;
                }
            }
            
            if (isExist) {
                return model.cellHeight+20;
            }
        }
        
        
        
    }else if (model.recomAlign ==3 ) {
        
        BOOL isExist =NO;
        for (BookModel *model_ in model.books) {
            NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model_.bookName?model_.bookName:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
            
            CGFloat bookDescHeight =0.0;
            
            bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:KSCALEWidth(80) font:REGULAR_FONT(14)];
            
            if (bookDescHeight >=20*2.0) {
                isExist =YES;
            }
        }
        
        if (isExist) {
            return model.cellHeight+20;
        }
        
    }
    
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCityModel *model=[BookCityModel new];
    if (indexPath.section<self.dataSourceArr.count) {
        model =self.dataSourceArr[indexPath.section];
        
    }
    //布局方式(1=垂直2=水平带简介3=水平不带简介 4=1、3混合)
    switch (model.recomAlign) {
        case 1:
        {
            static NSString * const bookInfoHCellID =@"bookInfoHCell";
            BookInfoHCell *bookInfoHCell =[tableView dequeueReusableCellWithIdentifier:bookInfoHCellID];
            if (!bookInfoHCell) {
                bookInfoHCell =[[BookInfoHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoHCellID];
                bookInfoHCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            BookModel *bookModel =[BookModel new];
            
            if (model.books.count > indexPath.row) {
                bookModel =model.books[indexPath.row];
            }
            [bookInfoHCell cellContent:bookModel indexPath:indexPath type:2];
            
            return bookInfoHCell;
            
        }
            break;
        case 2:
        {
            static NSString* const bookInfoCCellID =@"bookInfoCCell";
            BookInfoCCell *bookInfoCCell =[tableView dequeueReusableCellWithIdentifier:bookInfoCCellID];
            if (!bookInfoCCell) {
                bookInfoCCell =[[BookInfoCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoCCellID];
                bookInfoCCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [bookInfoCCell cellContent:model indexPath:indexPath];
            
            return bookInfoCCell;
        }
            break;
        case 3:
        {
            
            static NSString* const bookInfoVTopCellID =@"bookInfoVTopCell";
            BookInfoVTopCell*bookInfoVTopCell =[tableView dequeueReusableCellWithIdentifier:bookInfoVTopCellID];
            if (!bookInfoVTopCell) {
                bookInfoVTopCell =[[BookInfoVTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoVTopCellID];
                bookInfoVTopCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [bookInfoVTopCell cellContent:model.books indexPath:indexPath];
            
            return bookInfoVTopCell;
        }
            break;
        case 4:
        {
            if (indexPath.row ==0) {
                
                static NSString * const bookInfoHCellID =@"bookInfoHCell4";
                BookInfoHCell *bookInfoHCell =[tableView dequeueReusableCellWithIdentifier:bookInfoHCellID];
                if (!bookInfoHCell) {
                    bookInfoHCell =[[BookInfoHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoHCellID];
                    bookInfoHCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                BookModel *bookModel =[BookModel new];
                
                if (model.books.count > 0) {
                    bookModel =model.books[0];
                }
                [bookInfoHCell cellContent:bookModel indexPath:indexPath type:2];
                
                return bookInfoHCell;
                
            }else{
                
                static NSString* const bookInfoVTopCellID =@"bookInfoVTopCell4";
                BookInfoVTopCell*bookInfoVTopCell =[tableView dequeueReusableCellWithIdentifier:bookInfoVTopCellID];
                if (!bookInfoVTopCell) {
                    bookInfoVTopCell =[[BookInfoVTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoVTopCellID];
                    bookInfoVTopCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                NSMutableArray *arr =[NSMutableArray arrayWithArray:model.books];
                
                if (arr.count>0) {
                    [arr removeObjectAtIndex:0];
                }
                
                [bookInfoVTopCell cellContent:arr indexPath:indexPath];
                
                return bookInfoVTopCell;
                
            }
            
            
        }
            break;
            
        default:
        {
            return [UITableViewCell new];
        }
            break;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BookCityModel *model=[BookCityModel new];
    if (section<self.dataSourceArr.count) {
        model =self.dataSourceArr[section];
        
    }
    
    static NSString * const headerID =@"hederViewID";
    BookCityHeaderView *hederView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    if (!hederView) {
        hederView =[[BookCityHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    
    [hederView headerViewcontent:model section:section];
    
    return hederView;

}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCityModel *model=[BookCityModel new];
    if (indexPath.section<self.dataSourceArr.count) {
        model =self.dataSourceArr[indexPath.section];
        
    }
    
    BookModel *dto =[BookModel new];
    if (indexPath.row < model.books.count) {
        dto =model.books[indexPath.row];
    }
    BookDetailViewController *bookDetail =[BookDetailViewController new];
    bookDetail.model =dto;
    [self.navigationController pushViewController:bookDetail animated:YES];
}

#pragma mark-
#pragma mark 网络请求
- (void)refresh{
    self.pageNum =KPageNum;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getRecomClassifies];
};

- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getRecomClassifies];
}
- (void)getRecomClassifies{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    switch (self.categoryType) {
        case CategoryTypeStyle_Male:
        {
            dic[@"channelCode"] =@"1";
        }
            break;
        case CategoryTypeStyle_Female:
        {
            dic[@"channelCode"] =@"2";
        }
            break;
        default:
        {
            dic[@"channelCode"] =@"1";
        }
            break;
    }
    dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
    dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
    
    __weak typeof(self) wself = self;
    [[[BookCityApi alloc] initGetRecomClassifiesWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        [self hiddenNoNetwork];
        
        if (code == SUCCESS_REQUEST) {
            
            BookCityModelGroup *group =(BookCityModelGroup *)responseModel;
            
            if (wself.refreshType != UIBehaviorTypeStyle_More) {
                [wself.dataSourceArr removeAllObjects];
            }
            // 添加到数据源
            [wself.dataSourceArr addObjectsFromArray:group.resBody];
            [wself.tableView reloadData];
            
            if (group.resBody.count) {
                wself.tableView.mj_footer.hidden = NO;
                
            }else{
                wself.tableView.mj_footer.hidden = YES;
            }
            
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

- (void)getBannerNetworkInfo{
    __weak typeof(self) wself = self;
    
    NSString *bannerId =[NSString stringWithFormat:@"%ld",[BMSHelper getChannel]];
    [[[BookCityApi alloc] initBannerInfosWithParameter:@{} parameterId:bannerId] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code ==SUCCESS_REQUEST) {
            [wself.adArr removeAllObjects];
            BannerGroupModel *groupModel =(BannerGroupModel *)responseModel;
            [wself.adArr addObjectsFromArray:groupModel.resBody];
            [wself.adScrollView setContent:wself.adArr];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark-
#pragma mark AdScrollerViewDelegate
-(void)adScrollerViewDidClicked:(NSUInteger)index{
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    if (self.adArr.count > index) {
        BannerMoel *bannerModel =[BannerMoel new];
        bannerModel = self.adArr[index];
        if (bannerModel.typeInfo.length) {
            if (bannerModel.bannerType ==0) {//h5
                
                MOLWebViewController *web =[MOLWebViewController new];
                web.urlString =bannerModel.typeInfo;
                [self.navigationController pushViewController:web animated:YES];
                
            }else if(bannerModel.bannerType ==1){//书籍 详情
                BookModel *dto =[BookModel new];
                dto.bookId =bannerModel.typeInfo.integerValue;
                BookDetailViewController *bookDetail =[BookDetailViewController new];
                bookDetail.model =dto;
                [self.navigationController pushViewController:bookDetail animated:YES];
                
            }else if(bannerModel.bannerType ==2){//分类 详情
                BookListViewController *bookList =BookListViewController.new;
                BookCityModel *dto =[BookCityModel new];
                dto.classifyId = bannerModel.typeInfo.integerValue;
                bookList.cityModel =dto;
                bookList.featureStyle =FeatureTypeStyle_More;
                [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:bookList animated:YES];
            }
        }
        
    }
    
}

#pragma mark-
#pragma mark action event
- (void)itemEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 1000://分类
        {
            BookCityViewController *bookCity =[BookCityViewController new];
            bookCity.fromFunctionType =FromFunctionType_Category;
            bookCity.categoryType =self.categoryType;
            [self.navigationController pushViewController:bookCity animated:YES];
        }
            break;
            
        case 1001://排行
        {
            BookCityViewController *bookCity =[BookCityViewController new];
            bookCity.fromFunctionType =FromFunctionType_Ranking;
            bookCity.categoryType =self.categoryType;
            [self.navigationController pushViewController:bookCity animated:YES];
        }
            break;
        case 1002://完结
        {
            BookListViewController *bookList =[BookListViewController new];
            bookList.featureStyle =FeatureTypeStyle_End;
            [self.navigationController pushViewController:bookList animated:YES];
        }
            break;
        case 1003://新书
        {
            BookListViewController *bookList =[BookListViewController new];
            bookList.featureStyle =FeatureTypeStyle_NewBook;
            [self.navigationController pushViewController:bookList animated:YES];
        }
            break;
    }
}

#pragma mark-
#pragma mark 获取新手红包信息
-(void)getRedPackageInfo{
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initNewBagInfo:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            
            NSString *money =request.responseObject[@"resBody"][@"money"];
            
            if (money.length) {
                if (wself.benefitsView) {
                    [wself.benefitsView setAlpha:1];
                    wself.benefitsView.moneyString =money;
                    wself.saveMoneyStatus =YES;
                }
                
            }else{
                if (wself.benefitsView) {
                    [wself.benefitsView setAlpha:0];
                    wself.saveMoneyStatus =NO;
                }
                
            }
        }else{
            wself.saveMoneyStatus =NO;
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        wself.saveMoneyStatus =NO;
    }];
}

/// 领取新手红包
-(void)openNewBagInfo{
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initOpenNewBagInfo:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            [wself removeRedPacketEvent];
            wself.redPacket.alpha =0;
            wself.userModel.newBagSign =1;
            // 登录成功
            [UserManagerInstance user_saveUserInfoWithModel:wself.userModel isLogin:YES];
            
            MOLWebViewController *wallet =[MOLWebViewController new];
            NSString *url =[BMSHelper getBaseUrl];
            wallet.urlString =[NSString stringWithFormat:@"%@%@",url,WIDTHDRAW];
        
            [wself.navigationController pushViewController:wallet animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_MYWALLET_NOTIF object:nil];
            });
            
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}


#pragma mark-
#pragma mark NewUserBenefitsViewDelegate

- (void)removeRedPacketEvent{
    for (id views in self.benefitsView.subviews) {
        [views removeFromSuperview];
    }
    [self.benefitsView removeFromSuperview];
    self.benefitsView.delegate =nil;
    self.benefitsView =nil;
    
    self.saveMoneyStatus =NO;
}
- (void)newUserBenefitsViewCloseEvent:(NewUserBenefitsView *)view{
    
    [self removeRedPacketEvent];
    
}
- (void)newUserBenefitsViewSaveMoney:(NewUserBenefitsView *)view{
    //添加到我的钱包
   // [self openNewBagInfo];
    [self removeRedPacketEvent];
    self.redPacket.alpha =0;
    self.userModel.newBagSign =1;
    
}


#pragma mark-
#pragma mark action event
- (void)redPacketEvent:(UIButton *)sender{
    [self getRedPackageInfo];
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
