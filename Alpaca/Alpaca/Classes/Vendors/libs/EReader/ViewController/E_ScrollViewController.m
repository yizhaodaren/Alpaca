//
//  E_ScrollViewController.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ScrollViewController.h"
#import "E_MainReaderViewController.h"
#import "E_ReaderViewController.h"
#import "E_ReaderDataSource.h"
#import "E_EveryChapter.h"
#import "E_Paging.h"
#import "E_CommonManager.h"
#import "E_SettingTopBar.h"
#import "E_SettingBottomBar.h"
#import "E_ContantFile.h"
#import "E_DrawerView.h"
//#import "CDSideBarController.h"
#import "E_CommentViewController.h"
#import "E_WebViewControler.h"
#import "E_HUDView.h"
#import "BookModel.h"
#import "E_ColorModel.h"
#import "BookCatalogueViewController.h"
#import "BookcaseApi.h"
#import "BSTabBarController.h"
#import "CircularProgressBar.h"

#import "BookDetailViewController.h"
#import "WarnLoginView.h"
#import "LoginViewController.h"
#import "BSNavigationController.h"

#import "E_EndReaderViewController.h"


@interface E_ScrollViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,E_ReaderViewControllerDelegate,E_SettingTopBarDelegate,E_SettingBottomBarDelegate,E_DrawerViewDelegate,/*CDSideBarControllerDelegate,*/WarnLoginViewDelegate,CircularProgressBarDelegate,UIGestureRecognizerDelegate>
{
    UIPageViewController * _pageViewController;
    E_Paging             * _paginater;
    BOOL _isRight;       //翻页方向  yes为右 no为左

    UITapGestureRecognizer *tapGesRec;
    E_SettingTopBar *_settingToolBar;
    E_SettingBottomBar *_settingBottomBar;
    
    //CGFloat   _panStartY;
    UIImage  *_themeImage;
    E_ColorModel *_themeColor;
    
   // CDSideBarController *sideBar;
    dispatch_semaphore_t _semaphore;
    
}

@property (copy, nonatomic) NSString* chapterTitle_;
@property (copy, nonatomic) NSString* chapterContent_;
@property (assign, nonatomic) NSUInteger fontSize;
@property(nonatomic,assign)NSInteger  lineSpace;//行间距
@property (assign, nonatomic) NSUInteger readOffset;
@property (assign, nonatomic) NSInteger readPage;
@property (strong, nonatomic) UIColor *contentColor;
@property (assign, nonatomic) BOOL pageAnimationFinished;
@property (assign, nonatomic) NSUInteger wordSize;
@property (assign, nonatomic) BOOL isTurnOver; //yes跨章 No未跨章
@property (assign, nonatomic) BOOL turnOverData; //yes跨章有数据 No跨章无数据
@property (strong, nonatomic) UIView *verticalView; //垂直中心view
@property (strong, nonatomic) UIImageView *guidImageView; //第一次引导阅读视图
@property(nonatomic,strong)E_MainReaderViewController  *mainReaderVC;

@property(nonatomic,strong)CircularProgressBar *circleView;
@property(nonatomic,strong)WarnLoginView  *warnLoginView;
@property(nonatomic,weak)YYLabel *coinLable;
@property(nonatomic,assign)BOOL isCover; //YES 在封面 NO 不在封面
@property(nonatomic,assign)BOOL isScreen; //no 屏幕显示 yes 熄屏
@property(nonatomic,assign)BOOL isMoreThenReaderTime; //YES 超过最大阅读时间 NO 熄屏


@end


@implementation E_ScrollViewController

