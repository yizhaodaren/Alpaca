//
//  BookDetailViewController.m
//  Alpaca
//
//  Created by ACTION on 2018/11/22.
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

#import "BookDetailViewController.h"
#import "BookModel.h"
#import "BookcaseApi.h"
#import "HomeShareView.h"
#import "BookDetailInfoCell.h"
#import "BookDetailGuideCell.h"
#import "BookDCopyrightCell.h"
#import "BookInfoVTopCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "BookGroupModel.h"
#import "E_ScrollViewController.h"
#import "NetworkCollectCenter.h"


@interface BookDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HomeShareViewDelegate,BookDetailInfoCellDelegate>
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,strong)UIButton *leftBottomButton;
@property (nonatomic,strong)UIButton *rightBottomButton;
@property (nonatomic, strong)HomeShareView *shareView;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL isDetailNet; //yes no
@property (nonatomic, assign)BOOL isRecomNet; //yes no

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    
    [self layoutUI];
    [self getBookDetail];
    [self networkData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(putBookSuccess) name:SUCCESS_BOOKSHELF_ADDED object:nil];
}

- (void)putBookSuccess{
    [self.leftBottomButton setTitle:NSLocalizedString(@"STR_AddedBookcase", nil) forState:UIControlStateNormal];
    [self.leftBottomButton setTitleColor:HEX_COLOR_ALPHA(0x19B898,0.5) forState:UIControlStateNormal];
    [self.leftBottomButton setEnabled: NO];
    self.model.inShelf =1;
    
    
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back" centerTitle:nil titleColor:nil rightItemImageName:@"share"];
    
}

- (void)initData{
    
    self.dataSourceArr =[NSMutableArray new];
    
}

