//
//  BookcaseViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
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

static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 15;

#import "BookcaseViewController.h"
#import "BookcaseApi.h"
#import "BookCaseCell.h"
#import "BookModel.h"
#import "BookGroupModel.h"
#import "BookDetailViewController.h"
//#import <SGAdvertScrollView/SGAdvertScrollView.h>

#import "BSTabBarController.h"
#import "UserModel.h"
#import "MOLWebViewController.h"
#import "BMSHelper.h"
#import "BannerGroupModel.h"
#import "E_ScrollViewController.h"
#import "EmptyTipView.h"
#import "BMSHelper.h"
#import "NetworkCollectCenter.h"
#import "BookcaseHeaderView.h"


@interface BookcaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)EmptyTipView *emptyView;
@property (nonatomic, strong)UIButton *nodataButton;
//@property (nonatomic, strong)SGAdvertScrollView *advertScrollView;
//@property (nonatomic, strong)UIImageView *emojiImageView;
//@property (nonatomic, strong)UIImageView *arrowsImageView;
@property (nonatomic, assign)BOOL orderType;//yes编辑 No完成
@property (nonatomic, strong)UIButton *removeButton;
@property (nonatomic, strong)NSMutableArray *selectArr;
//@property (nonatomic, strong)UIButton *redPacket;
//@property (nonatomic, strong)NewUserBenefitsView *benefitsView;
//@property (nonatomic, assign)BOOL saveMoneyStatus; //默认不需要保存 yes 需要
//@property (nonatomic, strong)UserModel *userModel;
@property (nonatomic, strong)BookModel *bookModel;


@end

@implementation BookcaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    
    [self layoutUI];
    
    [self getBookList];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([UserManagerInstance user_isLogin]) {
        [self getUserInfo];
    }
    
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent) name:SUCCESS_USER_LOGINOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDate:) name:SUCCESS_BOOKSHELF_ADDED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"BookcaseViewController" object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollStatus:) name:@"SGAdvertScrollView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIsDebugStatus) name:@"updatecontrollerUI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"NetworkHave" object:nil];
    
   
    
}

- (void)updateIsDebugStatus{
    [self.collectionView reloadData];
}

#if 0
- (void)refreshScrollStatus:(NSNotification *)notif{
    if (self.advertScrollView && self.advertScrollView.isHidden) {
        [self.advertScrollView setHidden:NO];
        [self lauoutFrame];
    }
}
#endif


- (void)logOutEvent{
    [self refresh];

    
}

- (void)login_success{
    [self refresh];
    
}


- (void)upDate:(NSNotification *)notif{
    [self refresh];
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:nil centerTitle:NSLocalizedString(@"Bookcase",nil) titleColor:HEX_COLOR(0x000000) rightItemImageName:NSLocalizedString(@"STR_Edit",nil) rightItemColor:HEX_COLOR(0x4A4A4A)];
}

- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.orderType =YES;
    self.selectArr =[NSMutableArray new];
 //   self.userModel =[UserModel new];
 //   [self getUserInfo];
    self.bookModel =[BookModel new];
    
     _semaphore = dispatch_semaphore_create(1);
    
}




- (void)layoutUI{
//    [self.advertScrollView addSubview:self.emojiImageView];
//    [self.advertScrollView addSubview:self.arrowsImageView];
//    [self.view addSubview:self.advertScrollView];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.emptyView];
    [self.collectionView addSubview:self.nodataButton];
    
//    [self.view addSubview:self.redPacket];
//    [self redPacketHiddenEvent];
    
    [self lauoutFrame];
   // [self.tabBarController.tabBar addSubview: self.removeButton];
    
    [self.view addSubview:self.removeButton];
    

}

//- (void)getUserInfo{
//    self.userModel =[UserManagerInstance user_getUserInfo];
//    if (!self.userModel) {
//        self.userModel =[UserModel new];
//    }
//}


