//
//  CategoryCollectionViewCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CategoryModel;
@interface CategoryCollectionViewCell : UICollectionViewCell
- (void)content:(CategoryModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
