//
//  UIViewController+GZExtension.m
//  youYouJiaJiao
//
//  Created by apple on 17/4/9.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "UIViewController+GZExtension.h"

@implementation UIViewController (GZExtension)

- (void)navigationBarGradualChangeWithScrollView:(UIScrollView *)scrollView positionBtn:(GGZButton *)positionBtn newsBtn:(GGZButton *)newsBtn GZCustomTextField:(GZCustomTextField *)searchTF offset:(CGFloat)offset color:(UIColor *)color
{
    [self viewWillLayoutSubviews];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    if (scrollView.contentOffset.y >= 150) {
        [positionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [positionBtn setImage:[UIImage imageNamed:@"circle_left_icon01_"] forState:UIControlStateNormal];
        [newsBtn setImage:[UIImage imageNamed:@"details_bottom_icon01_"] forState:UIControlStateNormal];

        [searchTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        UIImageView *searImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 20, 20)];
        searImgView.image = [UIImage imageNamed:@"search_icon_"];
        searchTF.leftView = searImgView;
        searchTF.leftViewMode = UITextFieldViewModeAlways;
       
    //    UIImage *image = [UIImage imageNamed:@"search_input"];
    //    searchTF.background = image;

        
        
    }else if (scrollView.contentOffset.y < 150) {
        [positionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [positionBtn setImage:[UIImage imageNamed:@"index_top_xia_"] forState:UIControlStateNormal];
      
        [newsBtn setImage:[UIImage imageNamed:@"index_top_message_"] forState:UIControlStateNormal];

        [searchTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        UIImageView *searImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 20, 20)];
        searImgView.image = [UIImage imageNamed:@"index_top_search_"];
        searchTF.leftView = searImgView;
        searchTF.leftViewMode = UITextFieldViewModeAlways;
        UIImage *image = [UIImage imageNamed:@"index_top_input"];
        searchTF.background = image;
        


    }
    
    
    float alpha = 1 - ((offset - scrollView.contentOffset.y) / offset);
    [self setNavigationBarColor:color alpha:alpha];

}

- (void)setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:alpha > 0.95f ? 0.95f : alpha]] forBarMetrics:UIBarMetricsDefault];
    if (self.navigationController.viewControllers.count > 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        view.backgroundColor = color; [self.view addSubview:view];
    }
}

@end
