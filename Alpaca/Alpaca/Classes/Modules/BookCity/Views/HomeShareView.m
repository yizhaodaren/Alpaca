//
//  HomeShareView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeShareView.h"


static const CGFloat kCancelHeight =57.0;
static const CGFloat kDistance =10.0;
static const NSInteger kMenuCout =5;

@interface HomeShareView()
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,assign)HomeShareViewType currentShareType;
@property (nonatomic,strong)BookModel *currentModel;
@end

@implementation HomeShareView
{
    UIView *bgView;
    UIView *contentBgView;
    UIView *contentView;

    UIButton *cancelBtn;
    
    NSArray *iconArr;
    CGFloat kContentHeight;
}


+ (void)showHomeShareViewIcon:(NSArray *)_iconArr{
    HomeShareView *share =[[HomeShareView alloc] initWithIcon:_iconArr];
    [share show];
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:bgView];
    
    // ------View出现动画
    contentView.transform = CGAffineTransformMakeTranslation(0.01, kContentHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self-> contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        iconArr =[NSArray new];
        self.currentModel =[BookModel new];
        kContentHeight = 112;
    }
    return self;
}

- (instancetype)initWithIcon:(NSArray *)iconArr_
{
    self = [super init];
    if (self) {
        iconArr =[NSArray new];
        iconArr = iconArr_;
        [self contentIcon:iconArr];
        
    }
    return self;
}



//需要分享图标  分享名称
- (void)contentIcon:(NSArray *)_iconArr{
    
    if (self.currentBusinessType == HomeShareViewBookDetailType) {
           kContentHeight = 112 + 100;
    }
    
    CGFloat kContentWidth =KSCREEN_WIDTH-kDistance*2.0;
    CGFloat kContentBgHeight =kContentHeight+kDistance*3.0+kCancelHeight;
    
    iconArr = _iconArr;
    
    bgView =[UIView new];
    [bgView setFrame:[[UIScreen mainScreen] bounds]];
    [bgView setUserInteractionEnabled:YES];
    [bgView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.3)];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundEvent:)];
    [bgView addGestureRecognizer:tap];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:bgView];
    
    contentBgView =[UIView new];
    [contentBgView setFrame:CGRectMake(0,KSCREEN_HEIGHT-kContentHeight-kDistance*3.0-kCancelHeight, KSCREEN_WIDTH,kContentBgHeight)];
    [bgView addSubview:contentBgView];
    
    contentView =[UIView new];
    
    [contentView setFrame:CGRectMake(kDistance,kDistance, kContentWidth,kContentHeight)];
  
   
    [contentView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff,1.0)];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    

    [contentBgView addSubview:contentView];
    

    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(kDistance,contentView.bottom+kDistance,kContentWidth, kCancelHeight)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:REGULAR_FONT(20)];
    [cancelBtn setTag:1004];
    [cancelBtn setBackgroundColor:HEX_COLOR_ALPHA(0xffffff,1.0)];
    [cancelBtn addTarget:self action:@selector(cancelActionEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:cancelBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = cancelBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    cancelBtn.layer.mask = maskLayer1;
    [contentBgView addSubview:cancelBtn];
    
    
    // ------View出现动画
    contentBgView.transform = CGAffineTransformMakeTranslation(0.01,kContentBgHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        self-> contentBgView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);

    }];
    
    
    
 //   NSLog(@"iconArr.count :%lf",ceil(iconArr.count/5.0));

    //左右间距 21
    //上下间距 25
    //宽高 W * H 50*75
    //顶部 17
    //left = right 20
    
    //列 5  行2
    
    for (int i=0; i<ceil(iconArr.count/5.0); i++) {
        //应该有更好的解决方案
        for (int j=0; j<kMenuCout; j++) {
            // x 20+j*(w+w1)
            // y 17+i*(w+w1)  68 61
            
            if ((kMenuCout*i+j)>=iconArr.count) {
                return;
            }
//            NSLog(@"i:%d --- j:%d",i,j);
            UIButton *iconBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [iconBtn setFrame:CGRectMake(20+j*(50+(kContentWidth-20*2.0-5*50)/4.0),17+i*(75+25),50, 75)];

            [iconBtn setImage:[UIImage imageNamed:iconArr[kMenuCout*i+j]] forState:UIControlStateNormal];
            iconBtn.tag =1000+kMenuCout*i+j;
            [iconBtn addTarget:self action:@selector(shareActionEvent:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:iconBtn];
        }
        
    }
    
    

}

-(void)tapBackgroundEvent:(UITapGestureRecognizer *)tap{
    [self cancelActionEvent];
}


- (void)shareActionEvent:(UIButton *)btn{
    
        switch (btn.tag%1000) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
            case 5: //详情
                self.currentShareType = HomeShareViewBookDetail;
                break;
        }
    
    if (_delegate && [_delegate respondsToSelector:@selector(homeShareView: businessType:type:)]) {
        [self cancelUI];
        [_delegate homeShareView:self.currentModel businessType:self.currentBusinessType type:self.currentShareType];
    }
}

- (void)cancelActionEvent{
    self.currentShareType =HomeShareViewCancel;
    if (_delegate && [_delegate respondsToSelector:@selector(homeShareView: businessType:type:)]) {
        [self cancelUI];
        [_delegate homeShareView:self.currentModel businessType:self.currentBusinessType type:self.currentShareType];
    }
}

-(void)cancelUI{
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        self->contentBgView.transform = CGAffineTransformMakeTranslation(0.01,kContentHeight+kDistance*3.0+kCancelHeight);

    } completion:^(BOOL finished) {
        [self->cancelBtn removeFromSuperview];
        [self->contentView removeFromSuperview];
        [self->contentBgView removeFromSuperview];
        [self->bgView removeFromSuperview];
        [wself removeFromSuperview];
        
        
    }];

}

- (void)setDto:(BookModel *)dto{
    if (!self.currentModel) {
        self.currentModel =[BookModel new];
    }
    self.currentModel =dto;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
