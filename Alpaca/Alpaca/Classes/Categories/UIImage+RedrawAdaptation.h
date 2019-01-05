//
//  UIImage+RedrawAdaptation.h
//  Alpaca
//
//  Created by xujin on 2018/12/13.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RedrawAdaptation)

+ (UIImage *)adaptation:(UIImage *)originalImage toSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
