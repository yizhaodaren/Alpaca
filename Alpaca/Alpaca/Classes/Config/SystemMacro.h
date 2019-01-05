//
//  SystemMacro.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
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


#ifndef SystemMacro_h
#define SystemMacro_h

//****************************** 系统 ***************************** //
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS11 (SYSTEM_VERSION >= 11.0)?YES:NO
#define iOS10 (SYSTEM_VERSION >= 10.0)?YES:NO
#define iOS9 (SYSTEM_VERSION >= 9.0)?YES:NO
#define iOS8 (SYSTEM_VERSION >= 8.0)?YES:NO
#define iOS7 (SYSTEM_VERSION >= 7.0)?YES:NO
#define iOS6 (SYSTEM_VERSION >= 6.0)?YES:NO

//****************************** 设备类型 ***************************** //
#define iPhoneX   ((KSCREEN_HEIGHT>=812)?YES:NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iTouch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ((KSCREEN_WIDTH==414)?YES:NO)
#define iPhone6   ((KSCREEN_WIDTH==375)?YES:NO)
#define iPhone320 ((KSCREEN_WIDTH==320)?YES:NO)
#define iPhone4 ((KSCREEN_HEIGHT==480)?YES:NO)


//****************************** 屏幕 ***************************** //
// 尺寸适配
#define KSCREEN_ADAPTER(w) lrintf(1.0*KSCREEN_WIDTH/375.0f*(w))
//屏幕宽度
#define KSCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define KSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
// 比例
#define KSCREEN_SCALE      ([UIScreen mainScreen].scale)
//适配（以iPhone6为基准传入高，得出当前设备应该有的高度）
#define KSCALEHeight(height)  ((height) *KSCREEN_WIDTH/375.0f)
#define KSCALEWidth(width) ((width) *KSCREEN_WIDTH/375.0f)


// 状态栏

#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height  // 状态栏高度

// Status bar height.
#define  StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// Navigation bar height.
#define  NavigationBarHeight  44.f
// Tabbar height.
#define  KTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

// 常用宏
#define AppDelegateWindow [UIApplication sharedApplication].delegate.window

#define   Defaults [NSUserDefaults standardUserDefaults]

#endif /* SystemMacro_h */
