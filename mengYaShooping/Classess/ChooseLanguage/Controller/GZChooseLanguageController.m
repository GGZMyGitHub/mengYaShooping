//
//  GZChooseLanguageController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZChooseLanguageController.h"
#import "GZTabBarViewController.h"
#import "GZGuideViewController.h"

@interface GZChooseLanguageController ()

/** 用于标记选中button */
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) GGZButton *sureBtn;

@property (nonatomic, strong) UIImageView *logoImgV;

@property (nonatomic, strong) UILabel *logoBottomLabel;
@property (nonatomic, strong) UILabel *logoBottomTwoLabel;

@end

@implementation GZChooseLanguageController
{
    BOOL _isSelectLanguage;
}

-(GGZButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [GGZButton createGGZButton];
        _sureBtn.frame = CGRectMake((kScreenWidth - 100)/ 2 - 15, self.remindLabel.bottom + 200, 100, 32);

        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:YHRGBA(151, 151, 151, 1.0) forState:UIControlStateNormal];

        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = _sureBtn.height / 2;
        _sureBtn.layer.borderWidth = 1;
        _sureBtn.layer.borderColor = YHRGBA(207, 207, 207, 1.0).CGColor;
        
        GZWeakSelf;
        _sureBtn.block = ^(GGZButton *btn) {
            
            if ([GGZTool iSSureLogin]) {
                //调存储语言
                [weakSelf getLanguageData];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                GZTabBarViewController *tab = [[GZTabBarViewController alloc] init];
                window.rootViewController = tab;

            }else
            {
                if (_isSelectLanguage == YES) {
                    
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    GZGuideViewController *guideVC = [[GZGuideViewController alloc] init];
                    
                    guideVC.imageArr = @[@"bg_guide_1",@"bg_guide_2",@"bg_guide_3"];
                    window.rootViewController = guideVC;
                    
                }else
                {
                    [MBProgressHUD showAlertMessage:@"请选择语言"];
                }
            }
        };
    }
    return _sureBtn;
}

-(UIImageView *)logoImgV
{
    if (!_logoImgV) {
        _logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _logoImgV.image = [[UIImage imageNamed:@"appIconlogo_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _logoImgV.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 94);
    }
    return _logoImgV;
}

-(UILabel *)logoBottomLabel
{
    if (!_logoBottomLabel) {
        _logoBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2, self.logoImgV.bottom + 10, 200, 20)];
        _logoBottomLabel.text = @"更高品质    更好生活";
        _logoBottomLabel.textColor = YHRGBA(107, 107, 107, 1.0);
        _logoBottomLabel.textAlignment = NSTextAlignmentCenter;
        _logoBottomLabel.font = [UIFont systemFontOfSize:14];
    }
    return _logoBottomLabel;
}

-(UILabel *)logoBottomTwoLabel
{
    if (!_logoBottomTwoLabel) {
        _logoBottomTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 300)/2, self.logoBottomLabel.bottom + 5, 300, 20)];
        _logoBottomTwoLabel.text = @"上海梦雅塑业有限公司@2000-2017";
        _logoBottomTwoLabel.textColor = YHRGBA(183, 184, 176, 1.0);
        _logoBottomTwoLabel.textAlignment = NSTextAlignmentCenter;

        _logoBottomTwoLabel.font = [UIFont systemFontOfSize:11];
    }
    return _logoBottomTwoLabel;
}

- (void)getLanguageData
{
    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"User_use_language"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarColor:[UIColor whiteColor] alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
        
    [self remindLabel];
    
    [self createRadioButton];

    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.logoImgV];
    [self.view addSubview:self.logoBottomLabel];
    [self.view addSubview:self.logoBottomTwoLabel];
    
}

-(UILabel *)remindLabel
{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 99 + 36, 100, 20)];
        _remindLabel.text = @"请选择语言";
        _remindLabel.textColor = [UIColor blackColor];
        _remindLabel.font = [UIFont systemFontOfSize:16];
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:_remindLabel];
    }
    return _remindLabel;
}

- (void)createRadioButton
{
    NSArray *languageArr = @[@"中文",@"English",@"Magyar"];
    
    NSArray *languageJianPin = @[@"zh-Hans-CN",@"en-CN",@"fr-CN"];
    
    for (NSInteger i = 0; i < languageArr.count; i++) {
        
        GGZButton *languageBtn = [GGZButton createGGZButton];
        
        languageBtn.frame = CGRectMake(0, 0, 120, 20);
        languageBtn.center = CGPointMake(kScreenWidth / 2, self.remindLabel.bottom + 30 + (i % 3) * (20 + 25));

        [languageBtn setTitle:languageArr[i] forState:UIControlStateNormal];
        [languageBtn setTitleColor:YHRGBA(120, 120, 120, 1.0) forState:UIControlStateNormal];
        [languageBtn setImage:[UIImage imageNamed:@"dian1_"] forState:UIControlStateNormal];
        languageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if (i == 0) {
            languageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
            languageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        }else
        {
            languageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 22);
            languageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
        }
        
        languageBtn.tag = i;
        
        languageBtn.block = ^(GGZButton *btn) {
           
            _isSelectLanguage = YES;
            
            if (_selectBtn == btn) {
                
            }else{
                NSString *languageID = [NSString stringWithFormat:@"%zd",btn.tag];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:languageID forKey:@"languageID"];
                
                [user synchronize];
                
                [btn setTitleColor:YHRGBA(0, 0, 0, 1.0) forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"dian2_"] forState:UIControlStateNormal];

                NSString *language = languageJianPin[i];
                [kLanguageManager setUserlanguage:language];
                
                [_selectBtn setTitleColor:YHRGBA(120, 120, 120, 1.0) forState:UIControlStateNormal];
                [_selectBtn setImage:[UIImage imageNamed:@"dian1_"] forState:UIControlStateNormal];
                
            }
            _selectBtn = btn;

        };
        [self.view addSubview:languageBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end









