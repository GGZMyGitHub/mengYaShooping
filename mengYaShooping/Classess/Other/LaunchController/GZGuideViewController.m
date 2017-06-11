//
//  GZGuideViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZGuideViewController.h"
#import "GZTabBarViewController.h"
#import "GZLoginViewController.h"

#import "AppDelegate.h"

@interface GZGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GZGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scroll];

     AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [appDelegate JPush];
}

-(UIScrollView *)scroll
{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scroll.contentSize = CGSizeMake(kScreenWidth * self.imageArr.count
                                         , kScreenHeight);
        _scroll.bounces = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.pagingEnabled = YES;

        _scroll.delegate = self;
        
        [self.view addSubview:_scroll];
    }
    return _scroll;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake((kScreenWidth - 100) / 2, kScreenHeight * 0.9, 100, 44);
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.numberOfPages = 3;

        _pageControl.currentPageIndicatorTintColor = YHRGBA(211, 192, 162, 1.0);
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}

-(void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    
    for (int i=0; i<imageArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];

        imageView.image = [UIImage imageNamed:imageArr[i]];
        imageView.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        
        [self.scroll addSubview:imageView];
        
        if (i == 0) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2, kScreenHeight - 220, 200, 25)];
            label.text = @"餐桌增添暖意";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:label];
            
            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 250)/2, label.bottom + 50, 250, 20)];

            twoLabel.text = @"精挑细选匠人品牌和设计感餐具";
            twoLabel.textColor = YHRGBA(50, 51, 41, 1.0);
            
            twoLabel.font = [UIFont systemFontOfSize:15];
            twoLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:twoLabel];
            
            UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2, twoLabel.bottom + 5, 150, 20)];

            threeLabel.text = @"让每一餐更加精致";
            threeLabel.textColor = YHRGBA(50, 51, 41, 1.0);
            
            threeLabel.font = [UIFont systemFontOfSize:15];
            threeLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:threeLabel];
        }
        
        if (i == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2 + kScreenWidth, kScreenHeight - 220, 200, 25)];
            label.text = @"生活增添乐趣";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:label];
            
            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 250)/2 + kScreenWidth, label.bottom + 50, 250, 20)];
            
            twoLabel.text = @"精挑细选匠人品牌和设计感用品";
            twoLabel.textColor = YHRGBA(50, 51, 41, 1.0);
            
            twoLabel.font = [UIFont systemFontOfSize:15];
            twoLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:twoLabel];
            
            UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2 + kScreenWidth, twoLabel.bottom + 5, 150, 20)];
            
            threeLabel.text = @"让每一天更加轻松";
            threeLabel.textColor = YHRGBA(50, 51, 41, 1.0);
            
            threeLabel.font = [UIFont systemFontOfSize:15];
            threeLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:threeLabel];
        }
        
        
        if (i == 2) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2 + kScreenWidth * 2, 107, 200, 25)];
            label.text = @"- 更高品质，更好生活 -";
            label.textColor = YHRGBA(76, 76, 76, 1.0);
            
            label.font = [UIFont systemFontOfSize:17];
            label.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:label];

            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
            twoLabel.center = CGPointMake(kScreenWidth * 2 + kScreenWidth / 2, kScreenHeight / 2 + 50);
            twoLabel.text = @"梦雅商城";
            twoLabel.textColor = [UIColor blackColor];
            
            twoLabel.font = [UIFont systemFontOfSize:23];
            twoLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:twoLabel];
            
            UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 250)/2 + kScreenWidth * 2, twoLabel.bottom + 15, 250, 20)];
            
            threeLabel.text = @"上海梦雅塑业有限公司@2000-2017";
            threeLabel.textColor = YHRGBA(182, 183, 178, 1.0);
            
            threeLabel.font = [UIFont systemFontOfSize:13];
            threeLabel.textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:threeLabel];

            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor whiteColor];
            btn.frame = CGRectMake(kScreenWidth*i + 94, kScreenHeight * 0.75, kScreenWidth - 94 * 2, 44);
            
            [btn setTitle:@"点击进入" forState:0];
            [btn setTitleColor:YHRGBA(229, 78, 56, 1.0) forState:0];
            
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 22;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = YHRGBA(229, 78, 56, 1.0).CGColor;
            
            [btn addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scroll addSubview:btn];
        }
    }
    [self pageControl];

}

#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    long page = scrollView.contentOffset.x / kScreenWidth;
    
//    if (page == 2) {
//        self.pageControl.hidden = YES;
//    } else {
//        self.pageControl.hidden = NO;
//    }
    self.pageControl.currentPage = (NSInteger)page+0.5;
}

- (void)startApp
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    GZTabBarViewController *tab = [[GZTabBarViewController alloc] init];

    window.rootViewController = tab;
//    GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    
//    window.rootViewController = nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
