//
//  GZGoShoppingCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZGoShoppAllModel.h"

typedef void(^reduceClick)(UIButton *);
typedef void(^addClick)(UIButton *);

@class GZGoShoppingCell;

@protocol GZGoShoppingCellDelegate <NSObject>

@optional
/**
 *  选中商品的代理方法
 */
- (void)shopPlatformTableViewCell:(GZGoShoppingCell *)cell andTag:(NSInteger)tag;

@end

@interface GZGoShoppingCell : UITableViewCell

/**
 点击减号的回调
 */
@property (nonatomic, copy) reduceClick reduceClickBlock;

/**
 点击加号的回调
 */
@property (nonatomic, copy) addClick addClickBlock;

/**
 选中商品的代理
 */
@property (nonatomic,weak) id<GZGoShoppingCellDelegate> delegate;

/**
 cell的位置
 */
@property (nonatomic, strong) NSIndexPath *indexpath;

/**
 数据源
 */
@property (nonatomic, strong) GZGoShoppAllModel *allModel;
@property (weak, nonatomic) IBOutlet UIButton *NoSelect;


@end
