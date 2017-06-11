//
//  GZwoDeDingDanController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZwoDeDingDanController.h"
#import "GZOrderDetailViewController.h"
#import "GZfinishOrderViewController.h"

#import "GZTopScrollMenu.h"
#import "GZWoDeDingDanCell.h"

#import "GZWoDeDingDanResultModel.h"
#import "GZWoDeDingDanDataModel.h"

@interface GZwoDeDingDanController ()<GZTopScrollMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GZTopScrollMenu *topMenu;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, assign) NSUInteger currentPage;

/** 下拉刷新时的动画图片 */
@property (nonatomic, strong) NSArray *refreshImgArr;


@property (nonatomic, strong) UIView *footerView;

/**
 判断是否是刷新，如果是刷新，msgcode=0不删除数据源
 */
@property (nonatomic) BOOL isSelect;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic, strong) GZNoDataCommonView *NoDataView;


@end

static NSString *TableViewIdentitys = @"tableViewCellfinishID";
@implementation GZwoDeDingDanController

- (NSArray *)refreshImgArr
{
    if (!_refreshImgArr) {
        _refreshImgArr = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    }
    return _refreshImgArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topMenu.bottom, kScreenWidth, kScreenHeight - 49 - 64 - 7) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 117;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GZWoDeDIngDanCell" bundle:nil] forCellReuseIdentifier:TableViewIdentitys];
        

    }
    return _tableView;
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

-(GZNoDataCommonView *)NoDataView
{
    if (!_NoDataView) {
        _NoDataView = [GZNoDataCommonView createNoDataCommonView];
        _NoDataView.frame = CGRectMake(0, self.topMenu.bottom + 10, kScreenWidth, kScreenHeight - self.topMenu.height - 64 - 10);
        
        _NoDataView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_NoDataView];
    }
    return _NoDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的订单";
    
    self.currentPage = 1;
    
    [MBProgressHUD showMessage:@"加载中..."];
    
    self.topMenu = [GZTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    
    NSArray *titleArr = @[@"全部",@"待发货",@"待收货",@"已完成"];

    self.topMenu.titleIndex = self.titleIndex;
    
    self.topMenu.staticTitleArr = titleArr;
    self.topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:_topMenu];
    
    [self.view addSubview:self.tableView];
    [self MJRefresh];
}

#pragma mark - Method
- (void)MJRefresh
{
    [self getData];
    
    GZWeakSelf;
    MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        
        [weakSelf getData];
    }];
    
    self.tableView.mj_header = header;
    [header setImages:self.refreshImgArr  forState:MJRefreshStateRefreshing];
    [header setImages:self.refreshImgArr  forState:MJRefreshStatePulling];
    [header setImages:self.refreshImgArr  forState:MJRefreshStateIdle];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _isSelect = YES;
        
        weakSelf.currentPage++;
        [weakSelf getData];
    }];
}

#pragma mark - 拉取数据
- (void)getData
{

    self.tableView.mj_footer.hidden = YES;

    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    NSDictionary *params = @{
                             @"ye":page,
                             @"language":[GGZTool iSLanguageID],
                             @"uid":[GGZTool isUid],
                             @"states":_statusStr,
                             @"action":@"order_list"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        GZWoDeDingDanResultModel *resultModel = [[GZWoDeDingDanResultModel alloc] initWithDictionary:obj error:nil];
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        self.NoDataView.hidden = YES;
        
        [MBProgressHUD hideHUD];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {

            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];

            }
             [self.dataSource addObjectsFromArray:resultModel.data];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else
        {
            if (!_isSelect) {
                [self.dataSource removeAllObjects];
            }
            
            if (self.currentPage == 1) {
                self.NoDataView.hidden = NO;
            }
            
            [self.dataSource addObjectsFromArray:resultModel.data];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            self.tableView.mj_footer.hidden = YES;
            
            self.currentPage--;
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.currentPage--;
    }];
}

