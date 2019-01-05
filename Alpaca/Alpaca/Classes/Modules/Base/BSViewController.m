//
//  BSViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/15.
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



#import "BSViewController.h"

@interface BSViewController ()<UINavigationControllerDelegate>

@end

@implementation BSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    [self layoutBaseNavigationBar];
    [self layoutBaseUI];
}

- (void)layoutBaseNavigationBar{
    
}

- (void)layoutBaseUI{
    [self.view setBackgroundColor: HEX_COLOR(0xffffff)];
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)navigationLeftItemWithImageName:(NSString *)leftImageName{
    
    [self navigationLeftItemWithImageName:leftImageName centerTitle:nil titleColor:nil];
    
}

- (void)navigationLeftItemWithImageName:(NSString *)leftImageName centerTitle:(NSString *)title titleColor:(UIColor *)color{
    [self navigationLeftItemWithImageName:leftImageName centerTitle:title titleColor:color rightItemImageName:nil];
}

- (void)navigationLeftItemWithImageName:(NSString *)leftImageName centerTitle:(NSString *)title titleColor:(UIColor *)color rightItemImageName:(NSString *)rightImageName{
    
    [self navigationLeftItemWithImageName:leftImageName centerTitle:title titleColor:color rightItemImageName:rightImageName rightItemColor:nil];
    
    
    
}

- (void)navigationLeftItemWithImageName:(NSString *)leftImageName centerTitle:(NSString *)title titleColor:(UIColor *)color rightItemImageName:(NSString *)rightImageName rightItemColor:(UIColor *)rightColor{
    
    if (leftImageName.length) {
        
        UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftItemEvent) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItemC =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
        leftItemC.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:leftImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemEvent)];
        
        
    
        
        self.navigationItem.leftBarButtonItem = leftItemC;
        
    }
    
    if (title.length) {
        self.navigationItem.title = title;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:REGULAR_FONT(17)}];
    }
    
    if (rightImageName.length) {
        
        
        UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
        
        UIBarButtonItem *rightItem ;
        
        if (!rightColor) {
            rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:rightImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemEvent)];
        }else{
            
            [leftButton setTitle:rightImageName forState:UIControlStateNormal];
            [leftButton setTitleColor:rightColor forState:UIControlStateNormal];
            [leftButton.titleLabel setFont:REGULAR_FONT(15)];
            [leftButton addTarget:self action:@selector(rightItemEvent) forControlEvents:UIControlEventTouchUpInside];
            rightItem =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
            
        }
        
        if (rightItem) {
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
    }
    
}

// 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BSViewController *v = (BSViewController *)viewController;
    BOOL isHidden = NO;
    if (v.showNavigation) {
        isHidden = YES;
    }
    [viewController.navigationController setNavigationBarHidden:isHidden animated:YES];
}

- (void)leftItemEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemEvent{
    
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