- (void)layoutUI{
    
    [self.view addSubview:self.tableView];

    [self layoutBottomUI];
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat KTableHeight =KSCREEN_HEIGHT-StatusBarAndNavigationBarHeight-KTabbarHeight;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KTableHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        
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
    if (self.model.books.count) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:self.model.bookDesc?self.model.bookDesc:@"" color:HEX_COLOR(0x4A4A4A) font:REGULAR_FONT(16)];
        
        CGFloat bookDescHeight =0.0;
        CGFloat kwidth =KSCREEN_WIDTH-15*2.0;
        bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(16)];
        
        if (self.model.isOpening) {
            return 15+116+15+bookDescHeight+15;
        }else{
            if (bookDescHeight>69) {
                return 15+116+15+69+15;
            }else{
                return 15+116+15+bookDescHeight+15;
            }
        }
        
        
        
        
        
    }else if (indexPath.section==1){
        return 44;
        
    }
    
    if (self.model.books.count) {
        if (indexPath.section ==2) {
            BOOL isExist =NO;
            for (BookModel *model_ in self.model.books) {
                NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model_.bookName?model_.bookName:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
                
                CGFloat bookDescHeight =0.0;
                
                bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:KSCALEWidth(80) font:REGULAR_FONT(14)];
                
                if (bookDescHeight >=20*2.0) {
                    isExist =YES;
                }
            }
            
            if (isExist) {
                return self.model.recommendHeight+20;
            }
            return self.model.recommendHeight;
        }
    }
    return self.model.copyrightHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==2 || section ==3) {
       return 44;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *headerView =[UIView new];
    [headerView setBackgroundColor:[UIColor whiteColor]];
   
    UILabel *titleLable =[UILabel new];
    [titleLable setBackgroundColor:[UIColor whiteColor]];
    [titleLable setTextColor:HEX_COLOR(0x000000)];
    [titleLable setFont:REGULAR_FONT(16)];
    [headerView addSubview:titleLable];
    
    
    if (self.model.books.count) { //有相关推荐
        if (section == 2) {
            [titleLable setText:NSLocalizedString(@"STR_RelatedRecommend", nil)];
        }else if(section == 3){
            [titleLable setText:NSLocalizedString(@"STR_CopyrightInformation", nil)];
        }
        
    }else{//无相关推荐
        if (section == 2) {
            [titleLable setText:NSLocalizedString(@"STR_CopyrightInformation", nil)];
        }
        
    }
    
    
    
    
    if (section == 2 || section ==3) {
        [titleLable setFrame:CGRectMake(15, 0, 100, 44)];
    }
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        static NSString * const bookDetailInfoCellID =@"bookDetailInfoCell";
        BookDetailInfoCell *bookDetailInfoCell =[tableView dequeueReusableCellWithIdentifier:bookDetailInfoCellID];
        if (!bookDetailInfoCell) {
            bookDetailInfoCell =[[BookDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookDetailInfoCellID];
            bookDetailInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        bookDetailInfoCell.delegate =self;
        [bookDetailInfoCell cellContent:self.model indexPath:indexPath];
        
        return bookDetailInfoCell;
        
    }else if(indexPath.section ==1){
        static NSString * const bookDetailGuideCellID =@"bookDetailGuideCell";
        BookDetailGuideCell *bookDetailGuideCell =[tableView dequeueReusableCellWithIdentifier:bookDetailGuideCellID];
        if (!bookDetailGuideCell) {
            bookDetailGuideCell =[[BookDetailGuideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookDetailGuideCellID];
            bookDetailGuideCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [bookDetailGuideCell cellContent:self.model indexPath:indexPath];
        
        return bookDetailGuideCell;
        
    }
    
    if (self.model.books.count) {
        if (indexPath.section ==2) {
            static NSString* const bookInfoVTopCellID =@"bookInfoVTopCell";
            BookInfoVTopCell*bookInfoVTopCell =[tableView dequeueReusableCellWithIdentifier:bookInfoVTopCellID];
            if (!bookInfoVTopCell) {
                bookInfoVTopCell =[[BookInfoVTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookInfoVTopCellID];
                bookInfoVTopCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [bookInfoVTopCell cellContent:self.model.books indexPath:indexPath];
            
            return bookInfoVTopCell;
        }
    }
    
    
    static NSString * const bookDCopyrightCellID =@"bookDCopyrightCell";
    BookDCopyrightCell *bookDCopyrightCell =[tableView dequeueReusableCellWithIdentifier:bookDCopyrightCellID];
    if (!bookDCopyrightCell) {
        bookDCopyrightCell =[[BookDCopyrightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookDCopyrightCellID];
        bookDCopyrightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [bookDCopyrightCell cellContent:self.model indexPath:indexPath];
    
    return bookDCopyrightCell;
    
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BookModel *dto =[BookModel new];
//    if (indexPath.row < self.dataSourceArr.count) {
//        dto =self.dataSourceArr[indexPath.row];
//    }
//    BookDetailViewController *bookDetail =[BookDetailViewController new];
//    bookDetail.model =dto;
//    [self.navigationController pushViewController:bookDetail animated:YES];
}



- (HomeShareView *)shareView{
    if (!_shareView) {
        _shareView =[HomeShareView new];
        [_shareView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        _shareView.currentBusinessType = HomeShareViewBusinessRewardType;
        [_shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo"]];
        _shareView.delegate =self;
    }
    return _shareView;
}

- (void)layoutLeftBottomButtonUI{
    //STR_AddedBookcase
    if (self.model.inShelf) {//已加入
        [self.leftBottomButton setTitle:NSLocalizedString(@"STR_AddedBookcase", nil) forState:UIControlStateNormal];
        // [self.leftBottomButton setTitle:@"已加入书架" forState:UIControlStateNormal];
        [self.leftBottomButton setTitleColor:HEX_COLOR_ALPHA(0x979FAC,0.5) forState:UIControlStateNormal];
        [self.leftBottomButton setEnabled: NO];
    }else{
        [self.leftBottomButton setTitle:NSLocalizedString(@"STR_AddBookcase", nil) forState:UIControlStateNormal];
        [self.leftBottomButton setTitleColor:HEX_COLOR(0x19B898) forState:UIControlStateNormal];
        [self.leftBottomButton setEnabled: YES];
    }
}

- (void)layoutBottomUI{
    
    self.leftBottomButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBottomButton setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    
    [self layoutLeftBottomButtonUI];
    
    [self.leftBottomButton.titleLabel setFont: MEDIUM_FONT(16)];
    [self.leftBottomButton addTarget:self action:@selector(putBookEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftBottomButton];
    
    self.rightBottomButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBottomButton setBackgroundColor:HEX_COLOR(0x19B898)];
    [self.rightBottomButton setTitle:NSLocalizedString(@"SET_Read_NOW", nil) forState:UIControlStateNormal];
    [self.rightBottomButton.titleLabel  setFont:MEDIUM_FONT(16)];
    [self.rightBottomButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    [self.rightBottomButton addTarget:self action:@selector(readEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBottomButton];
    
    __weak typeof(self) wself = self;
    
    [self.leftBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.view).offset(-TabbarSafeBottomMargin);
        make.left.mas_equalTo(wself.view);
        make.width.mas_equalTo(KSCREEN_WIDTH/2.0);
        make.height.mas_equalTo(48);
    }];
    
    [self.rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.leftBottomButton);
        make.right.mas_equalTo(wself.view);
        make.width.mas_equalTo(KSCREEN_WIDTH/2.0);
        make.height.mas_equalTo(48);
    }];
    
    
    
}

#pragma mark -
#pragma mark 网络请求事件

- (void)networkData{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"bookId"] = [NSString stringWithFormat:@"%ld",self.model.bookId];
    dic[@"isRandom"] =@"1"; //随机
    dic[@"pageNum"] =@"1";
    dic[@"pageSize"] =@"4";
    
    BookcaseApi *recomBooks = [[BookcaseApi alloc] initRelateRecomBooksWithParameter:dic];
    __weak typeof(self) wself = self;
    [recomBooks baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        wself.isRecomNet =YES;
        if (code ==SUCCESS_REQUEST) {
            BookGroupModel *groupModel =(BookGroupModel *)responseModel;
            wself.model.books =[NSMutableArray arrayWithArray:groupModel.resBody];
            
        }else{
            
        }
        
        [wself reloadDataEvent];
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        wself.isRecomNet =YES;
        [wself reloadDataEvent];
    }];
    
}

- (void)getBookDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initBookDetailWithParameter:dic parameterId:[NSString stringWithFormat:@"%ld",self.model.bookId]] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        wself.isDetailNet =YES;
        if (code == SUCCESS_REQUEST) {
            BookModel *detailModel =(BookModel *)responseModel;
            if (detailModel) {
                wself.model =detailModel;
                [wself layoutLeftBottomButtonUI];
                
            }
        }else{
            [OMGToast showWithText:message];
        }
        
        [wself reloadDataEvent];
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [hud hideAnimated:YES];
        wself.isDetailNet =YES;
        [wself reloadDataEvent];
    }];
    
}

- (void)reloadDataEvent{
    if (self.isRecomNet && self.isDetailNet) {
        [self.tableView reloadData];
    }
}

#pragma mark-
#pragma mark action event
- (void)putBookEvent:(UIButton *)sender{
    
    [sender setEnabled:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initPutWithParameter:dic parameterId:[NSString stringWithFormat:@"%ld",self.model.bookId]] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        
        
        ///
        if (code == SUCCESS_REQUEST) {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_BOOKSHELF_ADDED object:nil];
            [OMGToast showWithText:@"成功加入书架"];
        }else{
            [OMGToast showWithText:message];
            [sender setEnabled:YES];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [sender setEnabled:YES];
    }];
    
}

