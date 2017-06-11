//
//  GZlianXiWoMenController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZlianXiWoMenController.h"

#import "GZSetResultModel.h"
#import "GZSetDataModel.h"

@interface GZlianXiWoMenController ()

@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *diallingBtn;


- (IBAction)addressBookClick:(UIButton *)sender;

@end

@implementation GZlianXiWoMenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.title = @"联系我们";
        [self.diallingBtn setTitle:@"一键拨号" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.title = @"contact us";
        [self.diallingBtn setTitle:@"一键拨号英文" forState:UIControlStateNormal];

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.title = @"kapcsolatok";
        [self.diallingBtn setTitle:@"一键拨号匈牙利文" forState:UIControlStateNormal];

    }
    
    self.diallingBtn.layer.masksToBounds = YES;
    self.diallingBtn.layer.borderWidth = 1;
    self.diallingBtn.layer.borderColor = YHRGBA(229, 78, 57, 1.0).CGColor;
    self.diallingBtn.layer.cornerRadius = self.diallingBtn.height / 2;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *telephoneStr = [defaults objectForKey:@"connectMe"];
    
    if (telephoneStr != nil) {
        
        self.telephoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"connectMe"];
    }else
    {
        NSDictionary *params = @{
                                 @"action":@"set"
                                 };

        [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
            
            GZSetResultModel *resultModel = [[GZSetResultModel alloc] initWithDictionary:obj error:nil];
            
            if ([resultModel.msgcode isEqualToString:@"1"]) {
                
                GZSetDataModel *dataModel = [[GZSetDataModel alloc] initWithDictionary:resultModel.data error:nil];

                self.telephoneLabel.text = dataModel.set_tel;
            }
        } failure:^(NSError *error) {

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addressBookClick:(UIButton *)sender {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"connectMe"]];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

@end
