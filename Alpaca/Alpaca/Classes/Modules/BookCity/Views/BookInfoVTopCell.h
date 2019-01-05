//
//  BookInfoVTopCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//
// 上图 下简要信息style

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookCityModel;
@interface BookInfoVTopCell : UITableViewCell
//- (void)cellContent:(BookCityModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)cellContent:(NSArray *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
