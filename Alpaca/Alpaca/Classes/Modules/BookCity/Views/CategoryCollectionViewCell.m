//
//  CategoryCollectionViewCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/27.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "CategoryModel.h"
@interface CategoryCollectionViewCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)CategoryModel *currentModel;
@property (nonatomic, assign)CGRect cellFrame;
@end
@implementation CategoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentModel =[CategoryModel new];
        self.cellFrame =frame;
    }
    return self;
}

- (void)content:(CategoryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    if (model) {
        self.currentModel =model;
    }
    
    YYLabel *categoryName =[YYLabel new];
    [categoryName setFont: REGULAR_FONT(17)];
    [categoryName setTextColor:HEX_COLOR(0x979FAC)];
    [categoryName setText: model.cateName?model.cateName:@""];
    [categoryName setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:categoryName];
    
     __weak typeof(self) wself = self;
    [categoryName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(wself.contentView);
    }];
    
}
@end
