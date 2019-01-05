//
//  E_SettingBottomBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingBottomBar.h"
#import "E_ContantFile.h"
#import "E_CommonManager.h"
#import "ILSlider.h"
#import "E_HUDView.h"
#import "E_ColorModel.h"
#import "TJThemeManager.h"
#import "ThemeRedTemplate.h"
#import "ThemeYellowTemplate.h"



#define MAX_FONT_SIZE 28
#define MIN_FONT_SIZE 16
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@interface  E_SettingBottomBar()
@property (nonatomic, weak)UIButton *menuBtn;
@property (nonatomic, weak)UIButton *lightBtn;
@property (nonatomic, weak)UIButton *fontBtn;
@property (nonatomic, weak)UIView *menuBgView;
@property (nonatomic, weak)UIView *fontBgView;
@property (nonatomic, weak)UIView *lightBgView;
@property (nonatomic, strong)E_ColorModel *themeID;





@end

@implementation E_SettingBottomBar
{
    ILSlider *ilSlider;
    UILabel  *showLbl;
    BOOL isFirstShow;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR_ALPHA(0xffffff,1.0);
        isFirstShow = YES;
        
        [self setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
        [self addGestureRecognizer:tap];
        
        
        
        [self initData];
        
        [self configUI];
    }
    return self;
    
}

- (void)tapEvent{
}

- (void)initData{
    
    self.colorArr=[NSMutableArray array];
    
   // NSArray *colorD =@[@"#F8F8FA",@"#D8EAD4",@"#EFDBB8",@"niupizhi",@"#4A4A4A",];
  //  NSArray *colorS =@[@"#F8F8FA",@"#D8EAD4",@"#EFDBB8",@"niupizhi",@"#4A4A4A",];
  //  NSArray *border =@[@"#E5E8EC",@"#D8EAD4",@"#EFDBB8",@"",@"#4A4A4A"];
    
    
    NSArray *colorD =@[@"E_grey",@"E_green",@"E_yellow",@"E_niupizhi",@"E_black",];
    NSArray *colorS =@[@"E_greyselected",@"E_greenselected",@"E_yellowselected",@"E_niupizhiselected",@"E_blackselected",];
    NSArray *border =@[@"#E5E8EC",@"#D8EAD4",@"#EFDBB8",@"",@"#4A4A4A"];
    for (NSInteger i=0; i<colorD.count; i++) {
        E_ColorModel *model =[E_ColorModel new];
        if ([colorD[i] hasPrefix:@"#"]) {//色值
            model.colorType =E_ColorType_Hex;
            model.colorD =colorD[i];
            model.colorS =colorS[i];
            model.colorB =border[i];
            
        }else{//图片
            
            if ([colorD[i] isEqualToString:@"nightDefault"]) {
                model.colorType =E_colorType_Night;
                model.colorD =@"#0C0C0E";
                model.colorS =@"#0C0C0E";
                model.smallImageD =colorD[i];
                model.smallImageS =colorS[i];
                  model.colorB =border[i];
            }else{
                model.colorType =E_ColorType_Image;
                model.colorD =colorD[i];
                model.colorS =colorS[i];
                model.smallImageD =colorD[i];
                model.smallImageS =colorS[i];
                model.colorB =border[i];
                if ([colorD[i] isEqualToString:@"E_niupizhi"]) {
                    model.bigImage =@"bg";
                }
            }
            
        }
        [self.colorArr addObject:model];
    }
    
    self.themeID =[E_ColorModel new];
    self.themeID =[E_CommonManager Manager_getReadTheme];
    if (!self.themeID) {
        self.themeID =[E_ColorModel new];
    }
    
   
}


- (void)changeBottomBarColor{
    if (self.themeID.colorType == E_colorType_Night) {//夜间模式
        [self nightColor];
    }else{//否则
        [self defineColor];
    }
}


