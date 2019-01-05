//
//  BookCatalogueViewController.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSViewController.h"
@class BookModel;
NS_ASSUME_NONNULL_BEGIN


@interface BookCatalogueViewController : BSViewController
@property (nonatomic, assign)BOOL isPush;
@property (nonatomic, strong)BookModel *model;

@end

NS_ASSUME_NONNULL_END
