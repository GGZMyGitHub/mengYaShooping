//
//  GZwoDeShouCangController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZwoDeShouCangController.h"
#import "GZOrderDetailViewController.h"
#import "GZcollectionCell.h"
#import "GZCollectionResultModel.h"
#import "GZColletcionDataModel.h"

@interface GZwoDeShouCangController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSUInteger currentPage;

/** 下拉刷新时的动画图片 */
@property (nonatomic, strong) NSArray *refreshImgArr;

@property (nonatomic, strong) NSMutableArray *dataSource;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic, strong) GZNoDataCommonView *NoDataView;

@end

static NSString *TableViewIdentity = @"tableViewCellID";
@implementation GZwoDeShouCangController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 110;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GZcollectionCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

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
        _NoDataView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        
        _NoDataView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_NoDataView];
    }
    return _NoDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.title = @"我的收藏";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.title = @"my collection";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.title = @"kedvenceim";
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.currentPage = 1;
    
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
        
        weakSelf.currentPage++;
        [weakSelf getData];
    }];
}

-(void)getData
{
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    NSDictionary *params = @{
                             @"ye":page,
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"My_Collection"
                            };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        self.NoDataView.hidden = YES;
        
        
        GZCollectionResultModel *resultModel = [[GZCollectionResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:resultModel.data];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else
        {
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
                
                self.NoDataView.hidden = NO;
                
            }
            [self.dataSource addObjectsFromArray:resultModel.data];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.currentPage--;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZcollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];
    
    cell.dataModel = self.dataSource[indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //点击取消收藏按钮，重新刷数据
    cell.didSelectClickBlock = ^{
        
        [self getData];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZColletcionDataModel *dataModel = self.dataSource[indexPath.row];
    
    GZOrderDetailViewController *orderDetailVC = [[GZOrderDetailViewController alloc] init];
    
    orderDetailVC.pid =dataModel.P_id;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
