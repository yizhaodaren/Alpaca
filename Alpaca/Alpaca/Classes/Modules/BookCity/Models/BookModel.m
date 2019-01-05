//
//  BookModel.m
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"tags":[TagsModel class]
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
           //  @"chapterNum" : @"sortNum", // chapterNum 替换key   sortNum 被替换sortNum
            // @"cNum" : @"chapterNum",
             
             };
    
}


- (CGFloat)copyrightHeight{
    if (_copyrightHeight ==0) {
        
        NSMutableAttributedString *copyrightStr =[STSystemHelper attributedContent:self.bookCopyRight?self.bookCopyRight:@"" color:HEX_COLOR(0xB2B2B2) font:REGULAR_FONT(12)];
        
        _copyrightHeight =[copyrightStr mol_getAttributedTextWidthWithMaxWith:KSCREEN_WIDTH-15*2.0 font:REGULAR_FONT(14)];
    }
    
    return _copyrightHeight;
}

- (CGFloat)recommendHeight{
    if (_recommendHeight == 0) {
        //上间距0+图片高度110 +间距6+ 书名20 +作者名17+15+线1
        _recommendHeight +=110+6+20+17+15+1;
    }
    return _recommendHeight;
}


@end
