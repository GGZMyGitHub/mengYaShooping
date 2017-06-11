//
//  GZTmpTableViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZMineTableViewController.h"
#import "GZlianXiWoMenController.h"
#import "GZsheZhiController.h"
#import "GZwoDeDingDanController.h"
#import "GZwoDeJiFenController.h"
#import "GZwoDeShouCangController.h"
#import "GZChooseLanguageController.h"
#import "GZOnesDataViewController.h"
#import "GZSureOrderDiZhiGuanLiController.h"
#import "GZMessageViewController.h"

#import "GZStatusView.h"

#import "GZLoginViewController.h"
#import "GZMineTableViewCell.h"

#import "GZMineTableViewCell.h"

@interface GZMineTableViewController ()<UINavigationControllerDelegate>

@property(nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) NSArray *dataSource;


@property (nonatomic, strong) GGZButton *headerBtn;
@property (nonatomic, strong) UILabel *niChengLabel;
@property (nonatomic, strong) UILabel *qianMingLabel;

@property (nonatomic, copy) NSString *User_Nick;
@property (nonatomic, copy) NSString *User_Qianming;
@property (nonatomic, copy) NSString *User_Header;

@property (nonatomic, copy) NSString *User_Fengmian;
@property (nonatomic, copy) NSNumber *dfh;
@property (nonatomic, copy) NSNumber *dsh;
@property (nonatomic, copy) NSNumber *ywc;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;


@end

static NSString *Identifier = @"GZMineTableViewCell";
@implementation GZMineTableViewController

#pragma mark - Getter
-(NSArray *)dataSource
{
    NSString *woDeDingDanStr;
    NSString *woDeShouCangStr;
    NSString *lianXiWoMenStr;
    NSString *diZhiGuanLiStr;
    NSString *woDeJiFenStr;
    NSString *woDeXiaoXiStr;
    NSString *sheZhiStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        woDeDingDanStr = @"我的订单";
        woDeShouCangStr = @"我的收藏";
        lianXiWoMenStr = @"联系我们";
        diZhiGuanLiStr = @"地址管理";
        woDeJiFenStr = @"我的积分";
        woDeXiaoXiStr = @"我的消息";
        sheZhiStr = @"设置";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        woDeDingDanStr = @"my order";
        woDeShouCangStr = @"my collection";
        lianXiWoMenStr = @"contact us";
        diZhiGuanLiStr = @"address management";
        woDeJiFenStr = @"my point";
        woDeXiaoXiStr = @"我的消息英文";
        sheZhiStr = @"setting";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        woDeDingDanStr = @"rendeléseim";
        woDeShouCangStr = @"kedvenceim";
        lianXiWoMenStr = @"kapcsolatok";
        diZhiGuanLiStr = @"cím kezelés";
        woDeJiFenStr = @"pont gyűjtéseim";
        woDeXiaoXiStr = @"我的消息匈牙利文";
        sheZhiStr = @"beállítások";
        
    }
    
    NSMutableDictionary *woDeDingDan = [NSMutableDictionary dictionary];
    woDeDingDan[@"title"] = woDeDingDanStr;
    woDeDingDan[@"icon"] = @"dingdan_";
    woDeDingDan[@"controller"] = [GZwoDeDingDanController class];
    
    NSMutableDictionary *woDeShouCang = [NSMutableDictionary dictionary];
    woDeShouCang[@"title"] = woDeShouCangStr;
    woDeShouCang[@"icon"] = @"shoucang_";
    woDeShouCang[@"controller"] = [GZwoDeShouCangController class];
    
    NSMutableDictionary *lianXiWoMen = [NSMutableDictionary dictionary];
    lianXiWoMen[@"title"] = lianXiWoMenStr;
    lianXiWoMen[@"icon"] = @"lianxi_";
    lianXiWoMen[@"controller"] = [GZlianXiWoMenController class];
    
    NSMutableDictionary *diZhiGuanLi = [NSMutableDictionary dictionary];
    diZhiGuanLi[@"title"] = diZhiGuanLiStr;
    diZhiGuanLi[@"icon"] = @"dizhi_";
    diZhiGuanLi[@"controller"] = [GZSureOrderDiZhiGuanLiController class];
    
    NSMutableDictionary *woDeJiFen = [NSMutableDictionary dictionary];
    woDeJiFen[@"title"] = woDeJiFenStr;
    woDeJiFen[@"icon"] = @"jifen_";
    woDeJiFen[@"controller"] = [GZwoDeJiFenController class];
    
    NSMutableDictionary *woDeXiaoXi = [NSMutableDictionary dictionary];
    woDeXiaoXi[@"title"] = woDeXiaoXiStr;
    woDeXiaoXi[@"icon"] = @"xiaoxi_";
    woDeXiaoXi[@"controller"] = [GZMessageViewController class];
    
    NSMutableDictionary *sheZhi = [NSMutableDictionary dictionary];
    sheZhi[@"title"] = sheZhiStr;
    sheZhi[@"icon"] = @"shezhi_";
    sheZhi[@"controller"] = [GZsheZhiController class];
    
    NSArray *section1 = @[woDeDingDan];
    
    NSArray *section2 = @[woDeShouCang,lianXiWoMen,diZhiGuanLi,woDeJiFen,woDeXiaoXi,sheZhi];
    _dataSource = [NSArray arrayWithObjects:section1,section2, nil];
    return _dataSource;
}