- (void)configUI{
    
    [self configMenuUI];
    [self configLightUI];//字体
//    [self confitFontUI];
    [self changeBottomBarColor];

#if 0
    UIButton *commentBtn = [UIButton buttonWithType:0];
    [commentBtn setImage:[UIImage imageNamed:@"reader_comments.png"] forState:0];
    [commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.frame = CGRectMake(self.frame.size.width - 70, self.frame.size.height - 54, 60, 44);
    [self addSubview:commentBtn];
    
    
    _bigFont = [UIButton buttonWithType:0];
    _bigFont.frame = CGRectMake(110 + (self.frame.size.width - 200)/2, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [_bigFont setImage:[UIImage imageNamed:@"reader_font_increase.png"] forState:0];
    _bigFont.backgroundColor = [UIColor clearColor];
   
    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_bigFont];
    
    _smallFont = [UIButton buttonWithType:0];
   
    [_smallFont setImage:[UIImage imageNamed:@"reader_font_decrease.png"] forState:0];
    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    _smallFont.frame =  CGRectMake(90, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [self addSubview:_smallFont];
    

    showLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, self.frame.size.height - kBottomBarH - 70, self.frame.size.width - 140 , 60)];
    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [showLbl setTextColor:[UIColor whiteColor]];
    showLbl.font = [UIFont systemFontOfSize:18];
    showLbl.textAlignment = NSTextAlignmentCenter;
    showLbl.numberOfLines = 2;
    showLbl.alpha = 0.7;
    showLbl.hidden = YES;
    [self addSubview:showLbl];
    
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40 - 50 , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        
        if (!isFirstShow) {
            showLbl.hidden = NO;
            double percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
            showLbl.text = [NSString stringWithFormat:@"第%ld章\n%.1f%@",_currentChapter,percent*100,@"%"];
        }
        isFirstShow = NO;
       
       
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        
        showLbl.hidden = YES;
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        NSInteger page = (NSInteger)round(percent * _chapterTotalPage);
        if (page == 0) {
            page = 1;
        }
        [_delegate sliderToChapterPage:page];
    }];

    [self addSubview:ilSlider];
   
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 54 - 40 - 50, 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setTitle:@"上一章" forState:0];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:preChapterBtn];
    
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 54 - 40 - 50, 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setTitle:@"下一章" forState:0];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:nextChapterBtn];
    
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 54 - 50 , self.frame.size.width - 60, 40)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [self addSubview:themeScroll];
    
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    
    for (int i = 1; i <= 4; i ++) {
        
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(0 + 36*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
        
        if (i == 1) {
            [themeButton setBackgroundColor:[UIColor whiteColor]];
            
        }else{
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateSelected];
        }
        
        if (i == themeID) {
            themeButton.selected = YES;
        }
        
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateHighlighted];
        themeButton.tag = 7000+i;
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];

    }
#endif
}

- (void)configMenuUI{
    
    UIView *menuBgView =[UIView new];
    [menuBgView setBackgroundColor:HEX_COLOR(0xffffff)];
    self.menuBgView =menuBgView;
    [self addSubview:menuBgView];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
    [menuBgView addSubview:menuBtn];
    
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lightBtn = lightBtn;
    [lightBtn setImage:[UIImage imageNamed:@"reader_night"] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"Shape+"] forState:UIControlStateSelected];
    if (self.themeID.colorType == E_colorType_Night) {//夜间模式
        lightBtn.selected = YES;
    }else{//否则
        lightBtn.selected = NO;
    }
//    [lightBtn addTarget:self action:@selector(showLightView) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn addTarget:self action:@selector(lightAction:) forControlEvents:UIControlEventTouchUpInside];
    lightBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
    [menuBgView addSubview:lightBtn];
    
    UIButton *fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fontBtn setImage:[UIImage imageNamed:@"fount+"] forState:UIControlStateNormal];