- (BOOL)showNavigation{
    return YES;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.view.backgroundColor = [UIColor clearColor];
//    }
//    return self;
//}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 0.0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 1.0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

  //  [self navigationLeftItemWithImageName:nil];
    
    _semaphore = dispatch_semaphore_create(1);
    
    [self getBookDetail];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    
    // app将进入到前台UIApplicationWillEnterForegroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:SUCCESS_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutEvent) name:SUCCESS_USER_LOGINOUT object:nil];
    
    /// 点击第几章节监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifToClickChapter:) name:READER_START_NOTIF object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNextCharacterNetData:) name:@"readTextData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changesTopBarColor:) name:@"CHANGE_TOPBAR_COLOR" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreThenMaxReaderTime) name:@"CircularProgressBarStop" object:nil];
    
    
    
    //设置章节相关信息
    ///设置总章节数
    [E_ReaderDataSource shareInstance].totalChapter = self.model.chapterCount;
    ///设置当前章节数
    [E_ReaderDataSource shareInstance].currentChapterIndex =self.model.chapterNum;
    
   ///预缓存左中右三章
    [self cacheChapterData:self.model];
   
    ///初始化设置预览过章节数
    [Defaults setInteger:self.model.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",self.model.bookId]];
    [Defaults synchronize];
    
    ///设置章节ID
    [Defaults setInteger:self.model.chapterId forKey:[NSString stringWithFormat:@"chapterID_%ld_%ld",self.model.bookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
    [Defaults synchronize];
    
    
    
    ///设置当前章节ID
    [E_ReaderDataSource shareInstance].currentChapterId =self.model.chapterId;
    ///设置当前书籍ID
    [E_ReaderDataSource shareInstance].currentBookId =self.model.bookId;
    
    NSLog(@"currentChapterId--->%ld",[E_ReaderDataSource shareInstance].currentChapterId);
    if (self.model.chapterName.length) {
        
        [E_ReaderDataSource shareInstance].currentChapterName =self.model.chapterName;
        
        //设置当前书籍章节名
        [Defaults setObject:self.model.chapterName forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,self.model.chapterNum]];
        [Defaults synchronize];
        
    }else{
        
        [E_ReaderDataSource shareInstance].currentChapterName =[Defaults objectForKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
        
    }
    
    
    
    
    
    ///初始化当前屏幕亮度
    [E_CommonManager saveBrightness:[[UIScreen mainScreen] brightness]];
    
    CGFloat e_Rightness =1.0;
    if (![E_CommonManager readBrightness]) {
        ///由于设置屏幕阅读亮度值为0.1 ~ 1.0 所以当为0时则表示未设置过阅读亮度，则获取屏幕亮度
        e_Rightness =[E_CommonManager brightness_];
    }else{
        ///获取书的屏幕亮度值
        e_Rightness =[E_CommonManager readBrightness];
    }
    
    ///设置屏幕亮度值
    [[UIScreen mainScreen] setBrightness: e_Rightness];
    
    
    
    ///用于设置阅读字体大小
    self.fontSize = [E_CommonManager fontSize];
    self.lineSpace = [E_CommonManager lineSpace];
    
    ///用于设置阅读字体颜色
    self.contentColor =[E_CommonManager contentColor];
    
    if (!self.contentColor) {
        NSLog(@"contentColor 对象为空");
    }
    

    self.pageAnimationFinished = YES;
    self.isTurnOver =NO;
    self.turnOverData =NO;
    
    
    ///阅读背景
    _themeColor = [E_CommonManager Manager_getReadTheme];
    
    
    ///章节实体
    E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] openChapter:self.model.chapterNum];
    
    [self parseChapter:chapter];
    
    [self initPageView:NO];
    
    
    
//    self.verticalView =[UIView new];
//    [self.verticalView setFrame:CGRectMake(KSCREEN_WIDTH/3.0, 0, KSCREEN_WIDTH/3.0, KSCREEN_HEIGHT)];
//
// //   [self.verticalView setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:self.verticalView];
    
    ///设置底部手势
    tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callToolBar)];
    tapGesRec.delegate =self;
    
    [self.view setTag:1001];
   
    [self.view addGestureRecognizer:tapGesRec];
    
    
    if (![Defaults boolForKey:ISFIRSTREAD]) {
        [Defaults setBool:YES forKey:ISFIRSTREAD];
        self.guidImageView =[UIImageView new];
        [self.guidImageView setUserInteractionEnabled:YES];
        [self.guidImageView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        [self.guidImageView setImage: [UIImage imageNamed:@"read_guide"]];
        
        UITapGestureRecognizer *guidTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guidEvent:)];
        [self.guidImageView addGestureRecognizer:guidTap];
        [self.view addSubview: self.guidImageView];
    }
    
    
    //  自绘圆中心设置
//    CircularProgressBar *circleView=[[CircularProgressBar alloc] initWithFrame:CGRectMake(self.view.right-16-20,self.view.bottom-12-20,20, 20)];
//    [circleView.layer setCornerRadius:10];
//    [circleView.layer setMasksToBounds:YES];
//    [circleView.startBtn setBackgroundImage:[UIImage imageNamed:@"circleA"] forState:UIControlStateNormal];
//    [circleView setDelegate:self];
//    self.circleView =circleView;
//    [circleView setUserInteractionEnabled:YES];
//    [circleView addCountTime:30];
    
    
//    [self timeStatusEvent];
    
//    UITapGestureRecognizer *coinTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coinTap)];
//    [circleView addGestureRecognizer:coinTap];
//    [self.view addSubview:circleView];
    [self.view addSubview:self.circleView];
    
    YYLabel *coinLable =[YYLabel new];
    [coinLable setTextColor:HEX_COLOR(0xF5A623)];
    [coinLable setFont:REGULAR_FONT(10)];
    [coinLable setTextAlignment:NSTextAlignmentRight];
    self.coinLable =coinLable;
    [coinLable setHidden:YES];
    if (![Defaults integerForKey:ISDEBUG]) {
        
        if (![[Defaults stringForKey:ISSHOWTIMERDAY] isEqualToString:[NSString yymmdd:@"YYYY-MM-dd"]]) {
            [coinLable setHidden:NO];
        }
        
    }
    [coinLable setFrame:CGRectMake(self.circleView.left-3-150,0,150,12)];
    [coinLable setCenterY: self.circleView.centerY];
    [self.view addSubview:coinLable];
    
}

- (CircularProgressBar *)circleView{
    if (!_circleView) {
        //  自绘圆中心设置
        _circleView=[[CircularProgressBar alloc] initWithFrame:CGRectMake(self.view.right-16-20,self.view.bottom-12-20,20, 20)];
        [_circleView.layer setCornerRadius:10];
        [_circleView.layer setMasksToBounds:YES];
        [_circleView.startBtn setBackgroundImage:[UIImage imageNamed:@"circleA"] forState:UIControlStateNormal];
        [_circleView setDelegate:self];
        [_circleView setAlpha:0];
        if (![Defaults integerForKey:ISDEBUG]) {
            
            if (![[Defaults stringForKey:ISSHOWTIMERDAY] isEqualToString:[NSString yymmdd:@"YYYY-MM-dd"]]) {
                [_circleView setAlpha:1];
            }
            
        }
        
        [_circleView setUserInteractionEnabled:YES];
        [_circleView addCountTime:30];
        
        
        [self timeStatusEvent];
        
        UITapGestureRecognizer *coinTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coinTap)];
        [_circleView addGestureRecognizer:coinTap];
    }
    return _circleView;
}