-(GGZButton *)headerBtn
{
    if (!_headerBtn) {
        _headerBtn = [GGZButton createGGZButton];
        _headerBtn.frame = CGRectMake((kScreenWidth - 82)/2, 50, 82, 82);
        _headerBtn.layer.masksToBounds = YES;
        _headerBtn.layer.cornerRadius = 82/2;
        
        __weak typeof(self) weakSelf = self;
        _headerBtn.block = ^(GGZButton *btn) {
            
            GZOnesDataViewController *onesDataVC = [[GZOnesDataViewController alloc] init];
            onesDataVC.niChengStr = weakSelf.User_Nick;
            onesDataVC.qianMingStr = weakSelf.User_Qianming;
            onesDataVC.headerStr = weakSelf.User_Header;
            onesDataVC.fengMianStr = weakSelf.User_Fengmian;
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            weakSelf.navigationController.navigationBar.tintColor = [UIColor blackColor];
            
            weakSelf.navigationItem.backBarButtonItem = backItem;
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:onesDataVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        };
    }
    return _headerBtn;
}

-(UILabel *)niChengLabel
{
    if (!_niChengLabel) {
        _niChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        _niChengLabel.center = CGPointMake(kScreenWidth / 2, self.headerBtn.bottom + 20);
        
        _niChengLabel.textColor = [UIColor blackColor];
        _niChengLabel.textAlignment = NSTextAlignmentCenter;
        _niChengLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _niChengLabel;
}

-(UILabel *)qianMingLabel
{
    if (!_qianMingLabel) {
        _qianMingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        _qianMingLabel.center = CGPointMake(kScreenWidth / 2, self.niChengLabel.bottom + 10);
        
        _qianMingLabel.textColor = [UIColor blackColor];
        _qianMingLabel.textAlignment = NSTextAlignmentCenter;
        _qianMingLabel.font = [UIFont systemFontOfSize:12];
    }
    return _qianMingLabel;
}

-(GZNoNetWorking *)noNetVC
{
    if (!_noNetVC) {
        _noNetVC = [GZNoNetWorking createNoNetWorkingView];
        _noNetVC.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [self.view addSubview:_noNetVC];
    }
    return _noNetVC;
}

-(UIView *)homeTopView
{
    if (!_homeTopView) {
        _homeTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _homeTopView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, (44-20)/2, 100, 20)];
        
        label.text = @"网络状态";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_homeTopView addSubview:label];
        
        [self.navigationController.navigationBar addSubview:_homeTopView];
    }
    return _homeTopView;
}

