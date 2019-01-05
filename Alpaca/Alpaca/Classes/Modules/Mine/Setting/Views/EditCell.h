//
//  EditCell.h
//  Alpaca
//
//  Created by xujin on 2019/1/4.
//  Copyright © 2019年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface EditCell : UITableViewCell
- (void)cell:(MineInfoModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
