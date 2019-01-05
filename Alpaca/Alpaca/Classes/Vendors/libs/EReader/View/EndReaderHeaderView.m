//
//  EndReaderHeaderView.m
//  Alpaca
//
//  Created by apple on 2018/12/26.
//  Copyright © 2018 Moli. All rights reserved.
//

#import "EndReaderHeaderView.h"
#import "UIButton+MOLButtonExtention.h"
@interface EndReaderHeaderView()

@property(nonatomic,strong)UIView  *topView;
@property(nonatomic,strong)UIView  *bottomView;
@property(nonatomic,strong)UIImageView  *statuImageView;
@property(nonatomic,strong)UILabel  *label1;
@property(nonatomic,strong)UILabel  *label2;
@end

@implementation EndReaderHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.3)];
       
         [self layoutUI];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self layoutUI];
        
    }
    return self;
}

- (void)layoutUI{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,KSCREEN_WIDTH - 15*2 , 168)];
//    self.topView.backgroundColor = [UIColor redColor];
    [self addSubview:self.topView];
    
     self.statuImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KSCREEN_WIDTH- 15*2 - 60)/2, 20, 60, 60)];
    self.statuImageView.image = [UIImage imageNamed:@"E_NoFinsh"];
    [self.topView addSubview:self.statuImageView];
    
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.topView.width,20)];
    self.label1.textAlignment  = NSTextAlignmentCenter;
    self.label1.text = @"未完待续";
    self.label1.font = [UIFont systemFontOfSize:14];
    self.label1.textColor = HEX_COLOR(0x979FAC);
    [self.topView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 128,self.topView.width, 20)];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.font  = [UIFont systemFontOfSize:14];
    self.label2.text = @"作者努力更新中，后续章节敬请期待…";
    self.label2.textColor = HEX_COLOR(0x979FAC);
    [self.topView addSubview:self.label2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(-15, self.topView.bottom, self.topView.width + 30, 5)];
    lineView.backgroundColor = HEX_COLOR(0xF6F8FB);
    [self addSubview:lineView];
    
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom + 5,  self.topView.width, 50)];
//    self.bottomView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.bottomView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 10, 217, 29 )];
    moreLabel.text = @"同类型热门好书";
    [moreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    moreLabel.textColor = [UIColor blackColor];
    [self.bottomView addSubview:moreLabel];
    
    
    self.moreBtn = [UIButton buttonWithType:0];
//    moreBtn.frame = CGRectMake(self.bottomView.width - 100, 15, 100, 20);
    [self.moreBtn setTitleColor:HEX_COLOR(0x6E6E6E) forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.moreBtn setImage:[UIImage imageNamed:@"bookcasemore"] forState:UIControlStateNormal];

    [self.moreBtn sizeToFit];
    self.moreBtn.centerY = moreLabel.centerY;
    self.moreBtn.right = self.bottomView.right + 8;
    
    [self.moreBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:0];
//    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.moreBtn];

}
-(void)setStatusFished{
    self.label1.text = @"完结撒花";
    self.label2.text = @"快去挑选其他喜欢的书籍吧";
    self.statuImageView.image = [UIImage imageNamed:@"E_Finsh"];
    
}

@end
