//
//  GZBaseViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZBaseViewController.h"
#import "GZSearchViewController.h"
#import "GZMessageViewController.h"
#import "GZLoginViewController.h"

#import "GZResultHomeModel.h"
#import "GZDataHomeModel.h"


@interface GZBaseViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIBarButtonItem *leftTitle;
/** 搜索跳转 */
@property (nonatomic, strong) GZCustomTextField *searchTF;

@end

@implementation GZBaseViewController

#pragma mark -Getter
-(UIBarButtonItem *)leftTitle
{
    if (!_leftTitle) {
        _leftTitle = [[UIBarButtonItem alloc] init];
        _leftTitle.style = UIBarButtonItemStylePlain;
        _leftTitle.image = [[UIImage imageNamed:@"logo_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _leftTitle;
}

-(GZCustomTextField *)searchTF
{
    if (!_searchTF) {
        UIImageView *searImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        searImgView.image = [UIImage imageNamed:@"sousuo_"];
        
        _searchTF = [[GZCustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 91 -45, 30) Icon:searImgView];
        
        UIImage *image = [UIImage imageWithColor:YHRGBA(236, 244, 244, 1.0) forSize:CGSizeMake(225, 30)];
        
        _searchTF.background = image;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 15;
        
        _searchTF.delegate = self;
    }
    return _searchTF;
}

- (UIBarButtonItem *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiaoxi_"] style:UIBarButtonItemStylePlain target:self action:@selector(messageClick:)];
        
        _messageBtn.tintColor = [UIColor blackColor];
    }
    return _messageBtn;
}

-(UILabel *)redSpotLabel
{
    if (!_redSpotLabel) {
        _redSpotLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 17, 7, 6, 6)];
        _redSpotLabel.backgroundColor = YHRGBA(233, 76, 60, 1.0);
        _redSpotLabel.layer.masksToBounds = YES;
        _redSpotLabel.layer.cornerRadius = 3;
    }
    return _redSpotLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.leftTitle;
    self.navigationItem.titleView =self.searchTF;
    self.navigationItem.rightBarButtonItem = self.messageBtn;

    [self getDatasss];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchTF.enabled = YES;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        self.searchTF.placeholder = @"请输入商品名称";
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        self.searchTF.placeholder = @"please enter product name";
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        self.searchTF.placeholder = @"adja meg a termék nevét";
    }
    
    [self.searchTF setValue:YHRGBA(123, 123, 123, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.searchTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    self.redSpotLabel.hidden = YES;

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    BOOL isFirstEnterMessageVC = [defaults boolForKey:@"enterMessageVC"];
//    
//    if (isFirstEnterMessageVC) {
//        
//        self.redSpotLabel.hidden = YES;
//    }
}

#pragma mark - 拉取数据
- (void)getDatasss
{
    NSString *uid = nil;
    
    if ([GGZTool iSSureLogin]) {
        uid = [GGZTool isUid];
    }else
    {
        uid = @"0";
    }
    
    //uid默认传0
    NSDictionary *param = @{
                            @"ye":@"1",
                            @"language":[GGZTool iSLanguageID],
                            @"uid":uid,
                            @"action":@"Index"
                            };
    
    [GZHttpTool post:URL params:param success:^(NSDictionary *obj) {
        
        GZResultHomeModel *resultModel = [[GZResultHomeModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            GZDataHomeModel *dataModel = [[GZDataHomeModel alloc] initWithDictionary:resultModel.data error:nil];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setBool:NO forKey:@"enterMessageVC"];
            
            [defaults synchronize];
            
            //判断是否有消息未读
            if (![dataModel.no_read isEqualToString:@"0"]) {
                
                [self.navigationController.navigationBar addSubview: self.redSpotLabel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
- (void)messageClick:(UIButton *)btn
{
    
    if ([GGZTool iSSureLogin]) {
        GZMessageViewController *messageVC = [[GZMessageViewController alloc] init];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.backBarButtonItem = backItem;
        
        self.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else
    {
        GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
     
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];

        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    textField.enabled = NO;
    
    GZSearchViewController *searchVC = [[GZSearchViewController alloc] init];
    
    NSDictionary *parmas = @{
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"Hotserch"
                             };
    
    [GZHttpTool post:URL params:parmas success:^(NSDictionary *obj) {
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            
            if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                
                searchVC.tagsArray = [[obj valueForKey:@"data"] valueForKey:@"s_name"];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:searchVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                textField.enabled = NO;
                
            }
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

@end
