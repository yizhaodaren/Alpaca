//
//  E_SettingBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingTopBar.h"
#import "BookcaseApi.h"
#import "HomeShareView.h"
#import "E_ColorModel.h"
#import "E_CommonManager.h"
#import "E_ReaderDataSource.h"

@interface  E_SettingTopBar()<HomeShareViewDelegate>
@property (nonatomic, weak)UIButton *addBookcase;
@property (nonatomic, strong)HomeShareView *shareView;
@property (nonatomic, strong)E_ColorModel *themeID;
@end

@implementation E_SettingTopBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR_ALPHA(0xffffff,1.0);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_TOPBAR_COLOR" object:sender];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changesTopBarColor:) name:@"CHANGE_TOPBAR_COLOR" object:nil];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
        [self addGestureRecognizer:tap];
        
        self.themeID =[E_ColorModel new];
        self.themeID =[E_CommonManager Manager_getReadTheme];
        if (!self.themeID) {
            self.themeID =[E_ColorModel new];
        }
        
        [self configUI];
    }
    return self;

}

- (void)tapEvent{
}


- (void)changesTopBarColor:(NSNotification *)noti{
    if (noti.object && [noti.object isKindOfClass: [NSString class]]) {
        NSString *sender =(NSString *)noti.object;
        
        if (sender.length) {
            if ([sender isEqualToString:@"night"]) {//夜
                [self setBackgroundColor: HEX_COLOR(0x0C0C0E)];
            }else{//默认
                [self setBackgroundColor: HEX_COLOR(0xffffff)];
            }
        }
        
        
    }
}


