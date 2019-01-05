//
//  ReadRecordViewController.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//


#import "ReadRecordViewController.h"
#import "ReadRecordCell.h"
#import "BookModel.h"
#import "WelfareApi.h"
#import "BookGroupModel.h"
#import "EmptyTipView.h"
#import "E_ScrollViewController.h"
#import "BookcaseApi.h"
static const NSInteger KPageNum = 1;
static const NSInteger KPageSize  = 10;

@interface ReadRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)EmptyTipView *emptyView;
@property (nonatomic, strong)BookModel *bookModel;

@end


@implementation ReadRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationBar];
    [self initData];

    [self layoutUI];
    [self getRecomClassifies];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)initData{
    self.pageNum =KPageNum;
    self.pageSize =KPageSize;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    self.bookModel =[BookModel new];
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
        [_emptyView contentImage:@"noReadHistory" title:@"你还没有阅读记录，快去发现喜欢的书吧"];
        
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
    return 10+50+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const readRecordCellID =@"readRecordCell";
    ReadRecordCell *readRecordCell =[tableView dequeueReusableCellWithIdentifier:readRecordCellID];
    if (!readRecordCell) {
        readRecordCell =[[ReadRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:readRecordCellID];
        readRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BookModel *bookModel =[BookModel new];
    
    if (self.dataSourceArr.count > indexPath.row) {
        bookModel =self.dataSourceArr[indexPath.row];
    }
    [readRecordCell cellContent:bookModel indexPath:indexPath];
    
    return readRecordCell;
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *dto =[BookModel new];
    if (indexPath.row < self.dataSourceArr.count) {
        dto =self.dataSourceArr[indexPath.row];
        dto.chapterName =dto.chapterVO.chapterName;
        dto.chapterId =dto.chapterVO.chapterId;
        dto.wordCount =dto.chapterVO.wordCount;
        dto.chapterNum =dto.chapterVO.sortNum;
        
    }

    
    self.bookModel =dto;
    
    if (dto) {
       [self readEvent:dto];
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
    
    id requestApi =[[WelfareApi alloc] initUserBookViewRecordsWithParameter:dic];
    
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
            
            if (group.resBody.count > KPageSize) {
                wself.tableView.mj_footer.hidden = NO;
                
            }else{
                wself.tableView.mj_footer.hidden = YES;
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

- (void)readEvent:(BookModel *)model{
    
    /*+++++++++++++++本地文件及网络文件处理+++++++++++++++++++*/
    
    FileManager *fileManager =[FileManager getInstance];
    
    // 保存本地（文件Path：Books/BookId/chapterNum.txt）
    NSString *filePath_ =[NSString stringWithFormat:@"Books/%ld/%ld.txt",model.bookId,model.chapterNum];
    
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
    
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back" centerTitle:@"阅读记录" titleColor:HEX_COLOR(0x000000) rightItemImageName:nil rightItemColor:nil];
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
