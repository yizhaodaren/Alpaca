//
//   Macro.h
//  Alpaca
//
//  Created by xujin on 2018/12/11.
//  Copyright © 2018年 Moli. All rights reserved.
//

#ifndef _Macro_h
#define _Macro_h

#define  SetupInit          @"SetupInitialization"
#define  CHANNEL            @"channel"  //1男 2女
#define  HISTORYTAGARR      @"HISTORYTAG"

/*++++++++++++全局配置++++++++++++*/
#define  READMAXSPEED       @"READMAXSPEED" //用于每页阅读计费
#define  READMINSPEED       @"READMINSPEED" //用于每页阅读计费
#define  ADSTARTCHAPTERCOUT @"ADSTARTCHAPTERCOUT" //用于阅读广告开启章节


#define  IMSTATUS           @"IMSTATUS"     // 消息状态 yes收到消息 no未收到消息

#define  ISDEBUG            @"ISDEBUG"      //
#define  DIRECTION          @"DIRECTION"    // 翻页方向 yes 向右滑动 No向左滑动

#define  REPEATLOGO         @"REPEATLOGO"   // 阅读章节统计去重标识（章节ID）

#define  ISFIRSTREAD        @"ISFIRSTREAD"  // 第一次阅读引导提示

#define  ISSHOWTIMERDAY        @"ISSHOWTIMERDAY"  //当天 NSThring

#endif /* _Macro_h */
