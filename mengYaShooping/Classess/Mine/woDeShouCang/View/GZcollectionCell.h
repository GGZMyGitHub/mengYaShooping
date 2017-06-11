//
//  GZcollectionCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZColletcionDataModel.h"

typedef void(^didSelectClick)();

@interface GZcollectionCell : UITableViewCell

@property (nonatomic, copy) didSelectClick didSelectClickBlock;

@property (nonatomic, strong) GZColletcionDataModel *dataModel;

@end
