//
//  MineRowCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineInfoModel;
@interface MineRowCell : UITableViewCell

- (void)cellContent:(MineInfoModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
