//
//  GZMessageCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/10.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZMessageListModel.h"

@interface GZMessageCell : UITableViewCell

@property (nonatomic, strong) GZMessageListModel *listModel;

@property (nonatomic) NSInteger typeMessage;

@end
