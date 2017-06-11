//
//  GZintegralRuleViewController.m
//  mengYaShooping
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZintegralRuleViewController.h"

#import "GZMineResultModel.h"
#import "GZMineDataModel.h"

@interface GZintegralRuleViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation GZintegralRuleViewController

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [MBProgressHUD showMessage:@"加载中..."];
    [self getData];
}

- (void)getData
{
    NSDictionary *params = @{
                             @"action":@"set"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        GZMineResultModel *resultModel = [[GZMineResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];

            GZMineDataModel *dataModel = [[GZMineDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            NSString *languageStr;
            if ([self.title isEqualToString:@"积分规则"]) {
                
                if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
                    languageStr = dataModel.set_jifenguize_china;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                    languageStr = dataModel.set_jifenguize_English;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                    languageStr = dataModel.set_jifenguize_Hungary;
                }
            }else if ([self.title isEqualToString:@"注册协议"])
            {
                if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
                    languageStr = dataModel.set_zhucexieyi_china;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                    languageStr = dataModel.set_zhucexieyi_English;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                    languageStr = dataModel.set_zhucexieyi_Hungary;
                }
            }else if ([self.title isEqualToString:@"常见问题" ]){
                
                if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
                    languageStr = dataModel.set_jifenguize_china;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                    languageStr = dataModel.set_jifenguize_English;
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                    languageStr = dataModel.set_jifenguize_Hungary;
                }
            }
            
            NSString *webContent = [NSString stringWithFormat:@"<!doctype html><html>\n<meta charset=\"utf-8\"><style type=\"text/css\">body{ padding:0; margin:0;}\n.view_h1{ width:90%%; margin:0 auto; display:block; overflow:hidden; font-size:1.1em; color:#333; padding:0.5em 0; line-height:1.0em; }\n.con{ width:90%%; margin:0 auto; color:#fff; color:#666; padding:0.5em 0; overflow:hidden; display:block; font-size:0.92em; line-height:1.8em;}\n.con h1,h2,h3,h4,h5,h6{ font-size:1em;}\nimg{ width:auto; max-width: 100%% !important;height:auto !important;margin:0 auto;display:block;}\n*{ max-width:100%% !important;}\n</style>\n<body style=\"padding:0; margin:0; \"><div class=\"con\">%@</div></body></html>",[NSString stringWithFormat:@"%@",languageStr]];
    
            [self.webView loadHTMLString:webContent baseURL:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAlertMessage:@"网络错误"];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
