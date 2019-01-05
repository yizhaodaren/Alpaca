//
//  E_EndReaderViewController.h
//  Alpaca
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSViewController.h"
@interface E_EndReaderViewController : BSViewController
@property(nonatomic,strong)BookModel  *originalModel;
-(void)setTopWithModel:(BookModel *)model;
@end
