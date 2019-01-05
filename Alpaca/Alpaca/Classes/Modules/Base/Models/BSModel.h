//
//  BSModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger total;
@end

NS_ASSUME_NONNULL_END