- (void)readEvent:(UIButton *)sender{
    
    //继续阅读
    if (self.isComeFormeReader) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    
    /*+++++++++++++++本地文件及网络文件处理+++++++++++++++++++*/

    FileManager *fileManager =[FileManager getInstance];
    
    /// 首先获取已阅读章节数
    NSInteger idx =[Defaults integerForKey:[NSString stringWithFormat:@"Chapter_%ld",self.model.bookId]];
    if (!idx) {
        ///未获取到章节数时，从第一章开始阅读
        idx =1;
    }
    self.model.chapterNum =idx;
    
    ///（文件Path：Books/BookId/cNum.txt）
    NSString *filePath_ =[NSString stringWithFormat:@"Books/%ld/%ld.txt",self.model.bookId,self.model.chapterNum];
    
    [NetworkCollectCenter chapterCollect:self.model];
    
    if ([fileManager isFileExists:filePath_]) {
        
        //文件存在
        [self push];
        
    }else{
        ///获取文章内容
        [sender setEnabled:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor =[UIColor whiteColor];
        [hud showAnimated:YES];
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",self.model.bookId] forKey:@"bookId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",self.model.chapterNum] forKey:@"chapterNum"];
#if 0
        NSString *signature =[NSString new];
        NSString *secretKey = @"PaQhbHy3XbH";
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
        
        signature =[signature stringByAppendingString:[NSString stringWithFormat:@"%ld",self.model.bookId]];
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
                
                if (!bookDto.chapterNum) {
                    bookDto.chapterNum =wself.model.chapterNum;
                }
                wself.model.chapterNum =bookDto.chapterNum;
                wself.model.chapterName =bookDto.chapterName;
                
                ///文件路径
                NSString *filePath =[NSString stringWithFormat:@"Books/%ld",bookDto.bookId];
                ///文件夹路径
                NSString *fileDir =[NSString stringWithString: filePath];
                
                filePath =[filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld.txt",bookDto.chapterNum]];
                
                
                if (![fileManager isFileExists:fileDir]) {
                    ///本地文件夹不存在
                    if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                        ///重试创建本地文件夹
                        if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                            NSLog(@"创建文件夹失败");
                        }else{
                            ///创建文件夹成功
                            //写到文件中
                            NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                            
                            //if (![fileManager isFileExists:filePath]) {
                            
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                ///文件写入失败，重写文件
                                if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                    NSLog(@"写入文件失败");
                                }else{
                                    ///文件写入成功
                                    [self push];
                                }
                                
                            }else{
                                ///文件写入成功
                                [self push];
                            }
                            
                            //  }
                            
                        }
                        

                    }else{
                        ///创建文件夹成功
                        //写到文件中
                        NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                        
                        //if (![fileManager isFileExists:filePath]) {
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            ///文件写入失败，重写文件
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                NSLog(@"写入文件失败");
                            }else{
                                ///文件写入成功
                                [self push];
                            }
                            
                        }else{
                            ///文件写入成功
                            [self push];
                        }
                        
                        //  }
                        
                    }
                }else{
                    ///本地文件夹存在
                    //写到文件中
                    NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                    
                    //if (![fileManager isFileExists:filePath]) {
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            ///文件写入失败，重写文件
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                NSLog(@"写入文件失败");
                            }else{
                                ///文件写入成功
                                 [self push];
                            }
                            
                        }else{
                            ///文件写入成功
                            [self push];
                        }
                        
                  //  }
                    
                }
                
                
            }else{
                [OMGToast showWithText:message];
            }
            [sender setEnabled:YES];
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            [sender setEnabled:YES];
        }];
    }
   
}

