//
//  WelfareCollectionViewCell.h
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WelfareModel;
@interface WelfareCollectionViewCell : UICollectionViewCell
- (void)content:(WelfareModel *)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
