//
//  E_MainReaderViewController.m
//  Alpaca
//
//  Created by apple on 2018/12/20.
//  Copyright © 2018 Moli. All rights reserved.
//

#import "E_MainReaderViewController.h"
#import "BookModel.h"
#import "E_ColorModel.h"
#import "E_CommonManager.h"
@interface E_MainReaderViewController ()

@property (nonatomic, strong)BookModel *model;

@property(nonatomic,strong)UIView  *bgView;
@property(nonatomic,strong)UILabel *authorLabel;
@property(nonatomic,strong)UILabel *bookNameLabel;
@property(nonatomic,strong)UIImageView *bookImageView;
@property(nonatomic,strong)UIImageView *bookShawImageView;
@property(nonatomic,strong)UIView  *shawView;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UILabel *detailLabel1;

@property (nonatomic, strong)E_ColorModel *eColorModel;
@end

@implementation E_MainReaderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithBook:(BookModel *)model{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self changeBgColer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changesTopBarColor:) name:@"CHANGE_TOPBAR_COLOR" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CircularProgressBarStop" object:nil];
    
}

// 改变主题
-(void)changeBgColer{
    self.eColorModel =[E_CommonManager Manager_getReadTheme];
    if (!self.eColorModel) {
        self.eColorModel =[E_ColorModel new];
    }
    
    

    if (self.eColorModel == nil || (self.eColorModel.colorType == E_ColorType_Hex) || (self.eColorModel.colorType == E_colorType_Night)) {
        if (self.eColorModel.colorD) {
            
            self.view.backgroundColor = [STSystemHelper colorWithHexString:self.eColorModel.colorD];
        }else{
            
            self.view.backgroundColor = [UIColor whiteColor];
        }
    }else{
        
        if ([self.eColorModel.colorD isEqualToString:@"E_niupizhi"]) {
            self.view.backgroundColor = [UIColor
                                                   colorWithPatternImage:[UIImage imageNamed:self.eColorModel.bigImage]];
        }else{
            self.view.backgroundColor = [STSystemHelper colorWithHexString:self.eColorModel.colorB];
        }
        
        
    }

    
}
- (void)changeColor{
    self.eColorModel =[E_CommonManager Manager_getReadTheme];
    if (self.eColorModel.colorType == E_colorType_Night) {//夜间模式
        [self nightColor];
    }else{//否则
        [self defineColor];
    }
}

-(void)initUI{
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView];
    
//作者
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.text = self.model.author ? self.model.author:@"";
    self.authorLabel.textColor = HEX_COLOR(0x363636);
    self.authorLabel.font = [UIFont systemFontOfSize:16];
    [self.bgView addSubview:self.authorLabel];
//书名
    self.bookNameLabel = [[UILabel alloc] init];
    self.bookNameLabel.text =   self.model.bookName ? self.model.bookName : @"";
    self.bookNameLabel.textColor = HEX_COLOR(0x363636);
    self.bookNameLabel.font =[UIFont fontWithName:@"PingFangSC-Medium" size:24];
    [self.bgView addSubview:self.bookNameLabel];