//    [fontBtn addTarget:self action:@selector(showFontView) forControlEvents:UIControlEventTouchUpInside];
    [fontBtn addTarget:self action:@selector(showLightView) forControlEvents:UIControlEventTouchUpInside];
    fontBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
    [menuBgView addSubview:fontBtn];
    
    __weak typeof(self) wself = self;
    CGFloat spaceFloat =(kScreenW-60*2.0-49*3.0)/2.0;
    
    [menuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(wself);
        make.height.mas_equalTo(KTabbarHeight);
    }];
    
    [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.width.height.mas_equalTo(49);
        make.top.mas_equalTo(menuBgView);
    }];
    
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(menuBtn.mas_right).mas_offset(spaceFloat);
        make.width.height.mas_equalTo(49);
        make.top.mas_equalTo(menuBgView);
    }];
    [fontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lightBtn.mas_right).mas_offset(spaceFloat);
        make.width.height.mas_equalTo(49);
        make.top.mas_equalTo(menuBgView);
    }];
};

- (void)configLightUI{
    
    UIView *lightBgView =[UIView new];
    [lightBgView setBackgroundColor:[UIColor whiteColor]];
    //[lightBgView setUserInteractionEnabled:NO];
    [lightBgView setAlpha:0];
    self.lightBgView =lightBgView;
    [self addSubview:lightBgView];
    
    UIButton *blackRightness = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [blackRightness setImage:[UIImage imageNamed:@"Shape+"] forState:UIControlStateNormal];
    blackRightness.backgroundColor = [UIColor clearColor];
    
  //  [blackRightness addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    
    [lightBgView addSubview:blackRightness];
    
    UISlider *sliderRightness =[UISlider new];
    sliderRightness.minimumValue =0.1;
    sliderRightness.maximumValue =1;
    
    if (![E_CommonManager readBrightness]) {
        sliderRightness.value =[E_CommonManager brightness_];
    }else{
        sliderRightness.value =[E_CommonManager readBrightness];
    }
    
    
    [sliderRightness setTintColor:HEX_COLOR_ALPHA(0x000000, 0.4)];
    [sliderRightness setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x000000, 0.2)];
    [sliderRightness addTarget:self action:@selector(sliderRightnessValueChanged:) forControlEvents:UIControlEventValueChanged];
   
    self.sliderBrightness =sliderRightness;
    [lightBgView addSubview:sliderRightness];
    
    UIButton *whiteRightness = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [whiteRightness setImage:[UIImage imageNamed:@"Shape-"] forState:UIControlStateNormal];
  //  [whiteRightness addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    [lightBgView addSubview:whiteRightness];
    
    _xitongBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_xitongBtn setImage:[UIImage imageNamed:@"xitong"] forState:UIControlStateNormal];
    [_xitongBtn setImage:[UIImage imageNamed:@"xitong_pressed"] forState:UIControlStateSelected];
    
    
    [_xitongBtn addTarget:self action:@selector(xitongAction:) forControlEvents:UIControlEventTouchUpInside];
    [lightBgView addSubview:_xitongBtn];

    
    __weak typeof(self) wself = self;
    
    [lightBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(wself);
        make.height.mas_equalTo(230);
    }];
    [blackRightness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12-60-18);
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo(25);
    }];
    
    [sliderRightness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(blackRightness.mas_left).mas_offset(-19);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(blackRightness.mas_centerY);
        make.left.mas_equalTo(whiteRightness.mas_right).mas_offset(19);
    }];
    
    [whiteRightness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(blackRightness.mas_centerY);
    }];
    
    [_xitongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(blackRightness.mas_centerY);
    }];
    
    
    _smallFont = [UIButton buttonWithType:0];
    
    [_smallFont setImage:[UIImage imageNamed:@"font-day"] forState:0];
    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    
    _smallFont.width = 100;
    _smallFont.height = 30;
    _smallFont.x = 20;
    _smallFont.top = sliderRightness.bottom + 35;
    _smallFont.layer.borderWidth = 1;
    _smallFont.layer.cornerRadius  = 5;
    _smallFont.layer.borderColor = HEX_COLOR(0xE5E8EC).CGColor;
    [lightBgView addSubview:_smallFont];
    
    
    _bigFont = [UIButton buttonWithType:0];
    _bigFont.width = 100;
    _bigFont.height = 30;
    _bigFont.x = kScreenW - 20 - 100;
    _bigFont.top = sliderRightness.bottom + 35;
    [_bigFont setImage:[UIImage imageNamed:@"font+day"] forState:0];
    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    _bigFont.layer.borderWidth = 1;
    _bigFont.layer.cornerRadius  = 5;
    _bigFont.layer.borderColor = HEX_COLOR(0xE5E8EC).CGColor;
    [lightBgView addSubview:_bigFont];
    
    
    showLbl = [[UILabel alloc] init];
    
    NSUInteger fontSize = [E_CommonManager fontSize];
    showLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)fontSize];
    showLbl.font = [UIFont systemFontOfSize:18];
    showLbl.width = 50;
    showLbl.height = 20;
    showLbl.centerX = kScreenW / 2;
    showLbl.centerY = _bigFont.centerY;
        
