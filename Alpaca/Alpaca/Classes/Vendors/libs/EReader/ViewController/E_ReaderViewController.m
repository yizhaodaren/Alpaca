//
//  E_ReaderViewController.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderViewController.h"
#import "E_ReaderView.h"
#import "E_CommonManager.h"
#import "E_ReaderDataSource.h"
#import "BookcaseApi.h"
#import "BatteryView.h"
#import "E_ColorModel.h"


#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface E_ReaderViewController ()<E_ReaderViewDelegate>
{
    E_ReaderView *_readerView;
}

@property (nonatomic, strong)NSDate *upDate;
@property (nonatomic, weak)YYLabel *chapterL;
@property (nonatomic, weak)YYLabel *pageShow;
@property(nonatomic, strong)UILabel  *TitleLabel;
@property (nonatomic, weak)BatteryView *batteryView;
@property (nonatomic, weak)YYLabel *timeLable;
@property (nonatomic, strong)E_ColorModel *themeID;
@property (nonatomic, weak)NSTimer *timer;


@end

@implementation E_ReaderViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changesTopBarColor:) name:@"CHANGE_TOPBAR_COLOR" object:nil];
    
    self.themeID =[E_ColorModel new];
    self.themeID =[E_CommonManager Manager_getReadTheme];
    if (!self.themeID) {
        self.themeID =[E_ColorModel new];
    }

    _readerView = [[E_ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y + 20, self.view.frame.size.width - 2 * offSet_x, self.view.frame.size.height - offSet_y - 44 - 30)];
    _readerView.keyWord = _keyWord;
    _readerView.magnifiterImage = _themeBgImage;
    _readerView.delegate = self;
    
    [_readerView setBackgroundColor: [UIColor clearColor]];
    [self.view addSubview:_readerView];
    

    YYLabel *chapterL =[YYLabel new];
    [chapterL setFont:REGULAR_FONT(11)];
    [chapterL setText: self.chapterTitle?self.chapterTitle:@""];
    self.chapterL =chapterL;
    [chapterL setFrame:CGRectMake(16, 20, KSCREEN_WIDTH-16*2.0, 16)];
   // [chapterL setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:chapterL];
    

    
    YYLabel *pageShow =[YYLabel new];
    //[pageShow setTextColor: HEX_COLOR_ALPHA(0x000000, 0.3)];
    [pageShow setFont:REGULAR_FONT(11)];
   
    self.pageShow =pageShow;
    [pageShow setTextAlignment:NSTextAlignmentRight];
//    [pageShow setFrame:CGRectMake(kScreenW-16-200, self.view.bottom-30, 200, 16)];
    [pageShow setFrame:CGRectMake(kScreenW-16-200, 20, 200, 16)];
    
    [self.view addSubview:pageShow];
    
    self.TitleLabel = [[UILabel alloc] init];
    self.TitleLabel.frame = CGRectMake(0, 20 + 25, kScreenW, 40);
    self.TitleLabel.font =[UIFont fontWithName:@"PingFangSC-Medium" size:25];
    self.TitleLabel.textColor = RGB_COLOR_ALPHA(0, 0, 0, 0.8);
    self.TitleLabel.textAlignment = NSTextAlignmentCenter;
  //  [self.view addSubview:self.TitleLabel];
    
    YYLabel *timeLable =[YYLabel new];
    [timeLable setFrame:CGRectMake(16, self.view.bottom-30,30, 16)];
    [timeLable setText: [NSString currentTime]];
//    [timeLable setTextColor: HEX_COLOR_ALPHA(0x000000, 0.3)];
    [timeLable setFont:REGULAR_FONT(11)];
    self.timeLable =timeLable;
    [timeLable sizeToFit];
    [self.view addSubview:timeLable];
    
    BatteryView *batterView =[[BatteryView alloc] initWithFrame:CGRectMake(timeLable.right+5,timeLable.top, 25, 12)];
    [batterView setCenterY: timeLable.centerY];
    self.batteryView =batterView;

//    [batterView setBatteryValue: [STSystemHelper getCurrentBatteryLevel]];
      [batterView setBatteryValue: [STSystemHelper getBatteryQuantity]];
    [self.view addSubview: batterView];
    

    if (self.themeID.colorType == E_colorType_Night) {
        [self statusNight];
    }else{
        [self statusLight];
    }
}


#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo{
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
}

- (void)ciBa:(NSString *)ciBaString{

    [_delegate ciBaWithString:ciBaString];
}

- (void)hideSettingToolBar{
    [_delegate hideTheSettingBar];
}

- (void)setContentColor:(UIColor *)contentColor{
    _readerView.contentColor =contentColor;
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

-(void)setLineSpace:(CGFloat)lineSpace{
    _readerView.lineSpce = lineSpace;
}
- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
   
    [_readerView render];
}

- (NSUInteger )font
{
    return _readerView.font;
}

