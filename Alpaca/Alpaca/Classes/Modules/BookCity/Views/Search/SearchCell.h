//
//  SearchCell.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookModel;
@interface SearchCell : UITableViewCell
- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
