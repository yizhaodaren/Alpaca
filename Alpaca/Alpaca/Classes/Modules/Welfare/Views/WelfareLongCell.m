//
//  WelfareLongCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareLongCell.h"
#import "WelfareModel.h"
@interface  WelfareLongCell()
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)WelfareModel *welfareModel;


@end

@implementation WelfareLongCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.welfareModel =[WelfareModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];

    }
    return self;
}



- (void)cellContent:(WelfareModel *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndex = indexPath;
    }
    
    if (model) {
        self.welfareModel =model;
    }
    
    YYLabel *lable =[YYLabel new];
    [lable setTextColor: HEX_COLOR(0x4A4A4A)];
    [lable setFont: REGULAR_FONT(16)];
   
    [self.contentView addSubview:lable];
    
    UIImageView *imageview =[UIImageView new];
    //[imageview setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.contentView addSubview:imageview];
    
    [lable setText:model.title?model.title:@""];
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:model.coverImg?model.coverImg:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    
    __weak typeof(self) wself = self;
    [lable mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];

    [imageview mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(lable.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(100);
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
