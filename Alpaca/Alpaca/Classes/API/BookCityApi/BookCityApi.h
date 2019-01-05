//
//  BookCityApi.h
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCityApi : NetRequest


///POST /search/info 搜索🔍
//content (string, optional): 搜索内容 ,
//pageNum (integer, optional): 当前页号 ,
//pageSize (integer, optional): 每页大小
- (id)initSearchInfoWithParameter:(NSDictionary *)parameter;

///POST /search/searchRecomBooks 搜索为空推荐
//pageNum (integer, optional): 当前页号 ,
//pageSize (integer, optional): 每页大小
- (id)initSearchRecomBooksWithParameter:(NSDictionary *)parameter;

///POST /book/cateOrRankBooks 分类或排行书籍列表
- (id)initCateOrRankBooksWithParameter:(NSDictionary *)parameter;




/// 完本数据列表
- (id)initCompleteBooksWithParameter:(NSDictionary *)parameter;

/// 最新数据列表POST /book/newestBooks
- (id)initNewestBooksWithParameter:(NSDictionary *)parameter;

///POST /banner/infos/{channelCode} //获取banner信息列表
- (id)initBannerInfosWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 获取书城推荐
- (id)initGetRecomClassifiesWithParameter:(NSDictionary *)parameter;

/// 获取书城推荐类型更多书籍
- (id)initGetRecomMoreBooksWithParameter:(NSDictionary *)parameter;

/// 书籍详情页
- (id)initBookDetailWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;

/// 分类类型列表
- (id)initCategoryListWithParameter:(NSDictionary *)parameter;

/// 分类内容列表
- (id)initCategoryContentWithParameter:(NSDictionary *)parameter;

/// 章节列表
- (id)initChapterListWithParameter:(NSDictionary *)parameter;

//同类书籍/book/relateRecomBooks
- (id)initRelateRecomBooksListWithParameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
