//
//  BookDetailViewController.h
//  Alpaca
//
//  Created by ACTION on 2018/11/22.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSViewController.h"
@class BookModel;
@interface BookDetailViewController : BSViewController
@property(nonatomic,strong)BookModel *model;
@property(nonatomic,assign)BOOL isComeFormeReader;
@end
