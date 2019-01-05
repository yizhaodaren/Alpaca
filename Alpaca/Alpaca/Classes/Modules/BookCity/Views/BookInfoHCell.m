//
//  BookInfoHCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookInfoHCell.h"
#import "BookModel.h"

@interface  BookInfoHCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *bookModel;

@end

@implementation BookInfoHCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bookModel =[BookModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(BookModel *)model indexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    if (model) {
        self.bookModel =model;
    }
    
    
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
    [bookDesc setTextColor:HEX_COLOR(0x6E6E6E)];
    [bookDesc setText: model.bookDesc?model.bookDesc:@""];
    [bookDesc setNumberOfLines:0];
    [bookDesc setPreferredMaxLayoutWidth:KSCREEN_WIDTH - 15*2.0 -12.0];
    [self.contentView addSubview:bookDesc];
    
    YYLabel *author =[YYLabel new];
    [author setFont: REGULAR_FONT(14)];
    [author setTextColor:HEX_COLOR(0xB2B2B2)];
    [author setText: model.author?model.author:@""];
    [self.contentView addSubview:author];
    
    
    UIView *bottomLine =[UIView new];
    [bottomLine setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:bottomLine];
    
    //////////////////////////////////////////////
    CGFloat kwidth =0.0;
    if (type ==100) {
        kwidth =KSCREEN_WIDTH-15*2.0-12-86-83;
    }else{
        kwidth =KSCREEN_WIDTH-15*2.0-12-86;
    }
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(116);
    }];
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(coverImage.mas_right).offset(12);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(24);
    }];
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.bookDesc?model.bookDesc:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
    
    CGFloat bookDescHeight =0.0;

    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(14)];
    
    if (type == 2) { //更多
        if (bookDescHeight > 60) {
            bookDescHeight =60;
        }
    }else{
        if (bookDescHeight > 40) {
            bookDescHeight =40;
        }
    }
    
    [bookDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom).offset(6);
        make.left.mas_equalTo(coverImage.mas_right).offset(12);
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
        make.bottom.mas_equalTo(bottomLine.mas_bottom).offset(-15);
        make.left.mas_equalTo(coverImage.mas_right).offset(12);
        make.width.mas_equalTo(70);
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
        CGFloat kTagRightWidth =15;
        
        
        
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomLine.mas_bottom).offset(-15);
            
           // make.right.mas_equalTo(-(kTagRightWidth+(kTagSpacer+tagWidth)*i));
            if (i==0) {
                make.right.mas_equalTo(-15);
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


- (void)userEvent{
    
}

- (void)userNameEvent:(UIButton *)sender{
    
    if (![UserManagerInstance user_isLogin]) {
        [[GlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
}

- (void)avatarEvent:(UITapGestureRecognizer *)sender{
    
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
