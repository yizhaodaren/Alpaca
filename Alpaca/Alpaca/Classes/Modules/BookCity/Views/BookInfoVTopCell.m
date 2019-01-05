//
//  BookInfoVTopCell.m
//  Alpaca
//
//  Created by xujin on 2018/11/21.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BookInfoVTopCell.h"
#import "BookCityModel.h"
#import "BookInfoVTopCollectionCell.h"
#import "BookDetailViewController.h"

@interface BookInfoVTopCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) BookCityModel *currentModel;
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@end
@implementation BookInfoVTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.currentModel =[BookCityModel new];
        [self.contentView setBackgroundColor: HEX_COLOR(0xffffff)];
        self.currentArr =[NSArray new];
    }
    return self;
}

//- (void)cellContent:(BookCityModel *)model indexPath:(NSIndexPath *)indexPath{
- (void)cellContent:(NSArray *)model indexPath:(NSIndexPath *)indexPath{
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    
    if (indexPath) {
        self.currentIndexPath = indexPath;
    }
    
//    if (model) {
//        self.currentModel =model;
//    }
    
    if (!model.count) {
        return;
    }
    
    self.currentArr =model;
    
    
    UICollectionViewFlowLayout *flowLayout =[UICollectionViewFlowLayout new];
    
    CGFloat itemW = KSCALEWidth(80);
    CGFloat itemH = 110+6+20+17;
    
        
        BOOL isExist =NO;
        for (BookModel *model_ in model) {
            NSMutableAttributedString *bookDescStr =[STSystemHelper attributedContent:model_.bookName?model_.bookName:@"" color:HEX_COLOR(0x6E6E6E) font:REGULAR_FONT(14)];
            
            CGFloat bookDescHeight =0.0;
            
            bookDescHeight =[bookDescStr mol_getAttributedTextWidthWithMaxWith:itemW font:REGULAR_FONT(14)];
            
            if (bookDescHeight >=20*2.0) {
                isExist =YES;
            }
        }
        
        if (isExist) {
            itemH +=20;
        }
    
    itemH =KSCALEHeight(itemH);
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.minimumLineSpacing = 2;
    //flowLayout.minimumInteritemSpacing = 8;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    UICollectionView *collectionViewS = [[UICollectionView alloc] initWithFrame:CGRectMake(0,15, KSCREEN_WIDTH, itemH) collectionViewLayout:flowLayout];
    
    collectionViewS.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    collectionViewS.delegate = self;
    collectionViewS.dataSource = self;
    collectionViewS.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        collectionViewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionViewS.showsVerticalScrollIndicator = NO;
    collectionViewS.showsHorizontalScrollIndicator = NO;
    [collectionViewS registerClass:[BookInfoVTopCollectionCell class] forCellWithReuseIdentifier:@"BookInfoVTopCollectionCellID"];
    
    self.collectionView =collectionViewS;
    [self.contentView addSubview:collectionViewS];
    
}

#pragma mark - collectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookModel *model =[BookModel new];
    if (indexPath.row < self.currentArr.count) {
        model =self.currentArr[indexPath.row];
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

    return self.currentArr.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookInfoVTopCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookInfoVTopCollectionCellID" forIndexPath:indexPath];
    
    BookModel *model =[BookModel new];
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
