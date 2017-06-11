//
//  GZTopScrollMenu.h
//  GZTopScrollMenu
//
//  Created by apple on 17/4/14.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GZTopScrollMenu;

@protocol GZTopScrollMenuDelegate <NSObject>

- (void)GZTopScrollMenu:(GZTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index;

@end

@interface GZTopScrollMenu : UIScrollView

/** 协议 */
@property (nonatomic, weak) id<GZTopScrollMenuDelegate> topScrollMenuDelegate;

/** 滚动标题数组 */
@property (nonatomic, strong) NSArray *scrollTitleArr;

@property (nonatomic, strong) NSArray *scrollTItleIDArr;

@property (nonatomic, copy) NSString *oldTitleIDStr;

/** 存入所有Label的数组 */
@property (nonatomic, strong) NSMutableArray *allTitleLabel;

/** titles数组传它，菜单是固定的，不能滚动 */
@property (nonatomic, strong) NSArray *staticTitleArr;


/**
 初始化
 */
+ (instancetype)topScrollMenuWithFrame:(CGRect)frame;

/** 静态标题默认选中 */
@property (nonatomic) NSInteger titleIndex;


/**
 滚动标题选中颜色改变以及指示器位置变化
 */
- (void)scrollTitleLabelSelecteded:(UILabel *)label;

/**
 滚动标题选中居中
 */
- (void)scrollTitleLabelSelectededCenter:(UILabel *)centerLabel;

/** 
 静止标题选中颜色改变以及指示器位置变化 
 */
- (void)staticTitleLabelSelecteded:(UILabel *)label;

@end
