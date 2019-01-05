//
//  BookDetailInfoCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookModel,BookDetailInfoCell;
NS_ASSUME_NONNULL_BEGIN

@protocol BookDetailInfoCellDelegate <NSObject>

- (void)clickFoldEvent:(BookDetailInfoCell *)cell;

@end

@interface BookDetailInfoCell : UITableViewCell
@property (nonatomic, weak) id<BookDetailInfoCellDelegate>delegate;
- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
