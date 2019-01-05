//
//  BookCatalogueViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCatalogueViewController.h"
#import "ChapterItemGroupModel.h"
#import "BookCityApi.h"
#import "BookModel.h"
#import "CategoryCell.h"
#import "BookcaseApi.h"
#import "ChapterItemModel.h"
#import "E_ScrollViewController.h"
#import "BookGroupModel.h"

static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 30;

@interface BookCatalogueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL orderType; //yes正序 No倒序//排序1=正向|2=反向 ,
@property (nonatomic, weak)UIButton *rightButotn;
@property (nonatomic, strong)CategoryCell *oldCell;

@end

@interface BookCatalogueViewController ()

@end

@implementation BookCatalogueViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self layoutUI];
    [self getRecomClassifies];
    
    [self layoutNavigationBar];
}

- (void)layoutNavigationBar{
    
    
    
    UIButton *leftButotn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButotn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButotn addTarget:self action:@selector(leftItemEvent) forControlEvents:UIControlEventTouchUpInside];
    [leftButotn setFrame:CGRectMake(0,StatusBarHeight, 44, 44)];
    [self.view addSubview:leftButotn];
    
    UILabel *titleLable =[UILabel new];
    [titleLable setTextColor:HEX_COLOR(0x000000)];
    [titleLable setText:NSLocalizedString(@"STR_FOLODER",nil)];
    [titleLable setFont:REGULAR_FONT(17)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLable];
    [titleLable setFrame:CGRectMake(0, leftButotn.y,48,44)];
    titleLable.centerX =self.view.centerX;
    
    UIButton *rightButotn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButotn setTitle:@"正序" forState:UIControlStateNormal];
    [rightButotn setTitle:@"倒序" forState:UIControlStateSelected];
    [rightButotn setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    [rightButotn setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateSelected];
    [rightButotn.titleLabel setFont:REGULAR_FONT(15)];
    [rightButotn addTarget:self action:@selector(rightItemEvent) forControlEvents:UIControlEventTouchUpInside];
    [rightButotn setFrame:CGRectMake(KSCREEN_WIDTH-44-15,20, 44, 44)];
    self.rightButotn =rightButotn;
    [self.view addSubview:rightButotn];
    
}

- (void)initData{
    self.pageNum =KPageNum;
    //  self.pageSize =KPageSize;
    
    if (!_model.chapterCount) {
        self.pageSize =1000;
    }else{
        self.pageSize =_model.chapterCount;
    }
    
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.orderType =YES;
    
}

- (void)layoutUI{
    [self.view addSubview:self.tableView];
}


-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat KTableHeight =KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KTableHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        
        
#if 0
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself refresh];
        }];
        
        _tableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMore];
        } ];
        
        _tableView.mj_footer.hidden =YES;
