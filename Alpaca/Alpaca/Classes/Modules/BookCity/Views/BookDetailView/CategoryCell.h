//
//  CategoryCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface CategoryCell : UITableViewCell

@property (nonatomic, weak)YYLabel *bookName;

- (void)cellContent:(CategoryModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
