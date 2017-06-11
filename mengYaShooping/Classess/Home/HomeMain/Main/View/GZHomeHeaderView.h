//
//  GZHomeHeaderView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/15.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cycleScrollClick)(NSInteger);
typedef void(^classBtnClick)(NSInteger);


@interface GZHomeHeaderView : UIView


/**
 点击轮播图的block回调
 */
@property (nonatomic, copy) cycleScrollClick selectCycleScrollBlock;

@property (nonatomic, copy) classBtnClick classBtnClickBlock;

/** 轮播图数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 分类数据 */
@property (nonatomic, strong) NSArray *classArray;

@property (nonatomic, strong) UILabel *bottomLineLabel;

//翻译用
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (instancetype)createHeaderView;

@end
