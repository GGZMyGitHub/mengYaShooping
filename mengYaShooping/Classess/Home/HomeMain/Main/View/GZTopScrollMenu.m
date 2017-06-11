//
//  GZTopScrollMenu.m
//  GZTopScrollMenu
//
//  Created by apple on 17/4/14.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZTopScrollMenu.h"
#import "YYKit.h"

#define labelFontOfSize [UIFont systemFontOfSize:17]
#define selectedTitleAndIndicatorViewColor [UIColor redColor]


@interface GZTopScrollMenu ()

/** 滚动标题Label */
@property (nonatomic, strong) UILabel *scrollTitleLabel;

/** 选中标题是的Label */
@property (nonatomic, strong) UILabel *selectedLabel;

/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UILabel *IDLabel;
//最后一个label，判断label是否居中
@property (nonatomic, strong) UILabel *finilyLabel;

/** 固定Label */
@property (nonatomic, strong) UILabel *staticTitleLabel;



@end

/** label之间的间距 */
static CGFloat const labelMargin = 15;

/** 指示器的高度 */
static CGFloat const indicatorHeight = 3;

@implementation GZTopScrollMenu

-(NSMutableArray *)allTitleLabel
{
    if (!_allTitleLabel) {
        _allTitleLabel = [NSMutableArray array];
    }
    return _allTitleLabel;
}

-(UILabel *)IDLabel
{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
    }
    return _IDLabel;
}