-(UIImageView *)headerImageV
{
    if (!_headerImageV) {
        _headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 215)];
        
        _headerImageV.userInteractionEnabled = YES;
    }
    return _headerImageV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = YHRGBA(237, 244, 247, 1.0);
    
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableHeaderView = self.headerImageV;
    [self.headerImageV addSubview:self.headerBtn];
    [self.headerImageV addSubview:self.niChengLabel];
    [self.headerImageV addSubview:self.qianMingLabel];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GZMineTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [MBProgressHUD showMessage:@"加载中..."];
    [self getData];
    
    NSString *homeStr;
    NSString *classifyStr;
    NSString *goShoppingStr;
    NSString *mineStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        homeStr = @"首页";
        classifyStr = @"分类";
        goShoppingStr = @"购物车";
        mineStr = @"我的";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        homeStr = @"home";
        classifyStr = @"classify";
        goShoppingStr = @"cart";
        mineStr = @" mine";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        homeStr = @"főoldal";
        classifyStr = @"osztályozások";
        goShoppingStr = @"bevásárlókocsi";
        mineStr = @"saját";
        
    }
    
    UITabBarItem *item0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    item0.title = homeStr;
    item1.title = classifyStr;
    item2.title = goShoppingStr;
    item3.title = mineStr;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)getData
{
    
    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"User_info"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        [MBProgressHUD hideHUD];
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            
            self.niChengLabel.text = [[obj valueForKey:@"data"] valueForKey:@"User_Nick"];
            self.qianMingLabel.text = [[obj valueForKey:@"data"] valueForKey:@"User_Qianming"];
            
            _User_Header = [[obj valueForKey:@"data"] valueForKey:@"User_head"];
            _User_Fengmian = [[obj valueForKey:@"data"] valueForKey:@"User_Fengmian"];

            _User_Nick = [[obj valueForKey:@"data"] valueForKey:@"User_Nick"];
            _User_Qianming = [[obj valueForKey:@"data"] valueForKey:@"User_Qianming"];
            
            _dfh = [[obj valueForKey:@"data"] valueForKey:@"dfh"];
            _dsh = [[obj valueForKey:@"data"] valueForKey:@"dsh"];
            _ywc = [[obj valueForKey:@"data"] valueForKey:@"ywc"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:_User_Nick forKey:@"usernick"];
            [defaults setObject:_User_Qianming forKey:@"mineQianming"];
            
            [defaults setObject:_User_Header forKey:@"UserHeader"];
            [defaults setObject:_User_Fengmian forKey:@"fengmian"];
            
            [defaults synchronize];
            
            if ([_User_Header isEqualToString:@"/upload/"]) {
                [self.headerBtn setImage:[UIImage imageNamed:@"MineTouxiang_"] forState:UIControlStateNormal];
            }else
            {
                [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,[[obj valueForKey:@"data"] valueForKey:@"User_head"]]] forState:UIControlStateNormal];
            }
            
            if ([_User_Fengmian isEqualToString:@"/upload/"] || _User_Fengmian == nil) {
                
                //图片模糊化
                UIImage *image = [GGZTool boxblurImage:[UIImage imageNamed:@"bj_"] withBlurNumber:20];
                _headerImageV.image = image;
                
            }else
            {
                [_headerImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,_User_Fengmian]]];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        self.noNetVC.hidden = NO;
        self.homeTopView.hidden = NO;
        
        GZWeakSelf;
        self.noNetVC.netWorkAgainBlock = ^{
            
            [weakSelf getData];
        };
    }];
    
}

