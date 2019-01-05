//
//  TJThemeManager.m
//  TJTheme
//
//  Created by tao on 2018/9/18.
//  Copyright © 2018年 tao. All rights reserved.
//

#import "TJThemeManager.h"
NSString *const TJThemeChangedNotification = @"TJThemeChangedNotification";
NSString *const TJThemeBeforeChangedData = @"TJThemeBeforeChangedData";
NSString *const TJThemeAfterChangedData = @"TJThemeAfterChangedData";
@implementation TJThemeManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TJThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[TJThemeManager alloc] init];
    });
    return instance;
}

- (void)setCurrentTheme:(NSObject<TJThemeProtocol> *)currentTheme{
    if (_currentTheme != currentTheme && currentTheme) {
        NSObject<TJThemeProtocol> *themeBeforeChanged = _currentTheme;
        _currentTheme = currentTheme;
        [[NSNotificationCenter defaultCenter] postNotificationName:TJThemeChangedNotification object:self userInfo:@{TJThemeBeforeChangedData: themeBeforeChanged ?: [NSNull null], TJThemeAfterChangedData: _currentTheme ?: [NSNull null]}];
    
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:TJThemeChangedNotification object:nil];
    }
    return self;
}
- (void)handleThemeChangedNotification:(NSNotification *)notification {
    //改变成功
    if (self.themeChangedBlock) {
        NSObject<TJThemeProtocol> *themeBeforeChanged = notification.userInfo[TJThemeBeforeChangedData];
        themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
        NSObject<TJThemeProtocol> *themeAfterChanged = notification.userInfo[TJThemeAfterChangedData];
        themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
        self.themeChangedBlock(themeBeforeChanged, themeAfterChanged);
    }
    
}


@end
