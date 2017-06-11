//
//  GZNiChengViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNiChengViewController.h"

@interface GZNiChengViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *niChengView;

@property (nonatomic, strong) UILabel *niChengLabel;
@property (nonatomic, strong) UITextField *niChengTF;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) GGZButton *saveBtn;

@end

@implementation GZNiChengViewController

-(UIView *)niChengView
{
    if (!_niChengView) {
        _niChengView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 40)];
        _niChengView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_niChengView];
    }
    return _niChengView;
}

-(UILabel *)niChengLabel
{
    if (!_niChengLabel) {
        _niChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 40, 20)];
        _niChengLabel.text = @"昵称";
        _niChengLabel.textAlignment = NSTextAlignmentLeft;
        _niChengLabel.textColor = [UIColor blackColor];
        _niChengLabel.font = [UIFont systemFontOfSize:14];

        [self.niChengView addSubview:_niChengLabel];
    }
    return _niChengLabel;
}

-(UITextField *)niChengTF
{
    if (!_niChengTF) {
        _niChengTF = [[UITextField alloc] initWithFrame:CGRectMake(self.niChengLabel.right + 5, 13, kScreenWidth - self.niChengLabel.right - 15, 17)];

        if ([self.title isEqualToString:@"修改昵称"]) {
            _niChengTF.placeholder = @"请输入昵称";
        }else if ([self.title isEqualToString:@"修改签名"])
        {
            _niChengTF.placeholder = @"请修改签名";
        }
     
        [_niChengTF setValue:YHRGBA(197, 197, 197, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [_niChengTF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

        _niChengTF.delegate = self;
        
        [self.niChengView addSubview:_niChengTF];
    }
    return _niChengTF;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.niChengView.bottom + 5, kScreenWidth - 24, 15)];
        _promptLabel.text = @"好的名字可以让好友更好的记住你";
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        _promptLabel.textColor = YHRGBA(157, 157, 157, 1.0);
        _promptLabel.font = [UIFont systemFontOfSize:12];
        
        [self.view addSubview:_promptLabel];
    }
    return _promptLabel;
}

-(GGZButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [GGZButton createGGZButton];
        _saveBtn.frame = CGRectMake(12, self.promptLabel.bottom + 28, kScreenWidth - 24, 38);
        _saveBtn.backgroundColor = YHRGBA(233, 76, 60, 1.0);

        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.layer.cornerRadius = 5;
        
        GZWeakSelf;
        _saveBtn.block = ^(GGZButton *btn) {
            
            if (weakSelf.niChengTF.text.length >0) {
                if ([weakSelf.title isEqualToString:@"修改昵称"]) {
                    NSDictionary *params = @{
                                             @"uid":[GGZTool isUid],
                                             @"language":[GGZTool iSLanguageID],
                                             @"nick":weakSelf.niChengTF.text,
                                             @"action":@"User_Edit_info"
                                             };
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                        
                        if (weakSelf.popBlock) {
                            weakSelf.popBlock(weakSelf.niChengTF.text);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD showAlertMessage:@"网络错误"];
                    }];
                }else if ([weakSelf.title isEqualToString:@"修改签名"]){
                    NSDictionary *params = @{
                                             @"uid":[GGZTool isUid],
                                             @"language":[GGZTool iSLanguageID],
                                             @"qianming":weakSelf.niChengTF.text,
                                             @"action":@"User_Edit_info"
                                             };
                    
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                        
                        if (weakSelf.popBlock) {
                            weakSelf.popBlock(weakSelf.niChengTF.text);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD showAlertMessage:@"网络错误"];
                    }];
                }
            }
        };
        
        [self.view addSubview:_saveBtn];
    }
    return _saveBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    
    [self niChengView];
    [self niChengLabel];
    [self niChengTF];
    [self saveBtn];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {

        self.niChengLabel.text = @"昵称";
        self.niChengTF.placeholder = @"请输入昵称";
        self.promptLabel.text = @"好的名字可以让好友更好的记住你";
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.niChengLabel.text = @"nickname";
        self.niChengTF.placeholder = @"please enter nick name";
        self.promptLabel.text = @"setting an appropriate name can make your friends better remember you";
        [self.saveBtn setTitle:@"save" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.niChengLabel.text = @"neve";
        self.niChengTF.placeholder = @"adja meg a neve";
        self.promptLabel.text = @"好的名字可以让好友更好的记住你匈牙利文";
        [self.saveBtn setTitle:@"mentés" forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.niChengTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.niChengTF resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
