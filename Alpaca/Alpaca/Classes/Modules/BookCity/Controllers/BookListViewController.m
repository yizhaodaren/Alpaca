//
//  BookListViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookListViewController.h"
#import "BookCityApi.h"
#import "BookGroupModel.h"
#import "BookCityModel.h"
#import "BookInfoHCell.h"
#import "SearchCell.h"
#import "BookDetailViewController.h"
#import "BMSHelper.h"
static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;

@interface BookListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationBar];
    [self initData];

    [self layoutUI];
    [self getRecomClassifies];
}

- (void)layoutNavigationBar{
    switch (self.featureStyle) {
        case FeatureTypeStyle_More:
        {
            [self navigationLeftItemWithImageName:@"back" centerTitle:_cityModel.recomName?_cityModel.recomName:@"" titleColor:HEX_COLOR(0x000000)];
        }
            break;
        case FeatureTypeStyle_NewBook:
        {
            [self navigationLeftItemWithImageName:@"back" centerTitle:NSLocalizedString(@"STR_NewBook", nil) titleColor:HEX_COLOR(0x000000)];
        }
            break;
        case FeatureTypeStyle_End:
        {
            [self navigationLeftItemWithImageName:@"back" centerTitle:NSLocalizedString(@"STR_Ended", nil) titleColor:HEX_COLOR(0x000000)];
        }
            break;
        case FeatureTypeRelateRecomBooks:
        {
            [self navigationLeftItemWithImageName:@"back" centerTitle:@"同类好书推荐" titleColor:HEX_COLOR(0x000000)];
        }
            break;
            
        default:
        {
            [self navigationLeftItemWithImageName:@"back"];
            return;
        }
            break;
    }
}

- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10+88+10;
   // return 15+116+15+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const bookInfoHCellID =@"bookInfoHCell";
    SearchCell *bookInfoHCell =[tableView dequeueReusableCellWithIdentifier:bookInfoHCellID];
    if (!bookInfoHCell) {
        bookInfoHCell =[[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoHCellID];
        bookInfoHCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BookModel *bookModel =[BookModel new];
    
    if (self.dataSourceArr.count > indexPath.row) {
        bookModel =self.dataSourceArr[indexPath.row];
    }
//    [bookInfoHCell cellContent:bookModel indexPath:indexPath type:self.featureStyle];
    
    [bookInfoHCell cellContent:bookModel indexPath:indexPath type:nil];
    
    return bookInfoHCell;
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookModel *dto =[BookModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
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
    dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
    dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
    
    id requestApi;
    
    switch (self.featureStyle) {
        case FeatureTypeStyle_More:
        {
            dic[@"classifyId"] = [NSString stringWithFormat:@"%ld",_cityModel.classifyId];
            requestApi =[[BookCityApi alloc] initGetRecomMoreBooksWithParameter:dic];
            
        }
            break;
        case FeatureTypeStyle_NewBook:
        {
            dic[@"channelCode"] = [NSString stringWithFormat:@"%ld",[BMSHelper getChannel]];
            requestApi =[[BookCityApi alloc] initNewestBooksWithParameter:dic];
        }
            break;
        case FeatureTypeStyle_End:
        {
            dic[@"channelCode"] = [NSString stringWithFormat:@"%ld",[BMSHelper getChannel]];
            requestApi =[[BookCityApi alloc] initCompleteBooksWithParameter:dic];
        }
            break;
        case FeatureTypeRelateRecomBooks:
        {
            dic[@"bookId"] = [NSString stringWithFormat:@"%ld",self.bookModel.bookId];
            dic[@"isRandom"] = @"1";
            requestApi =[[BookCityApi alloc] initRelateRecomBooksListWithParameter:dic];
        }
            break;
    
        default:
        {
            [hud hideAnimated:YES];
            return;
        }
            break;
    }
    
    
    __weak typeof(self) wself = self;
    [requestApi baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (code == SUCCESS_REQUEST) {
            
             BookGroupModel*group =(BookGroupModel *)responseModel;
            
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
    }];
}

- (void)setCityModel:(BookCityModel *)cityModel{
    _cityModel = cityModel;
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
