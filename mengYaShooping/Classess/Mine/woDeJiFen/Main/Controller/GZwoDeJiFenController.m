//
//  GZwoDeJiFenController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZwoDeJiFenController.h"
#import "GZintegralRuleViewController.h"
#import "GZWoDeJiFenCell.h"

#import "GZWoDeJiFenResultModel.h"
#import "GZWoDeJiFenDataModel.h"
#import "GZWoDeJiFenListModel.h"


@interface GZwoDeJiFenController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *rightBarButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property(nonatomic, assign) NSUInteger currentPage;

/** 下拉刷新时的动画图片 */
@property (nonatomic, strong) NSArray *refreshImgArr;

@property (nonatomic, strong) UIImageView *headerImgV;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *allIntergalLabel;
@property (nonatomic, strong) UILabel *lineLabel;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@end

static NSString *TableIdentifier = @"tableViewCell";
@implementation GZwoDeJiFenController

-(UIButton *)rightBarButton
{
    if (!_rightBarButton) {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBarButton.frame = CGRectMake(0, 0, 60, 20);
        
        [_rightBarButton setTitle:@"积分规则" forState:UIControlStateNormal];
        [_rightBarButton setTitleColor:YHRGBA(90, 90, 90, 1.0) forState:UIControlStateNormal];
        
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_rightBarButton addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenWidth, kScreenHeight - 64 - self.headerView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        [_tableView registerNib:[UINib nibWithNibName:@"GZWoDeJiFenCell" bundle:nil] forCellReuseIdentifier:TableIdentifier];
    }
    return _tableView;
}

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 135)];
        _headerView.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    }
    return _headerView;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerImgV.bottom, kScreenWidth, 9)];
        _lineLabel.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    }
    return _lineLabel;
}

-(UIImageView *)headerImgV
{
    if (!_headerImgV) {
        _headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 126)];
        _headerImgV.image = [UIImage imageNamed:@"jifenbj_"];
    }
    return _headerImgV;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allIntergalLabel.left, self.allIntergalLabel.bottom + 2, 100, 20)];

        _titleLabel.text = @"积分余额";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(UILabel *)allIntergalLabel
{
    if (!_allIntergalLabel) {
        _allIntergalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
        _allIntergalLabel.center = CGPointMake(self.headerImgV.width/2, self.headerImgV.height/2 - 15);

        _allIntergalLabel.font = [UIFont systemFontOfSize:22];
        _allIntergalLabel.textAlignment = NSTextAlignmentCenter;
        _allIntergalLabel.textColor = [UIColor whiteColor];
    }
    return _allIntergalLabel;
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
    self.view.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.currentPage = 1;
    
    
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.headerImgV];
    [self.headerView addSubview:self.lineLabel];
    [self.view addSubview:self.headerView];

    [self.headerImgV addSubview:self.titleLabel];
    [self.headerImgV addSubview:self.allIntergalLabel];
    
    [MBProgressHUD showMessage:@"加载中..."];
    [self MJRefresh];

}

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

-(void)rightBarClick
{
    GZintegralRuleViewController *integralRuleVC = [[GZintegralRuleViewController alloc] init];
    
    integralRuleVC.title = @"积分规则";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:integralRuleVC animated:YES];
}

#pragma mark - 拉取数据
- (void)getData
{
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    
    NSDictionary *param = @{
                            @"ye":page,
                            @"uid":[GGZTool isUid],
                            @"language":[GGZTool iSLanguageID],
                            @"action":@"My_jifen"
                            };
    
    [GZHttpTool post:URL params:param success:^(NSDictionary *obj) {
       
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;

        GZWoDeJiFenResultModel *resultModel = [[GZWoDeJiFenResultModel alloc] initWithDictionary:obj error:nil];
     
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            [MBProgressHUD hideHUD];
            GZWoDeJiFenDataModel *dataModel = [[GZWoDeJiFenDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
            }
            
            self.allIntergalLabel.text = dataModel.allcount;
            
            [self.dataSource addObjectsFromArray:dataModel.list];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else
        {
            if (self.currentPage == 1) {
                
                self.allIntergalLabel.text = @"0";
            }
            
            [MBProgressHUD hideHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    GZWoDeJiFenCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.listModel = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