- (void)timeStatusEvent{
    
    //未登录、TopBar显示 每页超过最大时长  熄屏
    
    /// 计时器停止
    // 如果计时器正在计时 1. 未登录 || 2.TopBar显示 || 3.在封面 || 4.熄屏 || 5.每页超过最大时长后（最大时长 = 本页字数/最小速度）
    if (self.circleView.isAnimation) {
        if (![UserManagerInstance user_isLogin] ||
            _settingToolBar || self.isScreen ||
            self.isMoreThenReaderTime) {
            [self.circleView stopTimerAnimation];

        }
    }else{
        /// 计时器计时
        // 如果计时器未在计时 1.登录 && 2.TopBar隐藏 && 3.不在封面 && 4.不是熄屏状态 && 5.不是每页最大时长
        
        if ([UserManagerInstance user_isLogin] && !_settingToolBar && !self.isScreen && !self.isMoreThenReaderTime) {
            [self.circleView startTimerAnimation];
        }
        
    }
    
    
    
}



- (void)coinTap{
    if ([Defaults integerForKey:ISDEBUG]) {
        return;
    }
    if (![UserManagerInstance user_isLogin]) {//未登录
        [self.view addSubview:self.warnLoginView];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [win addSubview:self.warnLoginView];
    }
}

- (void)guidEvent:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        [self.guidImageView removeFromSuperview];
        self.guidImageView = nil;
    }];
}

- (void)callToolBar{
    
    if (_settingToolBar == nil) {
        _settingToolBar= [[E_SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
        //_settingToolBar.bookModel =self.model;
        [_settingToolBar contentEvent:self.model];
        [self.view addSubview:_settingToolBar];
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        
    }
    
    if (_settingBottomBar == nil) {
        _settingBottomBar = [[E_SettingBottomBar alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH,KTabbarHeight)];
        [self.view addSubview:_settingBottomBar];
        _settingBottomBar.chapterTotalPage = _paginater.pageCount;
        
        NSRange range =[_paginater rangeOfPage:_readPage];
        NSLog(@"%ld---%ld",range.location,range.length);
        _settingBottomBar.chapterCurrentPage = _readPage;
        _settingBottomBar.currentChapter = [E_ReaderDataSource shareInstance].currentChapterIndex;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        
    }
    
    
    [self timeStatusEvent];
}

- (void)initPageView:(BOOL)isFromMenu;
{
    if (_pageViewController) {
        //  NSLog(@"remove pageViewController");
        [_pageViewController.view removeFromSuperview];
        _pageViewController.view =nil;
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
        
    }
    
    
    
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    //是否双面显示，默认为NO

    _pageViewController.doubleSided = YES;

    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
//    [self.view bringSubviewToFront:self.verticalView];
    
    [self.view bringSubviewToFront:self.circleView];
   
    ///////////////////////////////
    NSArray *subviews = _pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    thisControl.hidden = true;
    ///////////////////////////////
    
    
    if (isFromMenu == YES) {
        [self showPage:0];
    }else{
        ///初始化设置预览过章节页数
        
        // NSUInteger beforePage = [[E_ReaderDataSource shareInstance] openPage];
        
        NSInteger beforePage =[Defaults integerForKey:[NSString stringWithFormat:@"Page_%ld",self.model.bookId]];
        
        
        //上次浏览的为第一页 且为第一章的时候
        if (beforePage == 0 && [E_ReaderDataSource shareInstance].currentChapterIndex == 1) {
            beforePage = -1;
        }
        [self showPage:beforePage];
    }
    
}

#pragma mark - readerVcDelegate
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    
//    if (yesOrNo == NO) {
//        _pageViewController.delegate = self;
//        _pageViewController.dataSource = self;
//    }else{
//        _pageViewController.delegate = nil;
//        _pageViewController.dataSource = nil;
//
//    }
}

- (void)ciBaWithString:(NSString *)ciBaString{
    
    E_WebViewControler *webView = [[E_WebViewControler alloc] initWithSelectString:ciBaString];
    [self presentViewController:webView animated:YES completion:NULL];
    
}


#pragma mark - 通知

- (void)moreThenMaxReaderTime{
    self.isMoreThenReaderTime =YES;
    
    [self timeStatusEvent];
}

- (void)appDidEnterBackground{
    self.isScreen =YES;
    
    [self timeStatusEvent];
}

- (void)appDidEnterForeground{
    self.isScreen =NO;
    
    [self timeStatusEvent];
}

- (void)login_success{
    typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       [wself timeStatusEvent];
    });
    
}

- (void)logOutEvent{
    
    [self timeStatusEvent];
}

#pragma mark 夜间模式的通知
- (void)changesTopBarColor:(NSNotification *)noti{
    if (noti.object && [noti.object isKindOfClass: [NSString class]]) {
        NSString *sender =(NSString *)noti.object;
        
        if (sender.length) {
            if ([sender isEqualToString:@"night"]) {//夜
                
                self.contentColor =HEX_COLOR_ALPHA(0xffffff,0.3);
                
            }else{//默认
                self.contentColor =HEX_COLOR_ALPHA(0x000000, 0.8);
                
            }
            
            if (!self.contentColor) {
                NSLog(@"contentColor 还是空");
            }
            
            [E_CommonManager saveContentColor:self.contentColor];
            
            
            [self readPositionRecord];
            
            if ([self isMainReader]) {
                return;
            }
            
            
            _paginater.contentFont = self.fontSize;
            [_paginater paginate];
            int showPage = [self findOffsetInNewPage:self.readOffset];
            [self showPage:showPage];
        }
        
    }
}
- (void)notifToClickChapter:(NSNotification *)notif{
    
    if (notif.object && [notif.object isKindOfClass:[BookModel class]]) {
        BookModel *dto =(BookModel *)notif.object;
        [E_ReaderDataSource shareInstance].currentBookId =dto.bookId;
        [E_ReaderDataSource shareInstance].currentChapterId =dto.chapterId;
        [E_ReaderDataSource shareInstance].currentChapterName =dto.chapterName;
        [E_ReaderDataSource shareInstance].currentChapterIndex =dto.chapterNum;
        NSLog(@"%@",[E_ReaderDataSource shareInstance].currentChapterName);
        
        /// 预缓存前三章数据 左中右
        [self cacheChapterData:dto];
        
        //设置当前书籍章节名
        [Defaults setObject:dto.chapterName forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
        [Defaults synchronize];
        
        [Defaults setInteger:dto.chapterId forKey:[NSString stringWithFormat:@"chapterID_%ld_%ld",dto.bookId,dto.chapterId]];
        [Defaults synchronize];
        
        E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] openChapter:dto.chapterNum];
        [self parseChapter:chapter];
        [self initPageView:YES];
    }
}

