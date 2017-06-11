//
//  GZfinishOrderViewController.m
//  mengYaShooping
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZfinishOrderViewController.h"
#import "GZWoDeDIngDanCell.h"
#import "GZSureOrderHeaderView.h"
#import "GZfinishOrderFooterView.h"

#import "GZfinishResultModel.h"
#import "GZfinishDataModel.h"
#import "GZproListModel.h"

@interface GZfinishOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GZSureOrderHeaderView *headerView;
@property (nonatomic, strong) GZfinishOrderFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GZfinishDataModel *dataModel;


//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@end

static NSString *TableViewIdentity = @"tableViewCellID";
@implementation GZfinishOrderViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 112;
        
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GZWoDeDIngDanCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
    }
    return _tableView;
}


-(GZSureOrderHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [GZSureOrderHeaderView sharedSureOrderHeaderView];
        
        _headerView.jianTou.hidden = YES;
    }
    return _headerView;
}

-(GZfinishOrderFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [GZfinishOrderFooterView sharedSureOrderHeaderView];

        
        NSMutableArray *diyidArr = [NSMutableArray array];
        NSMutableArray *pidArr = [NSMutableArray array];
        NSMutableArray *countArr = [NSMutableArray array];
        
        //再次购买按钮的回调
        GZWeakSelf;
        _footerView.payForAgainClickBlock = ^{
            
            [MBProgressHUD showMessage:@"加载中..."];
            
            for (GZWoDeDingDanListModel *listModel in weakSelf.footerView.dataModel.pro_list) {
                [diyidArr addObject:listModel.diy_id];
                [pidArr addObject:listModel.p_id];
                [countArr addObject:listModel.p_count];
            }
            
            NSString *diyidStr = [diyidArr componentsJoinedByString:@","];
            NSString *pidStr = [pidArr componentsJoinedByString:@","];
            NSString *countStr = [countArr componentsJoinedByString:@","];

            NSDictionary *params = @{
                                     @"language":[GGZTool iSLanguageID],
                                     @"uid":[GGZTool isUid],
                                     @"diyid":diyidStr,
                                     @"pid":pidStr,
                                     @"count":countStr,
                                     @"action":@"Add_car_list"
                                     };
            
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                [MBProgressHUD hideHUD];
                
                if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                    
                    //发送通知，转换成购物车界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GZHomeDetailsVC" object:nil userInfo:nil];
                    
                    //添加购物车成功，通知TabbarController，调用数据更改角标
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                    
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];

                }

            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showAlertMessage:@"网络错误"];
            }];
        };
    }
    return _footerView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [MBProgressHUD showMessage:@"加载中..."];
    
    self.title = @"订单详情";

    [self.view addSubview:self.tableView];
    [self getData];
}

- (void)getData
{
    NSDictionary *params = @{
                             @"orderid":self.order_id,
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"order_info"
                             };

    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        GZfinishResultModel *resultModel = [[GZfinishResultModel alloc] initWithDictionary:obj error:nil];
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            
            GZfinishDataModel *dataModel = [[GZfinishDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            [self.dataSource addObjectsFromArray:dataModel.pro_list];
            
            self.headerView.dataModel  = (GZSureOrderDataModel *)dataModel;
            self.footerView.dataModel = dataModel;
            self.dataModel = dataModel;
            
            
            if ([dataModel.order_states isEqualToString:@"2"]) {
                self.footerView.payforBtn.hidden = NO;
            }else
            {
                self.footerView.payforBtn.hidden = YES;
            }
            
        }
        [self.tableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZWoDeDIngDanCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.listModel = self.dataSource[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 9)];
    
    lineLabel.backgroundColor = YHRGBA(235, 243, 243, 1.0);
    
    [headerView addSubview:lineLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 170, 15, 150, 23)];
    
    
    if ([self.dataModel.order_states isEqualToString:@"0"]){
        statusLabel.text = @"订单状态: 待发货";
        
        self.footerView.fixedFuKuanLabel.hidden = YES;
        self.footerView.fixedFaHuoLabel.hidden = YES;
        self.footerView.fukuanLabel.hidden = YES;
        self.footerView.fahuoLabel.hidden = YES;

    }else if ([self.dataModel.order_states isEqualToString:@"1"]){
        statusLabel.text = @"订单状态: 待收货";
        
        self.footerView.fixedFaHuoLabel.hidden = YES;
        self.footerView.fahuoLabel.hidden = YES;
        
    }else if ([self.dataModel.order_states isEqualToString:@"2"]){
        statusLabel.text = @"订单状态: 已完成";
    }else
    {
        self.footerView.fixedFuKuanLabel.hidden = NO;
        self.footerView.fixedFaHuoLabel.hidden = NO;
        self.footerView.fukuanLabel.hidden = NO;
        self.footerView.fahuoLabel.hidden = NO;
    }
    statusLabel.textColor = YHRGBA(233, 76, 60, 1.0);
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:15];
    
    [headerView addSubview:statusLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"GZHomeDetailsVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
}

-(BOOL)navigationShouldPopOnBackButton
{
    if (self.controllerID == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
