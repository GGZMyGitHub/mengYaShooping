//
//  GZsheZhiController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZsheZhiController.h"
#import "GZOnesDataViewController.h"
#import "GZXiuGaiMiMaViewController.h"
#import "GZSheZhiLanguageViewController.h"
#import "GZfeedBackViewController.h"
#import "GZNumberTieViewController.h"
#import "GZSheZhiTableViewCell.h"
#import "GZLoginViewController.h"
#import "GZintegralRuleViewController.h"


@interface GZsheZhiController ()

@property (nonatomic, strong) UITableView *tableView;

/**
 封装tableView
 */
@property (nonatomic, strong) GZCustomTableView *customTableView;

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) GGZButton *backLogin;


@end

@implementation GZsheZhiController

-(NSArray *)dataSource
{
        
    NSString *geRenZiLiaoStr;
    NSString *xiuGaiMiMaStr;
    NSString *zhangHaoBangDingStr;
    NSString *yuYanSheZhiStr;
    NSString *changJianWenTiStr;
    NSString *qingLiHuanCunStr;
    NSString *yiJianFanKuiStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        geRenZiLiaoStr = @"个人资料";
        xiuGaiMiMaStr = @"修改密码";
        zhangHaoBangDingStr = @"账号绑定";
        yuYanSheZhiStr = @"语言设置";
        changJianWenTiStr = @"常见问题";
        qingLiHuanCunStr = @"清理缓存";
        yiJianFanKuiStr = @"意见反馈";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        geRenZiLiaoStr = @"personal information";
        xiuGaiMiMaStr = @"change password";
        zhangHaoBangDingStr = @"account binding";
        yuYanSheZhiStr = @"语言设置英文";
        changJianWenTiStr = @"FAQ";
        qingLiHuanCunStr = @"wipe cache partition";
        yiJianFanKuiStr = @"feedback";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        geRenZiLiaoStr = @"személyes adatok";
        xiuGaiMiMaStr = @"jelszavak módosítás";
        zhangHaoBangDingStr = @"账号绑定匈牙利文";
        yuYanSheZhiStr = @"语言设置匈牙利文";
        changJianWenTiStr = @"kérdéseket";
        qingLiHuanCunStr = @"adatok törlése";
        yiJianFanKuiStr = @"vélemény csatlakozás";
    }

    NSMutableDictionary *geRenZiLiao = [NSMutableDictionary dictionary];
    geRenZiLiao[@"title"] = geRenZiLiaoStr;
    geRenZiLiao[@"controller"] = [GZOnesDataViewController class];
    
    NSMutableDictionary *xiuGaiMiMa = [NSMutableDictionary dictionary];
    xiuGaiMiMa[@"title"] = xiuGaiMiMaStr;
    xiuGaiMiMa[@"controller"] = [GZXiuGaiMiMaViewController class];
    
    NSMutableDictionary *zhangHaoBangDing = [NSMutableDictionary dictionary];
    zhangHaoBangDing[@"title"] = zhangHaoBangDingStr;
    zhangHaoBangDing[@"controller"] = [GZNumberTieViewController class];
    
    NSMutableDictionary *yuYanSheZhi = [NSMutableDictionary dictionary];
    yuYanSheZhi[@"title"] = yuYanSheZhiStr;
    yuYanSheZhi[@"controller"] = [GZSheZhiLanguageViewController class];
    
    NSMutableDictionary *changJianWenTi = [NSMutableDictionary dictionary];
    changJianWenTi[@"title"] = changJianWenTiStr;
    changJianWenTi[@"controller"] = [GZintegralRuleViewController class];
    
    NSMutableDictionary *qingLiHuanCun = [NSMutableDictionary dictionary];
    qingLiHuanCun[@"title"] = qingLiHuanCunStr;
    
    NSMutableDictionary *yiJianFanKui = [NSMutableDictionary dictionary];
    yiJianFanKui[@"title"] = yiJianFanKuiStr;
    yiJianFanKui[@"controller"] = [GZfeedBackViewController class];
    
    NSArray *section1 = @[geRenZiLiao,xiuGaiMiMa,zhangHaoBangDing,yuYanSheZhi,changJianWenTi,qingLiHuanCun];
    NSArray *section2 = @[yiJianFanKui];
    
    _dataSource = [NSArray arrayWithObjects:section1,section2, nil];
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49-64) style:UITableViewStyleGrouped];
        _tableView.sectionFooterHeight = 10;
        _tableView.sectionHeaderHeight = 0;
        _tableView.scrollEnabled = NO;

        _tableView.contentInset = UIEdgeInsetsMake(10 - 35, 0, 0, 0);
        
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