- (void)getNextCharacterNetData:(NSNotification *)notif{
    if (notif.object && [notif.object isKindOfClass:[NSNumber class]]) {
        NSNumber *number =(NSNumber *)notif.object;
        NSUInteger idx =number.unsignedLongValue;
        
        /*+++++++++++++++本地文件及网络文件处理+++++++++++++++++++*/
        //保存本地（文件Path：Books/BookId/cNum.txt）
        
        FileManager *fileManager =[FileManager getInstance];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor =[UIColor whiteColor];
        
        [hud showAnimated:YES];
        
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentBookId] forKey:@"bookId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",idx] forKey:@"chapterNum"];
        
#if 0
        NSString *signature =[NSString new];
        NSString *secretKey = @"PaQhbHy3XbH";
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)interval];
        
        signature =[signature stringByAppendingString:dic[@"bookId"]];
        signature =[signature stringByAppendingString:secretKey];
        signature =[signature stringByAppendingString:timestamp];
        signature =[signature mol_md5WithOrigin];
        
        [dic setObject:signature forKey:@"signature"];
        [dic setObject:timestamp forKey:@"timestamp"];
#endif
        
        __block BOOL runloop =YES;
        //加密规则=md5(bookId+X_SECRET_KEY+timestamp)
        __weak typeof(self) wself = self;
        [[[BookcaseApi alloc] initChapterInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
            
            [hud hideAnimated:YES];
            
            if (code == SUCCESS_REQUEST) {
                
                dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
                BookModel *bookDto =(BookModel *)responseModel;
                
            
                 //设置当前书籍章节名
                [E_ReaderDataSource shareInstance].currentChapterName =bookDto.chapterName;
                
                [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
                [Defaults synchronize];
                
                ///设置章节ID
                [E_ReaderDataSource shareInstance].currentChapterId=bookDto.chapterId;
    
                [Defaults setInteger:bookDto.chapterId forKey:[NSString stringWithFormat:@"chapterID_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
                [Defaults synchronize];
                
                [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
                [Defaults synchronize];
                
                dispatch_semaphore_signal(self->_semaphore);
                
                
                
                
                //                    [E_ReaderDataSource shareInstance].currentChapterId =bookDto.chapterId;
                //                    [E_ReaderDataSource shareInstance].currentBookId =bookDto.bookId;
                
                NSString *filePath =[NSString stringWithFormat:@"Books/%ld",bookDto.bookId];
                NSString *fileDir =[NSString stringWithString: filePath];
                
                filePath =[filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld.txt",bookDto.chapterNum]];
                
                if (![fileManager isFileExists:fileDir]) {
                    
                    if (![fileManager createDirectory: [fileManager fullFileName:fileDir]]) {
                        [fileManager createDirectory: [fileManager fullFileName:fileDir]];
                        // NSLog(@"创建文件夹失败");
                    }else{
                        ///创建文件夹成功
                        //写到文件中
                        NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                        
                        //if (![fileManager isFileExists:filePath]) {
                        
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            /// 写入文件失败，尝试重新写入
                            if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                                //                                    NSLog(@"写入文件失败");
                                
                            }else{
                                ///写入文件成功
                                //                                content = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
//                                dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
//                                [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                                [Defaults synchronize];
                                
//                                [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                                [Defaults synchronize];
//                                dispatch_semaphore_signal(self->_semaphore);
                            }
                            
                            
                        }else{
                            //写入文件成功
                            //                            content = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
//                            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
//                            [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                            [Defaults synchronize];
                            
//                            [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                            [Defaults synchronize];
//                            dispatch_semaphore_signal(self->_semaphore);
                            
                        }
                    }
                    
                }else{
                    
                    ///文件夹存在
                    //写到文件中
                    NSString *textContent =[NSString stringWithFormat:@"%@",bookDto.content];
                    
                    //if (![fileManager isFileExists:filePath]) {
                    
                    if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                        /// 写入文件失败，尝试重新写入
                        if (![textContent writeToFile:[fileManager fullFileName:filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
                            //                                    NSLog(@"写入文件失败");
                            
                        }else{
                            ///写入文件成功
                            //                            content = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
//                            dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
//                            [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                            [Defaults synchronize];
                            
//                            [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                            [Defaults synchronize];
//                            dispatch_semaphore_signal(self->_semaphore);
                        }
                        
                        
                    }else{
                        //写入文件成功
                        //                        content = [NSString stringWithContentsOfFile:[[FileManager getInstance] fullFileName:filePath] encoding:NSUTF8StringEncoding error:NULL];
                        
//                        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
//                        [Defaults setInteger:bookDto.chapterNum forKey:[NSString stringWithFormat:@"Chapter_%ld",bookDto.bookId]];
//                        [Defaults synchronize];
                        
//                        [Defaults setObject:bookDto.chapterName?bookDto.chapterName:@"" forKey:@"ChapterName"];
//                        [Defaults synchronize];
//                        dispatch_semaphore_signal(self->_semaphore);
                        
                    }
                    
                    //  }
                }
                
                
                 dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
                if (bookDto.chapterNum<=0) {
                    bookDto.chapterNum =1;
                }else if(bookDto.chapterNum>=2){
                    if ([Defaults boolForKey:DIRECTION]) {
                        //->
                        bookDto.chapterNum -=1;
                    }else{
                        //<-
                        bookDto.chapterNum +=1;
                    }
                    
                }
                
                [E_ReaderDataSource shareInstance].currentChapterIndex =bookDto.chapterNum;
                dispatch_semaphore_signal(self->_semaphore);
                
                
            }else{
                [OMGToast showWithText:message];
            }
            
            
            runloop =NO;
            
        } failure:^(__kindof BSNetRequest * _Nonnull request) {
            [hud hideAnimated:YES];
            runloop =NO;
            [OMGToast showWithText:@"网络不给力，请稍后重试"];
        }];
        
        
        
        
        //        while (runloop) {
        //            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        //        }
        
        NSLog(@"%ld",idx);
    }
}


- (void)getBookDetail{
    
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initBookDetailWithParameter:@{} parameterId:[NSString stringWithFormat:@"%ld",self.model.bookId]] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (code == SUCCESS_REQUEST) {
            BookModel *detailModel =(BookModel *)responseModel;
            if (detailModel) {
                
                wself.model.inShelf =detailModel.inShelf;
                wself.model.shareMsgVO =detailModel.shareMsgVO;
                
                [wself.mainReaderVC updateBook:detailModel];
                
                [self->_settingToolBar contentEvent:wself.model];
                
            }
        }else{
            
        }
        
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
    }];
    
}

