//
//  FemaleChannelViewController.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "FemaleChannelViewController.h"
#import "BookCityModelGroup.h"
#import "BookCityApi.h"

@interface FemaleChannelViewController ()
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, assign)UIBehaviorTypeStyle refreshType;
@end

@implementation FemaleChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    
    [self layoutUI];
    [self getRecomClassifies];
    
}

- (void)registNotification{
    
}

- (void)layoutNavigationBar{
    
}

- (void)initData{
    self.pageNum =1;
    self.pageSize =10;
    self.dataSourceArr =[NSMutableArray new];
    self.refreshType =UIBehaviorTypeStyle_Normal;
    
}




- (void)layoutUI{
    
}

#pragma mark-
#pragma mark 网络请求
- (void)refresh{
    self.pageNum =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    [self getRecomClassifies];
};

- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getRecomClassifies];
}
- (void)getRecomClassifies{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"channelCode"] =@"2";
    dic[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNum];
    dic[@"pageSize"] =[NSString stringWithFormat:@"%ld",self.pageSize];
    
    __weak typeof(self) wself = self;
    [[[BookCityApi alloc] initGetRecomClassifiesWithParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof BSNetRequest * _Nonnull request, BSModel * _Nonnull responseModel, NSInteger code, NSString * _Nonnull message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            //            [wself.tableview.mj_header endRefreshing];
            //            [wself.tableview.mj_footer endRefreshing];
        }
        
        if (code == SUCCESS_REQUEST) {
            
            BookCityModelGroup *group =(BookCityModelGroup *)responseModel;
            
            if (wself.refreshType != UIBehaviorTypeStyle_More) {
                [wself.dataSourceArr removeAllObjects];
                
            }
            
            // 添加到数据源
            [wself.dataSourceArr addObjectsFromArray:group.resBody];
            
            
            // [wself.tableview reloadData];
            
            //            if (wself.dataSource.count-wself.hoursArr.count >= group.total) {
            //                wself.tableview.mj_footer.hidden = YES;
            //
            //            }else{
            //                wself.tableview.mj_footer.hidden = NO;
            //            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
    } failure:^(__kindof BSNetRequest * _Nonnull request) {
        
    }];
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