- (void)lauoutFrame{
    __weak typeof(self) wself = self;

    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wself.view);
        make.right.mas_equalTo(wself.view);
        make.top.mas_equalTo(wself.view);
    
        
        if(!wself.orderType){//完成
           make.bottom.mas_equalTo(wself.view).offset(-KTabbarHeight-49);
        }else{
           make.bottom.mas_equalTo(wself.view);
        }
        
        
    }];
    

}



- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.flowLayout setHeaderReferenceSize:CGSizeMake(KSCREEN_WIDTH,KSCALEHeight(180+5+40+15))];
       // self.flowLayout.minimumLineSpacing = 20;
       // self.flowLayout.minimumInteritemSpacing = 10;
        //self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30+10+10, KSCREEN_WIDTH, KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight-KTabbarHeight-30-10-10) collectionViewLayout:self.flowLayout];
        _collectionView = collectionView;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
        collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        
        [_collectionView registerClass:[BookCaseCell class] forCellWithReuseIdentifier:@"BookCaseCellID"];
        
        [_collectionView registerClass:[BookcaseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
        
        __weak typeof(self) wself = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
             [wself refresh];
        }];
        
        _collectionView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
             [wself loadMore];
        } ];
        
        _collectionView.mj_footer.hidden =YES;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets =NO;
        }
        
        

        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)readEvent:(BookModel *)model{
    
    /*+++++++++++++++本地文件及网络文件处理+++++++++++++++++++*/

    FileManager *fileManager =[FileManager getInstance];
    
    // 保存本地（文件Path：Books/BookId/cNum.txt）
    NSString *filePath_ =[NSString stringWithFormat:@"Books/%ld/%ld.txt",model.bookId,model.chapterNum];
    
    [NetworkCollectCenter chapterCollect:model];
    
    ///判断本地文件是否存在
    if ([fileManager isFileExists:filePath_]) {
       ///本地文件存在，直接阅读
        
        [self push];
    
    }else{
        ///本地文件不存在，获取阅读内容
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor =[UIColor whiteColor];
        [hud showAnimated:YES];
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",model.bookId] forKey:@"bookId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",model.chapterNum] forKey:@"chapterNum"];
#if 0
        NSString *signature =[NSString new];
        NSString *secretKey = @"PaQhbHy3XbH";
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
        
        signature =[signature stringByAppendingString:[NSString stringWithFormat:@"%ld",model.bookId]];
        signature =[signature stringByAppendingString:secretKey];
        signature =[signature stringByAppendingString:timestamp];
        signature =[signature mol_md5WithOrigin];
        
        [dic setObject:signature forKey:@"signature"];
        [dic setObject:timestamp forKey:@"timestamp"];
        
        //加密规则=md5(bookId+X_SECRET_KEY+timestamp)
#endif
        __weak typeof(self) wself = self;
        [[[BookcaseApi alloc] initChapterInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
            
            [hud hideAnimated:YES];
            
            if (code == SUCCESS_REQUEST) {
                
                BookModel *bookDto =(BookModel *)responseModel;
                if (!bookDto.chapterNum) {
                    /// 未获取到章节数，则以请求章节数为当前章节数
                    bookDto.chapterNum =model.chapterNum;
                }
                wself.bookModel.chapterName =bookDto.chapterName;
                
                ///文件路径
                NSString *filePath =[NSString stringWithFormat:@"Books/%ld",bookDto.bookId];
                ///文件夹路径
                NSString *fileDir =[NSString stringWithString: filePath];
                
                filePath =[filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld.txt",bookDto.chapterNum]];
                
                
                if (![fileManager isFileExists:fileDir]) {
                    ///本地文件夹路径不存在
                    if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                        ///创建本地文件失败，再尝试创建一次
                        if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                            NSLog(@"创建文件夹失败");
                        }else{
                            ////文件夹创建成功
                            //文章内容
                            NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                            
                            // if (![fileManager isFileExists:filePath]) {
                            
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                ///写入文章内容到文件失败，尝试再次写入
                                if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                    NSLog(@"写入文件失败");
                                }else{
                                    ///文章写入成功
                                    [self push];
                                }
                            }else{
                                ///文章写入成功
                                [self push];
                            }
                        }
                        
                    }else{
                        ///文件夹创建成功
                        //文章内容
                        NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                        
                        // if (![fileManager isFileExists:filePath]) {
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            ///写入文章内容到文件失败，尝试再次写入
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                NSLog(@"写入文件失败");
                            }else{
                                ///文章写入成功
                                [self push];
                            }
                        }else{
                            ///文章写入成功
                            [self push];
                        }
                    }
                }else{
                    ///文件夹存在
                    //文章内容
                    NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                    
                   // if (![fileManager isFileExists:filePath]) {
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            ///写入文章内容到文件失败，尝试再次写入
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                NSLog(@"写入文件失败");
                            }else{
                                ///文章写入成功
                                [self push];
                            }
                        }else{
                            ///文章写入成功
                            [self push];
                        }
                        
                    //}
                    
                    
                }
                
            
            }else{
                [OMGToast showWithText:message];
            }
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            
        }];
    }
   
}

