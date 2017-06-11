//
//  GZStatusView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^daiFaHuoClick)(NSString *);
typedef void(^daiShouHuoClick)(NSString *);
typedef void(^yiWanChengClick)(NSString *);


@interface GZStatusView : UIView

@property (weak, nonatomic) IBOutlet UILabel *daiFaHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *daiShouHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiWanChengLabel;


@property (nonatomic, copy)daiFaHuoClick daiFaHuoClickBlock;
@property (nonatomic, copy)daiShouHuoClick daiShouHuoClickBlock;
@property (nonatomic, copy)yiWanChengClick yiWanChengClickBlock;



//翻译
@property (weak, nonatomic) IBOutlet UILabel *daiFaHuoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *daiShouHuoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiWanChengTitleLabel;


+ (instancetype)createOrderStatusView;

@end
