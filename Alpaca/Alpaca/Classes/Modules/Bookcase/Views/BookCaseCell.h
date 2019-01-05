//
//  BookCaseCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookModel;
@interface BookCaseCell : UICollectionViewCell
@property (nonatomic,weak)UIButton *selectButton;
- (void)content:(BookModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
