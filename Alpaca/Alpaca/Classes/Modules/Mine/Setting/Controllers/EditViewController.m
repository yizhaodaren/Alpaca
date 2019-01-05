//
//  EditViewController.m
//  Alpaca
//
//  Created by xujin on 2019/1/4.
//  Copyright © 2019年 Moli. All rights reserved.
//

#import "EditViewController.h"
#import "MineInfoModel.h"
#import "EditCell.h"


@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSMutableArray *infoArr;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registNotification];
    [self layoutNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)registNotification{
    
}

- (void)layoutNavigationBar{
    [self navigationLeftItemWithImageName:@"back" centerTitle:NSLocalizedString(@"STR_PERSON_Edit",nil) titleColor:HEX_COLOR(0x000000)];
}

- (void)initData{
    self.infoArr =[NSMutableArray array];
    self.titleArr =@[@"头像",@"昵称",@"性别",@"生日",@"城市"];
    
    for (NSInteger i=0; i<self.titleArr.count; i++) {
        MineInfoModel *infoDto =[MineInfoModel new];
        infoDto.title =self.titleArr[i];
        [self.infoArr addObject: infoDto];
        
    }
    
}

- (void)layoutUI{
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, KSCREEN_WIDTH, KSCREEN_HEIGHT-KTabbarHeight-StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
    
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://头像
        {
            
        }
            break;
        case 1://昵称
        {
            
        }
            break;
        case 2://性别
        {
            
        }
            break;
        case 3://生日
        {
            
        }
            break;
        case 4://城市
        {
            
        }
            break;
            

    }
    
}

#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (![UserManagerInstance user_isLogin]) {
        return self.infoArr.count?(self.infoArr.count-1):0;
    }
    
    return self.infoArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * const cellId = @"EditCell";
    
    EditCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MineInfoModel *model =[MineInfoModel new];
    
    if (self.infoArr.count > indexPath.row) {
        model = self.infoArr[indexPath.row];
    }
    
    [cell cell:model indexPath:indexPath];
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
