//
//  BookDetailGuideCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookDetailGuideCell.h"
#import "BookCatalogueViewController.h"
#import "BookModel.h"

@interface  BookDetailGuideCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *bookModel;

@end
@implementation BookDetailGuideCell

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
    
    YYLabel *bookName =[YYLabel new];
    [bookName setFont: REGULAR_FONT(16)];
    [bookName setTextColor:HEX_COLOR(0x000000)];
    [bookName setText:@"目录"];
    [self.contentView addSubview:bookName];
    
    
    UIButton *moreButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:[NSString stringWithFormat:@"共%ld章",model.chapterCount] forState:UIControlStateNormal];
    [moreButton setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
    [moreButton.titleLabel setFont: REGULAR_FONT(12)];
    [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:moreButton];
    
   
    
    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:lineView];
    
    
    //////////////////////////////////////////////
    __weak typeof(self) wself = self;
    [bookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(22);
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView);
        make.right.mas_equalTo(-15);
        make.left.mas_greaterThanOrEqualTo(bookName.mas_right);
        make.height.mas_equalTo(44);
    }];
    // 还可增设间距
    //CGFloat spacing = 5;
    // 图片右移
    CGFloat  imageWidth = CGRectGetWidth(moreButton.imageView.bounds);
    // 文字左移
    CGFloat titleWidth =CGRectGetWidth(moreButton.titleLabel.bounds);
    
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,-imageWidth, 0.0, imageWidth);
    
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleWidth, 0.0, -titleWidth);
    
    [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //  [moreButton sizeToFit];
    
    
   
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.contentView.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark action event
- (void)moreButtonEvent:(UIButton *)sender{
    
    BookCatalogueViewController *catalogue =BookCatalogueViewController.new;
    catalogue.isPush =YES;
    catalogue.model =self.bookModel;
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:catalogue animated:YES];
   
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
