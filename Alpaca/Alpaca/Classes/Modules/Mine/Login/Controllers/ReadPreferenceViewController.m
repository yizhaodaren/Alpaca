//
//  ReadPreferenceViewController.m
//  Alpaca
//
//  Created by xujin on 2018/12/7.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "ReadPreferenceViewController.h"
#import "PreferenceSetView.h"

@interface ReadPreferenceViewController ()
@property (nonatomic, strong)PreferenceSetView *preSetView;

@end

@implementation ReadPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNavigationBar];
    [self.view addSubview:self.preSetView];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftItemEvent) name:PREFERENCE_START_NOTIF object:nil];
    
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back"];
    
}

- (PreferenceSetView *)preSetView{
    if (!_preSetView) {
        _preSetView =[PreferenceSetView new];
        _preSetView.type =100;
        [_preSetView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];

    }
    return _preSetView;
}

- (void)leftItemEvent{
    [self.navigationController popViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