#pragma mark-
#pragma mark collectionviewDelegate

- (void)removeButtonSelectEvent{
    if (self.selectArr.count) {
        self.removeButton.selected=YES;
       // [self.removeButton setUserInteractionEnabled:YES];
    }else{
        self.removeButton.selected=NO;
       // [self.removeButton setUserInteractionEnabled:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookModel *dto =[BookModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
        dto.inShelf = 1;
        dto.fromVC =100;
        /// 根据Chapter_bookId 获取 本地已阅读章节数
        NSInteger idx =[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",dto.bookId]];
        
        if (!idx) {
            /// 未获取到已阅读本地章节数，则初始化章节为第一章节
            idx =1;
        }
        
        dto.chapterNum =idx;
        
        
    }
    
    self.bookModel =dto;
    
    if (self.orderType) {
    
        [self readEvent:dto];
        
    }else{
        if ([dto.indexpath isEqual:indexPath]) {
            
            dto.indexpath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            [self.selectArr removeObject:dto];
            
        }else{
            
            dto.indexpath = indexPath;
            [self.selectArr addObject:dto];
            
        }
        
        if (self.selectArr.count) {
            self.navigationItem.title= [NSString stringWithFormat:@"已选择%ld本",self.selectArr.count];
        }else{
            self.navigationItem.title= @"请选择图书";
        }
        
        
        [self.collectionView reloadData];
        
        [self removeButtonSelectEvent];
        
    }
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model = [BookModel new];
    if (self.dataSourceArr.count > indexPath.row) {
        model =self.dataSourceArr[indexPath.row];
    }
    
    
    BookCaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCaseCellID" forIndexPath:indexPath];
    
    [cell content:model indexPath:indexPath];
    
    
    if (self.orderType) {
        if (model) {
            model.indexpath =nil;
        }
        cell.selectButton.hidden =YES;
        
    }else{
        cell.selectButton.hidden =NO;
        
    }
    
    if ([model.indexpath isEqual:indexPath]) {
        cell.selectButton.selected =YES;
    }else{
        cell.selectButton.selected =NO;
    }
    
    cell.selectButton.userInteractionEnabled = NO;
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    BookcaseHeaderView *headerView =nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        headerView =(BookcaseHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID" forIndexPath:indexPath];
        headerView.contentMode =UIViewContentModeScaleToFill;
        [headerView content];
        
    }
    
    return headerView;
    
}



#pragma mark -空提示布局
- (UIButton *)nodataButton{
    if (!_nodataButton) {
        _nodataButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nodataButton setTitle:@"去找书" forState:UIControlStateNormal];
        [_nodataButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
        [_nodataButton setBackgroundColor:HEX_COLOR(0x4A4A4A)];
        [_nodataButton addTarget:self action:@selector(findBook:) forControlEvents:UIControlEventTouchUpInside];
        [_nodataButton setFrame:CGRectMake((KSCREEN_WIDTH-15*2.0-120)/2.0,90+120+55+180, 120, 40)];
        [_nodataButton.layer setMasksToBounds:YES];
        [_nodataButton.layer setCornerRadius:20];
        [_nodataButton setAlpha:0];
    }
    return _nodataButton;
}

- (EmptyTipView *)emptyView{
    if (!_emptyView) {
        _emptyView =[EmptyTipView new];
        [_emptyView setFrame:CGRectMake(0,180+90, KSCREEN_WIDTH-15*2.0,120+20+20)];
        [_emptyView setAlpha:0];
        [_emptyView contentImage:@"noReadHistory" title:@"书架都快饿扁了，快用好书填满它吧"];
       
        
    }
    return _emptyView;
}


#pragma mark-
#pragma mark 网络请求
- (void)refresh{
    self.pageNum =KPageNum;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getBookList];
};

- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getBookList];
}
- (void)getBookList{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
    dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
    
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initGetBookListWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.collectionView.mj_header endRefreshing];
            [wself.collectionView.mj_footer endRefreshing];
        }
        
        [self hiddenNoNetwork];
        
        if (code == SUCCESS_REQUEST) {
            
             BookGroupModel*group =(BookGroupModel *)responseModel;
            
            if (wself.refreshType != UIBehaviorTypeStyle_More) {
                [wself.dataSourceArr removeAllObjects];
            }
            // 添加到数据源
            [wself.dataSourceArr addObjectsFromArray:group.resBody];
            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
            [wself.collectionView reloadData];
            dispatch_semaphore_signal(self->_semaphore);
            
            if (group.resBody.count < wself.pageSize) {
                wself.collectionView.mj_footer.hidden = YES;

            }else{
                wself.collectionView.mj_footer.hidden = NO;
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
        [wself emptyDataShow];
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [wself emptyDataShow];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.collectionView.mj_header endRefreshing];
            [wself.collectionView.mj_footer endRefreshing];
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

- (void)getUserInfo{
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initUserInfoWithParameter:@{}] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        if (code ==SUCCESS_REQUEST) {
            
            UserModel *model =(UserModel *)responseModel;
            if (model) {
                // 登录成功
                [UserManagerInstance user_saveUserInfoWithModel:model isLogin:YES];
                
                dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
                [wself.collectionView reloadData];
                dispatch_semaphore_signal(self->_semaphore);
            }
            
        }
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}



/// 搜索🔍空数据显示
- (void)emptyDataShow{
    if (!self.dataSourceArr.count) { //表示无数据
       // [self.collectionView setBounces:NO];
        [self.emptyView setAlpha:1];
        [self.nodataButton setAlpha:1];
        UIBarButtonItem *rightItem=self.navigationItem.rightBarButtonItem;
        UIButton *rightButton =(UIButton *)rightItem.customView;
        [rightButton setAlpha:0];
        
    }else{
       // [self.collectionView setBounces:YES];
        [self.emptyView setAlpha:0];
        [self.nodataButton setAlpha:0];
        UIBarButtonItem *rightItem=self.navigationItem.rightBarButtonItem;
        UIButton *rightButton =(UIButton *)rightItem.customView;
        [rightButton setAlpha:1];
        
        CGFloat itemW = KSCALEWidth(88);
        
        CGFloat itemH = KSCALEHeight(125+5+16+17);
        
        BOOL isExist =NO;
        for (BookModel *model_ in self.dataSourceArr) {
            NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model_.bookName?model_.bookName:@"" color:HEX_COLOR(0x252525) font:REGULAR_FONT(14)];
            
            CGFloat bookDescHeight =0.0;
            
            bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:itemW font:REGULAR_FONT(14)];
            
            if (bookDescHeight >=20*2.0) {
                isExist =YES;
            }
        }
        
        if (isExist) {
            itemH +=24;
        }
        
        //row 之间距离  section之间距离
        self.flowLayout.minimumLineSpacing = 20;
        self.flowLayout.minimumInteritemSpacing = 20;
        self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        
    }
}


- (void)findBook:(UIButton *)sender{
    
    BSTabBarController *tabBar=(BSTabBarController *)[[GlobalManager shareGlobalManager] global_rootViewControl];
    tabBar.selectedIndex =1;
    
}


