//
//  SearchViewController.m
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

typedef NS_ENUM(NSInteger, SearchTypeStyle) {
    SearchTypeStyle_Normal,    //初始化
    SearchTypeStyle_NoData,    //未收到数据
    SearchTypeStyle_Data,      //收到数据
};

#import "SearchViewController.h"
#import "SearchCell.h"
#import "BookCityApi.h"
#import "BookGroupModel.h"
#import "BookModel.h"
#import "BookDetailViewController.h"
#import "BookCityApi.h"
#import "CircleSearch_HotView.h"
#import "SearchTagModel.h"

static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,CircleSearch_HotViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataSourceArr; //搜索🔍数据
@property (nonatomic,strong)NSMutableArray *recommendArr;//推荐数据
@property (nonatomic,strong)NSMutableArray *tagArr; //搜索历史
@property (nonatomic,strong)UIButton *cancleButton;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *searchTalble;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,strong)UIImageView *emptyImgView;
@property (nonatomic,assign)SearchTypeStyle searchStatus;
@property (nonatomic ,strong)CircleSearch_HotView *hotV;
@property (nonatomic,strong) UIView *hotBgView;
@property (nonatomic,strong)YYLabel *tipLable;
@property (nonatomic,strong)UIButton *deleteButton;
@property (nonatomic,strong)UIView *emptyView;
@property (nonatomic,strong)YYLabel *emptyLable;
@property (nonatomic,strong)UIView *lineView;
@end

@implementation SearchViewController

- (BOOL)showNavigation{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseData];
    [self layoutNavigation];
    [self layoutUI];
    //获取历史搜索关键字
    //获取推荐数据
   // [self getAttentionNetworkData];
}

- (void)initBaseData{
    self.dataSourceArr =[NSMutableArray new];
    self.recommendArr =[NSMutableArray new];
    self.searchStatus =SearchTypeStyle_Normal;
    self.tagArr =[NSMutableArray new];
    [self initData];
}

- (void)initData{
    self.refreshType = UIBehaviorTypeStyle_Normal;
    self.pageNumber =KPageNum;
    self.pageSize =KPageSize;
}

- (void)layoutNavigation{
    //self.showNavigation =NO;

}

- (void)layoutUI{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.cancleButton];
    __weak __typeof(self) weakSelf = self;
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchBar.mas_right);
        make.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(StatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.view addSubview:bottomLine];
    
    
    bottomLine.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.searchBar.mas_bottom).offset(5);
        make.height.mas_equalTo(1.0);
    }];
    [self.view addSubview:self.searchTalble];
    
    [self.searchTalble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(bottomLine.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-TabbarSafeBottomMargin);
    }];
    
   // [self.view addSubview:self.emptyImgView];
    
    
    [self layoutHistoryUI];
    

}

#pragma mark 搜索历史UI
- (void)layoutHistoryUI{
    [self.view addSubview:self.hotBgView];
  //  [self.hotBgView setBackgroundColor: [UIColor redColor]];
    [self.hotBgView addSubview:self.tipLable];
    [self.hotBgView addSubview:self.deleteButton];
    [self.tipLable setFrame:CGRectMake(16, 10, 68,21)];
    [self.deleteButton setFrame:CGRectMake(KSCREEN_WIDTH-44,0, 44, 44)];
    [self.hotBgView addSubview:self.hotV];
    self.tagArr = [NSKeyedUnarchiver unarchiveObjectWithData:[Defaults objectForKey:HISTORYTAGARR]];
    if (!self.tagArr) {
        [self.hotBgView setAlpha:0];
        self.tagArr =[NSMutableArray new];
    }
    
    
    if (self.tagArr.count) {
        [self.hotV creatAndArrangeHot:self.tagArr];
    }else{
        [self.hotBgView setAlpha:0];
    }


}



