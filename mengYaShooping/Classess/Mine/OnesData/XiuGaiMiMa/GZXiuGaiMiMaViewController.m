
//
//  GZXiuGaiMiMaViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZXiuGaiMiMaViewController.h"
#import "GZLoginViewController.h"

@interface GZXiuGaiMiMaViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *oldCodeLabel;
@property (nonatomic, strong) UILabel *nowCodeLabel;
@property (nonatomic, strong) UILabel *sureNowCodeLabel;


@property (nonatomic, strong) UIView *oldCodeView;
@property (nonatomic, strong) UIView *nowCodeView;
@property (nonatomic, strong) UIView *sureNowCodeView;


@property (nonatomic, strong) UITextField *oldCodeTF;
@property (nonatomic, strong) UITextField *nowCodeTF;
@property (nonatomic, strong) UITextField *sureNowCodeTF;

@property (nonatomic, strong) GGZButton *sureBtn;

@end

@implementation GZXiuGaiMiMaViewController

- (UIView *)oldCodeView
{
    if (!_oldCodeView) {
        _oldCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 40)];
        _oldCodeView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_oldCodeView];
    }
    return _oldCodeView;
}

-(UILabel *)oldCodeLabel
{
    if (!_oldCodeLabel) {
        _oldCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
        _oldCodeLabel.text = @"旧密码";
        _oldCodeLabel.textColor = [UIColor blackColor];
        _oldCodeLabel.textAlignment = NSTextAlignmentLeft;
        _oldCodeLabel.font = [UIFont systemFontOfSize:15];
        
        [self.oldCodeView addSubview:_oldCodeLabel];
    }
    return _oldCodeLabel;
}

-(UITextField *)oldCodeTF
{
    if (!_oldCodeTF) {
        _oldCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(self.oldCodeLabel.right + 40, 13, kScreenWidth - self.oldCodeLabel.right - 30 - 10, 17)];
        _oldCodeTF.placeholder = @"请输入原密码";
        _oldCodeTF.secureTextEntry = YES;
        _oldCodeTF.delegate = self;
        _oldCodeTF.clearButtonMode = UITextFieldViewModeAlways;

        [_oldCodeTF setValue:YHRGBA(197, 197, 197, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [_oldCodeTF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];

        
        [self.oldCodeView addSubview:_oldCodeTF];
    }
    return _oldCodeTF;
}

-(UIView *)nowCodeView
{
    if (!_nowCodeView) {
        _nowCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.oldCodeView.bottom + 1, kScreenWidth, 40)];
        _nowCodeView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_nowCodeView];
    }
    return _nowCodeView;
}

-(UILabel *)nowCodeLabel
{
    if (!_nowCodeLabel) {
        _nowCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 50, 20)];
        _nowCodeLabel.text = @"新密码";
        _nowCodeLabel.textColor = [UIColor blackColor];
        _nowCodeLabel.textAlignment = NSTextAlignmentLeft;
        _nowCodeLabel.font = [UIFont systemFontOfSize:15];
        [self.nowCodeView addSubview:_nowCodeLabel];
    }
    return _nowCodeLabel;
}

- (UITextField *)nowCodeTF
{
    if (!_nowCodeTF) {
        _nowCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(self.nowCodeLabel.right + 40, 13, kScreenWidth - self.nowCodeLabel.right - 30 - 10, 17)];
        _nowCodeTF.placeholder = @"请输入新密码";
        _nowCodeTF.secureTextEntry = YES;
        _nowCodeTF.delegate = self;
        _nowCodeTF.clearButtonMode = UITextFieldViewModeAlways;

        [_nowCodeTF setValue:YHRGBA(197, 197, 197, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [_nowCodeTF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        
        [self.nowCodeView addSubview:_nowCodeTF];
    }
    return _nowCodeTF;
}

-(UIView *)sureNowCodeView
{
    if (!_sureNowCodeView) {
        _sureNowCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.nowCodeView.bottom + 1, kScreenWidth, 40)];
        _sureNowCodeView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_sureNowCodeView];

    }
    return _sureNowCodeView;
}

-(UILabel *)sureNowCodeLabel
{
    if (!_sureNowCodeLabel) {
        _sureNowCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 80, 20)];
        _sureNowCodeLabel.text = @"确认新密码";
        _sureNowCodeLabel.textColor = [UIColor blackColor];
        _sureNowCodeLabel.textAlignment = NSTextAlignmentLeft;
        _sureNowCodeLabel.font = [UIFont systemFontOfSize:15];
       
        [self.sureNowCodeView addSubview:_sureNowCodeLabel];
    }
    return _sureNowCodeLabel;
}

- (UITextField *)sureNowCodeTF
{
    if (!_sureNowCodeTF) {
        _sureNowCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(self.sureNowCodeLabel.right + 10, 13, kScreenWidth - self.sureNowCodeLabel.right - 5 - 5, 17)];
        _sureNowCodeTF.placeholder = @"请再次输入新密码";
        _sureNowCodeTF.secureTextEntry = YES;
        _sureNowCodeTF.delegate = self;
        _sureNowCodeTF.clearButtonMode = UITextFieldViewModeAlways;

        [_sureNowCodeTF setValue:YHRGBA(197, 197, 197, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [_sureNowCodeTF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        
        [self.sureNowCodeView addSubview:_sureNowCodeTF];
    }
    return _sureNowCodeTF;
}

-(GGZButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [GGZButton createGGZButton];
        _sureBtn.frame = CGRectMake(12, self.sureNowCodeView.bottom + 25, kScreenWidth - 24, 38);
        _sureBtn.backgroundColor = YHRGBA(233, 76, 60, 1.0);
        
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        GZWeakSelf;
        _sureBtn.block = ^(GGZButton *btn) {

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *pwd = [defaults objectForKey:@"User_pwd"];
            
            NSLog(@"__%@",pwd);
                    //修改密码接口
                    NSDictionary *params = @{
                                             @"uid":[GGZTool isUid],
                                             @"oldpwd":weakSelf.oldCodeTF.text,
                                             @"newpwd":weakSelf.sureNowCodeTF.text,
                                             @"language":[GGZTool iSLanguageID],
                                             @"action":@"Change_Pwd"
                                             };
                    
                    [GZHttpTool get:URL params:params success:^(NSDictionary *obj) {
                        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                            
                            if (weakSelf.changeMiMaClickBlock) {
                                weakSelf.changeMiMaClickBlock(weakSelf.sureNowCodeTF.text);
                            }
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            
                            BOOL isSwitch = [defaults boolForKey:@"switch"];

                            if (isSwitch) {
                                
                                [defaults setObject:weakSelf.sureNowCodeTF.text forKey:@"User_pwd"];
                            }else
                            {
                                
                                [defaults setObject:nil forKey:@"User_pwd"];
                            }

                            GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
                            
                            [weakSelf.navigationController presentViewController:loginVC animated:YES completion:nil];
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                            
                        }else
                        {
                            [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
                        }
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD showAlertMessage:@"网络错误"];
                    }];
            

        
            
        };
        
        [self.view addSubview:_sureBtn];
    }
    return _sureBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    
    [self oldCodeTF];
    [self nowCodeTF];
    [self sureNowCodeTF];
    [self sureBtn];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.oldCodeTF resignFirstResponder];
    [self.nowCodeTF resignFirstResponder];
    [self.sureNowCodeTF resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.oldCodeTF resignFirstResponder];
    [self.nowCodeTF resignFirstResponder];
    [self.sureNowCodeTF resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
