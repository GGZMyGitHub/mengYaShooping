//
//  GZNumberTieViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/5.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNumberTieViewController.h"

@interface GZNumberTieViewController ()


@property (weak, nonatomic) IBOutlet UITextField *weChatTF;
@property (weak, nonatomic) IBOutlet UITextField *QQTF;


@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)QQTF:(UITextField *)sender;
- (IBAction)weChatTF:(UITextField *)sender;

@end

@implementation GZNumberTieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号绑定";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *QQStr = [defaults objectForKey:@"User_QQ"];
    NSString *weChatStr = [defaults objectForKey:@"User_Wechat"];

    if (QQStr != nil) {
        self.QQTF.text = QQStr;
    }
    if (weChatStr != nil) {
        self.weChatTF.text = weChatStr;
    }
    
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveBtn:(UIButton *)sender {

    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"qq":self.QQTF.text,
                             @"wchat":self.weChatTF.text,
                             @"action":@"Bind"
                             };
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.QQTF.text forKey:@"User_QQ"];
        [defaults setObject:self.weChatTF.text forKey:@"User_Wechat"];
        
        [defaults synchronize];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)QQTF:(UITextField *)sender {
    
    if (sender == self.QQTF) {
        if (sender.text.length > 0) {
            if ([GGZTool JudgeTheillegalCharacter:sender.text]) {
                
                [MBProgressHUD showAlertMessage:@"输入的有非法字符，请输入字母和数字"];
            }
            
            if (sender.text.length > 15) {
                sender.text = [sender.text substringToIndex:15];
            }
        }
    }
}

- (IBAction)weChatTF:(UITextField *)sender {
    
    if (sender == self.weChatTF) {
        if (sender.text.length > 0) {
            if ([GGZTool JudgeTheillegalCharacter:sender.text]) {
                
                [MBProgressHUD showAlertMessage:@"输入的有非法字符，请输入字母和数字"];
            }
            
            if (sender.text.length > 15) {
                sender.text = [sender.text substringToIndex:15];
            }
        }
    }
}

@end
