//
//  BookCaseCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCaseCell.h"
#import "BookModel.h"
#import "UIImage+RedrawAdaptation.h"

@interface BookCaseCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *currentModel;

@end

@implementation BookCaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor: [UIColor redColor]];
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
    
    CGFloat KContentWidth = KSCALEWidth(88);
    CGFloat KContentHeight = KSCALEHeight(125);
    
    UIImageView *coverImage=[UIImageView new];
    [coverImage setUserInteractionEnabled:YES];
    coverImage.contentMode =UIViewContentModeScaleAspectFill;
    
    [coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
//    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""]]];
    
//    [coverImage setImage:[UIImage adaptation:image toSize:CGSizeMake(KContentWidth, KContentHeight)]];
   
    [self.contentView addSubview:coverImage];
    
    YYLabel *systemTip =[YYLabel new];
    [systemTip setFont: REGULAR_FONT(9)];
    [systemTip setTextColor:HEX_COLOR(0xffffff)];
    [systemTip setBackgroundColor:HEX_COLOR(0x19B898)];
    [systemTip setTextAlignment:NSTextAlignmentCenter];
    [systemTip setText:@"推荐"];
    [systemTip.layer setMasksToBounds:YES];
    [systemTip.layer setCornerRadius:1.0];
    [coverImage addSubview:systemTip];
    
    if (!model.isSystem) {
        [systemTip setAlpha: 0];
    }
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: REGULAR_FONT(14)];
    [bookName setTextColor:HEX_COLOR(0x252525)];
    [bookName setText: model.bookName?model.bookName:@""];
    [bookName setNumberOfLines:0];
    [bookName setPreferredMaxLayoutWidth:KContentWidth];
    [self.contentView addSubview:bookName];
    
    
#warning 接口金币字段正在开发，等待中...
    YYLabel *money =[YYLabel new];
//    [money setTextAlignment:NSTextAlignmentCenter];
    [money setFont: REGULAR_FONT(11)];
    [money setTextColor:HEX_COLOR(0xD16710)];
    [money setText:[NSString stringWithFormat:@"可赚%@金币", [STSystemHelper getNum:model.money]]];
    [money setHidden:[Defaults integerForKey:ISDEBUG]];
    [self.contentView addSubview:money];
    
    
    UIButton *buttonSele =[UIButton buttonWithType:UIButtonTypeCustom];
    
   
    [buttonSele setBackgroundColor:[UIColor clearColor]];
    
    
    [buttonSele setImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
    [buttonSele setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
   // [buttonSele setAlpha:0];
    self.selectButton =buttonSele;
    [coverImage addSubview:buttonSele];
    
    //////////////////////////////////////////////
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(KContentHeight);
    }];
    
    [systemTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(coverImage.mas_left);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(13);
    }];
    
    [buttonSele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-3);
        make.right.mas_equalTo(-3);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    NSMutableAttributedString *bookNameStr =[STSystemHelper attributedContent:model.bookName?model.bookName:@"" color:HEX_COLOR(0x252525) font:REGULAR_FONT(14)];
    
    CGFloat bookNameHeight =0.0;
    
    bookNameHeight =[bookNameStr mol_getAttributedTextWidthWithMaxWith:KContentWidth font:REGULAR_FONT(14)];
    
    if (bookNameHeight > 20*2.0) {
        bookNameHeight =20*2.0;
    }
    
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverImage.mas_bottom).offset(5);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(bookNameHeight);
    }];
    
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom);
        make.left.mas_equalTo(wself.contentView);
        make.width.mas_equalTo(KContentWidth);
        make.height.mas_equalTo(16);
    }];
    
}

@end
