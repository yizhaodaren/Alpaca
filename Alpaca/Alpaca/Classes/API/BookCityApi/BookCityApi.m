//
//  BookCityApi.m
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCityApi.h"
#import "BSModel.h"
#import "BookCityModelGroup.h"
#import "BookGroupModel.h"
#import "CategoryGroupModel.h"
#import "ChapterItemGroupModel.h"
#import "BannerGroupModel.h"

typedef NS_ENUM(NSUInteger, BookCityApiType) {
    BookCityApiType_RecomClassifies, //推荐
    BookCityApiType_RecomMoreBooks, //推荐类型更多书籍
    BookCityApiType_BookDetail,//书籍详情页
    BookCityApiType_CategoryList,//分类列表
    BookCityApiType_CategoryContent,//分类内容
    BookCityApiType_ChapterList,//章节列表
    BookCityApi_BannerInfos, //获取banner信息列表
    BookCityApi_CompleteBooks, // 完本POST /book/completeBooks
    BookCityApi_NewestBooks, //最新 POST /book/newestBooks
    BookCityApi_CateOrRankBooks, ///POST /book/cateOrRankBooks 分类或排行书籍列表
    BookCityApi_SearchInfo, //搜索
    BookCityApi_SearchRecomBooks, //搜索为空时推荐
    BookCityApi_RelateRecomBooks,//同类书籍/book/relateRecomBooks
};

@interface BookCityApi()
@property (nonatomic, assign) BookCityApiType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;

@end

@implementation BookCityApi

///POST /search/info 搜索🔍
- (id)initSearchInfoWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type =BookCityApi_SearchInfo;
        _parameter = parameter;
    }
    return self;
}

///POST /search/searchRecomBooks 搜索为空推荐
- (id)initSearchRecomBooksWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type =BookCityApi_SearchRecomBooks;
        _parameter = parameter;
    }
    return self;
}

///POST /book/cateOrRankBooks 分类或排行书籍列表
- (id)initCateOrRankBooksWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_CateOrRankBooks;
        _parameter = parameter;
    }
    return self;
}

//同类书籍/book/relateRecomBooks
- (id)initRelateRecomBooksListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_RelateRecomBooks;
        _parameter = parameter;
    }
    return self;
}

/// 完本数据列表
- (id)initCompleteBooksWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_CompleteBooks;
        _parameter = parameter;
    }
    return self;
}

/// 最新数据列表POST /book/newestBooks
- (id)initNewestBooksWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type =BookCityApi_NewestBooks;
        _parameter = parameter;
    }
    return self;
}

///POST /banner/infos/{channelCode} //获取banner信息列表
- (id)initBannerInfosWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type =BookCityApi_BannerInfos;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}

/// 章节列表
- (id)initChapterListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookCityApiType_ChapterList;
        _parameter = parameter;
    }
    return self;
}

/// 分类类型列表
- (id)initCategoryListWithParameter:(NSDictionary *)parameter {
    self = [super init];
    if (self) {
        _type = BookCityApiType_CategoryList;
        _parameter = parameter;
    }
    return self;
}

/// 分类内容列表
- (id)initCategoryContentWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = BookCityApiType_CategoryContent;
        _parameter = parameter;
    }
    return self;
}

/// 获取书城推荐
- (id)initGetRecomClassifiesWithParameter:(NSDictionary *)parameter {
    self = [super init];
    if (self) {
        _type = BookCityApiType_RecomClassifies;
        _parameter = parameter;
        
    }
    return self;
}

/// 获取书城推荐类型更多书籍
- (id)initGetRecomMoreBooksWithParameter:(NSDictionary *)parameter {
    self = [super init];
    if (self) {
        _type = BookCityApiType_RecomMoreBooks;
        _parameter = parameter;
        
    }
    return self;
}



/// 书籍详情页
- (id)initBookDetailWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = BookCityApiType_BookDetail;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}


- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type == BookCityApiType_RecomClassifies) {
        return [BookCityModelGroup class];

    }else if (_type == BookCityApiType_RecomMoreBooks ||
              _type == BookCityApiType_CategoryContent ||
              _type == BookCityApi_CompleteBooks ||
              _type == BookCityApi_NewestBooks ||
              _type == BookCityApi_CateOrRankBooks ||
              _type == BookCityApi_SearchInfo ||
              _type == BookCityApi_SearchRecomBooks ||
              _type == BookCityApi_RelateRecomBooks
              ){
        return [BookGroupModel class];
        
    }else if (_type == BookCityApiType_BookDetail){
        
    }else if (_type == BookCityApiType_CategoryList){
        return [CategoryGroupModel class];
        
    }else if (_type == BookCityApiType_ChapterList){
        return [BookGroupModel class];
        
    }else if (_type == BookCityApi_BannerInfos){
        return [BannerGroupModel class];
    }
    return [BSModel class];
}

- (NSString *)parameterId
{
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}

- (NSString *)requestUrl
{
    switch (_type) {
        case BookCityApiType_RecomClassifies:
        {
            NSString *url = @"/recommend/recomClassifies";
            return url;
        }
            break;
        case BookCityApiType_RecomMoreBooks:
        {
            NSString *url = @"/recommend/recomMoreBooks";
            return url;
        }
            break;
        case BookCityApiType_BookDetail:
        {
            NSString *url = @"/book/bookId/{bookId}";
            url = [url stringByReplacingOccurrencesOfString:@"{bookId}" withString:self.parameterId];
            return url;
        }
            break;
        case BookCityApiType_CategoryList:
        {
            NSString *url = @"/category/cateList";
           // url = [url stringByReplacingOccurrencesOfString:@"{channelCode}" withString:self.parameterId];
            return url;
        }
            break;
        case BookCityApiType_CategoryContent:
        {
            NSString *url = @"/book/cateBooks";
            return url;
        }
            break;
        case BookCityApiType_ChapterList:
        {
            NSString *url = @"/chapter/chapterList";
            return url;
        }
            break;
        case BookCityApi_BannerInfos:
        {
            NSString *url = @"/banner/infos/{channelCode}";
            url = [url stringByReplacingOccurrencesOfString:@"{channelCode}" withString:self.parameterId];
            return url;
        }
            break;
        case BookCityApi_CompleteBooks:
        {
            NSString *url = @"/book/completeBooks";
            
            return url;
        }
            break;
        case BookCityApi_NewestBooks:
        {
            NSString *url = @"/book/newestBooks";
            return url;
        }
            break;
        
        case BookCityApi_CateOrRankBooks:
        {
            NSString *url = @"/book/cateOrRankBooks";
            return url;
        }
            break;
        case BookCityApi_SearchInfo:
        {
            NSString *url = @"/search/info";
            return url;
        }
            break;
        case BookCityApi_SearchRecomBooks:
        {
            NSString *url = @"/search/searchRecomBooks";
            return url;
        }
            break;
        case BookCityApi_RelateRecomBooks:
        {
            NSString *url = @"/book/relateRecomBooks";
            return url;
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}

@end