//#pragma mark - 点击侧边栏目录跳转
//- (void)turnToClickChapter:(NSInteger)chapterIndex{
//
//    E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] openChapter:chapterIndex + 1];//加1 是因为indexPath.row从0 开始的
//    [self parseChapter:chapter];
//    [self initPageView:YES];
//
//}





#pragma mark - 隐藏设置bar
- (void)hideTheSettingBar{
    
    if (_settingToolBar == nil) {
        
    }else{
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
    }
    
    if (_settingBottomBar == nil) {
        
    }else{
        
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}


#pragma mark --
- (void)parseChapter:(E_EveryChapter *)chapter
{
    self.chapterContent_ = chapter.chapterContent;
    ///章节title未知
    // self.chapterTitle_ = chapter.chapterTitle;
    [self configPaginater];
}


- (void)configPaginater
{
    ///真正阅读模板
    _paginater = [[E_Paging alloc] init];
    
    ///模板字体大小
    _paginater.contentFont = self.fontSize;
    _paginater.lineSpace = self.lineSpace;
    _paginater.contentColor =self.contentColor;
    
    ///根据阅读器阅读view 获取阅读模板大小
    _paginater.textRenderSize =CGSizeMake(KSCREEN_WIDTH - 2 * offSet_x,KSCREEN_HEIGHT - offSet_y - 49 - 30);
    _paginater.contentText = self.chapterContent_;
    [_paginater paginate];
}

- (void)readPositionRecord
{
    if([self isMainReader]){
        return;
    }
    int currentPage = [_pageViewController.viewControllers.lastObject currentPage];
    NSRange range = [_paginater rangeOfPage:currentPage];
    self.readOffset = range.location;
}




#pragma mark - TopbarDelegate
-(void)gotoBookDetail{
    [self callToolBar];
    
    BookDetailViewController *bookDetail =[BookDetailViewController new];
    bookDetail.model =self.model;
    bookDetail.isComeFormeReader = YES;
    [self.navigationController pushViewController:bookDetail animated:YES];
}
- (void)backEvent{
    
    //    [E_CommonManager saveCurrentPage:self->_readPage];
    //    [E_CommonManager saveCurrentChapter:[E_ReaderDataSource shareInstance].currentChapterIndex];
    
    if (self.model.fromVC==100) {//来自书城
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BookcaseViewController" object:nil];
    }
    
    [Defaults setInteger:self->_readPage forKey:[NSString stringWithFormat:@"Page_%ld",self.model.bookId]];
    [Defaults synchronize];
    
    [Defaults setInteger:[E_ReaderDataSource shareInstance].currentChapterIndex forKey:[NSString stringWithFormat:@"Chapter_%ld",self.model.bookId]];
    [Defaults synchronize];
    
    [Defaults setObject:[E_ReaderDataSource shareInstance].currentChapterName forKey:[NSString stringWithFormat:@"Chapter_%ld_%ld",[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterIndex]];
    [Defaults synchronize];

    
    [E_CommonManager saveContentColor:self.contentColor];
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[UIScreen mainScreen] setBrightness:[E_CommonManager brightness_]];
        [wself.navigationController popViewControllerAnimated:YES];
        
//        [wself dismissViewControllerAnimated:YES completion:^{
//            [[UIScreen mainScreen] setBrightness:[E_CommonManager brightness_]];
//        }];
    });
    
}