#endif
        
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
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const categoryCellID =@"categoryCell";
    CategoryCell *categoryCell =[tableView dequeueReusableCellWithIdentifier:categoryCellID];
    if (!categoryCell) {
        categoryCell =[[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellID];
        categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BookModel *bookModel =[BookModel new];
    
    if (self.dataSourceArr.count > indexPath.row) {
        bookModel =self.dataSourceArr[indexPath.row];
        bookModel.bookId =_model.bookId;
        bookModel.bookName =_model.bookName;
        bookModel.chapterNum =bookModel.sortNum;
    }
    [categoryCell cellContent:bookModel indexPath:indexPath];
    
    // [Defaults setInteger:index forKey:[NSString stringWithFormat:@"%ld+%ld",[E_ReaderDataSource shareInstance].currentBookId,index]];
    
    NSLog(@"^^^%ld^^^%ld",[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",bookModel.bookId]],bookModel.sortNum);
    
    NSInteger idx =[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",bookModel.bookId]];
//    if (idx>0) {
//        idx -=1;
//    }
    
    if (idx == bookModel.sortNum) {
        [categoryCell.bookName setTextColor: HEX_COLOR(0x19B898)];
        self.oldCell =categoryCell;
    }
    
   
    
    
    return categoryCell;
}





#pragma mark -
#pragma mark UITableViewDelegate

- (void)readBookEvent:(BookModel *)readModel{
    //本地文件存在
    if (self.isPush) {
        //push模态,直接跳转到阅读器 图书详情里
        [self push];
        
    }else{
        //present模态 阅读器里 通知跳转到对应章节
        [[NSNotificationCenter defaultCenter] postNotificationName:READER_START_NOTIF object:readModel];
        //销毁当前目录控制器
        [self leftItemEvent];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.oldCell) {
        [self.oldCell.bookName setTextColor: HEX_COLOR(0x4A4A4A)];
    }
    
    CategoryCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell.bookName setTextColor: HEX_COLOR(0x19B898)];
    self.oldCell =cell;
    
    
    BookModel *dto =[BookModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
        dto.bookId =_model.bookId;
        dto.bookName =_model.bookName;
        dto.wordCount =_model.wordCount;
        
        self.model.chapterNum = dto.sortNum;
        dto.chapterNum =dto.sortNum;
        
    }
    
    /*+++++++++++++++本地文件及网络文件处理+++++++++++++++++++*/
    FileManager *fileManager =[FileManager getInstance];
    
    //保存本地（文件Path：Books/BookId/chapterNum.txt）
    NSString *filePath_ =[NSString stringWithFormat:@"Books/%ld/%ld.txt",dto.bookId,dto.sortNum];
    
    [NetworkCollectCenter chapterCollect:dto];
    
    //本地文件是否存在
    if ([fileManager isFileExists:filePath_]) {
        [self readBookEvent:dto];
        
    }else{
        //本地文件不存在，获取书籍信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor =[UIColor whiteColor];
        [hud showAnimated:YES];
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",dto.bookId] forKey:@"bookId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",dto.sortNum] forKey:@"chapterNum"];
        
#if 0
        NSString *signature =[NSString new];
        NSString *secretKey = @"PaQhbHy3XbH";
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
        
        signature =[signature stringByAppendingString:[NSString stringWithFormat:@"%ld",dto.bookId]];
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
                
                wself.model.bookId =bookDto.bookId;
                wself.model.chapterId =bookDto.chapterId;
                wself.model.chapterNum =bookDto.chapterNum;
                wself.model.chapterName =bookDto.chapterName;
                
                //txt文件路径
                NSString *filePath =[NSString stringWithFormat:@"Books/%ld",bookDto.bookId];
                
                //文件夹路径
                NSString *fileDir =[NSString stringWithString: filePath];
                
                filePath =[filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld.txt",bookDto.chapterNum]];
                
                //文件夹是否存在
                if (![fileManager isFileExists:fileDir]) {
                    //文件夹不存在,先创建文件夹
                    if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                        //文件夹创建失败，再尝试创建一次
                        if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                            NSLog(@"创建文件夹失败");
                        }else{
                            
                            ///文件夹存在，写到文件
                            
                            /// 文章内容
                            NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                            
                            /// 文件是否存在 暂时不需要判断 写入时会根据当前文件状态自动选择创建，没有自动创建后写入，否则直接写入
                            //  if (![fileManager isFileExists:filePath]) {
                            
                            /// 文章内容写入文件
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                //写入失败再次尝试写入
                                
                                if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                    ///失败
                                    NSLog(@"写入文件失败");
                                }else{
                                    ///写入文件成功
                                    ///////////////////////
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        //  查看写入内容
                                        //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                                        //                    NSLog(@"content:%@",content);
                                        
                                        [wself readBookEvent:dto];
                                        
                                        
                                    });
                                }
                                
                                
                            }else{
                                ///写入文件成功
                                ///////////////////////
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //  查看写入内容
                                    //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                                    //                    NSLog(@"content:%@",content);
                                    
                                    [wself readBookEvent:dto];
                                    
                                    
                                });
                                
                            }
                            
                            //     }
                            
                        }
                        /////
                        
                    }else{
                        ///文件夹创建成功
                        //////////
                    
                            ///文件夹存在，写到文件
                            
                            /// 文章内容
                            NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                            
                            /// 文件是否存在 暂时不需要判断 写入时会根据当前文件状态自动选择创建，没有自动创建后写入，否则直接写入
                            //  if (![fileManager isFileExists:filePath]) {
                            
                            /// 文章内容写入文件
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                //写入失败再次尝试写入
                                
                                if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                    ///失败
                                    NSLog(@"写入文件失败");
                                }else{
                                    ///写入文件成功
                                    ///////////////////////
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        //  查看写入内容
                                        //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                                        //                    NSLog(@"content:%@",content);
                                        
                                        [wself readBookEvent:dto];
                                        
                                        
                                    });
                                }
                                
                                
                            }else{
                                ///写入文件成功
                                ///////////////////////
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //  查看写入内容
                                    //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                                    //                    NSLog(@"content:%@",content);
                                    
                                    [wself readBookEvent:dto];
                                    
                                    
                                });
                                
                            }
                            
                            //     }
                   
                        //////////
                        
                        
                    }
                }else{
                    ///文件夹存在，写到文件
                    
                    /// 文章内容
                    NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                    
                    /// 文件是否存在 暂时不需要判断 写入时会根据当前文件状态自动选择创建，没有自动创建后写入，否则直接写入
                    //  if (![fileManager isFileExists:filePath]) {
                    
                    /// 文章内容写入文件
                    if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                        //写入失败再次尝试写入
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            ///失败
                            NSLog(@"写入文件失败");
                        }else{
                            ///写入文件成功
                            ///////////////////////
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //  查看写入内容
                                //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                                //                    NSLog(@"content:%@",content);
                                
                                [wself readBookEvent:dto];
                                
                                
                            });
                        }
                        
                        
                    }else{
                        ///写入文件成功
                        ///////////////////////
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //  查看写入内容
                            //                    NSString *content  =[NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                            //                    NSLog(@"content:%@",content);
                            
                            [wself readBookEvent:dto];
                            
                            
                        });
                        
                    }
                    
                    //     }
                    
                }
                
            }else{
                [OMGToast showWithText:message];
            }
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            
        }];
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
    dic[@"bookId"] =[NSString stringWithFormat:@"%ld",_model.bookId];
    if (self.orderType) {
        dic[@"orderType"] =@"1";//排序1=正向|2=反向 ,
    }else{
        dic[@"orderType"] =@"2";//排序1=正向|2=反向 ,
    }
    
    
    __weak typeof(self) wself = self;
    [[[BookCityApi alloc] initChapterListWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
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
            
             NSInteger idx =[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",wself.model.bookId]];
            
            if (self.orderType) {//正序
                [wself.dataSourceArr addObjectsFromArray:group.resBody];
                
                if (idx > wself.dataSourceArr.count) {
                    idx =wself.dataSourceArr.count;
                }
                
                if (idx > 0) {
                   idx -=1;
                }
                
                
            }else{//倒序
                wself.dataSourceArr =(NSMutableArray *)[[wself.dataSourceArr reverseObjectEnumerator] allObjects];
                group.resBody =(NSMutableArray *)[[group.resBody reverseObjectEnumerator] allObjects];
                [wself.dataSourceArr  addObjectsFromArray:group.resBody];
                wself.dataSourceArr =(NSMutableArray *)[[wself.dataSourceArr reverseObjectEnumerator] allObjects];
                
                idx =wself.model.chapterCount-idx;
                
                if (idx <= 0) {
                    idx=0;
                }
                
                
            }
            
            [wself.tableView reloadData];
            
            [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

            
            if (group.resBody.count>=KPageSize) {
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

- (void)setModel:(BookModel *)model{
    _model =model;
}


- (void)rightItemEvent{
    
    self.orderType =!self.orderType;
    NSInteger idx =[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",self.model.bookId]];
    
    if (self.orderType) {//正序
        self.rightButotn.selected =NO;
        if (idx>1) {
            idx -=1;
        }
    }else{//倒序
         NSLog(@"---%ld",idx);
        
        idx =self.model.chapterCount-idx;
        
        NSLog(@"%ld---%ld",self.model.chapterCount,idx);
        
        if (idx <= 0) {
            idx =0;
        }
        self.rightButotn.selected =YES;
    }
    
    if (self.dataSourceArr.count) {
        //  [self refresh];
        self.dataSourceArr =(NSMutableArray *)[[self.dataSourceArr reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)leftItemEvent
{
    if (!self.isPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (BOOL)showNavigation{
    return YES;
}

- (void)push{
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    loginvctrl.model =self.model;
    [self.navigationController pushViewController:loginvctrl animated:YES];
//    [self.navigationController presentViewController:loginvctrl animated:NO completion:nil];
    
}

- (void)dealloc{
    
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
