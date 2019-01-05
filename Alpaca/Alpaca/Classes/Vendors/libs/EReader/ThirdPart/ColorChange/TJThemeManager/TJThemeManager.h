//
//  TJThemeManager.h
//  TJTheme
//
//  Created by tao on 2018/9/18.
//  Copyright © 2018年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJThemeProtocol.h"

/// 请求成功的Block
typedef void(^TJThemeStatusChange)(NSObject<TJThemeProtocol> *themeBeforeChanged,
                                   NSObject<TJThemeProtocol> *themeAfterChanged);

/// 当主题发生变化时会发送这个通知
extern NSString *const TJThemeChangedNotification;
@interface TJThemeManager : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic, strong) NSObject<TJThemeProtocol> *currentTheme;

@property(nonatomic, copy)TJThemeStatusChange themeChangedBlock;

                                                                                     ;

@end
