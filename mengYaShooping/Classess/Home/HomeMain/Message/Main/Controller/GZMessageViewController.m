//
//  GZMessageViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/22.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZMessageViewController.h"
#import "GZTopScrollMenu.h"
#import "GZMessageCell.h"
#import "GZLoginViewController.h"

#import "GZMessageResultModel.h"
#import "GZMessageDataModel.h"
#import "GZMessageListModel.h"

@interface GZMessageViewController ()<GZTopScrollMenuDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 顶部菜单栏 */
@property (nonatomic, strong) GZTopScrollMenu *topScrollMenu;

@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) NSInteger typeMessage;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic, strong) GZNoDataCommonView *NoDataView;

@property (nonatomic, strong) UILabel *jifen_no_readLabel;
@property (nonatomic, strong) UILabel *order_no_readLabel;
@property (nonatomic, strong) UILabel *xitong_no_readLabel;

@property (nonatomic, strong) UIView *Loadview;

@end

static NSString *TableViewIdentity = @"tabelViewCellID";
@implementation GZMessageViewController

-(GZTopScrollMenu *)topScrollMenu
{
    if (!_topScrollMenu) {
        _topScrollMenu = [GZTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 64,kScreenWidth, 44)];
        
        //将原来的标题对应的ID以及现在的ID数组传过去，在topScrollMenu里面比较，让其默认选中居中
        

        _topScrollMenu.topScrollMenuDelegate = self;
    }
    return _topScrollMenu;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topScrollMenu.bottom + 5, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = YHRGBA(237, 245, 245, 1.0);
        _tableView.rowHeight = 86;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"GZMessageCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
        
        [self.view addSubview:_tableView];
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
        _NoDataView.frame = CGRectMake(0, self.topScrollMenu.bottom + 10, kScreenWidth, kScreenHeight - self.topScrollMenu.height - 64 - 10);
        
        _NoDataView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_NoDataView];
    }
    return _NoDataView;
}

-(UILabel *)jifen_no_readLabel
{
    if (!_jifen_no_readLabel) {
        _jifen_no_readLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topScrollMenu.left + kScreenWidth / 3 - 30, 5, 8, 8)];
        _jifen_no_readLabel.backgroundColor =[UIColor redColor];
        
        _jifen_no_readLabel.layer.masksToBounds = YES;
        _jifen_no_readLabel.layer.cornerRadius = 4;
    }
    return _jifen_no_readLabel;
}

-(UILabel *)xitong_no_readLabel
{
    if (!_xitong_no_readLabel) {
        _xitong_no_readLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topScrollMenu.left + (kScreenWidth / 3) * 2 - 30, 5, 8, 8)];
        _xitong_no_readLabel.backgroundColor =[UIColor redColor];
        
        _xitong_no_readLabel.layer.masksToBounds = YES;
        _xitong_no_readLabel.layer.cornerRadius = 4;
    }
    return _xitong_no_readLabel;
}

-(UILabel *)order_no_readLabel
{
    if (!_order_no_readLabel) {
        _order_no_readLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topScrollMenu.left + (kScreenWidth / 3) * 3 - 30, 5, 6, 6)];
        _order_no_readLabel.backgroundColor =[UIColor redColor];
        
        _order_no_readLabel.layer.masksToBounds = YES;
        _jifen_no_readLabel.layer.cornerRadius = 3;
    }
    return _order_no_readLabel;
}

-(UIView *)Loadview
{
    if (!_Loadview) {
        _Loadview = [[UIView alloc] initWithFrame:self.view.bounds];
        _Loadview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview: _Loadview];
    }
    return _Loadview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YHRGBA(237, 245, 245, 1.0);
    self.title = @"消息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.topScrollMenu];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:@"enterMessageVC"];
    
    [defaults synchronize];
    
    self.typeMessage = 0;
    self.currentPage = 1;
    
    [self MJRefresh];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        self.topScrollMenu.staticTitleArr = @[@"系统消息",@"积分消息",@"订单消息"];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.topScrollMenu.staticTitleArr = @[@"system message",@"point message",@"order message"];

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.topScrollMenu.staticTitleArr = @[@"rendszer üzenetek",@"pont gyüjtés információk",@"rendelés információk"];

    }
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
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage++;
        [weakSelf getData];
    }];
    self.tableView.mj_footer = footer;
    
    footer.refreshingTitleHidden = YES;
}

#pragma mark - 拉取数据
- (void)getData
{
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    NSString *type = [NSString stringWithFormat:@"%zd",self.typeMessage];
    
    NSDictionary *param = @{
                            @"language":[GGZTool iSLanguageID],
                            @"uid":[GGZTool isUid],
                            @"ye":page,
                            @"type":type,
                            @"action":@"My_News"
                            };
    
    [GZHttpTool post:URL params:param success:^(NSDictionary *obj) {
        
        
        GZMessageResultModel *resultModel = [[GZMessageResultModel alloc] initWithDictionary:obj error:nil];
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        self.NoDataView.hidden = YES;

        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            self.Loadview.hidden = YES;
            [self.Loadview removeActivityView];
            
            GZMessageDataModel *dataModel = [[GZMessageDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
            }
            
            if (![dataModel.jifen_no_read isEqualToString:@"0"]) {
                
                [self.topScrollMenu addSubview:self.jifen_no_readLabel];
            }
            
            if (![dataModel.order_no_read isEqualToString:@"0"]) {
                
                [self.topScrollMenu addSubview:self.order_no_readLabel];
            }
            
            if (![dataModel.xitong_no_read isEqualToString:@"0"]) {
                
                [self.topScrollMenu addSubview:self.xitong_no_readLabel];
            }
            
            if (self.currentPage == 1 && !(dataModel.list != nil && ![dataModel.list isKindOfClass:[NSNull class]] && dataModel.list.count != 0)) {
                
                self.NoDataView.hidden = NO;
            }
            
            
            [self.dataSource addObjectsFromArray:dataModel.list];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }else
        {
            self.Loadview.hidden = YES;
            [self.Loadview removeActivityView];
            
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

#pragma mark - GZTopScrollMenu代理方法
- (void)GZTopScrollMenu:(GZTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    self.Loadview.hidden = NO;
    [self.Loadview appendActivityView:[UIColor lightGrayColor]];

    self.typeMessage = index;
    
    self.currentPage = 1;
    
    [self getData];
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
    GZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    cell.typeMessage = self.typeMessage;
    cell.listModel = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
