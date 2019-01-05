//
//  E_EndReaderViewController.m
//  Alpaca
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018 Moli. All rights reserved.
//

#import "E_EndReaderViewController.h"
#import "BookCityApi.h"
#import "BookcaseApi.h"
#import "BookGroupModel.h"
#import "BookCaseCell.h"
#import "BookModel.h"
#import "E_ScrollViewController.h"
#import "EndReaderHeaderView.h"
#import "E_SettingTopBar.h"
#import "BookDetailViewController.h"
#import "BookListViewController.h"

@interface E_EndReaderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,E_SettingTopBarDelegate>
{
      E_SettingTopBar *_settingToolBar;
}

@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;

@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)BookModel  *bookModel;

@property(nonatomic,strong)UISwipeGestureRecognizer * recognizer;
@end

@implementation E_EndReaderViewController
-(BOOL)showNavigation{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.pageNum = 1;
    self.pageSize = 9;
    self.dataSourceArr =[NSMutableArray new];
    [self getBookList];
    
    self.recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:self.recognizer];

}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

-(void)handleSwipeFrom{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI{
    [self.view addSubview:self.collectionView];
    
}
-(void)setTopWithModel:(BookModel *)model{
    self.originalModel = model;
    _settingToolBar = [[E_SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
    //_settingToolBar.bookModel =self.model;
    [_settingToolBar contentEvent:model];
    [self.view addSubview:_settingToolBar];
    _settingToolBar.backgroundColor = [UIColor whiteColor];
    _settingToolBar.delegate = self;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _settingToolBar.bottom - 2, _settingToolBar.width, 2)];
    lineView.backgroundColor = HEX_COLOR(0xF6F8FB);
    [_settingToolBar addSubview:lineView];
    
    [_settingToolBar showToolBar];
}
- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getBookList];
}

- (void)getBookList{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
    dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
    dic[@"bookId"] = [NSString stringWithFormat:@"%ld",self.originalModel.bookId];
    __weak typeof(self) wself = self;
    [[[BookCityApi alloc] initRelateRecomBooksListWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
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
//            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
            
            [wself emptyDataShow];
            [wself.collectionView reloadData];
//            dispatch_semaphore_signal(self->_semaphore);
            
            if (group.resBody.count < wself.pageSize) {
                wself.collectionView.mj_footer.hidden = YES;
                
            }else{
                wself.collectionView.mj_footer.hidden = NO;
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [wself emptyDataShow];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.collectionView.mj_header endRefreshing];
            [wself.collectionView.mj_footer endRefreshing];
        }
        
        if (!wself.dataSourceArr.count) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [OMGToast showWithText:@"网络不给力，请稍后重试"];
                
                [self showNoNetwork];
                
            });
        }
        
    }];
}

- (void)emptyDataShow{
    if (!self.dataSourceArr.count) { //表示无数据
        [self.collectionView setBounces:NO];

        UIBarButtonItem *rightItem=self.navigationItem.rightBarButtonItem;
        UIButton *rightButton =(UIButton *)rightItem.customView;
        [rightButton setAlpha:0];
        
    }else{
        [self.collectionView setBounces:YES];
 
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
- (void)push{
    
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    loginvctrl.model =self.bookModel;
    [self.navigationController pushViewController:loginvctrl animated:YES];
    //    [self.navigationController presentViewController:loginvctrl animated:NO completion:nil];
    
}
#pragma mark 代理方法
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
    
    [self readEvent:dto];
        

    
}

- (void)goBack{
    //复制就能用
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
}

-(void)gotoBookDetail{
    
    BookDetailViewController *bookDetail =[BookDetailViewController new];
    bookDetail.model =self.originalModel;
    bookDetail.isComeFormeReader = YES;
    [self.navigationController pushViewController:bookDetail animated:YES];
}
-(void)moreBtnAction:(UIButton *)sender{
    BookListViewController *bookList =[BookListViewController new];
    bookList.featureStyle =FeatureTypeRelateRecomBooks;
    bookList.bookModel = self.originalModel;
    
    [self.navigationController pushViewController:bookList animated:YES];
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
    
    
    BookCaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"E_EndBookCaseCellID" forIndexPath:indexPath];
    
    [cell content:model indexPath:indexPath];
    
    
        if (model) {
            model.indexpath =nil;
        }
        cell.selectButton.hidden =YES;
        

    
    if ([model.indexpath isEqual:indexPath]) {
        cell.selectButton.selected =YES;
    }else{
        cell.selectButton.selected =NO;
    }
    
    cell.selectButton.userInteractionEnabled = NO;
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
    EndReaderHeaderView *headerView =nil;

    if (kind == UICollectionElementKindSectionHeader) {

        headerView =(EndReaderHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"E_EndHeaderViewID" forIndexPath:indexPath];
        headerView.contentMode =UIViewContentModeScaleToFill;
        [headerView.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.originalModel.isFinish == 1) {
            [headerView setStatusFished];
        }
//        [headerView content];

    }

    return headerView;

}

#pragma mark 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.flowLayout setHeaderReferenceSize:CGSizeMake(KSCREEN_WIDTH,KSCALEHeight(168+5+50))];
  
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight) collectionViewLayout:self.flowLayout];
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
        
        
        [_collectionView registerClass:[BookCaseCell class] forCellWithReuseIdentifier:@"E_EndBookCaseCellID"];
        
      [_collectionView registerClass:[EndReaderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"E_EndHeaderViewID"];
        
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
