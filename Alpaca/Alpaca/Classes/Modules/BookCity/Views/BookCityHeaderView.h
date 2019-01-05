//
//  BookCityHeaderView.h
//  Alpaca
//
//  Created by xujin on 2018/11/26.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookCityModel;
@interface BookCityHeaderView : UITableViewHeaderFooterView

- (void)headerViewcontent:(BookCityModel *)model section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