- (void)configUI{
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);

    [backBtn setImage:[UIImage imageNamed:@"readerback"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];

    UIButton *multifunctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    multifunctionBtn.frame = CGRectMake(self.frame.size.width - 44, 20, 44, 44);
    [multifunctionBtn setImage:[UIImage imageNamed:@"share"] forState:0];
    [multifunctionBtn setTitleColor:[UIColor whiteColor] forState:0];
    [multifunctionBtn addTarget:self action:@selector(multifunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:multifunctionBtn];
    
    UIButton *addBookcase = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBookcase setHidden:YES];
    addBookcase.frame = CGRectMake(multifunctionBtn.left-9-44-7-20-3, 20, 9+44+7+20+3, 44);
    
    
    [addBookcase.titleLabel setFont: REGULAR_FONT(11)];
    [addBookcase addTarget:self action:@selector(putBookEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBookcase];
    self.addBookcase =addBookcase;
    addBookcase.titleEdgeInsets=UIEdgeInsetsMake(3, 7, 0, 0);
    addBookcase.imageEdgeInsets=UIEdgeInsetsMake(3, 0, 0, 0);
    
    if (self.themeID.colorType == E_colorType_Night) {
        [self setBackgroundColor: HEX_COLOR(0x0C0C0E)];
        
    }else{
        [self setBackgroundColor: HEX_COLOR(0xffffff)];
        
    }


}


- (void)contentEvent:(BookModel *)bookModel{
    self.bookModel =bookModel;
    if (self.bookModel.inShelf) {//已加入
//        [self.addBookcase setTitle:NSLocalizedString(@"STR_AddedBookcase", nil) forState:UIControlStateNormal];
//        [self.addBookcase setImage:[UIImage imageNamed:@"bookshelf small"] forState:UIControlStateNormal];
//        [self.addBookcase setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
//        [self.addBookcase setEnabled: NO];
        [self.addBookcase setHidden:YES];
    }else{
        [self.addBookcase setHidden:NO];
        [self.addBookcase setTitle:NSLocalizedString(@"STR_AddBookcase", nil) forState:UIControlStateNormal];
        [self.addBookcase setImage:[UIImage imageNamed:@"bookshelf small"] forState:UIControlStateNormal];
        [self.addBookcase setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
        [self.addBookcase setEnabled: YES];
    }
}

- (void)backToFront{
    
    [_delegate goBack];
}

- (void)multifunction{
    
    UIViewController *vc =[[GlobalManager shareGlobalManager] global_currentViewControl];
    [vc.view addSubview:self.shareView];
    
   // [_delegate showMultifunctionButton];
    
}


- (HomeShareView *)shareView{
    if (!_shareView) {
        _shareView =[HomeShareView new];
        [_shareView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        _shareView.currentBusinessType = HomeShareViewBookDetailType;
        [_shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo" ,@"Book_Details"]];
        _shareView.delegate =self;
    }
    return _shareView;
}


#pragma mark - HomeShareViewDelegate
- (void)homeShareView:(BookModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType{
    self.shareView =nil;
    switch (shareType) {
        case HomeShareViewWechat: //朋友圈
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case HomeShareViewWeixin: //微信好友
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case HomeShareViewMqMzone: //QQ空间
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case HomeShareViewQQ: //QQ
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case HomeShareViewSinaweibo: //微博
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
            break;
        case HomeShareViewBookDetail: //书籍详情
        {
            [self gotoBookDetail];
        }
            break;
            
            
            
    }
}

#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  self.bookModel.shareMsgVO.shareImg?self.bookModel.shareMsgVO.shareImg:@"";
    
    NSLog(@"%@---%@",self.bookModel.shareMsgVO.shareTitle,self.bookModel.shareMsgVO.shareContent);
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.bookModel.shareMsgVO.shareTitle?self.bookModel.shareMsgVO.shareTitle:@"" descr:self.bookModel.shareMsgVO.shareContent?self.bookModel.shareMsgVO.shareContent:@"" thumImage:thumbURL];
    
    //设置网页地址
    shareObject.webpageUrl = self.bookModel.shareMsgVO.shareUrl?self.bookModel.shareMsgVO.shareUrl:@"";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    UIViewController *vc =[[GlobalManager shareGlobalManager] global_currentViewControl];
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
//                //                分享埋点接口
//                /log/addOperateLog
//                参数：{
//                    "dataId": "6",  //数据ID  如书籍id
//                    "dataType": 1,  //数据类型  如书籍
//                    "operateType": 1 //操作类型。1=微信好友分享 11=微信朋友圈 12=qq 13=QQ空间 14=微博
//                }
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                dic[@"dataId"] =[NSString stringWithFormat:@"%ld",[E_ReaderDataSource shareInstance].currentChapterId];
                dic[@"dataType"]=@"2";
                
                switch (resp.platformType) {
                    case UMSocialPlatformType_WechatSession:
                    {
                        dic[@"operateType"]=@"1";
                    }
                        break;
                    case UMSocialPlatformType_WechatTimeLine:
                    {
                        dic[@"operateType"]=@"11";
                    }
                        break;
                    case UMSocialPlatformType_QQ:
                    {
                        dic[@"operateType"]=@"12";
                    }
                        break;
                    case UMSocialPlatformType_Qzone:
                    {
                        dic[@"operateType"]=@"13";
                    }
                        break;
                    case UMSocialPlatformType_Sina:
                    {
                        dic[@"operateType"]=@"14";
                    }
                        break;
                        
                        
                }
    
                [NetworkCollectCenter monitorLogAddLog:dic];
            }else{
                NSLog(@"response data is %@",data);
            }
            
            
        }
    }];
    
}
- (void)gotoBookDetail{
    if (_delegate) {
        [_delegate gotoBookDetail];
    }
    
}

- (void)showToolBar{
   
    CGRect newFrame = self.frame;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
       
    }];

}


#pragma mark-
#pragma mark 加入书架
- (void)putBookEvent:(UIButton *)sender
{
    [sender setEnabled:NO];
    
    UIViewController *vc=[[GlobalManager shareGlobalManager] global_currentViewControl];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    [hud showAnimated:YES];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [[[BookcaseApi alloc] initPutWithParameter:dic parameterId:[NSString stringWithFormat:@"%ld",self.bookModel.bookId]] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        [hud hideAnimated:YES];
        ///
        if (code == SUCCESS_REQUEST) {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESS_BOOKSHELF_ADDED object:nil];
//            [self.addBookcase setTitle:NSLocalizedString(@"STR_AddedBookcase", nil) forState:UIControlStateNormal];
//            [self.addBookcase setImage:[UIImage imageNamed:@"bookshelf small"] forState:UIControlStateNormal];
//            [self.addBookcase setTitleColor:HEX_COLOR(0x979FAC) forState:UIControlStateNormal];
//            [self.addBookcase setEnabled: NO];
            [self.addBookcase setAlpha:0];
            self.bookModel.inShelf =1;
           [OMGToast showWithText:@"成功加入书架"];
            
        }else{
            [OMGToast showWithText:message];
            [sender setEnabled:YES];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        [sender setEnabled:YES];
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
