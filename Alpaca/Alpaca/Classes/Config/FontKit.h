//
//  FontKit.h
//  Alpaca
//
//  Created by xujin on 2018/11/15.
//  Copyright © 2018年 Moli. All rights reserved.
//

#ifndef FontKit_h
#define FontKit_h
//字体
#define FONT(f)   [UIFont systemFontOfSize:(f)]
#define LIGHT_FONT(size) [UIFont systemFontOfSize:size fontWithName:@"PingFangSC-Light"]
#define REGULAR_FONT(size) [UIFont systemFontOfSize:size fontWithName:@"PingFangSC-Regular"]
#define MEDIUM_FONT(size) [UIFont systemFontOfSize:size fontWithName:@"PingFangSC-Medium"]
#define SEMIBOLD_FONT(size) [UIFont systemFontOfSize:size fontWithName:@"PingFangSC-Semibold"]
#define SourceHanSerifCNBold_FONT(size) [UIFont systemFontOfSize:size fontWithName:@"SourceHanSerifCN-Bold"]

#endif /* FontKit_h */
