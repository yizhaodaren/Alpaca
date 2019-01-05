//
//  TJThemeProtocol.h
//  TJTheme
//
//  Created by tao on 2018/9/18.
//  Copyright © 2018年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TJThemeProtocol <NSObject>
@required
- (UIColor *)themeBgColor;
- (UIColor *)themeTextColor;
- (NSString *)themeImage;
@end