-(UILabel *)finilyLabel
{
    if (!_finilyLabel) {
        _finilyLabel = [[UILabel alloc] init];
    }
    return _finilyLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

+(instancetype)topScrollMenuWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

/**
 计算文字尺寸

 @param text 需要计算尺寸的文字
 @param font 文字的字体
 @param maxSize 文字的最大尺寸
 
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - 重写滚动标题数组setter方法
-(void)setScrollTitleArr:(NSArray *)scrollTitleArr
{
    _scrollTitleArr = scrollTitleArr;
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH =self.frame.size.height - indicatorHeight;

    NSInteger index = 0;

    for (NSInteger i = 0; i < self.scrollTitleArr.count; i++) {
        self.scrollTitleLabel = [[UILabel alloc] init];
        _scrollTitleLabel.userInteractionEnabled = YES;
        _scrollTitleLabel.text = scrollTitleArr[i];
        _scrollTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scrollTitleLabel.tag = i;
        
        //设置高亮文字颜色
        _scrollTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        //计算内容的Size
        CGSize labelSize = [self sizeWithText:_scrollTitleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
        
        //计算内容的宽度
        CGFloat labelW = labelSize.width + 2 * labelMargin;
        
        _scrollTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        labelX = labelX + labelW;
        
        [self.allTitleLabel addObject:_scrollTitleLabel];
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTitleClick: index:)];
        [_scrollTitleLabel addGestureRecognizer:tap];
        
        if ([self.oldTitleIDStr isEqualToString:self.scrollTItleIDArr[i]]) {
            index = i;
            [self scrollTitleClick:tap index:i];
        }
        
        [self addSubview:_scrollTitleLabel];
    }
    
    //计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    self.IDLabel = (UILabel *)self.subviews[index];
    
    self.finilyLabel = (UILabel *)self.subviews[self.scrollTitleArr.count - 1];
   //如果选中的没有超过一个屏幕的宽度，则不让居中
    if (self.finilyLabel.right >= kScreenWidth) {
        [self scrollTitleLabelSelectededCenter:self.IDLabel];
    }

    //添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
    _indicatorView.height = indicatorHeight;
    _indicatorView.top = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    //指示器默认在第一个选中位置
    CGSize labelSize = [self sizeWithText:self.IDLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
    _indicatorView.width = labelSize.width;
    _indicatorView.centerX = self.IDLabel.centerX;
    
}

/** title点击事件 */
- (void)scrollTitleClick:(UITapGestureRecognizer *)tap index:(NSInteger)i
{
    //0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    //1.标题颜色变成红色，设置高亮状态下的颜色，以及指示器位置
    [self scrollTitleLabelSelecteded:selLabel];
    
    if (self.finilyLabel.right >= kScreenWidth) {
        //2.让选中的标题居中 （当contentSize 大于self的宽度才会生效）
        [self scrollTitleLabelSelectededCenter:selLabel];
    }
    
    //3.代理方法实现
    NSInteger index = selLabel.tag;
    
    if ([self.topScrollMenuDelegate respondsToSelector:@selector(GZTopScrollMenu:didSelectTitleAtIndex:)]) {
        [self.topScrollMenuDelegate GZTopScrollMenu:self didSelectTitleAtIndex:index];
    }
}

/** 滚动标题选中颜色改变以及指示器位置变化 */
- (void)scrollTitleLabelSelecteded:(UILabel *)label
{
    //取消高亮
    _selectedLabel.highlighted = NO;
    
    _selectedLabel.textColor = [UIColor blackColor];
    
    label.highlighted = YES;
    _selectedLabel = label;
    
    //改变指示器位置
    [UIView animateWithDuration:0.20f animations:^{
        self.indicatorView.width = label.width - 2 * labelMargin;
        self.indicatorView.centerX = label.centerX;
    }];
}

/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectededCenter:(UILabel *)centerLabel
{
    //计算偏移量
    CGFloat offsetX = centerLabel.center.x - kScreenWidth * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    //获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - kScreenWidth;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }

    //滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark - - - 重写静止标题数组的setter方法
- (void)setStaticTitleArr:(NSArray *)staticTitleArr {
    _staticTitleArr = staticTitleArr;
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = scrollViewWidth / self.staticTitleArr.count;
    CGFloat labelH = self.frame.size.height - indicatorHeight;
    
    for (NSInteger j = 0; j < self.staticTitleArr.count; j++) {
        // 创建静止时的标题Label
        self.staticTitleLabel = [[UILabel alloc] init];
        _staticTitleLabel.userInteractionEnabled = YES;
        _staticTitleLabel.text = self.staticTitleArr[j];
        _staticTitleLabel.textAlignment = NSTextAlignmentCenter;
        _staticTitleLabel.tag = j;
        
        // 设置高亮文字颜色
        _staticTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        // 计算staticTitleLabel的x值
        labelX = j * labelW;
        
        _staticTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_staticTitleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staticTitleClick:)];
        [_staticTitleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
        if (j == _titleIndex) {
            [self staticTitleClick:tap];
        }
        
        [self addSubview:_staticTitleLabel];
    }
    
    // 取出第一个子控件
    UILabel *firstLabel = self.subviews[_titleIndex];
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
    _indicatorView.height = indicatorHeight;
    _indicatorView.top = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    
    // 指示器默认在第一个选中位置
    // 计算TitleLabel内容的Size
    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
    _indicatorView.width = labelSize.width;
    _indicatorView.centerX = firstLabel.centerX;
}

/** staticTitleClick的点击事件 */
- (void)staticTitleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self staticTitleLabelSelecteded:selLabel];
    
    // 2.代理方法实现
    NSInteger index = selLabel.tag;
    
    if ([self.topScrollMenuDelegate respondsToSelector:@selector(GZTopScrollMenu:didSelectTitleAtIndex:)]) {
        [self.topScrollMenuDelegate GZTopScrollMenu:self didSelectTitleAtIndex:index];
    }
}
/** 静止标题选中颜色改变以及指示器位置变化 */
- (void)staticTitleLabelSelecteded:(UILabel *)label {
    // 取消高亮
    _selectedLabel.highlighted = NO;
    
    // 颜色恢复
    _selectedLabel.textColor = [UIColor blackColor];
    
    // 高亮
    label.highlighted = YES;
    
    _selectedLabel = label;
    
    // 改变指示器位置
    [UIView animateWithDuration:0.20 animations:^{
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_selectedLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorHeight)];
        self.indicatorView.width = labelSize.width;
        self.indicatorView.centerX = label.centerX;
    }];
}

@end
