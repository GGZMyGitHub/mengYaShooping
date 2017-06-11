//
//  GZRegisterViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZRegisterViewController.h"
#import "GZintegralRuleViewController.h"

@interface GZRegisterViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passnameTF;
@property (weak, nonatomic) IBOutlet UITextField *surePassTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *negotiateBtn;

@property (nonatomic, strong) GGZButton *leftBarBtn;

//翻译
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *negotiateDescribeBtn;


- (IBAction)registerBtn:(UIButton *)sender;
- (IBAction)negotiateBtn:(UIButton *)sender;
- (IBAction)registerNegotiateBtn:(UIButton *)sender;

@end

@implementation GZRegisterViewController{
    BOOL isSelectBtn;
}

-(GGZButton *)leftBarBtn
{
    if (!_leftBarBtn) {
        _leftBarBtn = [GGZButton createGGZButton];
        
        _leftBarBtn.frame = CGRectMake(7, 20, 0, 0);
        [_leftBarBtn sizeToFit];
        
        [_leftBarBtn setImage:[[UIImage imageNamed:@"fanhui_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        GZWeakSelf;
        _leftBarBtn.block = ^(GGZButton *btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
        
    }
    return _leftBarBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;

    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.borderColor = YHRGBA(229, 78, 57, 1.0).CGColor;
    self.negotiateBtn.eventTimeInterval = 0.01;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.usernameTF.placeholder = @"请输入用户名";
        self.passnameTF.placeholder = @"请输入密码";
        self.surePassTF.placeholder = @"请重新输入密码";
        self.describeLabel.text = @"注册或使用账号登录即视为同意";

        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.negotiateDescribeBtn setTitle:@"《梦雅商城用户使用协议》" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.usernameTF.placeholder = @"please enter user name";
        self.passnameTF.placeholder = @"please enter password";
        self.surePassTF.placeholder = @"please enter password again";
        self.describeLabel.text = @"注册或使用账号登录即视为同意英文";
        
        [self.registerBtn setTitle:@"sign in" forState:UIControlStateNormal];
        [self.negotiateDescribeBtn setTitle:@"《梦雅商城用户使用协议》英文" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.usernameTF.placeholder = @"请输入用户名匈牙利文";
        self.passnameTF.placeholder = @"请输入密码匈牙利文";
        self.surePassTF.placeholder = @"请重新输入密码匈牙利文";
        self.describeLabel.text = @"注册或使用账号登录即视为同意匈牙利文";
        
        [self.registerBtn setTitle:@"regiszráltráció" forState:UIControlStateNormal];
        [self.negotiateDescribeBtn setTitle:@"《梦雅商城用户使用协议》匈牙利文" forState:UIControlStateNormal];
    }
    
    [self.usernameTF setValue:YHRGBA(194, 194, 194, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.passnameTF setValue:YHRGBA(194, 194, 194, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.surePassTF setValue:YHRGBA(194, 194, 194, 1.0) forKeyPath:@"_placeholderLabel.textColor"];

    [self.usernameTF addTarget:self action:@selector(usernameTFDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passnameTF addTarget:self action:@selector(passWordTFDidChange:) forControlEvents:UIControlEventEditingChanged];
   
    self.passnameTF.secureTextEntry = YES;
    self.surePassTF.secureTextEntry = YES;
    
    isSelectBtn = NO;
    
    [self.view addSubview:self.leftBarBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.usernameTF resignFirstResponder];
    [self.passnameTF resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameTF resignFirstResponder];
    [self.passnameTF resignFirstResponder];
    [self.surePassTF resignFirstResponder];
    
}

#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)leftBarBtnClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)passWordTFDidChange:(UITextField *)textField
{
    if (textField == self.passnameTF) {
        
        if (textField.text.length >= 6 && textField.text.length <= 18) {
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length)];
            
        }else if (textField.text.length > 18){
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 18)];
        }
    }
}

- (void)usernameTFDidChange:(UITextField *)textField
{
    if (textField == self.usernameTF) {
        
        if (textField.text.length > 0) {
            if ([GGZTool JudgeTheillegalCharacter:textField.text]) {
                
                [MBProgressHUD showAlertMessage:@"输入的有非法字符，请输入字母和数字"];
            }
            
            if (textField.text.length > 15) {
                textField.text = [textField.text substringToIndex:15];
            }
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}

- (IBAction)registerBtn:(UIButton *)sender {

    if (isSelectBtn && self.usernameTF.text.length != 0 && self.passnameTF.text.length != 0 && [self.passnameTF.text isEqualToString:self.surePassTF.text]) {
            
        if ([GGZTool JudgeTheillegalCharacter:self.usernameTF.text]) {
            
        }else
        {
            NSDictionary *params = @{
                                     @"Zhanghao":self.usernameTF.text,
                                     @"pwd":self.passnameTF.text,
                                     @"language":[GGZTool iSLanguageID],
                                     @"action":@"RegMeb"
                                     };
            
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                
                if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                    
                    [MBProgressHUD showSuccess:[obj valueForKey:@"msg"]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else
                {
                    [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD showAlertMessage:@"注册失败"];
            }];
        }
   
    }else if (self.usernameTF.text.length == 0 && self.passnameTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入用户名和密码"];
    }else if (self.usernameTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入用户名"];
    }else if (self.passnameTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入密码"];
    }else if (![self.passnameTF.text isEqualToString:self.surePassTF.text])
    {
        [MBProgressHUD showAlertMessage:@"两次密码不一样"];
    }else if ([self.passnameTF.text isEqualToString:self.surePassTF.text] && self.passnameTF.text.length < 6) {
        
        [MBProgressHUD showAlertMessage:@"请输入密码6~18位"];
    }else if (isSelectBtn == NO){
        [MBProgressHUD showAlertMessage:@"您没同意该协议"];
    }}

- (IBAction)negotiateBtn:(UIButton *)sender {
    
    isSelectBtn = !isSelectBtn;
    
    
    if (isSelectBtn) {
        [sender setImage:[UIImage imageNamed:@"gouxuan2_"] forState:UIControlStateNormal];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"gouxuan1_"] forState:UIControlStateNormal];
    }
}

- (IBAction)registerNegotiateBtn:(UIButton *)sender {
    
    GZintegralRuleViewController *registerNegotiateVC = [[GZintegralRuleViewController alloc] init];
    
    registerNegotiateVC.title = @"注册协议";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:registerNegotiateVC animated:YES];
}

@end
