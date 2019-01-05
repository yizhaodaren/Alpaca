//
//  UIImage+RedrawAdaptation.m
//  Alpaca
//
//  Created by xujin on 2018/12/13.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "UIImage+RedrawAdaptation.h"

@implementation UIImage (RedrawAdaptation)
+ (UIImage *)adaptation:(UIImage *)originalImage toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

@end
