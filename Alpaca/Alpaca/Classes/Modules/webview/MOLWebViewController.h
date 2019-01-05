//
//  MOLWebViewController.h
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "BSViewController.h"

@interface MOLWebViewController : BSViewController
@property (nonatomic, assign) NSInteger from; //100 来自输入好友邀请码 //101 来自福利
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *titleString;
@end
