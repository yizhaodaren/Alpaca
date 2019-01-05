//
//  BookDetailGuideCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookModel;
NS_ASSUME_NONNULL_BEGIN

@interface BookDetailGuideCell : UITableViewCell
- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
