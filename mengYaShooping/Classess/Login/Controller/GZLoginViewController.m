//
//  GZLoginViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZLoginViewController.h"
#import "GZChooseLanguageController.h"
#import "GZRegisterViewController.h"
#import "GZTabBarViewController.h"
#import "GZlianXiWoMenController.h"
#import "GZMineResultModel.h"
#import "GZMineDataModel.h"

#import "GZHomeViewController.h"
#import "GZTabBarViewController.h"

#import "GZLoginResultModel.h"
#import "GZLoginDataModel.h"

#import "GZLoginField.h"
#import "UMSocial.h"

#define XLREQUEST @"https://api.weibo.com/oauth2/authorize?client_id=2039393085&redirect_uri=http://www.code4app.com/space-uid-843201.html"

@interface GZLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@property (nonatomic, strong) GGZButton *leftBarBtn;

//翻译
@property (weak, nonatomic) IBOutlet UILabel *rememberLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UILabel *NoUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *huoZheLabel;



@property (nonatomic, strong) GZLoginDataModel *dataModel;
@property (nonatomic) BOOL isButtonOn;

- (IBAction)forgetBtn:(UIButton *)sender;
- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)registerBtn:(UIButton *)sender;
- (IBAction)QQLogin:(UIButton *)sender;
- (IBAction)weixinLogin:(UIButton *)sender;

- (IBAction)switchAction:(UISwitch *)sender;

@end

@implementation GZLoginViewController

