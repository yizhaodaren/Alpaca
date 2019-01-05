//
//  BookCategoryViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//


typedef NS_ENUM(NSInteger,NetworkTypeStyle) {
    NetworkTypeStyle_CategoryList, //分类列表
    NetworkTypeStyle_CateContent,  //类型内容
    
};

#import "BookCategoryViewController.h"
#import "BookCityApi.h"
#import "BookGroupModel.h"
#import "BookCityModel.h"
#import "SearchCell.h"
#import "BookDetailViewController.h"
#import "CategoryCollectionViewCell.h"
#import "CategoryModel.h"
#import "CategoryGroupModel.h"



static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;


@interface BookCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)NSMutableArray *categoryArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)NetworkTypeStyle networkType;
@property (nonatomic, strong)CategoryModel *categoryDto;
@property (nonatomic, strong)YYLabel *currentLabel;

@end

@implementation BookCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initData];
    
    [self layoutUI];
    [self getRecomClassifies];
}

- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.categoryArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.networkType =NetworkTypeStyle_CategoryList;
    self.categoryDto =[CategoryModel new];
}

- (void)layoutUI{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat KTableHeight =KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.collectionView.width,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH-self.collectionView.width, KTableHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = HEX_COLOR(0xffffff);
        
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself refresh];
        }];
        
        _tableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMore];
        } ];
        
        _tableView.mj_header.hidden =YES;
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
    //return 15+116+15+1;
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
    [bookInfoHCell cellContent:bookModel indexPath:indexPath type:self.fromFunctionType];
    
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

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout =[UICollectionViewFlowLayout new];
        
        CGFloat itemW = 83;
        CGFloat itemH = 50;
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //flowLayout.minimumLineSpacing = 2;
        //flowLayout.minimumInteritemSpacing = 8;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        CGFloat KTableHeight =KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight;
        
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight,itemW, KTableHeight) collectionViewLayout:flowLayout];
        
        //collectionViewS.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCollectionViewCellID"];
        [_collectionView setBackgroundColor: HEX_COLOR(0xF6F8FB)];
        
        
    
    }
    return _collectionView;
}
#pragma mark -
#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self contentEvent:indexPath.row status:NO];
}

- (void)getCollectionCellEvent:(NSInteger)row model:(CategoryModel *)model{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    CategoryCollectionViewCell *cell =(CategoryCollectionViewCell*)[self.collectionView  cellForItemAtIndexPath:indexPath];
    
    for (id item  in cell.contentView.subviews) {
        if ([item isKindOfClass:[YYLabel class]]) {
            
            if (self.currentLabel) {
                [self.currentLabel setTextColor: HEX_COLOR(0x979FAC)];
                [self.currentLabel setFont:REGULAR_FONT(17)];
                [self.currentLabel setBackgroundColor: [UIColor clearColor]];
            }
            
            YYLabel *label =(YYLabel *)item;
            [label setTextColor: HEX_COLOR(0x000000)];
            [label setFont:SEMIBOLD_FONT(17)];
            [label setBackgroundColor: HEX_COLOR(0xffffff)];
            self.currentLabel =label;
        }
    }
}

- (void)contentEvent:(NSInteger)row status:(BOOL)status{
    self.networkType = NetworkTypeStyle_CateContent;
    
    if (self.categoryArr.count) {
        _tableView.mj_header.hidden =NO;
    }
    CategoryModel *model =[CategoryModel new];
    if (row < self.categoryArr.count) {
        model =self.categoryArr[row];
        
        if (self.currentLabel) {
            if ([self.currentLabel.text isEqualToString: model.cateName]) {
                return;
            }
        }
        
        [self getCollectionCellEvent:row model:model];
    }
    if (model.cateId) {
        self.categoryDto =model;
        [self refresh];
    }
}



//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryArr.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCellID" forIndexPath:indexPath];
    
    CategoryModel *model =[CategoryModel new];
    if (indexPath.row < self.categoryArr.count) {
        model =self.categoryArr[indexPath.row];
    }
    
    [cell content:model indexPath:indexPath];
    
    return cell;

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
    
    
    id requestApi;
    
    
    
    if (self.networkType == NetworkTypeStyle_CategoryList) {
        
        NSString *parameterId =@"2";
        if (self.categoryType == CategoryTypeStyle_Male) {
            parameterId =@"1";
        }
        if (self.fromFunctionType == FromFunctionType_Category) {//分类
            dic[@"cateType"] =@"1";
        }else if (self.fromFunctionType == FromFunctionType_Ranking){//排行
            dic[@"cateType"] =@"2";
        }
        dic[@"channelCode"] =parameterId;
        requestApi =[[BookCityApi alloc] initCategoryListWithParameter:dic];
        
    }else{
        dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
        dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
        dic[@"cateId"] = [NSString stringWithFormat:@"%ld",self.categoryDto.cateId];
        if (self.fromFunctionType == FromFunctionType_Category) {//分类
            dic[@"cateType"] =@"1";
        }else if (self.fromFunctionType == FromFunctionType_Ranking){//排行
            dic[@"cateType"] =@"2";
        }
       
        requestApi =[[BookCityApi alloc] initCateOrRankBooksWithParameter:dic];
    }
    
    __weak typeof(self) wself = self;
    [requestApi baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        
        if (self.networkType ==NetworkTypeStyle_CateContent) {
            if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
            }
        }
        
        if (code == SUCCESS_REQUEST) {
            
            if (self.networkType == NetworkTypeStyle_CateContent) {
                
                BookGroupModel*group =(BookGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSourceArr removeAllObjects];
                }
                // 添加到数据源
                [wself.dataSourceArr addObjectsFromArray:group.resBody];
                [wself.tableView reloadData];
                
        
                if (group.resBody.count>=KPageSize) {
                    wself.tableView.mj_footer.hidden = NO;
                    
                }else{
                    wself.tableView.mj_footer.hidden = YES;
                }
                
            }else{
                CategoryGroupModel*group =(CategoryGroupModel *)responseModel;
                
                // 添加到数据源
                [wself.categoryArr addObjectsFromArray:group.resBody];
                [wself.collectionView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [wself contentEvent:0 status:YES];
                });
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [hud hideAnimated:YES];
        
        if (self.networkType == NetworkTypeStyle_CateContent) {
            if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
            }
        }
        
    }];
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
