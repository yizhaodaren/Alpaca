//
//  MOLAppStartRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "NetRequest.h"

@interface MOLAppStartRequest : NetRequest

///POST /version/versionInfo
/// 获取版本更新
- (instancetype)initRequest_versionCheckWithParameter:(NSDictionary *)parameter;

/// 获取开关接口
- (instancetype)initRequest_getSwitchActionCommentWithParameter:(NSDictionary *)parameter;
//获取AD信息
- (instancetype)initRequest_getADInfoWithParameter:(NSDictionary *)parameter;


@end