- (void)goBack{
    
    if (self.model.inShelf) {
        [self backEvent];
        
    }else{
        
        if (self.model.isSystem) { //系统推荐
            [self backEvent];
            
        }else{//普通
            
            __weak typeof(self) wself = self;
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"加入书架" message:@"喜欢这本书就加入书架吧？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                
                [[[BookcaseApi alloc] initPutWithParameter:dic parameterId:[NSString stringWithFormat:@"%ld",(long)wself.model.bookId]] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
                    
                    if (code == SUCCESS_REQUEST) {
                        //
                        [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_BOOKSHELF_ADDED object:nil];
                        wself.model.inShelf =1;
                        [OMGToast showWithText:@"成功加入书架"];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself backEvent];
                    });
                    
                } failure:^(__kindof BSNetRequest * _Nonnull request) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself backEvent];
                    });
                    
                }];
                
            }];
            
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [wself backEvent];
            }];
            
            [alert addAction:confirm];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:^{}];
            
        }
    }
}




//#pragma mark - CDSideBarDelegate -- add by tiger-
//- (void)changeGestureRecognizers{
//
//    tapGesRec.enabled = YES;
//    for (int i = 0 ; i < _pageViewController.gestureRecognizers.count; i ++) {
//        UIGestureRecognizer *ges = (UIGestureRecognizer *)[_pageViewController.gestureRecognizers objectAtIndex:i];
//        ges.enabled = YES;
//    }
//}


#pragma mark - 底部左侧按钮触发事件---跳转到目录
- (void)callDrawerView{
    
    
    BookCatalogueViewController *catalogue =BookCatalogueViewController.new;
    catalogue.model =self.model;
    
    
    [self presentViewController:catalogue animated:YES completion:nil];
    
    
    [self callToolBar];
    
}




- (void)openTapGes{
    
    tapGesRec.enabled = YES;
}


/////////////////////////////////////////////////////////////////
#pragma mark - 修改亮度UI高度
- (void)lightEvent{//中间亮度实现
    _settingBottomBar.height =230+49;
    _settingBottomBar.y =KSCREEN_HEIGHT-_settingBottomBar.height;
    
}

#pragma mark - 修改右侧字体设置高度
- (void)fontEvent{ //右侧字体设置
    _settingBottomBar.height =58+49;
    _settingBottomBar.y =KSCREEN_HEIGHT-_settingBottomBar.height;
}

// //////////////////////////////////////////////////////////////////

#pragma mark - 字体改变
- (void)fontSizeChanged:(int)fontSize
{
    if([self isMainReader]){
        return;
    }
    [self readPositionRecord];
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    int showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage:showPage];
    
}
#pragma mark - 行间距改变
-(void)lineSapceChanged:(CGFloat)lineSpace{
    if([self isMainReader]){
        return;
    }
    [self readPositionRecord];
    self.lineSpace = lineSpace;
    _paginater.lineSpace = self.lineSpace;
    [_paginater paginate];
    int showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage:showPage];
}
#pragma mark - 改变主题
- (void)themeButtonAction:(id)myself themeColor:(E_ColorModel *)themeDto{
    
    _themeColor =themeDto;
    
    if ([self isMainReader]) {
        [(E_MainReaderViewController *)_pageViewController.viewControllers.lastObject changeBgColer];
        return;
    }
    
    
    [self showPage:self.readPage];
}

#pragma mark - 根据偏移值找到新的页码
- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset
{
    int pageCount = _paginater.pageCount;
    for (int i = 0; i < pageCount; i++) {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset) {
            return i;
        }
    }
    return 0;
}