-(GZCustomTableView *)customTableView
{
        _customTableView = [[GZCustomTableView alloc] initWithTableView:self.tableView
                                                          tableViewCell:[GZSheZhiTableViewCell class]
                                                         cellIdentifier:@"GZSheZhiTableViewCell"
                                                                 useXib:NO
                                                                   data:self.dataSource
                                                                  click:^(NSIndexPath *indexpath, NSArray *dataArr)
                            {
                                //点击cell回调事件
                                GZSheZhiTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];

                                if (indexpath.section == 0 && indexpath.row == 0) {
                                    
                                    GZOnesDataViewController *onesDataVC = [[GZOnesDataViewController alloc] init];
                                    
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    onesDataVC.niChengStr = [defaults objectForKey:@"User_Nick"];
                                    onesDataVC.qianMingStr = [defaults objectForKey:@"mineQianming"];
                                    onesDataVC.headerStr =  [defaults objectForKey:@"UserHeader"];
                                    onesDataVC.fengMianStr = [defaults objectForKey:@"fengmian"];
                                    
                                    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                                    
                                    self.navigationItem.backBarButtonItem = backItem;
                                    
                                    self.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:onesDataVC animated:YES];
                                    
                                }else if (indexpath.section == 0 && indexpath.row == 2){
                                 
                                    GZNumberTieViewController *numberTieVC = [[GZNumberTieViewController alloc] init];
                                    
                                    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                    
                                    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                                    
                                    self.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:numberTieVC animated:YES];
                                    
                                }else if (indexpath.section == 0 && indexpath.row == 4)
                                {
                                    GZintegralRuleViewController *integralRuleVC = [[GZintegralRuleViewController alloc] init];
                                    
                                    integralRuleVC.title = @"常见问题";
                                    
                                    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                                    
                                    self.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:integralRuleVC animated:YES];
                                    
                                }else{
                                    if (self.dataSource[indexpath.section][indexpath.row][@"controller"]){
                                        UIViewController *vc = [[self.dataSource[indexpath.section][indexpath.row][@"controller"] alloc] init];
                                        
                                        vc.title = self.dataSource[indexpath.section][indexpath.row][@"title"];
                                        
                                        
                                        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                        
                                        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                                        
                                        self.navigationItem.backBarButtonItem = barItem;
                                        
                                        self.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vc animated:YES];
                                        
                                        self.navigationController.navigationBar.hidden = NO;
                                        
                                    }else{
                                        [self.tableView deselectRowAtIndexPath:indexpath animated:YES];
                                        
                                        [[SDImageCache sharedImageCache] clearDisk];
                                        [[SDWebImageManager sharedManager] cancelAll];
                                        
                                        cell.detailLabel.text = [self caCheSize];
                                    }
                                }
                            }];
        
        _customTableView.tableViewType = TableViewStyleGrouped;

    
    return _customTableView;
}

-(GGZButton *)backLogin
{
    if (!_backLogin) {
        _backLogin = [GGZButton createGGZButton];
        _backLogin.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
        _backLogin.backgroundColor = [UIColor whiteColor];
        _backLogin.titleLabel.font = [UIFont systemFontOfSize:16];
        _backLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_backLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        [_backLogin setTitleColor:YHRGBA(233, 76, 60, 1.0) forState:UIControlStateNormal];
        
        GZWeakSelf;
        _backLogin.block = ^(GGZButton *btn) {
            
            GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
            
            loginVC.languageID = @"sheZhiVC";
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"uid"];
            [defaults removeObjectForKey:@"u_ZhangHao"];
            [defaults removeObjectForKey:@"User_Nick"];
            [defaults removeObjectForKey:@"User_head"];
            [defaults removeObjectForKey:@"User_Fengmian"];
            [defaults setBool:NO forKey:@"login"];
            [defaults synchronize];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            weakSelf.hidesBottomBarWhenPushed = YES;
            
        };
    }
    return _backLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.backLogin];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [self.backLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        [self.backLogin setTitle:@"log out" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        [self.backLogin setTitle:@"kilépés" forState:UIControlStateNormal];
    }
    
    [self customTableView];
}

#pragma mark - custom action
- (NSString *)caCheSize
{
    NSString *detailTitle = nil;
    CGFloat size = [SDImageCache sharedImageCache].getSize;
    
    if (size > 1024 * 1024){
        detailTitle = [NSString stringWithFormat:@"%.02fM",size / 1024 / 1024];
    }else if (size > 1024){
        detailTitle = [NSString stringWithFormat:@"%.02fKB",size / 1024];
    }else{
        detailTitle = [NSString stringWithFormat:@"%.02fB",size];
    }
    
    return detailTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
