//
//  BookInfoCCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookInfoCCell.h"
#import "BookCityModel.h"
#import "BookInfoCCollectionCell.h"
#import "BookDetailViewController.h"

@interface BookInfoCCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) BookCityModel *currentModel;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@end

@implementation BookInfoCCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.currentModel =[BookCityModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
    }
    return self;
}

- (void)cellContent:(BookCityModel *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
    if (model) {
        self.currentModel =model;
    }
    
    UICollectionViewFlowLayout *flowLayout =[UICollectionViewFlowLayout new];
    
    CGFloat itemW = (KSCREEN_WIDTH-15*2.0-8)/2.0;
    CGFloat itemH = model.cellHeight;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //行间距
    //flowLayout.minimumLineSpacing = 2;
    //列间距
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionViewS = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, KSCREEN_WIDTH, itemH) collectionViewLayout:flowLayout];
    
    
    collectionViewS.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    collectionViewS.delegate = self;
    collectionViewS.dataSource = self;
    collectionViewS.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        collectionViewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionViewS.showsVerticalScrollIndicator = NO;
    collectionViewS.showsHorizontalScrollIndicator = NO;
    [collectionViewS registerClass:[BookInfoCCollectionCell class] forCellWithReuseIdentifier:@"BookInfoCCollectionCellID"];
    
    self.collectionView =collectionViewS;
    [self.contentView addSubview:collectionViewS];
    
}

#pragma mark - collectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model =[BookModel new];
    if (indexPath.row < self.currentModel.books.count) {
        model =self.currentModel.books[indexPath.row];
    }
    
    BookDetailViewController *bookDetail =[BookDetailViewController new];
    bookDetail.model =model;
    [[[GlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:bookDetail animated:YES];
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.currentModel.books.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookInfoCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookInfoCCollectionCellID" forIndexPath:indexPath];
    
    BookModel *model =[BookModel new];
    if (indexPath.row < self.currentModel.books.count) {
        model =self.currentModel.books[indexPath.row];
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