- (UIImageView *)emptyImgView{
    if (!_emptyImgView) {
        _emptyImgView =[UIImageView new];
        [_emptyImgView setImage: [UIImage imageNamed:@"search_empty"]];
    }
    return _emptyImgView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, StatusBarHeight,KSCREEN_WIDTH-13-32, 44)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.barTintColor = [UIColor clearColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        [_searchBar setImage:[UIImage imageNamed:@"searchIn"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        _searchBar.placeholder = @"搜索你想看的书籍";
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingNone;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.showsCancelButton = NO;
        [_searchBar becomeFirstResponder];
        
        
        for (UIView *view in _searchBar.subviews.lastObject.subviews) {
            if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)view;
                //设置输入框的背景颜色
                textField.clipsToBounds = YES;
                textField.backgroundColor = HEX_COLOR(0xF6F8FB);
                
                //设置输入框边框的圆角以及颜色
                textField.layer.cornerRadius = 4.0f;
//                textField.layer.borderColor = HEX_COLOR(0x3A3A44).CGColor;
//                textField.layer.borderWidth = 1;
                
                //设置输入字体颜色
                textField.textColor = HEX_COLOR(0x979FAC);
                textField.font =REGULAR_FONT(14);
                
                //设置默认文字颜色
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索你想看的书籍" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x979FAC),NSFontAttributeName:REGULAR_FONT(14)}];
            }
        }
           
        //[self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UIButton *)cancleButton{
    
    if (!_cancleButton) {
        _cancleButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
        [_cancleButton.titleLabel setFont:REGULAR_FONT(15)];
        [_cancleButton addTarget:self action:@selector(cancleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setBackgroundColor:[UIColor clearColor]];
    }
    
    return _cancleButton;
    
}

-(UITableView *)searchTalble{
    
    if (!_searchTalble) {
        _searchTalble = [[UITableView alloc]initWithFrame:CGRectMake(0,64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _searchTalble.delegate = self;
        _searchTalble.dataSource = self;
        _searchTalble.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTalble.estimatedRowHeight = 0;
        _searchTalble.estimatedSectionHeaderHeight = 0;
        _searchTalble.estimatedSectionFooterHeight = 0;
        
        [_searchTalble setBackgroundColor:[UIColor clearColor]];
        [self layoutEmptyView];
        
        
        _searchTalble.tableHeaderView =self.emptyView;
        
        
        [self layoutEmptyView];
        
        if (@available(iOS 11.0, *)) {
            _searchTalble.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets =NO;
        }
        
    }
    
    //[_searchTalble setBackgroundColor: [UIColor blueColor]];
    return _searchTalble;
    
    
}

- (void)layoutEmptyView{
    [self.emptyView addSubview:self.emptyImgView];
    [self.emptyView addSubview:self.emptyLable];
    [self.emptyView addSubview:self.lineView];
    [self.emptyImgView setFrame:CGRectMake((KSCREEN_WIDTH-60)/2.0,20, 60, 60)];
    [self.emptyLable setFrame:CGRectMake(0, self.emptyImgView.bottom+15, KSCREEN_WIDTH, 20)];
    [self.lineView setFrame:CGRectMake(0, self.emptyView.bottom,KSCREEN_WIDTH,5)];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchStatus == SearchTypeStyle_Data) {
        return self.dataSourceArr.count;
    }else if(self.searchStatus == SearchTypeStyle_NoData){
        return self.recommendArr.count;
    }
    return 0;
    
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
    
    if (self.searchStatus == SearchTypeStyle_Data) {
        if (self.dataSourceArr.count > indexPath.row) {
            bookModel =self.dataSourceArr[indexPath.row];
        }
    }else if (self.searchStatus == SearchTypeStyle_NoData){
        if (self.recommendArr.count > indexPath.row) {
            bookModel =self.recommendArr[indexPath.row];
        }
    }
    
    [bookInfoHCell cellContent:bookModel indexPath:indexPath type:nil];
    
    return bookInfoHCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 10+88+10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchStatus == SearchTypeStyle_NoData) {
        return 10+29+10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view =[UIView new];
    
    
    for (id views in view.subviews) {
        [views removeFromSuperview];
    }
    
    if (self.searchStatus == SearchTypeStyle_NoData) {
        [view setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10+29+10)];
        YYLabel *titleLable =[YYLabel new];
        [titleLable setFrame:CGRectMake(16, 10, 80, 29)];
        [titleLable setTextColor: HEX_COLOR(0x000000)];
        [titleLable setFont:MEDIUM_FONT(20)];
        
        [titleLable setText:@"人气榜"];
        [view addSubview: titleLable];
    }
   // [view setBackgroundColor: [UIColor redColor]];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookModel *dto =[BookModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
    }
    BookDetailViewController *bookDetail =[BookDetailViewController new];
    bookDetail.model =dto;
    [self.navigationController pushViewController:bookDetail animated:YES];
  
}

