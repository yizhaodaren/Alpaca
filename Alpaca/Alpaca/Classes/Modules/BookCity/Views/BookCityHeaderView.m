//
//  BookCityHeaderView.m
//  Alpaca
//
//  Created by xujin on 2018/11/26.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookCityHeaderView.h"
#import "BookCityModel.h"
#import "TimerView.h"
#import "BookListViewController.h"

@interface  BookCityHeaderView()
@property (nonatomic, assign)NSInteger currentSection;
@property (nonatomic, strong)BookCityModel *currentModel;
@end

@implementation BookCityHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.currentModel =[BookCityModel new];
        [self.contentView setBackgroundColor:HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)headerViewcontent:(BookCityModel *)model section:(NSInteger)section{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    if (section) {
        self.currentSection = section;
    }
    
    if (model) {
        self.currentModel =model;
    }
    
    UILabel * titleLable =[UILabel new];
    [titleLable setTextColor:HEX_COLOR(0x000000)];
    [titleLable setFont: SourceHanSerifCNBold_FONT(20)];
    [titleLable setText: model.recomName?model.recomName:@""];
    [titleLable setFrame:CGRectMake(15, 20, 0, 29)];
    [titleLable sizeToFit];
    [self.contentView addSubview:titleLable];
    
    if (model.hasMore) {
        UIButton *moreButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:HEX_COLOR(0x6E6E6E) forState:UIControlStateNormal];
        [moreButton.titleLabel setFont: REGULAR_FONT(14)];
        [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [moreButton setFrame:CGRectMake(KSCREEN_WIDTH-15-56-20,0, 56+20, 49)];
        moreButton.centerY =titleLable.centerY;
        
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
        
        [self.contentView addSubview:moreButton];
        
    }else if (model.remainTime){
        
        TimerView *timerView =[TimerView new];
        
        [timerView setFrame:CGRectMake(titleLable.right+10,titleLable.top,52,29)];
        timerView.remainTime =model.remainTime;
        [self.contentView addSubview:timerView];
    }
    
}

#pragma mark action event
- (void)moreButtonEvent:(UIButton *)sender{
    
    BookListViewController *bookList =BookListViewController.new;
    bookList.cityModel =self.currentModel;
    bookList.featureStyle =FeatureTypeStyle_More;
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:bookList animated:YES];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
