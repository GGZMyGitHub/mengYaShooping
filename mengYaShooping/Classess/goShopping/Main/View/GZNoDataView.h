//
//  GZNoDataView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZNoDataHeaderView.h"

typedef void(^didSelectCollectionCellClick)(NSString *photoID);

@interface GZNoDataView : UIView

@property (nonatomic, copy) didSelectCollectionCellClick didSelectCollectionCellClickClick;

/** 数据源 */
@property (nonatomic, strong) NSArray *prolistArr;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) GZNoDataHeaderView *headerView;

@end
