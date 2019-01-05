//
//  E_SettingBottomBar.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E_ColorModel.h"

/**
 *  底部设置条
 */
@protocol E_SettingBottomBarDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)fontSizeChanged:(int)fontSize;//改变字号
- (void)lineSapceChanged:(CGFloat)lineSpace;//行间距
- (void)callDrawerView;//侧边栏
- (void)turnToNextChapter;//下一章
- (void)turnToPreChapter;//上一章
- (void)sliderToChapterPage:(NSInteger)chapterIndex;
- (void)themeButtonAction:(id)myself themeColor:(E_ColorModel*)themeDto;
- (void)callCommentView;
- (void)lightEvent; //中间亮度实现
- (void)fontEvent; //右侧字体设置


@end


@interface E_SettingBottomBar : UIView

@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;

//3个行间距
@property (nonatomic,strong) UIButton *lineSpacing1Btn;
@property (nonatomic,strong) UIButton *lineSpacing2Btn;
@property (nonatomic,strong) UIButton *lineSpacing3Btn;
@property (nonatomic,strong)UIButton  *xitongBtn;


@property (nonatomic,strong) UISlider *sliderFont;
@property (nonatomic,strong) UISlider *sliderBrightness;
@property (nonatomic,assign) id<E_SettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;

@property (nonatomic, strong)NSMutableArray *colorArr;

- (void)changeSliderRatioNum:(float)percentNum;

- (void)showToolBar;

- (void)hideToolBar;

@end
