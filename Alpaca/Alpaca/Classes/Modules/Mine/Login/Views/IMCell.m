//
//  IMCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "IMCell.h"
#import "IMModel.h"
#import "MOLWebViewController.h"
#import "BookDetailViewController.h"
#import "BookModel.h"

@interface  IMCell()
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)IMModel *bookModel;
@end

@implementation IMCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bookModel =[IMModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(IMModel *)model indexPath:(NSIndexPath *)indexPath{
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
    [coverImage setImage:[UIImage imageNamed:@"headerD"]];
    //[coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage?model.coverImage:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    [self.contentView addSubview:coverImage];
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: MEDIUM_FONT(16)];
    [bookName setTextColor:HEX_COLOR(0x4A4A4A)];
    [bookName setText: model.title?model.title:@""];
    [self.contentView addSubview:bookName];
    
    YYLabel *time =[YYLabel new];
    [time setFont: REGULAR_FONT(10)];
    [time setTextColor:HEX_COLOR(0x9B9B9B)];
    //[time setText: [NSString mol_timeWithTimeString:model.createTime formatter:@"YYYY-MM-dd hh:mm:ss"]];
    NSString *timeStr =[NSString mol_timeWithTimestampString:[NSString stringWithFormat:@"%ld",model.createTime] formatter:@"YYYY-MM-dd hh:mm:ss"];
   
    [time setText:timeStr];
    [self.contentView addSubview:time];
    
    YYLabel *bookDesc =[YYLabel new];
    [bookDesc setFont: REGULAR_FONT(14)];
    [bookDesc setTextColor:HEX_COLOR(0x4A4A4A)];
    [bookDesc setText: model.content?model.content:@""];
    [bookDesc setNumberOfLines:0];
    [bookDesc setPreferredMaxLayoutWidth:KSCREEN_WIDTH - 16*2.0 -40-9];
    [self.contentView addSubview:bookDesc];
    
    UIButton *lookDetail =[UIButton buttonWithType:UIButtonTypeCustom];
    [lookDetail setTitle:@"查看详情" forState:UIControlStateNormal];
    [lookDetail setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
    [lookDetail.titleLabel setFont:REGULAR_FONT(12)];
    [lookDetail setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [lookDetail addTarget:self action:@selector(lookDetailEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:lookDetail];
    
    if (model.msgType ==0) {
        [lookDetail setAlpha:0];
    }
    
    
    UIView *bottomLine =[UIView new];
    [bottomLine setBackgroundColor: HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:bottomLine];
    
    //////////////////////////////////////////////
    CGFloat kwidth =0.0;
    kwidth =KSCREEN_WIDTH-16*2.0-40-9;
    
    
    __weak typeof(self) wself = self;
    
    [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(coverImage.mas_right).offset(9);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(27);
    }];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wself.contentView).offset(-16);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(bookName.mas_centerY);
    }];
    
    NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model.content?model.content:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(12)];
    
    CGFloat bookDescHeight =0.0;
    
    bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:kwidth font:REGULAR_FONT(14)];
    
    [bookDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookName.mas_bottom);
        make.left.mas_equalTo(coverImage.mas_right).offset(9);
        make.width.mas_equalTo(kwidth);
        make.height.mas_equalTo(bookDescHeight);
    }];
    
    [lookDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookDesc.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(coverImage.mas_right).offset(9);
        make.width.mas_equalTo(48+20);
        make.height.mas_equalTo(20);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(KSCREEN_WIDTH-15*2.0);
        make.height.mas_equalTo(1);
    }];
    
    // 还可增设间距
    //CGFloat spacing = 5;
    // 图片右移
    CGFloat  imageWidth = CGRectGetWidth(lookDetail.imageView.bounds);
    // 文字左移
    CGFloat titleWidth =CGRectGetWidth(lookDetail.titleLabel.bounds);
    
    lookDetail.titleEdgeInsets = UIEdgeInsetsMake(0.0,-imageWidth, 0.0, imageWidth);
    
    lookDetail.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleWidth, 0.0, -titleWidth);
    
    [lookDetail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //  [moreButton sizeToFit];
    
}

- (void)lookDetailEvent{
    
    if (self.bookModel.info.length) {
        if (self.bookModel.msgType ==1) {//h5
            
            MOLWebViewController *web =[MOLWebViewController new];
            web.urlString =self.bookModel.info;
            [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:web animated:YES];
            
        }else if(self.bookModel.msgType ==2){//书籍 详情
            BookModel *dto =[BookModel new];
            dto.bookId =self.bookModel.info.integerValue;
            BookDetailViewController *bookDetail =[BookDetailViewController new];
            bookDetail.model =dto;
            [[[GlobalManager shareGlobalManager] global_currentViewControl].navigationController pushViewController:bookDetail animated:YES];
            
        }else if(self.bookModel.msgType ==3){//分类 详情
            
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