-(GGZButton *)leftBarBtn
{
    if (!_leftBarBtn) {
        _leftBarBtn = [GGZButton createGGZButton];
        _leftBarBtn.frame = CGRectMake(7, 20, 0, 0);
        [_leftBarBtn sizeToFit];
        
        [_leftBarBtn setImage:[[UIImage imageNamed:@"fanhui_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        GZWeakSelf;
        _leftBarBtn.block = ^(GGZButton *btn) {
           
            if ([weakSelf.languageID isEqualToString:@"sheZhiVC"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoDataView" object:nil userInfo:nil];

            }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _leftBarBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySwitch.transform = CGAffineTransformMakeScale( 0.5, 0.5);//缩放
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2;
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = YHRGBA(229, 78, 57, 1.0).CGColor;
    self.loginBtn.adjustsImageWhenHighlighted = NO;
    self.usernameTF.delegate = self;
    self.passWordTF.delegate = self;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.usernameTF.placeholder = @"用户名";
        self.passWordTF.placeholder = @"密码";
        
        self.rememberLabel.text = @"记住密码";
        self.NoUserNameLabel.text = @"没有账号?";
        self.huoZheLabel.text = @"或者";
        
        [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.usernameTF.placeholder = @"user name";
        self.passWordTF.placeholder = @"password";
        self.rememberLabel.text = @"remember password";
        self.NoUserNameLabel.text = @"no account?";
        self.huoZheLabel.text = @"Or";
        
        [self.forgetBtn setTitle:@"forget password?" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"login" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"sign in" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.usernameTF.placeholder = @"Felhasználói név";
        self.passWordTF.placeholder = @"jelszó";
        self.rememberLabel.text = @"emlékesztő";
        self.NoUserNameLabel.text = @"nincs még regisztráltva?";
        self.huoZheLabel.text = @"Vagy";
        
        [self.forgetBtn setTitle:@"elfelejtett jelszó?" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"bejelentkezés" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"regisztráció" forState:UIControlStateNormal];
    }

    [self.usernameTF setValue:YHRGBA(194, 194, 194, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWordTF setValue:YHRGBA(194, 194, 194, 1.0) forKeyPath:@"_placeholderLabel.textColor"];

    [self.usernameTF addTarget:self action:@selector(usernameTFDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTF addTarget:self action:@selector(passWordTFDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.passWordTF.secureTextEntry = YES;
    
    [self.view addSubview:self.leftBarBtn];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    NSString *pwd = [defaults objectForKey:@"User_pwd"];
    BOOL isSwitch = [defaults boolForKey:@"switch"];
    
    self.passWordTF.text = pwd;
    [self.mySwitch setOn:isSwitch animated:YES];
    
    
//    @property (weak, nonatomic) IBOutlet UILabel *rememberLabel;
//    @property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
//    @property (weak, nonatomic) IBOutlet UILabel *NoUserNameLabel;
//    @property (weak, nonatomic) IBOutlet UIButton *registerBtn;
//    @property (weak, nonatomic) IBOutlet UILabel *huoZheLabel;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)passWordTFDidChange:(UITextField *)textField
{
    if (textField == self.passWordTF) {
        
        if (textField.text.length >= 6 && textField.text.length <= 18) {

            textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length)];
            NSLog(@"%@",textField.text);

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

- (IBAction)forgetBtn:(UIButton *)sender {
    
    GZlianXiWoMenController *lianxiWoMenVC = [[GZlianXiWoMenController alloc] init];
    lianxiWoMenVC.title = @"忘记密码";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self.navigationController pushViewController:lianxiWoMenVC animated:YES];
}

- (IBAction)loginBtn:(UIButton *)sender {
//    //账号密码加密
//    NSString *usernameEncrypt = [self.usernameTF.text Des_3EncryptForTimeInterval:nil Appkey:APPKEY AppSecret:APPSECRET];
//    
//    NSString *passWordEncrypt = [self.passWordTF.text Des_3EncryptForTimeInterval:nil Appkey:APPKEY AppSecret:APPSECRET];
   
    if (self.usernameTF.text.length != 0 && self.passWordTF.text.length != 0) {
        
        if (self.passWordTF.text.length < 6) {
            [MBProgressHUD showAlertMessage:@"请输入密码6~18位"];
        }else
        {
            if ([GGZTool JudgeTheillegalCharacter:self.usernameTF.text]) {
                
            }else
            {
                NSDictionary *params = @{
                                         @"Zhanghao":self.usernameTF.text,
                                         @"pwd":self.passWordTF.text,
                                         @"language":[GGZTool iSLanguageID],
                                         @"action":@"User_Login"
                                         };
                
                [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                    GZLoginResultModel *resultModel = [[GZLoginResultModel alloc] initWithDictionary:obj error:nil];
                    
                    if ([resultModel.msgcode isEqualToString:@"1"]) {
                        
                        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
                        {
                            [MBProgressHUD showSuccess:@"登录成功"];
                            
                        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                            
                            [MBProgressHUD showSuccess:@"登录成功英文"];
                            
                        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                            
                            [MBProgressHUD showSuccess:@"登录成功匈牙利文"];
                        }
                        
                        
                        GZLoginDataModel *dataModel = [[GZLoginDataModel alloc] initWithDictionary:resultModel.data error:nil];
                        
                        self.dataModel = dataModel;
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setBool:YES forKey:@"login"];
                        
                        //替换语言，转化成服务器给的语言
                        [defaults setObject:dataModel.User_Language forKey:@"languageID"];
                        
                        //将firstLaunch值改为NO
                        [defaults setBool:NO forKey:@"firstLaunch"];
                        
                        [defaults setObject:dataModel.uid forKey:@"uid"];
                        [defaults setObject:dataModel.u_ZhangHao forKey:@"u_ZhangHao"];
                        [defaults setObject:dataModel.User_Nick forKey:@"User_Nick"];
                        [defaults setObject:dataModel.User_head forKey:@"User_head"];
                        [defaults setObject:dataModel.User_Fengmian forKey:@"User_Fengmian"];
                        
                        if (_isButtonOn) {
                            
                            [defaults setObject:self.dataModel.User_pwd forKey:@"User_pwd"];
                        }else
                        {
                            
                            [defaults setObject:nil forKey:@"User_pwd"];
                        }
                        
                        //同步一下
                        [defaults synchronize];
                        
                        if (_selectTabBarBlock) {
                            _selectTabBarBlock();
                        }
                        
                        //添加购物车成功，通知TabbarController，调用数据更改角标
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        //登录成功调后面联系我们、积分规则等数据接口
                        [self getSetData];
                        
                    }else
                    {
                        [MBProgressHUD showAlertMessage:resultModel.msg];
                    }
                    
                } failure:^(NSError *error) {
                    
                    [MBProgressHUD showError:@"登录失败"];
                    
                }];
            }
        }
    }else if (self.usernameTF.text.length == 0 && self.passWordTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入用户名和密码"];

    }else if (self.passWordTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入密码"];
        
    }else if (self.usernameTF.text.length == 0){
        [MBProgressHUD showAlertMessage:@"请输入用户名"];
    }
}

- (void)getSetData
{
    NSDictionary *params = @{
                             @"action":@"set"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        GZMineResultModel *resultModel = [[GZMineResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
        
            GZMineDataModel *dataModel = [[GZMineDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dataModel.set_tel forKey:@"connectMe"];
            [defaults setObject:dataModel.set_over_mony_noyunfei forKey:@"set_over_mony_noyunfei"];
            
            [defaults synchronize];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (IBAction)registerBtn:(UIButton *)sender {
    
    GZRegisterViewController *registerVC = [[GZRegisterViewController alloc] init];
  
    [self.navigationController pushViewController:registerVC animated:YES];

}

- (IBAction)QQLogin:(UIButton *)sender {
    
    UMSocialSnsPlatform * snsPlatform= [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    __weak typeof(self) weakSelf = self;
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //   获取微博用户名、uid、token
        if (response.responseCode == UMSResponseCodeSuccess) {
            //            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                
                [MBProgressHUD showSuccess:@"登陆成功"];
                
                [weakSelf jump];
                
            }];
        }});
    
}

- (IBAction)weixinLogin:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //   获取用户名、uid、token
        if (response.responseCode == UMSResponseCodeSuccess) {
            //            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatTimeline];
            //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                
                [MBProgressHUD showSuccess:@"登陆成功"];
                
                [weakSelf jump];
            }];
        }});
}

/** 登陆成功之后跳转 */
- (void)jump
{
    GZTabBarViewController *tab = [[GZTabBarViewController alloc] init];
    
    //一秒之后跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"登陆成功"];
        
        [self presentViewController:tab animated:YES completion:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
        }];
    });
}

- (IBAction)switchAction:(UISwitch *)sender {
    
    BOOL isButtonOn = [sender isOn];
    
    if (isButtonOn) {
        
        _isButtonOn = YES;
        
    }else {
        _isButtonOn = NO;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:isButtonOn forKey:@"switch"];
    
    [defaults synchronize];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.usernameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"GZLoginVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"NoDataView"];

}

@end
