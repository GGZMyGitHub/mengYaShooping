//
//  BuyCountView.h
//  AddShoppingCart
//
//  Created by 主用户 on 16/3/23.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^countChangeClick)(NSString *);

@interface BuyCountView : UIView

/**
 数量变化回调
 */
@property (nonatomic, copy) countChangeClick countChangeClickBlock;

@property(nonatomic, retain) UIButton *bt_reduce;
@property(nonatomic, retain) UILabel *lb_count;
@property(nonatomic, retain) UIButton *bt_add;

@end
