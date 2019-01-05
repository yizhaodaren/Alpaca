//
//  WelfareShortCell.m
//  Alpaca
//
//  Created by xujin on 2018/12/6.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "WelfareShortCell.h"
#import "WelfareCollectionViewCell.h"
#import "WelfareModel.h"
#import "MOLWebViewController.h"
@interface  WelfareShortCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)WelfareModel *welfareModel;
@property (nonatomic, strong)NSMutableArray *currentArr;


@end

@implementation WelfareShortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.welfareModel =[WelfareModel new];
        self.currentArr =[NSMutableArray array];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
        
    }
    return self;
}



- (void)cellContent:(NSArray *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndex = indexPath;
    }
    
    if (model.count) {
        self.currentArr =(NSMutableArray *)model;
    }
    
    UICollectionViewFlowLayout *flowLayout =[UICollectionViewFlowLayout new];
    
    CGFloat itemW = (KSCREEN_WIDTH-16*2.0-10)/2.0;
    CGFloat itemH = 10+20+10+100+20;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //行间距
    //flowLayout.minimumLineSpacing = 2;
    //列间距
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionViewS = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, KSCREEN_WIDTH, itemH) collectionViewLayout:flowLayout];
    
    
    collectionViewS.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
    collectionViewS.delegate = self;
    collectionViewS.dataSource = self;
    collectionViewS.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        collectionViewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionViewS.showsVerticalScrollIndicator = NO;
    collectionViewS.showsHorizontalScrollIndicator = NO;
    [collectionViewS registerClass:[WelfareCollectionViewCell class] forCellWithReuseIdentifier:@"WelfareCollectionViewCellID"];

//    self.collectionView =collectionViewS;
    [self.contentView addSubview:collectionViewS];
    
    
}

#pragma mark - collectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WelfareModel *model =[WelfareModel new];
    if (indexPath.row < self.currentArr.count) {
        model =self.currentArr[indexPath.row];
    }

    MOLWebViewController *web =[MOLWebViewController new];
    web.urlString =model.url?model.url:@"";
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:web animated:YES];
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.currentArr.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WelfareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCollectionViewCellID" forIndexPath:indexPath];
    
    WelfareModel *model =[WelfareModel new];
    if (indexPath.row < self.currentArr.count) {
        model =self.currentArr[indexPath.row];
    }
    
    [cell content:model indexPath:indexPath];
    
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
