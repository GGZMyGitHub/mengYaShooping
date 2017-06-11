//
//  GZHomeHeaderView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/15.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHomeHeaderView.h"
#import "GZClassListModel.h"

@interface GZHomeHeaderView ()<UIScrollViewDelegate>

/**
 创建轮播图
 */
@property (weak, nonatomic) IBOutlet UIScrollView *cycleScroll;

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UILabel *eightLabel;



@property (nonatomic, strong) YYInfiniteLoopView *loopView;

@property (nonatomic, strong) NSArray *classArr;

- (IBAction)oneBtn:(UIButton *)sender;
- (IBAction)TwoBtn:(UIButton *)sender;
- (IBAction)ThreeBtn:(UIButton *)sender;
- (IBAction)FourBtn:(UIButton *)sender;
- (IBAction)FiveBtn:(UIButton *)sender;

- (IBAction)sixBtn:(UIButton *)sender;
- (IBAction)sevenBtn:(UIButton *)sender;
- (IBAction)eightBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveLabelHeight;


@end

@implementation GZHomeHeaderView

+ (instancetype)createHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil] lastObject];
}

#pragma mark - Getter
-(YYInfiniteLoopView *)loopView
{
    if (!_loopView) {
        _loopView =[[YYInfiniteLoopView alloc] initWithImageUrls:self.imageURLStringsGroup titles:nil didSelectedImage:^(NSInteger index) {
            [self didSelectedImageWithIndex:index];
        }];
        
        // 是否隐藏蒙版
        _loopView.hideCover = NO;
        
        _loopView.coverColor = YHRGBA(0, 0, 0, 0.1);
        // 是否自动轮播
        _loopView.autoPlayer = YES;
        
        // 设置轮播时间
        _loopView.timeInterval = 2.0f;
        
        // 是否隐藏标题, 如果标题数组为nil, 请手动设置隐藏, 默认为NO
        _loopView.hideTitleLabel = YES;
        
        // 以下两个设置pageControl的图片, 用于替代默认的圆点
        _loopView.pageImage = [UIImage imageWithColor:YHRGBA(228, 232, 228, 1.0) forSize:CGSizeMake(10, 2)];
        
        _loopView.currentPageImage = [UIImage imageWithColor:YHRGBA(128, 131, 131, 1.0) forSize:CGSizeMake(10, 2)];
        
        // 设置轮播时的占位图, 用于网络状态不好未能及时请求到网络图片时展示
        // loopView.placeholderImage = [UIImage imageNamed:@"PlaceholderImage"];
        
        // 过渡动画执行时间
        _loopView.animationDuration = 1.0f;
        
        // 过渡动画类型
        _loopView.animationType = InfiniteLoopViewAnimationTypeFade;
        
        // 过渡动画方向
        _loopView.animationDirection = InfiniteLoopViewAnimationDirectionRight;
        
        // 设置frame
        _loopView.frame = self.cycleScroll.bounds;
        
        [self.cycleScroll addSubview:_loopView];
    }
    return _loopView;
}

-(void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
 
    [self loopView];
}

- (void)didSelectedImageWithIndex:(NSInteger)index
{
    if (_selectCycleScrollBlock) {
        _selectCycleScrollBlock(index);
    }
}

