//
//  MineHeaderCell.h
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;
@interface MineHeaderCell : UITableViewCell

- (void)cellContent:(UserModel *)model indexPath:(NSIndexPath *)indexPath status:(BOOL)status;

@end

NS_ASSUME_NONNULL_END
