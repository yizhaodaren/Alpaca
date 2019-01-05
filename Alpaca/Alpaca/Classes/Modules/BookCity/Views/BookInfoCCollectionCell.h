//
//  BookInfoCCollectionCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/24.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookModel;
@interface BookInfoCCollectionCell : UICollectionViewCell
- (void)content:(BookModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