#pragma mark UISearchBarDelegateMethod

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(0 == searchText.length)
    {
        [self.dataSourceArr removeAllObjects];
        [self.recommendArr removeAllObjects];
        self.searchStatus =SearchTypeStyle_Normal;
        [self.searchTalble reloadData];
        [self.hotBgView setAlpha:1];
        [self.emptyView setAlpha:0];
       // [self emptyDataShow];
        return ;
        
    }
    [self initData];
    [self getSearchNetData];
    
}

//点击键盘搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [self getSearchNetData];
    [self viewResignFirstResbonder];
}

- (void)viewResignFirstResbonder
{
    [_searchBar resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self viewResignFirstResbonder];
}

/*
 * 收起键盘
 */
-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    [self viewResignFirstResbonder];
}

#pragma mark-
#pragma mark 获取网络数据

//- (void)getNetworkType{
//    if (self.isSerchEd) {
//        [self getSearchNetData];
//    }else{
//        [self getAttentionUsersNetworkData];
//    }
//}

- (void)refresh{
    self.pageNumber =KPageNum;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
   // [self getNetworkType];
};

- (void)loadMore{
    self.pageNumber++;
    self.refreshType =UIBehaviorTypeStyle_More;
   // [self getNetworkType];
}

- (void)removeTagItem{
    if (self.tagArr.count>=10) {
        [self.tagArr removeObjectAtIndex:0];
    }
    if (self.tagArr.count >=10) {
        [self removeTagItem];
    }
}
- (void)getSearchNetData{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageNumber);
    dic[@"pageSize"] = @(self.pageSize);
    dic[@"content"] =self.searchBar.text?self.searchBar.text:@"";
    
    SearchTagModel *tagModel =[SearchTagModel new];
    tagModel.hot_word =dic[@"content"];
    
    [self removeTagItem];
    
    BOOL isExist =NO;
    for (SearchTagModel *dto in self.tagArr) {
        
        if ([dto.hot_word isEqualToString: tagModel.hot_word]) {
            isExist =YES;
        }
    }
    
    if (!isExist) {
        [self.tagArr addObject:tagModel];
    }
    
    
    __weak typeof(self) wself = self;
    
    [[[BookCityApi alloc] initSearchInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof NetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        if (code == SUCCESS_REQUEST) {
            if (responseModel) {

                // 解析数据
                BookGroupModel *groupModel = (BookGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.dataSourceArr removeAllObjects];
                }
                
                // 添加到数据源
                [wself.dataSourceArr addObjectsFromArray:groupModel.resBody];
                
                if (wself.dataSourceArr.count) {
                    wself.searchStatus = SearchTypeStyle_Data;
                    [wself.searchTalble reloadData];
                }

              
                
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
        [wself emptyDataShow];
        
    } failure:^(__kindof NetRequest *request) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        [wself emptyDataShow];
        
    }];

}


