//
//  BookCityModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/20.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"
#import "BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCityModel : BSModel

@property (nonatomic, strong) NSMutableArray <BookModel *>*books;
@property (nonatomic, assign) NSInteger classifyId;
@property (nonatomic, assign) NSInteger hasMore; //1更多 0无更多
@property (nonatomic, assign) NSInteger recomAlign;//布局方式(1=垂直2=水平带简介3=水平不带简介 4=1、3混合)
@property (nonatomic, copy)   NSString *recomName; //组标题（大标题，eg：都市精品）
@property (nonatomic, assign) NSInteger remainTime; //限时剩余时间(秒)
@property (nonatomic, assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