- (void)initRightItemEvent{
    self.orderType =!self.orderType;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BookcaseViewControllerStatus" object:[NSNumber numberWithBool:self.orderType]];
    
    UIBarButtonItem *rightItem=self.navigationItem.rightBarButtonItem;
    UIButton *rightButton =(UIButton *)rightItem.customView;
    

    if (self.orderType) {//编辑
        _collectionView.mj_header.hidden =NO;
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.removeButton setAlpha:0];
        [self.tabBarController.tabBar setAlpha:1];
        self.view.height =KSCREEN_HEIGHT-KTabbarHeight-StatusBarAndNavigationBarHeight;
        self.navigationItem.title =@"书架";
        [self.selectArr removeAllObjects];
        [self removeButtonSelectEvent];
        
    }else{//完成
        _collectionView.mj_header.hidden =YES;
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.removeButton setAlpha:1];
        if (self.selectArr.count) {
            self.navigationItem.title= [NSString stringWithFormat:@"已选择%ld本",self.selectArr.count];
        }else{
            self.navigationItem.title= @"请选择图书";
        }
        [self.tabBarController.tabBar setAlpha:0];
        self.view.height =KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight+KTabbarHeight;
    }
    [self lauoutFrame];
}

- (void)rightItemEvent{
    
    if (!self.dataSourceArr.count) {
        return;
    }
    
    [self initRightItemEvent];
    
    [self.collectionView reloadData];
}

- (UIButton *)removeButton{
    if (!_removeButton) {
        _removeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setAlpha:0];
        [_removeButton setBackgroundColor:HEX_COLOR(0xF6F8FB)];
        [_removeButton setFrame:CGRectMake(0,KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight-KTabbarHeight, KSCREEN_WIDTH, 49)];
        [_removeButton setTitle:@"移出书架" forState:UIControlStateNormal];
       // [_removeButton setUserInteractionEnabled:NO];
        [_removeButton setTitleColor:HEX_COLOR(0xD0021B) forState:UIControlStateSelected];
        [_removeButton setTitleColor:HEX_COLOR(0xDEE2E8) forState:UIControlStateNormal];
        [_removeButton.titleLabel setFont:REGULAR_FONT(17)];
        [_removeButton addTarget:self action:@selector(removeBookEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

- (void)removeBookEvent:(UIButton *)sender{
    
    if (!sender.selected) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否将所选书籍移出书架？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) wself = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [wself removeBookcaseNet];

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
     
}

- (void)removeBookcaseNet{
    
    if (!self.selectArr.count) {
        return;
    }
    
    __weak typeof(self) wself = self;
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
  
    
    NSMutableArray *shelfArr =[NSMutableArray array];
    [self.selectArr enumerateObjectsUsingBlock:^(BookModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [shelfArr addObject:[NSString stringWithFormat:@"%ld",obj.bookId]];
    }];
   
    [dic setObject:shelfArr forKey:@"bookIds"];
    

    [[[BookcaseApi alloc] initRemoveBookcase:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            [wself.selectArr enumerateObjectsUsingBlock:^(BookModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [wself.dataSourceArr removeObject:obj];
            }];
            
            [wself.selectArr removeAllObjects];
            
            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
            [wself.collectionView reloadData];
            dispatch_semaphore_signal(self->_semaphore);
            
        }else{
            [OMGToast showWithText:message];
        }
        
        [wself removeButtonSelectEvent];
        [wself initRightItemEvent];
        [wself emptyDataShow];
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [wself removeButtonSelectEvent];
        [wself initRightItemEvent];
        [wself emptyDataShow];
    }];
}



- (void)push{
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    loginvctrl.model =self.bookModel;
    [self.navigationController pushViewController:loginvctrl animated:YES];
//    [self.navigationController presentViewController:loginvctrl animated:NO completion:nil];
    
}

- (void)dealloc{
#if    !OS_OBJECT_USE_OBJC
    dispatch_release(_semaphore);
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
