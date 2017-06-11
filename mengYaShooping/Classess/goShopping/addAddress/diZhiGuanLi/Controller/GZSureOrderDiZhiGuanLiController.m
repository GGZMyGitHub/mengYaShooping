//
//  GZSureOrderDiZhiGuanLiController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderDiZhiGuanLiController.h"
#import "GZAddressViewController.h"
#import "GZSureOrderDiZhiGuanLiResuleModel.h"
#import "GZSureOrderDiZhiGuanLiDataModel.h"
#import "GZSureOrderDiZhiGuanLiCell.h"
#import "GZSureOrderController.h"

@interface GZSureOrderDiZhiGuanLiController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addAdressBtn;

@property(nonatomic, assign) NSUInteger currentPage;

/** 下拉刷新时的动画图片 */
@property (nonatomic, strong) NSArray *refreshImgArr;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isDelect;
@property (nonatomic) BOOL isClickXinZengDiZhi;

@property (nonatomic, strong) NSIndexPath *indexpath;

/** 无数据时 */
@property (nonatomic, strong) GZNoDataCommonView *NoDataView;

//翻译
@property (weak, nonatomic) IBOutlet UIButton *diZhiGuanLiBtn;


- (IBAction)addAdressBtn:(UIButton *)sender;


@end

static NSString *Identifier = @"tableViewCellID";
@implementation GZSureOrderDiZhiGuanLiController

- (NSArray *)refreshImgArr
{
    if (!_refreshImgArr) {
        _refreshImgArr = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    }
    return _refreshImgArr;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(GZNoDataCommonView *)NoDataView
{
    if (!_NoDataView) {
        _NoDataView = [GZNoDataCommonView createNoDataCommonView];
        _NoDataView.frame = CGRectMake(0, 10, kScreenWidth, kScreenHeight - 64 - 44 -10);
        
        _NoDataView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_NoDataView];
    }
    return _NoDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 115;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self MJRefresh];

    [self.tableView registerNib:[UINib nibWithNibName:@"GZSureOrderDiZhiGuanLiCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [self.diZhiGuanLiBtn setTitle:@"新增地址" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        [self.diZhiGuanLiBtn setTitle:@"new address " forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        [self.diZhiGuanLiBtn setTitle:@"új címet megadása" forState:UIControlStateNormal];
    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currentPage = 1;
    
    [MBProgressHUD showMessage:@"加载中..."];
    
    [self getData];
}

#pragma mark - Method
- (void)MJRefresh
{
    GZWeakSelf;
    MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        
        [weakSelf getData];
    }];
    
    self.tableView.mj_header = header;
    
#warning 
    NSString *IdleStr;
    NSString *PullingStr;
    NSString *RefreshingStr;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        IdleStr = @"下拉可以刷新";
        PullingStr = @"松开立即刷新";
        RefreshingStr = @"正在刷新数据中...";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        IdleStr = @"Pull down to refresh";
        PullingStr = @"Release to refresh";
        RefreshingStr = @"Loading ...";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        IdleStr = @"";
        PullingStr = @"";
        RefreshingStr = @"";
        
    }
    
    [header setTitle:IdleStr forState:MJRefreshStateIdle];
    [header setTitle:PullingStr forState:MJRefreshStatePulling];
    [header setTitle:RefreshingStr forState:MJRefreshStateRefreshing];
    
    [header setImages:self.refreshImgArr  forState:MJRefreshStateRefreshing];
    [header setImages:self.refreshImgArr  forState:MJRefreshStatePulling];
    [header setImages:self.refreshImgArr  forState:MJRefreshStateIdle];
    
    header.lastUpdatedTimeLabel.hidden = YES;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage++;
        [weakSelf getData];
    }];
    
    self.tableView.mj_footer = footer;
    
    NSString *footerIdleStr;
    NSString *footerPullingStr;
    NSString *footerRefreshingStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        footerIdleStr = @"点击或者上拉加载更多";
        footerPullingStr = @"正在加载更多的数据...";
        footerRefreshingStr = @"已经全部加载完毕";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        footerIdleStr = @"Click or drag up to refresh";
        footerPullingStr = @"Loading more ...";
        footerRefreshingStr = @"No more data";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        footerIdleStr = @"";
        footerPullingStr = @"";
        footerRefreshingStr = @"";
    }
    
    [footer setTitle:footerIdleStr forState:MJRefreshStateIdle];
    [footer setTitle:footerPullingStr forState:MJRefreshStateRefreshing];
    [footer setTitle:footerRefreshingStr forState:MJRefreshStateNoMoreData];
    
}