//显示第几页
//- (void)showPage:(NSUInteger)page
- (void)showPage:(NSInteger)page
{
    
    if (page == -1) {
        [_pageViewController setViewControllers:@[self.mainReaderVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:^(BOOL f){
                                         
                                     }];
    }else{
    
    E_ReaderViewController *readerController = [self readerControllerWithPage:page];
    [_pageViewController setViewControllers:@[readerController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL f){
                                     
                                 }];
    }
}


- (E_ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    _readPage = page;
    E_ReaderViewController *textController = [[E_ReaderViewController alloc] init];
    textController.delegate = self;
    textController.themeBgImage = _themeImage;
    
    if (_themeColor == nil || (_themeColor.colorType == E_ColorType_Hex) || (_themeColor.colorType == E_colorType_Night)) {
        if (_themeColor.colorD) {
            
            textController.view.backgroundColor = [STSystemHelper colorWithHexString:_themeColor.colorD];
        }else{
            
            textController.view.backgroundColor = [UIColor whiteColor];
        }
    }else{
        
        if ([_themeColor.colorD isEqualToString:@"E_niupizhi"]) {
            textController.view.backgroundColor = [UIColor
                                                   colorWithPatternImage:[UIImage imageNamed:_themeColor.bigImage]];
        }else{
                textController.view.backgroundColor = [STSystemHelper colorWithHexString:_themeColor.colorB];
        }
        
      
    }
    
    
    //夜间模式或者E_black黑色背景时候设置不同字体颜色
    if (_themeColor.colorType == E_colorType_Night || [_themeColor.colorD isEqualToString:@"E_black"]) {//夜
       
        [textController statusNight];
        self.contentColor =HEX_COLOR_ALPHA(0xffffff,0.3);
        
    }else{//默认
        self.contentColor =HEX_COLOR_ALPHA(0x000000, 0.8);
        
    }

    
    
    [E_CommonManager saveContentColor:self.contentColor];
    
    [textController view];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    //textController.chapterTitle = self.chapterTitle_;
    textController.font = self.fontSize;
    textController.lineSpace = self.lineSpace;
    textController.contentColor =self.contentColor;
    textController.text = [_paginater stringOfPage:page];
    textController.chapterTitle = [E_ReaderDataSource shareInstance].currentChapterName;
    [textController totalPage:_paginater.pageCount currentPage:page];
    
    NSRange range =[_paginater rangeOfPage:page];
    if (range.length) {
        textController.wordSize =range.length;
    }
    
    
    if (_settingBottomBar) {
        
        float currentPage = [[NSString stringWithFormat:@"%ld",_readPage] floatValue] + 1;
        float totalPage = [[NSString stringWithFormat:@"%ld",textController.totalPage] floatValue];
        
        float percent;
        if (currentPage == 1) {//强行放置头部
            percent = 0;
        }else{
            percent = currentPage/totalPage;
        }
        
        [_settingBottomBar changeSliderRatioNum:percent];
    }
    
    return textController;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPageViewDataSource And UIPageViewDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
 
    if (self.pageAnimationFinished) {
        if ([viewController isKindOfClass:[E_ReaderViewController class]]) {
            
            E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
            NSUInteger currentPage = reader.currentPage;
            
            
            //如果是第1章第一页 返回到
            if ([E_ReaderDataSource shareInstance].currentChapterIndex == 1 && currentPage ==0) {
                //否则返回主页背面控制器
                MainBackViewController *backViewController = [MainBackViewController new];
                [backViewController updateWithViewController:(id)self.mainReaderVC];
                return backViewController;
            }
            
            if (currentPage <= 0) {
                
                self.isTurnOver =YES;
                
                E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] preChapter];
                
                if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""]) {
                    self.pageAnimationFinished =YES;
                    self.turnOverData =NO;
                    return  nil;
                    
                }else{
                    self.turnOverData =YES;
                }
                
                [self parseChapter:chapter];
                currentPage = self.lastPage + 1;
                
                
            }else{
                self.isTurnOver =NO;
            }
            
            //否则返回背面视图
            BackViewController *backViewController = [BackViewController new];
            [backViewController updateWithViewController:[self readerControllerWithPage:currentPage - 1]];
            return backViewController;
            
        }else if([viewController isKindOfClass: [MainBackViewController class]]){
            
            return self.mainReaderVC;
        }else if([viewController isKindOfClass: [E_MainReaderViewController class]]){
            
            return nil;
        }else{
            
            if (self.isTurnOver) {
                if (!self.turnOverData) {
                    return nil;
                }
            }
            self.isMoreThenReaderTime =NO;
            
            [self timeStatusEvent];
            return [(id)viewController currentViewController];
            
        }
        

        
    }else{
        self.pageAnimationFinished =YES;
        return nil;
    }
    
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{

    if (self.pageAnimationFinished) {
        //动画已完成
        if ([viewController isKindOfClass: [E_ReaderViewController class]]) {
            ///反面
            /// 获取当前阅读器翻转页数
            E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
            NSUInteger currentPage = reader.currentPage;
            
           
            if (currentPage >= self.lastPage) {
                /// 当前页为最后一页
                //获取下一章节数据
                self.isTurnOver =YES;
                self.turnOverData =YES;
                E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
                
                if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""]) {
                    //未获取到章节信息
                    //设置动画为结束
                    //返回滑动控制器为nil
                    self.pageAnimationFinished =YES;
                    self.turnOverData =NO;
                    
                    NSUInteger index =[E_ReaderDataSource shareInstance].currentChapterIndex;
                    NSUInteger totalChapter =[E_ReaderDataSource shareInstance].totalChapter;
                    
                    if (index >= totalChapter) {
                        E_EndReaderViewController *end = [[E_EndReaderViewController alloc] init];
                        [end setTopWithModel:self.model];
                        [self.navigationController pushViewController:end animated:YES];
                    }
                
                    return nil;
                }
                
                [self parseChapter:chapter];
                
            }else{
                
                self.isTurnOver =NO;
                
            }
            
            //否则返回背面控制器
            BackViewController *backViewController = [BackViewController new];
            [backViewController updateWithViewController:(id)viewController];
            return backViewController;
            
        }else if([viewController isKindOfClass: [E_MainReaderViewController class]]){
    
            //否则返回主页背面控制器
            MainBackViewController *backViewController = [MainBackViewController new];
            [backViewController updateWithViewController:(id)self.mainReaderVC];
            return backViewController;
        }else if([viewController isKindOfClass: [MainBackViewController class]]){
            
            //否则返回主页背面控制器
            ///返回阅读器
            E_ReaderViewController *textController = [self readerControllerWithPage:0];
            self.isMoreThenReaderTime =NO;
            
            [self timeStatusEvent];
            return textController;
        }else{
            ///正面
            ///返回阅读器
            ///表示无正面页则展示下个正面页
            E_ReaderViewController *_reader = (E_ReaderViewController *)[(id)viewController currentViewController];
            NSUInteger currentPage =_reader.currentPage;
            
                if (self.isTurnOver) { //表示跨章
                     currentPage = -1;
                    if (!self.turnOverData) { //表示跨章节无数据返回nil
                        return nil;
                    }
                }
            
            ///返回阅读器
            self.isMoreThenReaderTime =NO;
            
            [self timeStatusEvent];
            E_ReaderViewController *textController = [self readerControllerWithPage:currentPage + 1];
            return textController;
            
        }
        
        
    }else{
        //动画未完成，正在动画
        self.pageAnimationFinished =YES;
        return nil;
    }
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{

    self.pageAnimationFinished = NO;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{

    self.pageAnimationFinished = YES;

    if (completed) {
        //翻页完成
        if (_settingToolBar) {
           [self  callToolBar];
        }
        
        
    }else{ //翻页未完成 又回来了。
    
#warning 暂时屏蔽，未发现问题
#if 0
        if (_isTurnOver && !_isRight) {//往右翻 且正好跨章节
            
            E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
            [self parseChapter:chapter];
            
        }else if(_isTurnOver && _isRight){//往左翻 且正好跨章节
            
            E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] preChapter];
            [self parseChapter:chapter];
            
        }
#endif
        
    }

    
}

