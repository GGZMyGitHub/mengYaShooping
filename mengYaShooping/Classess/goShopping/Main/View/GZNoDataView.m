//
//  GZNoDataView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNoDataView.h"
#import "GZHomeDetailCell.h"

@interface GZNoDataView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

static NSString *collectionIdentifier = @"collectionViewID";
static NSString *collectionHeaderIdentifier = @"CollectionViewHeaderView";
@implementation GZNoDataView

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom + 10, kScreenWidth, kScreenHeight - 64 - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerNib:[UINib nibWithNibName:@"GZHomeDetailCell" bundle:nil] forCellWithReuseIdentifier:collectionIdentifier];
        
        //注册分区头标题
        [_collectionView registerNib:[UINib nibWithNibName:@"GZNoDataHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderIdentifier];
    }
    return _collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma - collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    
    return self.prolistArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GZHomeDetailCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    
    cell.noDataModel = self.prolistArr[indexPath.row];
    cell.goShoppingBtn.hidden = YES;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZNoDataProlist *prolistModel = self.prolistArr[indexPath.row];
    if (_didSelectCollectionCellClickClick) {
        _didSelectCollectionCellClickClick(prolistModel.p_id);
    }
}

//创建collectionViewHeader
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        GZNoDataHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                      withReuseIdentifier:collectionHeaderIdentifier
                                                                             forIndexPath:indexPath];
        return view;
    }
    
    return nil;
}

//header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 335);
}

#pragma mark - UICollectionViewFlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.collectionView.width - 40) / 2,
                      (self.collectionView.width - 40) / 2 +90);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
}

@end