//    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    showLbl.textAlignment = NSTextAlignmentCenter;
    showLbl.numberOfLines = 2;
    showLbl.alpha = 0.7;
    [lightBgView addSubview:showLbl];
    
    
    //行间距
    
    _lineSpacing1Btn = [UIButton buttonWithType:0];
    _lineSpacing1Btn.width = 100;
    _lineSpacing1Btn.height = 30;
    _lineSpacing1Btn.x = 20;
    _lineSpacing1Btn.top = _smallFont.bottom + 20;
    _lineSpacing1Btn.tag = 8000 + 1;
    [_lineSpacing1Btn addTarget:self action:@selector(lineSpaceingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lineSpacing1Btn setImage:[UIImage imageNamed:@"character1"] forState:UIControlStateNormal];
     [_lineSpacing1Btn setImage:[UIImage imageNamed:@"character1_presed"] forState:UIControlStateSelected];
    [lightBgView addSubview:_lineSpacing1Btn];
    
    _lineSpacing2Btn = [UIButton buttonWithType:0];
    _lineSpacing2Btn.width = 100;
    _lineSpacing2Btn.height = 30;
    _lineSpacing2Btn.centerX =  kScreenW / 2;
    _lineSpacing2Btn.top = _smallFont.bottom + 20;
    _lineSpacing2Btn.tag = 8000 + 2;
    [_lineSpacing2Btn addTarget:self action:@selector(lineSpaceingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lineSpacing2Btn setImage:[UIImage imageNamed:@"character2"] forState:UIControlStateNormal];
     [_lineSpacing2Btn setImage:[UIImage imageNamed:@"character2_presed"] forState:UIControlStateSelected];
    [lightBgView addSubview:_lineSpacing2Btn];
    
    _lineSpacing3Btn = [UIButton buttonWithType:0];
    _lineSpacing3Btn.width = 100;
    _lineSpacing3Btn.height = 30;
    _lineSpacing3Btn.x =   kScreenW - 20 - 100;
    _lineSpacing3Btn.top = _smallFont.bottom + 20;
    _lineSpacing3Btn.tag = 8000 + 3;
    [_lineSpacing3Btn addTarget:self action:@selector(lineSpaceingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lineSpacing3Btn setImage:[UIImage imageNamed:@"character3"] forState:UIControlStateNormal];
    [_lineSpacing3Btn setImage:[UIImage imageNamed:@"character3_presed"] forState:UIControlStateSelected];
    [lightBgView addSubview:_lineSpacing3Btn];

    //设置默认选中的
    if ([E_CommonManager lineSpace] == 1) {
        _lineSpacing1Btn.selected = YES;
    }else if([E_CommonManager lineSpace] == 3){
        _lineSpacing3Btn.selected = YES;
    }else{
        _lineSpacing2Btn.selected = YES;
    }
    
    
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_lineSpacing1Btn.bottom+30, kScreenW, 30)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [lightBgView addSubview:themeScroll];
    
    
    CGFloat leftSpace =20;
    CGFloat rightSpace =20;
    CGFloat width =30;
    CGFloat height =30;
    CGFloat space =(kScreenW - leftSpace-rightSpace -width*self.colorArr.count)/(self.colorArr.count-1);
    for (int i = 0; i < self.colorArr.count; i ++) {
        
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[themeButton setBackgroundColor:[UIColor blueColor]];
        themeButton.layer.cornerRadius = 2.0f;
       // themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(leftSpace+(width+space)*i,0, width, height);
        [themeButton.layer setCornerRadius:width/2.0];
        
        E_ColorModel *model =self.colorArr[i];
        
        if (model) {
            if (model.colorType ==E_ColorType_Hex) {
                [themeButton.layer setBorderColor:[STSystemHelper colorWithHexString:@"#E5E8EC"].CGColor];
                [themeButton setBackgroundColor:[STSystemHelper colorWithHexString:model.colorD]];
                
            }else if (model.colorType ==E_ColorType_Image){
                [themeButton.layer setBorderColor:[STSystemHelper colorWithHexString:@"#E5E8EC"].CGColor];
                [themeButton setImage:[UIImage imageNamed:model.smallImageD] forState:UIControlStateNormal];
                [themeButton setImage:[UIImage imageNamed:model.smallImageS] forState:UIControlStateSelected];
                
            }else if (model.colorType ==E_colorType_Night){
                [themeButton setImage:[UIImage imageNamed:model.smallImageD] forState:UIControlStateNormal];
                [themeButton setImage:[UIImage imageNamed:model.smallImageS] forState:UIControlStateSelected];
            }
        }
        
       themeButton.tag = 7000+i;
        
        NSLog(@"%@---%@",model.colorD,self.themeID.colorD)
        
        if (!self.themeID.colorD.length) {
            if (themeButton.tag == 7000) {
                themeButton.selected = YES;
                [themeButton.layer setBorderWidth:1.0];
            }
            
        }else if ([model.colorD isEqualToString: self.themeID.colorD]) {
            
            themeButton.selected = YES;
            if (themeButton.tag !=7004) {
                [themeButton.layer setBorderWidth:1.0];
            }
        }

        
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];
        
    }
    
    
   
    
}