//书的图
    self.bookImageView = [[UIImageView alloc] init];

    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImage?self.model.coverImage:@""]];
    self.bookImageView.layer.borderWidth = 0.5;
    self.bookImageView.layer.borderColor = HEX_COLOR(0xF4F4F4).CGColor;
    self.bookNameLabel.numberOfLines  = 0;
    [self.bgView addSubview:self.bookImageView];
    
    self.bookShawImageView = [[UIImageView alloc] init];
    self.bookShawImageView.image = [UIImage imageNamed:@"book_shaw"];
    [self.bgView addSubview:self.bookShawImageView];
    
    
    self.shawView = [[UIView alloc] init];
    self.shawView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.shawView.hidden = YES;
    [self.bookImageView addSubview:self.shawView];
    
    
    
    self.detailLabel1 = [[UILabel alloc] init];
    self.detailLabel1.text = @"版权所有·侵权必究";
    self.detailLabel1.textColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3);
    self.detailLabel1.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.detailLabel1];
    
    
    self.detailLabel = [[UILabel alloc] init];
    
    //版权所有
    NSArray *arr =  [self.model.bookCopyRight componentsSeparatedByString:@"，"];
    NSString *copyRightStr = @"";
    if (arr.count > 1) {
       copyRightStr  = arr.firstObject;
    }
    self.detailLabel.text = copyRightStr;
    self.detailLabel.textColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3);
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.detailLabel];
    
    
    [self calculatorFrame];
    
    [self changeColor];
}
-(void)calculatorFrame{
    self.bgView.width = KSCREEN_WIDTH - 20;
    self.bgView.height = KSCREEN_HEIGHT - StatusBarHeight - TabbarSafeBottomMargin;
    self.bgView.x = 10;
    self.bgView.y = StatusBarHeight - 10;
    self.bgView.layer.cornerRadius = 0.3;
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3).CGColor;
    


   
    self.bookNameLabel.width = self.bgView.width - 46 * 2;
    [self.bookNameLabel sizeToFit];
    self.bookNameLabel.centerY = self.bgView.height/2;
    self.bookNameLabel.centerX = self.bgView.width/2;
    
    
    [self.authorLabel sizeToFit];
    self.authorLabel.centerX = self.bgView.width/2;
    self.authorLabel.top = self.bookNameLabel.bottom + 15;
   
    self.bookImageView.width = 116;
    self.bookImageView.height = 156;
    self.bookImageView.centerX = self.authorLabel.centerX;
    self.bookImageView.bottom = self.bookNameLabel.top - 15;
    
    self.bookShawImageView.width = 31;
    self.bookShawImageView.height = 156;
    self.bookShawImageView.right = self.bookImageView.left;
    self.bookShawImageView.bottom = self.bookImageView.bottom;
    
    self.shawView.frame = self.bookImageView.bounds;
  
    [self.detailLabel1 sizeToFit];
    self.detailLabel1.centerX = self.authorLabel.centerX;
    self.detailLabel1.bottom = self.bgView.height - 55;
    
    
    [self.detailLabel sizeToFit];
    self.detailLabel.centerX = self.authorLabel.centerX;
    self.detailLabel.bottom = self.detailLabel1.top - 10;
    

    
}

-(void)updateBook:(BookModel *)model{
    self.model = model;
    
    //版权所有
    NSArray *arr =  [self.model.bookCopyRight componentsSeparatedByString:@"，"];
    NSString *copyRightStr = @"";
    if (arr.count > 1) {
        copyRightStr  = arr.firstObject;
    }
    self.detailLabel.text = copyRightStr;
    
    //作者
    self.authorLabel.text = self.model.author ? self.model.author:@"";
    [self calculatorFrame];
}

- (void)changesTopBarColor:(NSNotification *)noti{
    if (noti.object && [noti.object isKindOfClass: [NSString class]]) {
        NSString *sender =(NSString *)noti.object;
        
        if (sender.length) {
            if ([sender isEqualToString:@"night"]) {//夜
                
                [self nightColor];
                
            }else{//默认
                [self defineColor];
                
            }
            
        }
        
        
    }
}
- (void)nightColor
{
    
    self.view.backgroundColor = [UIColor blackColor];
    self.detailLabel.textColor =  RGB_COLOR_ALPHA(255, 255, 255, 0.15);
    self.detailLabel1.textColor = RGB_COLOR_ALPHA(255, 255, 255, 0.15);
    self.bgView.layer.borderColor =  RGB_COLOR_ALPHA(255, 255, 255, 0.15).CGColor;
    self.shawView.hidden = NO;
    self.bookImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bookShawImageView.image = [UIImage imageNamed:@"book_shaw_Night"];
}

- (void)defineColor
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailLabel.textColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3);
    self.detailLabel1.textColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3);
    self.bgView.layer.borderColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3).CGColor;
    self.shawView.hidden = YES;
    self.bookImageView.layer.borderColor = HEX_COLOR(0xF4F4F4).CGColor;
    self.bookShawImageView.image = [UIImage imageNamed:@"book_shaw"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface MainBackViewController ()
@property (nonatomic, strong) UIImage *backgroundImage;
@end

@implementation MainBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [imageView setImage:_backgroundImage];
    [imageView setAlpha:0.9];
    [self.view addSubview:imageView];
}

- (void)updateWithViewController:(E_MainReaderViewController *)viewController {
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
