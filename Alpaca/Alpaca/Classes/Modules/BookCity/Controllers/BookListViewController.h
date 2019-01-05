//
//  BookListViewController.h
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

typedef NS_ENUM(NSInteger,FeatureTypeStyle) {
    FeatureTypeStyle_End,     //完结
    FeatureTypeStyle_NewBook, //新书
    FeatureTypeStyle_More,    //查看更多
    FeatureTypeRelateRecomBooks, //同类书籍
};

#import "BSViewController.h"
@class BookCityModel;

NS_ASSUME_NONNULL_BEGIN

@interface BookListViewController : BSViewController
@property (nonatomic, assign)FeatureTypeStyle featureStyle;
@property (nonatomic, strong)BookCityModel *cityModel;
@property (nonatomic, strong)BookModel  *bookModel;
@end

NS_ASSUME_NONNULL_END
