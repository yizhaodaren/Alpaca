//
//  NSMutableAttributedString+AttExtention.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "NSMutableAttributedString+AttExtention.h"

@implementation NSMutableAttributedString (AttExtention)
// 获取文本高度
-(CGFloat)mol_getAttributedTextWidthWithMaxWith:(CGFloat)height font:(UIFont *)font
{
    self.yy_font = font;
    CGSize introSize = CGSizeMake(height, CGFLOAT_MAX);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:self];
    
    CGFloat introHeight = layout.textBoundingSize.height;
    
    return introHeight;
}

-(CGFloat)mol_getAttributedTextHeightWithMaxWith:(CGFloat)height font:(UIFont *)font
{
    self.yy_font = font;
    CGSize introSize = CGSizeMake(CGFLOAT_MAX, height);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:self];
    
    CGFloat introWidth = layout.textBoundingSize.width;
    
    return introWidth;
}
@end
