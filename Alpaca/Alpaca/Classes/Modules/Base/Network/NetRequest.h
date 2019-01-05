//
//  NetRequest.h
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSNetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class BSModel;
typedef void(^RequestSuccessBlock)(__kindof BSNetRequest *request,  BSModel*responseModel, NSInteger code, NSString *message);
typedef void(^RequestFaileBlock)(__kindof BSNetRequest *request);

@interface NetRequest : BSNetRequest

- (void)baseNetwork_startRequestWithcompletion:(RequestSuccessBlock)completion failure:(RequestFaileBlock)failure;

@end

NS_ASSUME_NONNULL_END