-(void)setClassArray:(NSArray *)classArray
{
    _classArray = classArray;
    
    NSArray *imgArr = [classArray valueForKey:@"class_img"];
    NSArray *nameArr = [classArray valueForKey:@"class_name"];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.oneLabelHeight.constant = 20;
        self.fiveLabelHeight.constant = 20;
        self.height = 485;
        
        
        self.oneLabel.font = [UIFont systemFontOfSize:14];
        self.twoLabel.font = [UIFont systemFontOfSize:14];
        self.threeLabel.font = [UIFont systemFontOfSize:14];
        self.fourLabel.font = [UIFont systemFontOfSize:14];
        self.fiveLabel.font = [UIFont systemFontOfSize:14];
        self.sixLabel.font = [UIFont systemFontOfSize:14];
        self.sevenLabel.font = [UIFont systemFontOfSize:14];
        self.eightLabel.font = [UIFont systemFontOfSize:14];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.oneLabelHeight.constant = 50;
        self.fiveLabelHeight.constant = 50;
        self.height = 545;

        
        self.oneLabel.font = [UIFont systemFontOfSize:12];
        self.twoLabel.font = [UIFont systemFontOfSize:12];
        self.threeLabel.font = [UIFont systemFontOfSize:12];
        self.fourLabel.font = [UIFont systemFontOfSize:12];
        self.fiveLabel.font = [UIFont systemFontOfSize:12];
        self.sixLabel.font = [UIFont systemFontOfSize:12];
        self.sevenLabel.font = [UIFont systemFontOfSize:12];
        self.eightLabel.font = [UIFont systemFontOfSize:12];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.oneLabelHeight.constant = 50;
        self.fiveLabelHeight.constant = 50;
        self.height = 545;

        self.oneLabel.font = [UIFont systemFontOfSize:12];
        self.twoLabel.font = [UIFont systemFontOfSize:12];
        self.threeLabel.font = [UIFont systemFontOfSize:12];
        self.fourLabel.font = [UIFont systemFontOfSize:12];
        self.fiveLabel.font = [UIFont systemFontOfSize:12];
        self.sixLabel.font = [UIFont systemFontOfSize:12];
        self.sevenLabel.font = [UIFont systemFontOfSize:12];
        self.eightLabel.font = [UIFont systemFontOfSize:12];
    }
    
    [self.oneBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[0]]] forState:UIControlStateNormal];
    self.oneBtn.tag = 0;
    
    self.oneLabel.text = nameArr[0];
    self.oneLabel.tag = 0;
    
    UITapGestureRecognizer *tap0=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.oneLabel.userInteractionEnabled=YES;
    [self.oneLabel addGestureRecognizer:tap0];
    
    [self.twoBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[1]]] forState:UIControlStateNormal];
    self.twoBtn.tag = 1;
    
    self.twoLabel.text = nameArr[1];
    self.twoLabel.tag = 1;
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.twoLabel.userInteractionEnabled=YES;
    [self.twoLabel addGestureRecognizer:tap1];
    
    [self.threeBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[2]]] forState:UIControlStateNormal];
    self.threeBtn.tag = 2;

    self.threeLabel.text = nameArr[2];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.threeLabel.tag = 2;
    
    self.threeLabel.userInteractionEnabled=YES;
    [self.threeLabel addGestureRecognizer:tap2];
    
    [self.fourBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[3]]] forState:UIControlStateNormal];
    self.fourBtn.tag = 3;

    self.fourLabel.text = nameArr[3];
    
    UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.fourLabel.tag = 3;
    
    self.fourLabel.userInteractionEnabled=YES;
    [self.fourLabel addGestureRecognizer:tap3];
    
    [self.fiveBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[4]]] forState:UIControlStateNormal];
    self.fiveBtn.tag = 4;

    self.fiveLabel.text = nameArr[4];
    
    UITapGestureRecognizer *tap4=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.fiveLabel.tag = 4;
    
    self.fiveLabel.userInteractionEnabled=YES;
    [self.fiveLabel addGestureRecognizer:tap4];
    
    [self.sixBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[5]]] forState:UIControlStateNormal];
    self.sixBtn.tag = 5;

    self.sixLabel.text = nameArr[5];
    
    UITapGestureRecognizer *tap5=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.sixLabel.tag = 5;
    
    self.sixLabel.userInteractionEnabled=YES;
    [self.sixLabel addGestureRecognizer:tap5];
    
    [self.sevenBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[6]]] forState:UIControlStateNormal];
    self.sevenBtn.tag = 6;

    self.sevenLabel.text = nameArr[6];
    
    UITapGestureRecognizer *tap6=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.sevenLabel.tag = 6;
    
    self.sevenLabel.userInteractionEnabled=YES;
    [self.sevenLabel addGestureRecognizer:tap6];
    
    [self.eightBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,imgArr[7]]] forState:UIControlStateNormal];
    self.eightBtn.tag = 7;
    
    self.eightLabel.text = nameArr[7];
    
    UITapGestureRecognizer *tap7=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneLabelClick:)];

    self.eightLabel.tag = 7;
    
    self.eightLabel.userInteractionEnabled=YES;
    [self.eightLabel addGestureRecognizer:tap7];
    
}

- (IBAction)oneBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (void)oneLabelClick:(UITapGestureRecognizer *)tap
{
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(tap.view.tag);
    }
}

- (IBAction)TwoBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)ThreeBtn:(UIButton *)sender {

    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)FourBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)FiveBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)sixBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)sevenBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

- (IBAction)eightBtn:(UIButton *)sender {
    if (self.classBtnClickBlock) {
        self.classBtnClickBlock(sender.tag);
    }
}

@end
