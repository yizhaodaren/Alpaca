//
//  ShareMsgModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareMsgModel : BSModel
@property (nonatomic,copy)NSString *shareContent;//
@property (nonatomic,copy)NSString *shareImg; //
@property (nonatomic,copy)NSString *shareUrl; //
@property (nonatomic,copy)NSString *shareTitle;//
@property (nonatomic,copy)NSString *type;

@end

NS_ASSUME_NONNULL_END
