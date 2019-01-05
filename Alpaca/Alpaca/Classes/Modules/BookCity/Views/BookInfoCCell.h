//
//  BookInfoCCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//
// 左图 右书信息 下书描述信息style

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookCityModel;
@interface BookInfoCCell : UITableViewCell
- (void)cellContent:(BookCityModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