- (NSUInteger)lastPage
{
    return _paginater.pageCount - 1;
}

#pragma mark-
#pragma mark 预缓存章节数据 左中右
- (void)cacheChapterData:(BookModel *)model{
    
    NSUInteger index =self.model.chapterNum;
    NSUInteger nextIndex =index;
    NSUInteger upIndex =index;
    
    if (index <=1) { //表示第一章
        nextIndex ++;
        for (NSInteger i= nextIndex; i<=2; i++) { //表示获取下下章节数据
            NSString *nextFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",self.model.bookId,i];
            
            if (![[FileManager getInstance] isFileExists:nextFilePath]) {
                [NetworkCollectCenter getChapterDataWithBookId:self.model.bookId chapterNum:i];
            }
        }
        
    }else if(index >= ([E_ReaderDataSource shareInstance].totalChapter)){ //表示最后一章
        upIndex--;
        for (NSInteger i= upIndex; i >= index-2; i--) { //表示获取下下章节数据
            NSString *upFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,i];
            
            if (![[FileManager getInstance] isFileExists:upFilePath]) {
                
                [NetworkCollectCenter getChapterDataWithBookId:self.model.bookId chapterNum:i];
            }
            
        }
        
    }else{ //表示其它章节
        upIndex--;
        nextIndex++;
        
        NSString *upFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,upIndex];
        
        if (![[FileManager getInstance] isFileExists:upFilePath]) {
            [NetworkCollectCenter getChapterDataWithBookId:self.model.bookId chapterNum:upIndex];
        }
        
        NSString *nextFilePath =[NSString stringWithFormat:@"Books/%ld/%ld.txt",[E_ReaderDataSource shareInstance].currentBookId,nextIndex];
        
        if (![[FileManager getInstance] isFileExists:nextFilePath]) {
            [NetworkCollectCenter getChapterDataWithBookId:self.model.bookId chapterNum:nextIndex];
        }
    }

}


- (void)dealloc{
    self.circleView.delegate =nil;
    [self.circleView stopTimerAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if    !OS_OBJECT_USE_OBJC
    dispatch_release(_semaphore);
#endif
}
-(E_MainReaderViewController *)mainReaderVC{
    if (!_mainReaderVC) {
        _mainReaderVC =  [[E_MainReaderViewController alloc] initWithBook:self.model];
        
    }
    return _mainReaderVC;
}

//当前是否是封面
-(BOOL)isMainReader{
    return  [_pageViewController.viewControllers.lastObject isKindOfClass:[E_MainReaderViewController class]];
}

- (WarnLoginView *)warnLoginView{
    if (!_warnLoginView) {
        _warnLoginView =[[WarnLoginView alloc] init];
        [_warnLoginView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        _warnLoginView.delegate =self;
        
    }
    return _warnLoginView;
}
-(void)WarnLoginViewCloseEvent:(WarnLoginView *)view{
    [view removeFromSuperview];
}
-(void)WarnLoginViewlogin:(WarnLoginView *)view{
    [view removeFromSuperview];
    
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:vc];
    
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //转场模态效果
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark CircularProgressBarDelegate
- (void)responseCircularEventCoin{
    [self updateReadInfo:30];
}

#pragma mark -统计阅读时长
- (void)updateReadInfo:(NSInteger)time{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"bookId"] =[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentBookId];
    dic[@"chapterId"] =[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentChapterId];
    dic[@"readTime"] =[NSString stringWithFormat:@"%ld",(NSInteger)time];
    
    
    __weak typeof(self) wself = self;
    [[[BookcaseApi alloc] initReadUpdateReadInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        if (code == SUCCESS_REQUEST) {
            
            NSInteger coin =[request.responseObject[@"resBody"][@"coin"] integerValue];
            NSInteger timeSign =[request.responseObject[@"resBody"][@"timeSign"] integerValue];
            
            if (timeSign) {//
                
                if (![Defaults integerForKey:ISDEBUG]) {
                    [wself.circleView setHidden:YES];
                    [wself.coinLable setHidden:YES];
                }
    
                
                [Defaults setObject:[NSString yymmdd:@"YYYY-MM-dd"] forKey:ISSHOWTIMERDAY];
                [Defaults synchronize];
                
            }else{
                
                if (![[Defaults stringForKey:ISSHOWTIMERDAY] isEqualToString:[NSString yymmdd:@"YYYY-MM-dd"]]) {
                    if (![Defaults integerForKey:ISDEBUG]) {
                        [wself.circleView setHidden:NO];
                        [wself.coinLable setHidden:NO];
                    }
                    
                }
                
                
            }
           
            if (coin && !timeSign) {
                [wself.coinLable setText:[NSString stringWithFormat:@"+%ld金币",coin]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself.coinLable setAlpha:1];
                });
                
                [UIView animateWithDuration:3.0 animations:^{
                    
                    wself.coinLable.y =wself.coinLable.y-50;
                    
                } completion:^(BOOL finished) {
                    [wself.coinLable setAlpha:0];
                    wself.coinLable.y =wself.coinLable.y+50;
                    
                }];
            }

            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Touch gestures below top bar should not make the page turn.
    //EDITED Check for only Tap here instead.
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        CGPoint touchPoint = [touch locationInView:self.view];
       
        if (touchPoint.x < (KSCREEN_WIDTH / 3.0)  || touchPoint.x > (2.0*KSCREEN_WIDTH /3.0 )) {//Let the buttons in the middle of the top bar receive the touch
            return NO;
        }
    }
    return YES;
}

@end