- (void)confitFontUI{
    
    UIView *fontBgView =[UIView new];
    [fontBgView setBackgroundColor:[UIColor whiteColor]];
   // [fontBgView setUserInteractionEnabled:NO];
    [fontBgView setAlpha:0];
    self.fontBgView =fontBgView;
    [self addSubview:fontBgView];
    
    UIButton *bigFont = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bigFont setImage:[UIImage imageNamed:@"fount+"] forState:UIControlStateNormal];
    bigFont.backgroundColor = [UIColor clearColor];
    
   // [bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    
    [fontBgView addSubview:bigFont];
    
    UISlider *sliderFont =[UISlider new];
    sliderFont.minimumValue =MIN_FONT_SIZE;
    sliderFont.maximumValue =MAX_FONT_SIZE;
    NSUInteger fontSize = [E_CommonManager fontSize];
    
    sliderFont.value =(float)fontSize;
    [sliderFont setTintColor:HEX_COLOR_ALPHA(0x000000, 0.4)];
    [sliderFont setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x000000, 0.2)];
    [sliderFont addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.sliderFont =sliderFont;
    [fontBgView addSubview:sliderFont];
    
    UIButton *smallFont = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [smallFont setImage:[UIImage imageNamed:@"fount-"] forState:UIControlStateNormal];
 //   [smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    [fontBgView addSubview:smallFont];
    
    
    
    __weak typeof(self) wself = self;
    
    [fontBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(wself);
        make.height.mas_equalTo(58);
    }];
    [bigFont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo((58-20)/2.0);
    }];
    
    [sliderFont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bigFont.mas_left).mas_offset(-29);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(bigFont.mas_centerY);
        make.left.mas_equalTo(smallFont.mas_right).mas_offset(23);
    }];
    
    [smallFont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(bigFont.mas_centerY);
    }];
    
}

#pragma mark 行间距
-(void)lineSpaceingAction:(UIButton *)sender{
    NSInteger type = sender.tag % 8000;
    
    float lineSpace = 2;
    
    
    //如果改变对应的值 也需要在E_CommonManager获取的时候改变一下默认值
    switch (type) {
        case 1:
            lineSpace = 1;
            break;
        case 2:
            lineSpace = 2;
            break;
        case 3:
            lineSpace = 3;
            break;
            
        default:
            break;
    }
    
    _lineSpacing1Btn.selected = NO;
    _lineSpacing2Btn.selected = NO;
    _lineSpacing3Btn.selected = NO;
    sender.selected = YES;
    
    [E_CommonManager saveLineSpace:lineSpace];
    [_delegate lineSapceChanged:lineSpace];
    
}