#pragma mark - UITableViewDelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GZWoDeDingDanDataModel *dataModel = self.dataSource[section];
    
    return dataModel.zi_dic_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZWoDeDIngDanCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentitys   forIndexPath:indexPath];
    
    GZWoDeDingDanDataModel *dataModel = self.dataSource[indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.listModel = dataModel.zi_dic_list[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZWoDeDingDanDataModel *dataModel = self.dataSource[indexPath.section];

    GZfinishOrderViewController *finishOrderVC = [[GZfinishOrderViewController alloc] init];
    
    finishOrderVC.order_id = dataModel.order_id;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:finishOrderVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GZWoDeDingDanDataModel *dataModel = self.dataSource[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 9)];
    
    lineLabel.backgroundColor = YHRGBA(235, 243, 243, 1.0);
    
    [headerView addSubview:lineLabel];
    
    UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 19, 200, 23)];
    orderNumberLabel.text = [NSString stringWithFormat:@"订单编号:%@",dataModel.order_id];
    orderNumberLabel.textAlignment = NSTextAlignmentLeft;
    orderNumberLabel.font = [UIFont systemFontOfSize:14];
    orderNumberLabel.textColor = YHRGBA(93, 93, 93, 1.0);
    [headerView addSubview:orderNumberLabel];

    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 15, 100, 23)];
    
    if ([dataModel.order_states isEqualToString:@"0"]){
        statusLabel.text = @"待发货";
    }else if ([dataModel.order_states isEqualToString:@"1"]){
        statusLabel.text = @"待收货";
    }else if ([dataModel.order_states isEqualToString:@"2"]){
        statusLabel.text = @"已完成";
    }
    statusLabel.textColor = YHRGBA(233, 76, 60, 1.0);
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:15];
    
    [headerView addSubview:statusLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GZWoDeDingDanDataModel *dataModel = self.dataSource[section];
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    
    self.footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.footerView.right - 300, 10, 280, 23)];

    totalPriceLabel.text = [NSString stringWithFormat:@"共%@件商品  合计:%@FT (含运费%@)",dataModel.count,dataModel.price,dataModel.yunfei];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.font = [UIFont systemFontOfSize:14];
    totalPriceLabel.textColor = YHRGBA(93, 93, 93, 1.0);
    [self.footerView addSubview:totalPriceLabel];
    
    if ([dataModel.order_states isEqualToString:@"2"]) {
        self.footerView.height = 86;
        
        GGZButton *payForBtn = [GGZButton createGGZButton];
        payForBtn.frame = CGRectMake(self.footerView.right - 120, 53, 100, 23);
        payForBtn.backgroundColor = YHRGBA(229, 78, 57, 1.0);
        
        [payForBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        
        payForBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        payForBtn.titleColor = [UIColor whiteColor];
        payForBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        payForBtn.layer.masksToBounds = YES;
        payForBtn.layer.cornerRadius = 3;
        
        NSMutableArray *diyidArr = [NSMutableArray array];
        NSMutableArray *pidArr = [NSMutableArray array];
        NSMutableArray *countArr = [NSMutableArray array];
        
        payForBtn.block = ^(GGZButton *btn) {
            
            [MBProgressHUD showMessage:@"加载中..."];
            
            GZWoDeDingDanDataModel *dataModel = self.dataSource[section];
            for (GZWoDeDingDanListModel *listModel in dataModel.zi_dic_list) {
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
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showAlertMessage:@"网络错误"];
            }];
        };
    
        [self.footerView addSubview:payForBtn];
    }
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    GZWoDeDingDanDataModel *dataModel = self.dataSource[section];
    if ([dataModel.order_states isEqualToString:@"2"]) {
        
        return 86;
    }
    return 43;
}

#pragma mark - GZTopScrollMenu代理方法
- (void)GZTopScrollMenu:(GZTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    [MBProgressHUD showMessage:@"加载中..."];
    
    switch (index) {
        case 0:
        {
            _statusStr = @"-2";
            self.currentPage = 1;
            _isSelect = NO;
            
            [self getData];
            
            break;
        }
           
        case 1:
        {
            _statusStr = @"0";
            self.currentPage = 1;
            _isSelect = NO;

            [self getData];
            break;
        }
        case 2:
        {
            _statusStr = @"1";
            self.currentPage = 1;
            _isSelect = NO;

            [self getData];
            break;
        }
           
        case 3:
        {
            _statusStr = @"2";
            self.currentPage = 1;
            _isSelect = NO;
            
            [self getData];
            break;
        }
           
        default:
            break;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"GZHomeDetailsVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
