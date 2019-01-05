//
//  E_ReaderViewController.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示阅读内容
 */

@protocol E_ReaderViewControllerDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)hideTheSettingBar;
- (void)ciBaWithString:(NSString *)ciBaString;

@end


@interface E_ReaderViewController : UIViewController

@property (nonatomic,assign) id<E_ReaderViewControllerDelegate>delegate;
@property (nonatomic,unsafe_unretained) NSUInteger currentPage;
@property (nonatomic,unsafe_unretained) NSUInteger totalPage;
@property (nonatomic,strong)            NSString   *text;
@property (nonatomic,unsafe_unretained) NSUInteger  font;
@property(nonatomic,assign)CGFloat  lineSpace;
@property (nonatomic,strong)            UIColor *contentColor;
@property (nonatomic, strong)             NSString   *chapterTitle;
@property (nonatomic, unsafe_unretained,readonly) CGSize readerTextSize;
@property (nonatomic,strong)            UIImage    *themeBgImage;
@property (nonatomic,strong)            NSString   *keyWord;

@property (nonatomic,assign)            NSUInteger wordSize;



- (CGSize)readerTextSize;

- (void)totalPage:(NSUInteger)total  currentPage:(NSUInteger)page;
- (void)statusNight;
@end

@interface BackViewController : UIViewController

@property (weak, nonatomic) E_ReaderViewController *currentViewController;
- (void)updateWithViewController:(E_ReaderViewController *)viewController;
@end