- (void)getAttentionNetworkData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageNumber);
    dic[@"pageSize"] = @(self.pageSize);
    __weak typeof(self) wself = self;

    [[[BookCityApi alloc] initSearchRecomBooksWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof NetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        if (code == SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                BookGroupModel *groupModel = (BookGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.recommendArr removeAllObjects];
                }
                
                // 添加到数据源
                [wself.recommendArr addObjectsFromArray:groupModel.resBody];
                
                [wself.searchTalble reloadData];
            
            }
        }else{
            
        }
        
       // [wself emptyDataShow];
        
        
    } failure:^(__kindof NetRequest *request) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
      //  [wself emptyDataShow];
        
    }];

}


#pragma mark- 搜索历史记录

- (YYLabel *)emptyLable{
    if (!_emptyLable) {
        _emptyLable =[YYLabel new];
        [_emptyLable setTextColor: HEX_COLOR(0x979FAC)];
        [_emptyLable setTextAlignment:NSTextAlignmentCenter];
        [_emptyLable setFont:REGULAR_FONT(14)];
        [_emptyLable setText:@"未搜索到相关书籍，看看其他的吧～"];
    }
    return _emptyLable;
}

- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView =[UIView new];
        [_emptyView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH,140)];
        [_emptyView setAlpha:0];
    }
    return _emptyView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"deleteHot"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteHistoryEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView =[UIView new];
        [_lineView setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    }
    return _lineView;
}

- (YYLabel *)tipLable{
    if (!_tipLable) {
        _tipLable =[YYLabel new];
        [_tipLable setText: @"搜索历史"];
        [_tipLable setTextColor:HEX_COLOR(0xB2B2B2)];
        [_tipLable setFont:REGULAR_FONT(15)];
    }
    return _tipLable;
}

- (UIView *)hotBgView{
    if (!_hotBgView) {
        _hotBgView =[UIView new];
        [_hotBgView setFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight)];
    }
    return _hotBgView;
}
- (CircleSearch_HotView *)hotV{
    if (!_hotV) {
        _hotV =[[CircleSearch_HotView alloc] initWithFrame:CGRectMake(0,self.tipLable.bottom+15,KSCREEN_WIDTH,KSCREEN_HEIGHT-(self.tipLable.bottom+20))];
        _hotV.delegate =self;
        [_hotV setBackgroundColor: [UIColor whiteColor]];
        [self.view addSubview: _hotV];
    }
    return _hotV;
}

#pragma mark -CircleSearch_HotViewDelegate
-(void)tapContent:(NSString *)content{
    [_searchBar becomeFirstResponder];
    [_searchBar setText: content];
    [self initData];
    [self getSearchNetData];
}

#pragma mark -action Event
- (void)deleteHistoryEvent{
    // 清楚搜索历史记录
    [self.tagArr removeAllObjects];
    [self.hotV creatAndArrangeHot:self.tagArr];
    [Defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.tagArr] forKey:HISTORYTAGARR];
    [self.hotBgView setAlpha:0];
}


/// 搜索🔍空数据显示
- (void)emptyDataShow{
    if (self.dataSourceArr.count<=0) { //表示无数据
        //[self.emptyImgView setAlpha:1];
        self.searchStatus =SearchTypeStyle_NoData;
        [self.hotBgView setAlpha:0];
        self.emptyView.height =140;
        self.searchTalble.tableHeaderView =self.emptyView;
        [self.emptyView setAlpha:1];
        //请求推荐
        [self getAttentionNetworkData];
    }else{
        //[self.emptyImgView setAlpha:0];
        self.searchStatus =SearchTypeStyle_Data;
        [self.hotBgView setAlpha:0];
        self.emptyView.height =0.001;
        self.searchTalble.tableHeaderView =self.emptyView;
        [self.emptyView setBackgroundColor: [UIColor whiteColor]];
        [self.emptyView setAlpha:0];
    }
    [self.hotV creatAndArrangeHot:self.tagArr];
}


- (void)cancleButtonEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.tagArr.count) {
        [Defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.tagArr] forKey:HISTORYTAGARR];
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
