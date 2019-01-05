//
//  ChapterVOModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/10.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterVOModel : BSModel
@property (nonatomic,assign)NSInteger chapterId;//
@property (nonatomic,copy)NSString *chapterName; //
@property (nonatomic,assign)NSInteger sortNum; // 章节数
@property (nonatomic,assign)NSInteger wordCount;//


@end

NS_ASSUME_NONNULL_END
