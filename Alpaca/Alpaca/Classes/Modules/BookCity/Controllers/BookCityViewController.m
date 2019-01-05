//
//  BookCityViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCityViewController.h"
#import "MaleChannelViewController.h"
#import "FemaleChannelViewController.h"
#import "SearchViewController.h"
#import "BookCategoryViewController.h"
#import "BMSHelper.h"

static const CGFloat KMenuItemWidth = 64;
static const CGFloat KNavbarHeight  = 28;
static const CGFloat KProgressWidth  = 15;
static const CGFloat KProgressHeight  = 2;
static const CGFloat KTitleSizeSelected = 17;
static const CGFloat KTitleSizeNormal  = 17;

@interface BookCityViewController ()
@property (nonatomic, strong)NSArray *titleArr;

@end

@implementation BookCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelChange) name:PREFERENCE_START_NOTIF object:nil];
    [self layoutNavigationBar];
    [self initData];
    

}

- (void)channelChange{
    if ((int)[BMSHelper getChannel]==2) {
        self.selectIndex = 1;
    }else{
        self.selectIndex =0;
    }
}


- (void)layoutNavigationBar{
    if (self.fromFunctionType ==FromFunctionType_Category ||
        self.fromFunctionType ==FromFunctionType_Ranking) {
        [self navigationLeftItemWithImageName:@"back"];
    }else{
        [self navigationLeftItemWithImageName:@"search"];
    }
}

#pragma mark -
#pragma mark WMPageController 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = YES;
        self.titleColorSelected = HEX_COLOR(0x000000);
        self.titleColorNormal = HEX_COLOR(0x979FAC);
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.titleFontName =@"PingFangSC-Medium";
        self.titleSizeSelected = KTitleSizeSelected;
        self.titleSizeNormal = KTitleSizeNormal;
        
       // self.selectIndex = self.categoryType;
        self.progressWidth =KProgressWidth;
        self.progressHeight =KProgressHeight;
        
        self.menuItemWidth = KMenuItemWidth;
        self.scrollEnable =YES;
        //仿腾讯激萌效果
        self.progressViewIsNaughty = YES;
        
    }
    return self;
}


- (void)initData{
    
    self.titleArr =@[@"男频",@"女频"];
    if (self.categoryType == CategoryTypeStyle_Undefine) {
        
        if ((int)[BMSHelper getChannel]==2) {
            self.selectIndex = 1;
        }else{
            self.selectIndex =0;
        }
        
    }else if (self.categoryType ==CategoryTypeStyle_Male){
        self.selectIndex =0;
    }else if (self.categoryType ==CategoryTypeStyle_Female){
        self.selectIndex =1;
    }
    
    [self reloadData];

}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
   
    return self.titleArr.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
   
    return self.titleArr[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    if (self.fromFunctionType ==FromFunctionType_Category ||
        self.fromFunctionType ==FromFunctionType_Ranking) {
        
        BookCategoryViewController *bookCategory =[[BookCategoryViewController alloc] init];
        bookCategory.fromFunctionType =self.fromFunctionType;
        switch (index) {
            case 0:
            {
                bookCategory.categoryType =CategoryTypeStyle_Male;
            }
                break;
            case 1:
            {
                bookCategory.categoryType =CategoryTypeStyle_Female;
            }
                break;
        }
        
        return bookCategory;
        
    }else{
        MaleChannelViewController *maleChanner =[[MaleChannelViewController alloc] init];
        switch (index) {
            case 0:
            {
                maleChanner.categoryType =CategoryTypeStyle_Male;
            }
                break;
            case 1:
            {
                maleChanner.categoryType =CategoryTypeStyle_Female;
            }
                break;
        }
        
        return maleChanner;
    }
    
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat originY   = 0;
    CGFloat originX   = 15+20+15;
    return CGRectMake( originX, originY, KSCREEN_WIDTH-originX*2.0, KNavbarHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0,0  ,KSCREEN_WIDTH, KSCREEN_HEIGHT);
}



- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
        NSInteger index = [[info objectForKey:@"index"]integerValue];
    if (index == 0) {//男频
        [Defaults setInteger:1 forKey:CHANNEL];
        [Defaults synchronize];
        
    }else if (index==1) {//女频
        [Defaults setInteger:2 forKey:CHANNEL];
        [Defaults synchronize];
        
    }
    //    if (index == 0) {//关注
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"jcUpdateSelectDynamicData" object:nil];
    //    }
    //    else if (index == 1){//推荐
    //
    //        //点击了关注动态数据
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"jcUpdateFocusDynamicData" object:nil];
    //
    //    }
    
}

- (void)leftItemEvent{
    
    if (self.fromFunctionType ==FromFunctionType_Category ||
        self.fromFunctionType ==FromFunctionType_Ranking) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController pushViewController:SearchViewController.new animated:YES];
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
