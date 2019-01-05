//
//  BookCityModel.m
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCityModel.h"

@implementation BookCityModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"books":[BookModel class]
             };
}


- (CGFloat)cellHeight{
    
    if (_cellHeight==0) {
        switch (self.recomAlign) {//布局方式(1=垂直2=水平带简介3=水平不带简介 4=1、3混合)
            case 1:
            {// 上间距15+内容高度116+下间距15+底线1
                _cellHeight += 15+116+15+1;
            }
                break;
            case 2:
            {// 上间距15+内容高度88+ 间距16+ 简介60 +下间距20
                _cellHeight += 15+88+16+60+20;
            }
                break;
            case 3:
            {// 上间距15+内容高度110+ 间距6+ 书名20 +标签17+下间距20
                _cellHeight += 15+110+6+20+17+20;
            }
                break;
                
            case 4:
            {
                // 上间距15+内容高度110+ 间距6+ 书名20 +标签17+下间距20
                _cellHeight += 15+110+6+20+17+20;
            }
                break;
 
        }
    }
    
    return _cellHeight;
}

@end