#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - UINavigationController Delegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isMinePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isMinePage animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GZMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    cell.dataSource = self.dataSource[indexPath.section][indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.dataSource[indexPath.section][indexPath.row][@"controller"]){
        UIViewController *vc = [[self.dataSource[indexPath.section][indexPath.row][@"controller"] alloc] init];
        
        vc.title = self.dataSource[indexPath.section][indexPath.row][@"title"];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            GZwoDeDingDanController *DingDanVC = [[GZwoDeDingDanController alloc] init];
            DingDanVC.statusStr = @"-2";
            DingDanVC.titleIndex = 0;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:DingDanVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
            self.navigationController.navigationBar.hidden = NO;
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            
            GZlianXiWoMenController *lianxiWoMenVC = [[GZlianXiWoMenController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lianxiWoMenVC animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            self.navigationController.navigationBar.hidden = NO;
        }else
        {
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
            self.navigationController.navigationBar.hidden = NO;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        GZStatusView *statusView = [GZStatusView createOrderStatusView];
        statusView.frame = CGRectMake(0, 0, kScreenWidth, 90);
        
        statusView.daiFaHuoLabel.layer.masksToBounds = YES;
        statusView.daiFaHuoLabel.layer.cornerRadius = 7;
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            statusView.daiFaHuoTitleLabel.text = @"待发货";
            statusView.daiShouHuoTitleLabel.text = @"待收货";
            statusView.yiWanChengTitleLabel.text = @"已完成";

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            statusView.daiFaHuoTitleLabel.text = @"yet-to-be-delivered";
            statusView.daiShouHuoTitleLabel.text = @"yet-to-be-received";
            statusView.yiWanChengTitleLabel.text = @"finished";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
            statusView.daiFaHuoTitleLabel.text = @"várható kiszállítás";
            statusView.daiShouHuoTitleLabel.text = @"várható átvétel";
            statusView.yiWanChengTitleLabel.text = @"sikeres";
            
        }
        
        if (![_dfh isEqualToNumber:@0]) {
            statusView.daiFaHuoLabel.hidden = NO;
            statusView.daiFaHuoLabel.text = [NSString stringWithFormat:@"%@",_dfh];
        }else
        {
            statusView.daiFaHuoLabel.hidden = YES;
        }
        
        statusView.daiShouHuoLabel.layer.masksToBounds = YES;
        statusView.daiShouHuoLabel.layer.cornerRadius = 7;
        
        if (![_dsh isEqualToNumber:@0]) {
            statusView.daiShouHuoLabel.hidden = NO;
            statusView.daiShouHuoLabel.text = [NSString stringWithFormat:@"%@",_dsh];
            
        }else
        {
            statusView.daiShouHuoLabel.hidden = YES;
        }
        
        statusView.yiWanChengLabel.layer.masksToBounds = YES;
        statusView.yiWanChengLabel.layer.cornerRadius = 7;
        
        if (![_ywc isEqualToNumber:@0]) {
            statusView.yiWanChengLabel.hidden = NO;
            statusView.yiWanChengLabel.text = [NSString stringWithFormat:@"%@",_ywc];
        }else
        {
            statusView.yiWanChengLabel.hidden = YES;
        }
        
        statusView.daiFaHuoClickBlock = ^(NSString *status) {
            
            [self pushDingDanVC:status];
        };
        
        statusView.daiShouHuoClickBlock = ^(NSString *status) {
            
            [self pushDingDanVC:status];
        };
        
        statusView.yiWanChengClickBlock = ^(NSString *status) {
            
            [self pushDingDanVC:status];
        };
        
        return statusView;
    }
    return nil;
}

- (void)pushDingDanVC:(NSString *)status
{
    GZwoDeDingDanController *DingDanVC = [[GZwoDeDingDanController alloc] init];
    DingDanVC.statusStr = status;
    DingDanVC.titleIndex = [status integerValue] + 1;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = barItem;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DingDanVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    self.navigationController.navigationBar.hidden = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 70;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

@end
