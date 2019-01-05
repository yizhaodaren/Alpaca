//
//  BookDetailInfoCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookDetailInfoCell.h"
#import "BookModel.h"

@interface  BookDetailInfoCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *bookModel;
@property (nonatomic, weak)UIButton *foldButton;

@end
@implementation BookDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath{
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
    
    UIImageView *coverImage=[UIImageView new];
    [coverImage setUserInteractionEnabled:YES];
    coverImage.contentMode =UIViewContentModeScaleAspectFill;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    [self.contentView addSubview:coverImage];
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: SEMIBOLD_FONT(22)];
    [bookName setTextColor:HEX_COLOR(0x000000)];
    [bookName setText: model.bookName?model.bookName:@""];
    [self.contentView addSubview:bookName];
    
    YYLabel *bookDesc =[YYLabel new];
    [bookDesc setFont: REGULAR_FONT(16)];
    [bookDesc setTextColor:HEX_COLOR(0x4A4A4A)];
    [bookDesc setText: model.bookDesc?model.bookDesc:@""];
   // [bookDesc setNumberOfLines:2];
    bookDesc.lineBreakMode =NSLineBreakByTruncatingTail;
    [bookDesc setPreferredMaxLayoutWidth:KSCREEN_WIDTH - 15*2.0];
    UITapGestureRecognizer *foldTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldNewsOrNoTap:)];
    [bookDesc addGestureRecognizer:foldTap];
    [self.contentView addSubview:bookDesc];
    
    YYLabel *author =[YYLabel new];
    [author setFont: REGULAR_FONT(14)];
    [author setTextColor:HEX_COLOR(0x6E6E6E)];
    [author setText: model.author?model.author:@""];
    [self.contentView addSubview:author];
    
    TYAttributedLabel *tipLabel = [[TYAttributedLabel alloc]init];
    [tipLabel setBackgroundColor: [UIColor clearColor]];
    [self.contentView addSubview:tipLabel];
    
    NSString *moneyStr =[NSString stringWithFormat:@"可赚%@金币。",[STSystemHelper getNum:model.money]];
    
    if ([Defaults integerForKey:ISDEBUG]) {
        moneyStr =@"";
    }
    
    NSString *text =[NSString stringWithFormat:@"%@字,约%ld小时读完,%@",[STSystemHelper getNum:model.wordCount],model.time,moneyStr];
    
    
    // 属性文本生成器
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
   // textContainer.textAlignment = NSTextAlignmentRight;
    [textContainer setStrokeColor: [UIColor clearColor]];
    [textContainer setTextColor:HEX_COLOR(0x9B9B9B)];
    [textContainer setFont: REGULAR_FONT(12)];
    
    [textContainer addLinkWithLinkData:moneyStr linkColor:HEX_COLOR(0xD16710) underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:moneyStr]];
    
    
    tipLabel.textContainer =textContainer;
    
    
    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:lineView];
    
    
    UIButton *foldButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [foldButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    //[foldButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [foldButton addTarget:self action:@selector(foldButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
 //   [foldButton setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:foldButton];
    self.foldButton =foldButton;
    
    
    //////////////////////////////////////////////
    CGFloat kwidth =KSCREEN_WIDTH-15*2.0-kDistance-116;
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(116);
    }];
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(coverImage.mas_right).offset(12);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(24);
    }];
    
    
    [author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom).offset(5);
        make.left.mas_equalTo(coverImage.mas_right).offset(12);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(24);
    }];
    
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookDesc?model.bookDesc:@"" color:HEX_COLOR(0x4A4A4A) font:REGULAR_FONT(16)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:KSCREEN_WIDTH-15*2.0 font:REGULAR_FONT(16)];
    
    if (bookDescHeight > 69) {
//        self.foldButton.hidden =NO;
        if (model.isOpening) {
            bookDesc.numberOfLines =0;
            [self.foldButton setAlpha:0];
//            self.foldButton.selected =YES;
        }else{
            bookDesc.numberOfLines =3;
            [self.foldButton setAlpha:1];
//            self.foldButton.selected =NO;
        }
    }else{
        bookDesc.numberOfLines =0;
        [self.foldButton setAlpha:0];
       // self.foldButton.hidden =YES;
    }
    
    [bookDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverImage.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
     //   make.height.mas_equalTo(bookDescHeight);
    }];
    bookDesc.preferredMaxLayoutWidth = KSCREEN_WIDTH-15*2.0;
    
    [foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bookDesc.mas_bottom);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(232/2.0);
        make.height.mas_equalTo(20);
        //   make.height.mas_equalTo(bookDescHeight);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    
    //////////////////////////////////////////////
    
    //self.model.tags =(NSMutableArray *)[[self.model.tags reverseObjectEnumerator] allObjects];
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
        CGFloat kTagRightWidth =kDistance;
        
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(author.mas_bottom).offset(kDistance);
            if (i==0) {
                make.left.mas_equalTo(coverImage.mas_right).offset(kTagRightWidth);
            }else{
                make.left.mas_equalTo(oldTag.mas_right).offset(kTagSpacer);
            } //make.left.mas_equalTo(coverImage.mas_right).offset(kTagRightWidth+(kTagSpacer+tagWidth)*i);
            make.width.mas_equalTo(tagWidth);
            make.height.mas_equalTo(16);
        }];
        
        tag.layer.borderWidth =1;
        tag.layer.borderColor =HEX_COLOR(0xD8D8D8).CGColor;
        [tag.layer setMasksToBounds:YES];
        [tag.layer setCornerRadius:2];
        oldTag =tag;
        
        if (i==0) {
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(tag.mas_bottom).offset(10);
                make.height.mas_equalTo(17);
                make.left.mas_equalTo(coverImage.mas_right).offset(15);
                make.right.mas_equalTo(15);
            }];
        }
        
    }
}

- (void)foldButtonEvent:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFoldEvent:)]) {
        sender.selected =!sender.selected;
        [_delegate clickFoldEvent:self];
    }
}

#pragma mark - Gesture
/**
 *  折叠展开按钮的点击事件
 *
 *  @param recognizer 点击手势
 */
- (void)foldNewsOrNoTap:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if (_delegate && [_delegate respondsToSelector:@selector(clickFoldEvent:)]) {
            self.foldButton.selected =!self.foldButton.selected;
            [_delegate clickFoldEvent:self];
        }
    }
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
