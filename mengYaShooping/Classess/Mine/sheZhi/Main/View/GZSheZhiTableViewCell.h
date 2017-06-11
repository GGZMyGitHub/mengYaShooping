//
//  GZSheZhiTableViewCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/28.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZSheZhiTableViewCell : UITableViewCell

//创建cell时，必须要创建这两个属性，而且名字需求是这两个
@property(retain,nonatomic)id data;
@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, strong) UILabel *detailLabel;


@end
