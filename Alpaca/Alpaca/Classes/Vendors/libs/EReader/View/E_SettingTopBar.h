//
//  E_SettingBar.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
/**
 *  顶部设置条
 */

@protocol E_SettingTopBarDelegate <NSObject>

- (void)goBack;//退出
- (void)gotoBookDetail;//查看详情
- (void)showMultifunctionButton;

@end

@interface E_SettingTopBar : UIView

@property(nonatomic,strong)BookModel *bookModel;

@property(nonatomic,assign)id<E_SettingTopBarDelegate>delegate;

- (void)showToolBar;

- (void)hideToolBar;

- (void)contentEvent:(BookModel *)bookModel;

@end
