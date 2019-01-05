//
//  UIFont+Extension.m
//  Alpaca
//
//  Created by xujin on 2018/11/15.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize fontWithName:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];//这个是9.0以后自带的平方字体
    if (!font) {
        //这个是手动导入的第三方平方字体
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}
@end
