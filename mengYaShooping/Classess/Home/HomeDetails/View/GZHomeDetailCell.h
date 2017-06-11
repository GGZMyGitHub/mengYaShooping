//
//  GZHomeDetailCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/5.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZHomeDetailProlistModel.h"
#import "GZNoDataProlist.h"

typedef void(^addGoShopping)();

@interface GZHomeDetailCell : UICollectionViewCell

/** 加入购物车block */
@property (nonatomic, copy) addGoShopping addGoShoppingBlock;

//产品列表数据源
@property (nonatomic, strong) GZHomeDetailProlistModel *prolistModel;
//推荐精品数据源
@property (nonatomic, strong) GZNoDataProlist *noDataModel;


@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *goShoppingBtn;

@end