#pragma mark 选择背景颜色
- (void)themeButtonPressed:(UIButton *)sender{
    
    [sender setSelected:YES];
    if (sender.tag != 7004) {
       [sender.layer setBorderWidth:1.0];
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        if (button.tag != sender.tag) {
            [button setSelected:NO];
            [button.layer setBorderWidth:0.0];
        }
    }
    
    
//    if ((sender.tag%7000) == 4) { //夜间模式
//        [self nightColor];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_TOPBAR_COLOR" object:@"night"];
//
//    }else{
        [self defineColor];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_TOPBAR_COLOR" object:@"light"];
       self.lightBtn.selected = NO;
//
//    }
    
    

    
    E_ColorModel *model =[E_ColorModel new];
    if ((sender.tag%7000) < self.colorArr.count) {
        model = self.colorArr[sender.tag%7000];
    }
    
    [E_CommonManager saveLastThemeColor:model];
    [E_CommonManager saveCurrentThemeColor:model];

    [_delegate themeButtonAction:self themeColor:model];
  

}
#pragma mark 夜间模式
-(void)lightAction:(UIButton *)sender{
    if (!sender.selected) { //夜间模式
        [self nightColor];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_TOPBAR_COLOR" object:@"night"];
        E_ColorModel *model =[E_ColorModel new];
        model.colorType =E_colorType_Night;
        model.colorD =@"#0C0C0E";
        model.colorS =@"#0C0C0E";
        model.smallImageD =@"nightDefault";
        model.smallImageS =@"nightSelected";
        [E_CommonManager saveCurrentThemeColor:model];
        [_delegate themeButtonAction:self themeColor:model];
        
    }else{
        [self defineColor];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_TOPBAR_COLOR" object:@"light"];
        
        E_ColorModel *model =[E_CommonManager Manager_getLastTheme];
        if (!model) {
            model = self.colorArr[0];
        }
        
        [E_CommonManager saveCurrentThemeColor:model];
        [_delegate themeButtonAction:self themeColor:model];
        
    }
    sender.selected = !sender.selected;

    
}
- (void)nightColor
{
    showLbl.textColor = [UIColor whiteColor];
    [self.sliderFont setTintColor:HEX_COLOR_ALPHA(0x4A4A4A, 0.4)];
    [self.sliderFont setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x4A4A4A, 0.2)];
    [self.sliderFont setThumbImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
    
    [self.sliderBrightness setTintColor:HEX_COLOR_ALPHA(0x4A4A4A, 0.4)];
    [self.sliderBrightness setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x4A4A4A, 0.2)];
    [self.sliderBrightness setThumbImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
    
    [self.menuBgView setBackgroundColor: HEX_COLOR(0x0C0C0E)];
    [self.lightBgView setBackgroundColor: HEX_COLOR(0x0C0C0E)];
    [self.fontBgView setBackgroundColor: HEX_COLOR(0x0C0C0E)];
    
  
    [_lineSpacing1Btn setImage:[UIImage imageNamed:@"character1_night"] forState:UIControlStateNormal];
    [_lineSpacing2Btn setImage:[UIImage imageNamed:@"character2_night"] forState:UIControlStateNormal];
    [_lineSpacing3Btn setImage:[UIImage imageNamed:@"character3_night"] forState:UIControlStateNormal];
      [_xitongBtn setImage:[UIImage imageNamed:@"xitong_night"] forState:UIControlStateNormal];
    
    [_smallFont setImage:[UIImage imageNamed:@"type -_night"] forState:0];
    [_bigFont setImage:[UIImage imageNamed:@"type+_night"] forState:0];
    _smallFont.layer.borderColor = [UIColor clearColor].CGColor;
    _bigFont.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)defineColor
{
    showLbl.textColor = [UIColor blackColor];
    [self.sliderFont setTintColor:HEX_COLOR_ALPHA(0x000000, 0.4)];
    [self.sliderFont setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x000000, 0.2)];
    [self.sliderFont setThumbImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    
    [self.sliderBrightness setTintColor:HEX_COLOR_ALPHA(0x000000, 0.4)];
    [self.sliderBrightness setMaximumTrackTintColor: HEX_COLOR_ALPHA(0x000000, 0.2)];
    [self.sliderBrightness setThumbImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    
    [self.menuBgView setBackgroundColor: HEX_COLOR(0xffffff)];
    [self.lightBgView setBackgroundColor: HEX_COLOR(0xffffff)];
    [self.fontBgView setBackgroundColor: HEX_COLOR(0xffffff)];

    [_lineSpacing1Btn setImage:[UIImage imageNamed:@"character1"] forState:UIControlStateNormal];
    [_lineSpacing2Btn setImage:[UIImage imageNamed:@"character2"] forState:UIControlStateNormal];
    [_lineSpacing3Btn setImage:[UIImage imageNamed:@"character3"] forState:UIControlStateNormal];
      [_xitongBtn setImage:[UIImage imageNamed:@"xitong"] forState:UIControlStateNormal];
    
    [_smallFont setImage:[UIImage imageNamed:@"font-day"] forState:0];
    [_bigFont setImage:[UIImage imageNamed:@"font+day"] forState:0];
    _smallFont.layer.borderColor = HEX_COLOR(0xE5E8EC).CGColor;
    _bigFont.layer.borderColor = HEX_COLOR(0xE5E8EC).CGColor;
}

- (void)goToNextChapter{
    
    [_delegate turnToNextChapter];
    
}

- (void)goToPreChapter{
    
    [_delegate turnToPreChapter];

}

#pragma mark -font change

- (void)sliderValueChanged:(UISlider *)slider{
    NSUInteger fontSize = [E_CommonManager fontSize];
    fontSize =(NSUInteger)slider.value;
    [E_CommonManager saveFontSize:fontSize];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
}

#pragma mark -light change
- (void)sliderRightnessValueChanged:(UISlider *)slider{
    
    CGFloat regulaLight = [E_CommonManager readBrightness];
    regulaLight =slider.value;
    [E_CommonManager saveBrightness_read:regulaLight];
    if (regulaLight >1.0) {
         regulaLight = 1.0;
    }
    
    if (regulaLight <= 0.0) {
        regulaLight = 0.0;
    }
    _xitongBtn.selected = NO;
     [[UIScreen mainScreen] setBrightness:regulaLight];
    
}

-(void)xitongAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        CGFloat regulaLight = [E_CommonManager brightness_];
        [[UIScreen mainScreen] setBrightness:regulaLight];
    }else{
        CGFloat regulaLight = [E_CommonManager readBrightness];
        [[UIScreen mainScreen] setBrightness:regulaLight];
    }

}

