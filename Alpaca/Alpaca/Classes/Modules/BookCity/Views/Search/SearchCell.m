//
//  SearchCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "SearchCell.h"
#import "BookModel.h"
@interface  SearchCell()
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)BookModel *bookModel;
@end

@implementation SearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bookModel =[BookModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
       // [self.contentView setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
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
    [bookDesc setText: model.bookDesc?model.bookDesc:@""];
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
    
    if (type ==1 || type==2) {
       
        kwidth =KSCREEN_WIDTH-16*2.0-64-83;
    }else{
        
        kwidth =KSCREEN_WIDTH-16*2.0-64-10;
    }
    
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(88);
    }];
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(coverImage.mas_right).offset(10);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(21);
    }];
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookDesc?model.bookDesc:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(12)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(12)];
    
    if (bookDescHeight > 22*2.0) {
        bookDescHeight =22*2.0;
    }
    
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
    
    
    [author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomLine.mas_bottom).offset(-10);
        make.left.mas_equalTo(coverImage.mas_right).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(17);
    }];
    
    //////////////////////////////////////////////
    
    //model.tags =(NSMutableArray *)[[model.tags reverseObjectEnumerator] allObjects];
    
    if (type !=1) {
        
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
            CGFloat kTagRightWidth =15;
            
            
            
            [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(bottomLine.mas_bottom).offset(-10);
                
                // make.right.mas_equalTo(-(kTagRightWidth+(kTagSpacer+tagWidth)*i));
                if (i==0) {
                    make.right.mas_equalTo(-16);
                }else{
                    make.right.mas_equalTo(oldTag.mas_left).offset(-kTagSpacer);
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
