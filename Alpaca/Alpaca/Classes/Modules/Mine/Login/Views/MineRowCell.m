//
//  MineRowCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/19.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "MineRowCell.h"
#import "MineInfoModel.h"

@interface MineRowCell()
@property (nonatomic, strong)NSIndexPath *currentIndexPath;
@property (nonatomic, strong)MineInfoModel *infoModel;

@end

@implementation MineRowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.infoModel =[MineInfoModel new];
        
    }
    return self;
}

- (void)cellContent:(MineInfoModel *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    
    if (model) {
        self.infoModel =model;
    }
    
    UIImageView *icon=[UIImageView new];
    [icon setImage:[UIImage imageNamed:model.icon?model.icon:@""]];
    [self.contentView addSubview:icon];
    

    UILabel *titleLable =[UILabel new];
    [titleLable setTextColor:HEX_COLOR(0x4A4A4A)];
    [titleLable setFont:REGULAR_FONT(15)];
    [titleLable setText:model.title?model.title:@""];
    [self.contentView addSubview:titleLable];
    
    YYLabel *moneyLable =[YYLabel new];
    [moneyLable setTextColor:HEX_COLOR(0xF5A623)];
    [moneyLable setFont:REGULAR_FONT(11)];
    [moneyLable setTextAlignment:NSTextAlignmentRight];
    [moneyLable setAlpha:0];
    if (model.info.length) {
        [moneyLable setAlpha:1];
    }
    [moneyLable setText:model.info];
    [self.contentView addSubview:moneyLable];
    
//    UIImageView *redPacket=[UIImageView new];
//    [redPacket setImage:[UIImage imageNamed:@"samllRed"]];
//    [self.contentView addSubview:redPacket];
//
//    if (model.type != 101) {
//        [redPacket setAlpha:0];
//    }

    UIImageView *arrows=[UIImageView new];
    [arrows setImage:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:arrows];
    
    
    

    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR(0xF6F8FB)];
    [self.contentView addSubview:lineView];

    
    if ([model.title isEqualToString:@"退出登录"]) {
        [arrows setHidden:YES];
        [lineView setHidden:YES];
    }
    
    
    __weak typeof(self) wself = self;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView).offset(12);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
        
    }];
    

    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.height.mas_equalTo(21);
        make.left.mas_equalTo(icon.mas_right).offset(5);
        make.width.mas_equalTo(120);
    }];
    

    [arrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.width.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    [moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(arrows.mas_left);
        make.left.mas_greaterThanOrEqualTo(titleLable.mas_right);
       // make.width.mas_equalTo(120);
    }];
    
//    [redPacket mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(icon);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(26);
//        make.right.mas_equalTo(arrows.mas_left);
//    }];
    
   
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.contentView.mas_bottom).offset(-1);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
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
