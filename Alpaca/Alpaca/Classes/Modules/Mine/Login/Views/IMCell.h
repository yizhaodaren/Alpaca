//
//  IMCell.h
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMModel;
NS_ASSUME_NONNULL_BEGIN

@interface IMCell : UITableViewCell
- (void)cellContent:(IMModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
