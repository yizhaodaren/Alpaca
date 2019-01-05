//
//  BookInfoCCollectionCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/24.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookInfoCCollectionCell.h"
#import "BookModel.h"

@interface BookInfoCCollectionCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *currentModel;

@end

@implementation BookInfoCCollectionCell
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
    
    
    CGFloat kwidth =(KSCREEN_WIDTH - 15*2.0 -8.0)/2.0;
    
    UIImageView *coverImage=[UIImageView new];
    [coverImage setUserInteractionEnabled:YES];
    coverImage.contentMode =UIViewContentModeScaleAspectFill;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage imageNamed:@"defineImg"] options:SDWebImageRetryFailed];
    
    [self.contentView addSubview:coverImage];
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: SEMIBOLD_FONT(17)];
    [bookName setTextColor:HEX_COLOR(0x000000)];
    [bookName setText: model.bookName?model.bookName:@""];
    [self.contentView addSubview:bookName];
    
    YYLabel *bookDesc =[YYLabel new];
    [bookDesc setFont: REGULAR_FONT(14)];
    [bookDesc setTextColor:HEX_COLOR(0x4A4A4A)];
    [bookDesc setText: model.bookDesc?model.bookDesc:@""];
    [bookDesc setNumberOfLines:0];
    [bookDesc setPreferredMaxLayoutWidth:kwidth];
    [self.contentView addSubview:bookDesc];
    
    //////////////////////////////////////////////
    CGFloat width =kwidth-15-64-7;
    YYLabel *author =[YYLabel new];
    [author setFont: REGULAR_FONT(14)];
    [author setTextColor:HEX_COLOR(0xB2B2B2)];
    [author setText: model.author?model.author:@""];
    [author setNumberOfLines:0];
    [author setPreferredMaxLayoutWidth:width];
    [self.contentView addSubview:author];
    
    
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(88);
    }];
    
    CGFloat bookNameHeight =0.0;
     NSMutableAttributedString *bookNameStr =[STSystemHelper attributedContent:author.text color:HEX_COLOR(0x000000) font:SEMIBOLD_FONT(17)];
    bookNameHeight =[bookNameStr mol_getAttributedTextWidthWithMaxWith:width font:SEMIBOLD_FONT(17)];
    
    if (bookNameHeight > 48) {
        bookNameHeight =48;
    }
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(coverImage.mas_right).offset(7);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(bookNameHeight);
    }];
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookDesc?model.bookDesc:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:(kwidth-5*2.0) font:REGULAR_FONT(14)];
    
    if (bookDescHeight > 60) {
        bookDescHeight =60;
    }
    
    [bookDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverImage.mas_bottom).offset(16);
        make.left.mas_equalTo(wself.contentView).offset(5);
        make.width.mas_equalTo(kwidth-5*2.0);
        make.height.mas_equalTo(bookDescHeight);
    }];
    
    
    [author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom);
        make.left.mas_equalTo(coverImage.mas_right).offset(7);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20);
    }];
    
    //////////////////////////////////////////////
    
    model.tags =(NSMutableArray *)[[model.tags reverseObjectEnumerator] allObjects];
    
    YYLabel *oldTag;
    for (NSInteger i=0; i<model.tags.count; i++) {
        
        TagsModel *tagsDto =[TagsModel new];
        tagsDto =model.tags[i];
        
        YYLabel *tag =[YYLabel new];
        [tag setTextAlignment:NSTextAlignmentCenter];
        [tag setFont: LIGHT_FONT(11)];
        [tag setTextColor:[STSystemHelper colorWithHexString:tagsDto.color?tagsDto.color:@"BBBBBB"]];
        [tag setText: tagsDto.text?tagsDto.text:@""];
        [self.contentView addSubview:tag];
        
        
        NSMutableAttributedString *tagStr =[STSystemHelper attributedContent:tagsDto.text?tagsDto.text:@"" color:[STSystemHelper colorWithHexString:tagsDto.color?tagsDto.color:@"BBBBBB"] font:LIGHT_FONT(11)];
        
        CGFloat tagWidth =0.0;
        
        tagWidth =[tagStr mol_getAttributedTextHeightWithMaxWith:16 font:LIGHT_FONT(11)];
        
        tagWidth =4+tagWidth+4;
        
        CGFloat kTagSpacer =3;
        CGFloat kTagLeftWidth =7;
        
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(coverImage.mas_bottom);
            //make.left.mas_equalTo(coverImage.mas_right).offset((kTagLeftWidth+(kTagSpacer+tagWidth)*i));
            if (i==0) {
              make.left.mas_equalTo(coverImage.mas_right).offset(kTagLeftWidth);
            }else{
                make.left.mas_equalTo(oldTag.mas_right).offset(kTagSpacer);
            }
            make.width.mas_equalTo(tagWidth);
            make.height.mas_equalTo(16);
        }];
        
        tag.layer.borderWidth =1;
        tag.layer.borderColor =HEX_COLOR(0xD8D8D8).CGColor;
        [tag.layer setMasksToBounds:YES];
        [tag.layer setCornerRadius:2];
        oldTag =tag;
        
    }
    
}
@end