//-(BOOL)showNavigation{
//    return YES;
//}


- (void)rightItemEvent{
    [self.view addSubview:self.shareView];
}

#pragma mark - HomeShareViewDelegate
- (void)homeShareView:(BookModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType{
    self.shareView =nil;
    switch (shareType) {
        case HomeShareViewWechat: //朋友圈
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case HomeShareViewWeixin: //微信好友
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case HomeShareViewMqMzone: //QQ空间
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case HomeShareViewQQ: //QQ
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case HomeShareViewSinaweibo: //微博
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
            break;
            
    }
}

#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  self.model.shareMsgVO.shareImg?self.model.shareMsgVO.shareImg:@"";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.shareMsgVO.shareTitle?self.model.shareMsgVO.shareTitle:@"" descr:self.model.shareMsgVO.shareContent?self.model.shareMsgVO.shareContent:@"" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.model.shareMsgVO.shareUrl?self.model.shareMsgVO.shareUrl:@"";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    __weak typeof(self) wself = self;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                

                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
//                //                分享埋点接口
//                /log/addOperateLog
//                参数：{
//                    "dataId": "6",  //数据ID  如书籍id
//                    "dataType": 1,  //数据类型  如书籍
//                    "operateType": 1 //操作类型。1=微信好友分享 11=微信朋友圈 12=qq 13=QQ空间 14=微博
//                }
                
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                dic[@"dataId"] =[NSString stringWithFormat:@"%ld",wself.model.bookId];
                dic[@"dataType"]=@"1";
                
                switch (resp.platformType) {
                    case UMSocialPlatformType_WechatSession:
                    {
                        dic[@"operateType"]=@"1";
                    }
                        break;
                    case UMSocialPlatformType_WechatTimeLine:
                    {
                        dic[@"operateType"]=@"11";
                    }
                        break;
                    case UMSocialPlatformType_QQ:
                    {
                        dic[@"operateType"]=@"12";
                    }
                        break;
                    case UMSocialPlatformType_Qzone:
                    {
                        dic[@"operateType"]=@"13";
                    }
                        break;
                    case UMSocialPlatformType_Sina:
                    {
                        dic[@"operateType"]=@"14";
                    }
                        break;
                        

                }
                
                
                [NetworkCollectCenter monitorLogAddLog:dic];
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
          
        }
    }];

}

#pragma mark - 折叠按钮点击代理
/**
 *  折叠按钮点击代理
 *
 *  @param cell 按钮所属cell
 */
-(void)clickFoldEvent:(BookDetailInfoCell *)cell{
    
   // NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    BookModel *model = self.model;
    
    model.isOpening = !model.isOpening;
  //  [self.tableView beginUpdates];
  //  [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       [wself.tableView reloadData];
    });
    
   // [self.tableView endUpdates];
    
//    __weak typeof(self) wself = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        wself.tableView.contentOffset=CGPointZero;
//    });
//
    
    NSLog(@"%lf",self.tableView.contentInset.top);
    //self.tableView.contentInset  = UIEdgeInsetsMake(0, 0, 64, 0);
    
    
}

- (void)push{
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    loginvctrl.model =self.model;
    [self.navigationController pushViewController:loginvctrl animated:YES];
//    [self.navigationController presentViewController:loginvctrl animated:NO completion:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
