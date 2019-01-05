//
//  BookDCopyrightCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/28.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookDCopyrightCell.h"
#import "BookModel.h"

@interface  BookDCopyrightCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)BookModel *bookModel;

@end

@implementation BookDCopyrightCell

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
    
    TYAttributedLabel *tipLabel = [[TYAttributedLabel alloc]init];
    [tipLabel setBackgroundColor: [UIColor clearColor]];
    [self.contentView addSubview:tipLabel];
    
    
    NSString *text =model.bookCopyRight;
    
    
    // 属性文本生成器
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    // textContainer.textAlignment = NSTextAlignmentRight;
    [textContainer setStrokeColor: [UIColor clearColor]];
    [textContainer setTextColor:HEX_COLOR(0xB2B2B2)];
    [textContainer setFont: REGULAR_FONT(12)];
    
   // [textContainer addLinkWithLinkData:@"可赚 543 元。" linkColor:HEX_COLOR(0xD16710) underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:@"可赚 543 元。"]];
    
    tipLabel.textContainer =textContainer;
    
    __weak typeof(self) wself = self;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(wself.contentView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.right.mas_equalTo(model.copyrightHeight);
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