- (void)getData
{
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"ye":page,
                             @"action":@"My_Address"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
       
        self.NoDataView.hidden = YES;
        
        
        GZSureOrderDiZhiGuanLiResuleModel *resultModel = [[GZSureOrderDiZhiGuanLiResuleModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];

            if (self.currentPage == 1) {
                
                [self.dataSource removeAllObjects];
            }

            [self.dataSource addObjectsFromArray:resultModel.data];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else
        {
            [MBProgressHUD hideHUD];
            
            if (self.currentPage == 1) {
                
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:resultModel.data];

#warning
                if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
                {
                    self.NoDataView.promptLabel.text = @"暂无地址";
                    
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                    
                    self.NoDataView.promptLabel.text = @"暂无地址英文";
                    
                }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                    
                    self.NoDataView.promptLabel.text = @"暂无地址匈牙利文";
                }
                
                self.NoDataView.hidden = NO;
            }

            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.currentPage--;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.currentPage--;
    }];
}

#pragma mark - 新增地址点击事件
- (IBAction)addAdressBtn:(UIButton *)sender {

    _isClickXinZengDiZhi = YES;
    
    GZAddressViewController *diZhiGuanLiVC = [[GZAddressViewController alloc] init];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        diZhiGuanLiVC.title = @"新增地址";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        diZhiGuanLiVC.title = @"new address";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        diZhiGuanLiVC.title = @"új címet megadása";
    }
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:diZhiGuanLiVC animated:YES];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GZSureOrderDiZhiGuanLiCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.dataModel = self.dataSource[indexPath.row];
    
    //点击默认地址按钮
    __weak typeof(cell) weakCell = cell;
    cell.defaultBtnClickBlock = ^() {
        
        if (!weakCell.dataModel.isDefaultAddress) {
            
            NSDictionary *params = @{
                                     @"uid":[GGZTool isUid],
                                     @"id":weakCell.dataModel.sureOrderDiZhiGuanLiID,
                                     @"action":@"my_address_moren"
                                     };
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                [MBProgressHUD hideHUD];
                
                [self getData];
                
                weakCell.dataModel.isDefaultAddress = !weakCell.dataModel.isDefaultAddress;
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络异常"];
                
            }];
        }
    };
    
    //删除按钮
    cell.deleteBtnClickBlock = ^{
        
        GZAlertView * alert = [GZAlertView sharedAlertView];
        
        [alert animationAlert];
        
        [alert alertViewMessage:@"确定删除地址?" cancelTitle:@"取消" sureTitle:@"确定" image:@"delete_" Block:^(NSString *status) {
            
            if ([status isEqualToString:@"sure"]) {
                NSDictionary *params = @{
                                         @"id":weakCell.dataModel.sureOrderDiZhiGuanLiID,
                                         @"action":@"my_address_del"
                                         };
                [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                    [MBProgressHUD hideHUD];
                    
                    if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                        
                        _isDelect = YES;
                        
                    }else
                    {
                        
                        [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
                    }
                    
                    [self getData];
                    
                    weakCell.dataModel.isDefaultAddress = !weakCell.dataModel.isDefaultAddress;
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"网络异常"];
                    
                }];
            }
        }];
    };
    
    //修改按钮
    cell.alterBtnClickBlock = ^{

        //记录点击的是哪一行
        _indexpath = indexPath;

        GZAddressViewController *orderVC = [[GZAddressViewController alloc] init];
        orderVC.dataModel = self.dataSource[indexPath.row];
       
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            orderVC.title = @"修改地址";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
         //   orderVC.title = @"修改地址英文";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
          //  orderVC.title = @"修改地址匈牙利文";
        }
        
        
        orderVC.adressID = [self.dataSource[indexPath.row] valueForKey:@"sureOrderDiZhiGuanLiID"];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
