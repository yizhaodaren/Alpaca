//
//  CategoryCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "CategoryCell.h"
#import "BookModel.h"

@interface  CategoryCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *bookModel;

@end


@implementation CategoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(BookModel * )model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    if (model) {
        self.bookModel =model;
    }
    
    
    CGFloat kDistance =15.0;
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: REGULAR_FONT(15)];
    [bookName setTextColor:HEX_COLOR(0x4A4A4A)];
    [bookName setText:model.chapterName?model.chapterName:@""];
    self.bookName =bookName;
    [self.contentView addSubview:bookName];

    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:lineView];
    
    
    //////////////////////////////////////////////
    __weak typeof(self) wself = self;
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(29);
        make.right.mas_equalTo(-29);
        make.height.mas_equalTo(51);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom);
        make.left.mas_equalTo(kDistance);
        make.right.mas_equalTo(-kDistance);
        make.height.mas_equalTo(1);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