- (void)setChapterTitle:(NSString *)chapterTitle{
    _chapterTitle =chapterTitle;
    [self.chapterL setText: chapterTitle?chapterTitle:@""];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    self.timer =timer;
    
    self.upDate =[NSDate date];
  //  NSLog(@"viewDidAppear :%@---%ld",self,[E_ReaderDataSource shareInstance].currentChapterIndex);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self dTimer];
    
//    NSTimeInterval timeI=[[NSDate date] timeIntervalSinceDate:self.upDate];
//    NSInteger time =(NSInteger)timeI;
//
//    NSInteger maxSpeed =[Defaults integerForKey:READMAXSPEED];
//    if (!maxSpeed) {
//        maxSpeed =1500;
//    }
//
//    NSInteger minSpeed =[Defaults integerForKey:READMINSPEED];
//    if (!minSpeed) {
//        minSpeed =200;
//    }
//
//    NSInteger wordLength =self.wordSize;
//
//    if (!wordLength) {
//        wordLength =300;
//    }
//
//    NSInteger maxTime =(wordLength/(minSpeed/60));
//    NSInteger minTime =(wordLength/(maxSpeed/60));
//
//
//    if (time >= minTime) {
//        if (time > maxTime) {
//            time =maxTime;
//        }
//         [self updateReadInfo:time];
//    }
    
    
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    

    if (self.currentPage == 0) {
        _readerView.frame = CGRectMake(offSet_x, offSet_y + 20 + 30, self.view.frame.size.width - 2 * offSet_x, self.view.frame.size.height - offSet_y - 44 - 30);
        self.TitleLabel.text = self.chapterTitle?self.chapterTitle:@"";
    }
    
    [super viewWillAppear:animated];
    
   // NSLog(@"viewWillAppear :%@---%ld",self,[E_ReaderDataSource shareInstance].currentChapterIndex);
//    self.upDate =[NSDate date];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // NSLog(@"viewWillDisappear :%@---%ld---%ld",self,[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterId);
//   // [self updateReadInfo];
//
//    NSLog(@"%ld---%ld",[NSDate date],self.upDate);
//    NSTimeInterval timeI=[[NSDate date] timeIntervalSinceDate:self.upDate];
//    NSLog(@"viewWillDisappear :%@---%ld---%ld---%ld",self,[E_ReaderDataSource shareInstance].currentBookId,[E_ReaderDataSource shareInstance].currentChapterId,timeI);
//
}

#pragma mark -统计阅读时长
- (void)updateReadInfo:(NSInteger)time{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"bookId"] =[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentBookId];
    dic[@"chapterId"] =[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentChapterId];
    dic[@"readTime"] =[NSString stringWithFormat:@"%ld",(NSInteger)time];
    

    
    [[[BookcaseApi alloc] initReadUpdateReadInfoWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        if (code == SUCCESS_REQUEST) {
            
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
    
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}

- (void)totalPage:(NSUInteger)total currentPage:(NSUInteger)page{
    NSUInteger totalPage =total;
    NSUInteger currentpage =page;
    if (!totalPage) {
        return;
    }
    currentpage +=1;
    if (currentpage>totalPage) {
        currentpage =totalPage;
    }
    [self.pageShow setText:[NSString stringWithFormat:@"%ld/%ld",currentpage,totalPage]];
}

#pragma mark-
#pragma mark NSNotification
- (void)changesTopBarColor:(NSNotification *)noti{
    if (noti.object && [noti.object isKindOfClass: [NSString class]]) {
        NSString *sender =(NSString *)noti.object;
        
        if (sender.length) {
            if ([sender isEqualToString:@"night"]) {//夜
                
            }else{//默认
                
            }
        }
        
        
    }
}

- (void)statusNight{
    [self.chapterL setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.3)];
    [self.pageShow setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.3)];
    [self.timeLable setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.3)];
    self.TitleLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.5);
}

- (void)statusLight{
    [self.chapterL setTextColor: HEX_COLOR_ALPHA(0x000000, 0.3)];
    [self.pageShow setTextColor: HEX_COLOR_ALPHA(0x000000, 0.3)];
    [self.timeLable setTextColor: HEX_COLOR_ALPHA(0x000000, 0.3)];
    self.TitleLabel.textColor = [UIColor blackColor];
}

- (void)timerEvent{
    NSTimeInterval timeI=[[NSDate date] timeIntervalSinceDate:self.upDate];
    NSInteger time =(NSInteger)timeI;
    
//    NSInteger maxSpeed =[Defaults integerForKey:READMAXSPEED];
//    if (!maxSpeed) {
//        maxSpeed =1500;
//    }
    
    NSInteger minSpeed =[Defaults integerForKey:READMINSPEED];
    if (!minSpeed) {
        minSpeed =200;
    }
    
    NSInteger wordLength =self.wordSize;
    
    if (!wordLength) {
        wordLength =300;
    }
    
    NSInteger maxTime =(wordLength/(minSpeed/60));
   // NSInteger minTime =(wordLength/(maxSpeed/60));
    if (time>maxTime) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CircularProgressBarStop" object:nil];
        [self dTimer];
    }
}

- (void)dTimer{
    [self.timer invalidate];
    self.timer =nil;
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGE_TOPBAR_COLOR" object:nil];
    [self dTimer];
}


@end


@interface BackViewController ()
@property (nonatomic, strong) UIImage *backgroundImage;
@end

@implementation BackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [imageView setImage:_backgroundImage];
    [imageView setAlpha:0.9];
    [self.view addSubview:imageView];
}

- (void)updateWithViewController:(E_ReaderViewController *)viewController {
    self.backgroundImage = [self captureView:viewController.view];
    self.currentViewController = viewController;
}

- (UIImage *)captureView:(UIView *)view {
    CGSize size = view.bounds.size;
    CGAffineTransform transform = CGAffineTransformMake(-1,0,0,1,size.width,0);
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
