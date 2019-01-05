//
//  IMViewController.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "IMViewController.h"
#import "IMViewController.h"
#import "BookModel.h"
#import "IMCell.h"
#import "EmptyTipView.h"
#import "WelfareApi.h"
#import "IMGroupModel.h"
#import "IMModel.h"
#import "MOLWebViewController.h"
#import "BookDetailViewController.h"

static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;
@interface IMViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)EmptyTipView *emptyView;

@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_CancelRedDot_NOTIF object:nil];
    
    [self layoutNavigationBar];
    [self initData];
    
    [self layoutUI];
    [self getRecomClassifies];
}


- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    
}

- (void)layoutUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyView];
}

- (EmptyTipView *)emptyView{
    if (!_emptyView) {
        _emptyView =[EmptyTipView new];
        [_emptyView setFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+60, KSCREEN_WIDTH,120+20+20)];
        [_emptyView setAlpha:0];
        [_emptyView contentImage:@"noMessage" title:@"暂无系统消息"];
        
    }
    return _emptyView;
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
    IMModel *model =[IMModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        model =self.dataSourceArr[indexPath.row];
    }
    CGFloat kwidth =0.0;
    kwidth =KSCREEN_WIDTH-16*2.0-40-9;
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.content?model.content:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(12)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(14)];
    
    if (model.msgType ==0) {
        return 15+27+bookDescHeight+15;
    }
    
    return 15+27+bookDescHeight+11+17+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const imCellID =@"imCell";
     IMCell*imCell =[tableView dequeueReusableCellWithIdentifier:imCellID];
    if (!imCell) {
        imCell =[[IMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imCellID];
        imCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    IMModel *bookModel =[IMModel new];
    
    if (self.dataSourceArr.count > indexPath.row) {
        bookModel =self.dataSourceArr[indexPath.row];
    }
    [imCell cellContent:bookModel indexPath:indexPath];
    
    return imCell;
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IMModel *dto =[IMModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
    }
    
    if (dto.info.length) {
        if (dto.msgType ==1) {//h5
            
            MOLWebViewController *web =[MOLWebViewController new];
            web.urlString =dto.info;
            [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:web animated:YES];
            
        }else if(dto.msgType ==2){//书籍 详情
            BookModel *model =[BookModel new];
            model.bookId =dto.info.integerValue;
            BookDetailViewController *bookDetail =[BookDetailViewController new];
            bookDetail.model =model;
            [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:bookDetail animated:YES];
            
        }else if(dto.msgType ==3){//分类 详情
            
        }
    }
    
    
    
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
    

    id requestApi =[[WelfareApi alloc] initPushMsgWithParameter:dic];
    
    __weak typeof(self) wself = self;
    [requestApi baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (code == SUCCESS_REQUEST) {
            
            IMGroupModel*group =(IMGroupModel *)responseModel;
            
            if (wself.refreshType != UIBehaviorTypeStyle_More) {
                [wself.dataSourceArr removeAllObjects];
            }
            // 添加到数据源
            [wself.dataSourceArr addObjectsFromArray:group.resBody];
            [wself.tableView reloadData];
            
            if (group.resBody.count < self.pageSize) {
                wself.tableView.mj_footer.hidden = YES;
                
            }else{
                wself.tableView.mj_footer.hidden = NO;
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
         [self emptyDataShow];
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [hud hideAnimated:YES];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];
        }
        [self emptyDataShow];
    }];

}

/// 空数据显示
- (void)emptyDataShow{
    if (self.dataSourceArr.count<=0) { //表示无数据
        [self.emptyView setAlpha:1];
        
    }else{
        [self.emptyView setAlpha:0];
        
    }
}


- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back" centerTitle:@"消息" titleColor:HEX_COLOR(0x000000) rightItemImageName:nil rightItemColor:nil];
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