#pragma mark - 字体调整
- (void)changeSmall
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        [E_HUDView showMsg:MIN_TIPS inView:self];
        return;
    }
    fontSize--;
    showLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)fontSize];
    
    [E_CommonManager saveFontSize:fontSize];
    [_delegate fontSizeChanged:(int)fontSize];
}

- (void)changeBig
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        [E_HUDView showMsg:MAX_TIPS inView:self];
        return;
    }
    fontSize++;
    
    showLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)fontSize];
    [E_CommonManager saveFontSize:fontSize];
    [_delegate fontSizeChanged:(int)fontSize];

    
}


/// 目录触发事件
- (void)showDrawerView{
   
    
    [_delegate callDrawerView];

}

/// 亮度触发事件
- (void)showLightView{
    [self.fontBgView setAlpha:0];
    [self.lightBgView setAlpha:1];
    [_delegate lightEvent];
}

/// 字体大小触发事件
- (void)showFontView{
    [self.lightBgView setAlpha:0];
    [self.fontBgView setAlpha:1];
    [_delegate fontEvent];
}

- (void)changeSliderRatioNum:(float)percentNum{
    
    ilSlider.ratioNum = percentNum;

}

- (void)showCommentView{
    
    [_delegate callCommentView];
}




- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= KTabbarHeight;
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
    
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
