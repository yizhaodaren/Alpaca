//
//  BSTabBarController.m
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


#import "BSTabBarController.h"
#import "BSNavigationController.h"
#import "BookcaseViewController.h"
#import "BookCityViewController.h"
#import "WelfareViewController.h"
#import "MineViewController.h"
#import "MaleChannelViewController.h"
#import "MOLAppStartRequest.h"
#import "MOLUpdateView.h"


@interface BSTabBarController ()
@property (nonatomic, weak) MOLUpdateView *updateView;  // 更新view
@end

@implementation BSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    //[self.tabBar setTranslucent:false];
//    [self initMainTab];
//    [self launch_checkVersionUpdate];
     [[UITabBar appearance] setTranslucent:NO];

}
#if 0
- (void)initMainTab{
    
    //试图数组
    NSArray* controllerArr = @[@"BookcaseViewController",@"BookCityViewController",@"WelfareViewController",@"MineViewController"];
    //标题数组
    NSArray* titleArr = @[@"Bookcase",@"BookCity",@"Welfare",@"Mine"];
    //图片数组
    NSArray* picArr = @[@"bookshelf",@"welfare",@"featured",@"user"];
    
   
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    for(int i=0; i<picArr.count; i++)
    {
        Class cl=NSClassFromString(controllerArr[i]);
        
        UIViewController* controller = [cl new];
        BSNavigationController *nv =[[BSNavigationController alloc] initWithRootViewController:controller];
        
        NSString *titleStr =titleArr[i];
        
        nv.tabBarItem.title =NSLocalizedString(titleStr, nil);
        nv.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时的图片
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时字体的颜色(也可更改字体大小)
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(0x19B898)} forState:UIControlStateSelected];
        
        [array addObject:nv];
        
    }
    self.viewControllers = array;
}

#pragma mark - Update
- (void)launch_checkVersionUpdate
{
    // 获取当前版本
    NSString *version = [STSystemHelper getApp_version];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platForm"] = @"iOS";
    dic[@"version"] = version;
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_versionCheckWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest *request, BSModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == SUCCESS_REQUEST) {
            NSDictionary *dic = request.responseObject[@"resBody"];
            // 跟新内容
            NSString *content = [dic mol_jsonString:@"content"];
            
            // 最新版本号
            NSString *ver_new = [dic mol_jsonString:@"version"];
            
            // 判断是否需要跟新
            if ([ver_new compare:version options:NSNumericSearch] == NSOrderedDescending) { // 需要更新
                
                BOOL forceUpdate = [dic mol_jsonBool:@"isImpose"];
                
                [self.updateView removeFromSuperview];
                MOLUpdateView *updateV = [[MOLUpdateView alloc] init];
                self.updateView = updateV;
                updateV.width = KSCREEN_WIDTH;
                updateV.height = KSCREEN_HEIGHT;
                [updateV showUpdateWithVersion:ver_new content:content force:forceUpdate];
                [[[[GlobalManager shareGlobalManager] global_rootViewControl] view] addSubview:updateV];
            }else{
                
            }
        }
    } failure:^(__kindof BSNetRequest *request) {
        
    }];
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
