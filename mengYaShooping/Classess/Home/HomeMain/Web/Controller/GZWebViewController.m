//
//  GZWebViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZWebViewController.h"

@interface GZWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation GZWebViewController

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
       
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        
        [_webView loadRequest:request];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
