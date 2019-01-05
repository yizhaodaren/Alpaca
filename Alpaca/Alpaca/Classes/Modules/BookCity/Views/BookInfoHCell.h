//
//  BookInfoHCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//
// 左图 右信息style

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookModel;
@interface BookInfoHCell : UITableViewCell

//type 100 分类类型
- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
