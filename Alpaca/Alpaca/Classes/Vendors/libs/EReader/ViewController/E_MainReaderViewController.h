//
//  E_MainReaderViewController.h
//  Alpaca
//
//  Created by apple on 2018/12/20.
//  Copyright © 2018 Moli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookModel;
@interface E_MainReaderViewController : UIViewController

-(instancetype)initWithBook:(BookModel *)model;
// 改变主题
-(void)changeBgColer;

-(void)updateBook:(BookModel *)model;
@end


@interface MainBackViewController : UIViewController
@property (weak, nonatomic) E_MainReaderViewController *currentViewController;
- (void)updateWithViewController:(E_MainReaderViewController *)viewController;
@end
