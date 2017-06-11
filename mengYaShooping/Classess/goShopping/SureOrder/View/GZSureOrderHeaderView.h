//
//  GZSureOrderHeaderView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GZSureOrderDataModel.h"

@interface GZSureOrderHeaderView : UIView

@property (nonatomic, strong) GZSureOrderDataModel *dataModel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jianTou;
@property (nonatomic, strong) UILabel *label;



+ (instancetype)sharedSureOrderHeaderView;

@end
