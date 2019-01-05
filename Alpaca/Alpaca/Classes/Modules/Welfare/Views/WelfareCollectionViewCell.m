//
//  WelfareCollectionViewCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareCollectionViewCell.h"
#import "WelfareModel.h"
@interface WelfareCollectionViewCell()
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)WelfareModel *currentModel;
@property (nonatomic, assign)CGRect cellFrame;
@end
@implementation WelfareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentModel =[WelfareModel new];
        self.cellFrame =frame;
    }
    return self;
}

- (void)content:(WelfareModel *)model indexPath:(NSIndexPath *)indexPath{
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    if (indexPath) {
        self.currentIndex = indexPath;
    }
    
    if (model) {
        self.currentModel =model;
    }
    
    YYLabel *lable =[YYLabel new];
    [lable setTextColor: HEX_COLOR(0x4A4A4A)];
    [lable setFont: REGULAR_FONT(16)];
    
    [self.contentView addSubview:lable];
    
    UIImageView *imageview =[UIImageView new];
   // [imageview setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.contentView addSubview:imageview];
    
    [lable setText:model.title?model.title:@""];
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:model.coverImg?model.coverImg:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    __weak typeof(self) wself = self;
    [lable mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(wself.contentView);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(20);
    }];
    
    [imageview mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(wself.contentView);
        make.top.mas_equalTo(lable.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(100);
    }];
    
}
@end
