//
//  BookModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"
#import "TagsModel.h"
#import "ShareMsgModel.h"
#import "ChapterVOModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookModel : BSModel

@property (nonatomic, copy)   NSString *author;
@property (nonatomic, copy)   NSString *bookDesc;
@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, assign) NSInteger isFinish;
@property (nonatomic, copy)   NSString *bookName;
@property (nonatomic, copy)   NSString *coverImage;
@property (nonatomic, assign) NSInteger isSystem; //1系统 0普通

@property (nonatomic, strong) NSMutableArray <TagsModel *>*tags; //标签
@property (nonatomic, assign) NSInteger wordCount;
@property (nonatomic, assign) NSInteger inShelf; //0未在书架  1在书架
@property (nonatomic, assign) NSInteger chapterCount; //总章节数
@property (nonatomic, assign) NSInteger chapterNum; //第几章
@property (nonatomic, assign) NSInteger sortNum; //第几章 用于目录

@property (nonatomic, assign) NSInteger chapterId; //章节Id
@property (nonatomic, copy) NSString *chapterName; //章节名
@property (nonatomic, copy) NSString *content; //章节内容
@property (nonatomic, strong)ShareMsgModel *shareMsgVO;
@property (nonatomic, strong)ChapterVOModel *chapterVO;

@property (nonatomic, strong) NSMutableArray <BookModel *>*books;
@property (nonatomic, assign)CGFloat copyrightHeight;
@property (nonatomic, assign)CGFloat recommendHeight;
@property (nonatomic, copy)NSString *bookCopyRight;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger time;
@property (nonatomic, strong)NSIndexPath  * __nullable indexpath;//图片标识
@property (nonatomic, assign)NSInteger fromVC; //100来自书架



/** 是否展开 */
@property (nonatomic, assign) BOOL isOpening;


@end

NS_ASSUME_NONNULL_END
