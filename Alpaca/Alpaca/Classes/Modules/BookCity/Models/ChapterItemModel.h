//
//  ChapterItemModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterItemModel : BSModel
@property (nonatomic,assign)NSInteger chapterId;//
@property (nonatomic,copy)NSString *chapterName; //
@property (nonatomic,assign)NSInteger sortNum; //
@property (nonatomic,assign)NSInteger wordCount;//

@end

NS_ASSUME_NONNULL_END
