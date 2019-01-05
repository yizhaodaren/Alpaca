//
//  ReadRecordCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "ReadRecordCell.h"
#import "BookModel.h"
@interface  ReadRecordCell()
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)BookModel *bookModel;
@end

@implementation ReadRecordCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bookModel =[BookModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndex = indexPath;
    }
    
    if (model) {
        self.bookModel =model;
    }
    
    
    UIImageView *coverImage=[UIImageView new];
    [coverImage setUserInteractionEnabled:YES];
    coverImage.contentMode =UIViewContentModeScaleAspectFill;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    [self.contentView addSubview:coverImage];
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: SEMIBOLD_FONT(15)];
    [bookName setTextColor:HEX_COLOR(0x000000)];
    [bookName setText: model.bookName?model.bookName:@""];
    [self.contentView addSubview:bookName];
    
    YYLabel *bookDesc =[YYLabel new];
    [bookDesc setFont: REGULAR_FONT(12)];
    [bookDesc setTextColor:HEX_COLOR(0x6E6E6E)];
    [bookDesc setText: [NSString stringWithFormat:@"已读到 %@",model.chapterVO.chapterName?model.chapterVO.chapterName:@""]];
    [bookDesc setNumberOfLines:0];
    [bookDesc setPreferredMaxLayoutWidth:KSCREEN_WIDTH - 15*2.0 -12.0];
    [self.contentView addSubview:bookDesc];
    
    YYLabel *author =[YYLabel new];
    [author setFont: LIGHT_FONT(12)];
    [author setTextColor:HEX_COLOR(0xB2B2B2)];
    [author setText: model.author?model.author:@""];
    [self.contentView addSubview:author];
    
    
    UIView *bottomLine =[UIView new];
    [bottomLine setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:bottomLine];
    
    //////////////////////////////////////////////
    CGFloat kwidth =0.0;
    kwidth =KSCREEN_WIDTH-16-36-10-36;
    
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(50);
    }];
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(coverImage.mas_right).offset(10);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(21);
    }];
    
  //  NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookDesc?model.bookDesc:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(12)];
    
    CGFloat bookDescHeight =17;
    
   // bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(12)];
    
//    if (bookDescHeight > 17*2.0) {
//        bookDescHeight =17*2.0;
//    }
    
    [bookDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom).offset(3);
        make.left.mas_equalTo(coverImage.mas_right).offset(10);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(bookDescHeight);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(KSCREEN_WIDTH-15*2.0);
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
