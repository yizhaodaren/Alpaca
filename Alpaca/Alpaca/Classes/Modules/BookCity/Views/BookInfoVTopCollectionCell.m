//
//  BookInfoVTopCollectionCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookInfoVTopCollectionCell.h"
#import "BookModel.h"

@interface BookInfoVTopCollectionCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *currentModel;
@end

@implementation BookInfoVTopCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentModel =[BookModel new];
    }
    return self;
}

#pragma mark - UI
- (void)content:(BookModel *)model indexPath:(NSIndexPath *)indexPath;
{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    if (model) {
        self.currentModel =model;
    }
    
    
    UIImageView *coverImage=[UIImageView new];
    [coverImage setUserInteractionEnabled:YES];
    coverImage.contentMode =UIViewContentModeScaleAspectFill;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage imageNamed:@"defineImg"] options:SDWebImageRetryFailed];
    
    [self.contentView addSubview:coverImage];
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: REGULAR_FONT(14)];
    [bookName setTextColor:HEX_COLOR(0x252525)];
    [bookName setText: model.bookName?model.bookName:@""];
    [bookName setNumberOfLines:0];
    [bookName setPreferredMaxLayoutWidth:80];
    [self.contentView addSubview:bookName];
    
    YYLabel *tag =[YYLabel new];
    [tag setFont: REGULAR_FONT(12)];
    [tag setTextColor:HEX_COLOR(0xB2B2B2)];
    [tag setText: model.author?model.author:@""];
//    [tag setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:tag];
    
    
    
    //////////////////////////////////////////////
   
    __weak typeof(self) wself = self;
    
    CGFloat KContentWidth =KSCALEWidth(80);
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(110);
    }];
    
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookName?model.bookName:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:KContentWidth font:REGULAR_FONT(14)];
    
    if (bookDescHeight >=20*2.0) {
        bookDescHeight =40;
    }
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverImage.mas_bottom).offset(6);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(bookDescHeight);
    }];
    
    
    
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(17);
    }];
    
    
    
    //////////////////////////////////////////////
#if 0
    for (NSInteger i=0; i<model.tags.count; i++) {
        
        TagsModel *tagsDto =[TagsModel new];
        tagsDto =model.tags[i];
        
        if (tagsDto.type==2) {
            YYLabel *tag =[YYLabel new];
            [tag setFont: REGULAR_FONT(12)];
            [tag setTextColor:[STSystemHelper colorWithHexString:tagsDto.color?tagsDto.color:@"0xB2B2B2"]];
            [tag setText: tagsDto.text?tagsDto.text:@""];
            [self.contentView addSubview:tag];
            
            [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(bookName.mas_bottom);
                make.left.mas_equalTo(wself.contentView);
                make.width.mas_equalTo(KContentWidth);
                make.height.mas_equalTo(17);
            }];
            
        }
        
    }
#endif
}

@end
