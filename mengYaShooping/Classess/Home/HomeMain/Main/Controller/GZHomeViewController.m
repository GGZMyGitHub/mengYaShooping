 //
//  GZHomeViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHomeViewController.h"
#import "GZHomeTableViewCell.h"
#import "GZHomeHeaderView.h"
#import "GZHomeDetailsViewController.h"
#import "GZClassifyViewController.h"
#import "GZWebViewController.h"
#import "GZOrderDetailViewController.h"
#import "GZHomeDetailsViewController.h"

#import "GZResultHomeModel.h"
#import "GZDataHomeModel.h"
#import "GZAdlistModel.h"
#import "GZHotListModel.h"

@interface GZHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/** 轮播图数据源 */
@property (nonatomic, strong) NSMutableArray *cycleDataSource;

/** tableView数据源 */
@property (nonatomic, strong) NSMutableArray *tableDataSource;

@property (nonatomic, strong) GZAdlistModel *adlistModel;

@property(nonatomic, assign) NSUInteger currentPage;

/** 头视图 */
@property (nonatomic, strong) GZHomeHeaderView *headerView;

/** 点击浏览大图 */
@property (nonatomic, strong) UIImageView *clickedImagView;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic) BOOL isFooter;

@property (nonatomic, strong) UIView *Loadview;

@end

static NSString * TableViewIdentity = @"cellID";
@implementation GZHomeViewController

-(NSMutableArray *)cycleDataSource
{
    if (!_cycleDataSource) {
        _cycleDataSource = [NSMutableArray array];
    }
    return _cycleDataSource;
}

-(NSMutableArray *)tableDataSource
{
    if (!_tableDataSource) {
        _tableDataSource = [NSMutableArray array];
    }
    return _tableDataSource;
}

-(UIImageView *)clickedImagView
{
    if (!_clickedImagView) {
        _clickedImagView = [[UIImageView alloc] init];
    }
    return _clickedImagView;
}

-(GZHomeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [GZHomeHeaderView createHeaderView];
        
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 545);
        
        GZWeakSelf;
        //点击轮播图的回调
        _headerView.selectCycleScrollBlock = ^(NSInteger index) {
            
            NSMutableArray *cycleArr = [NSMutableArray array];
            [cycleArr addObjectsFromArray:(NSArray *)weakSelf.adlistModel];

            GZAdlistModel *adlistModel = cycleArr[index];
            
            //目前先放大图
            [weakSelf.clickedImagView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,adlistModel.Ad_logo]]];
            //浏览大图
            [GZScanImage scanBigImageWithImageView:weakSelf.clickedImagView];
            
        };
        
        _headerView.classBtnClickBlock = ^(NSInteger index) {
           
            if (weakSelf.selectHomeBolck) {
                weakSelf.selectHomeBolck(index);
            }
        };
    }
    return _headerView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 132;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GZHomeTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.currentPage = 1;
    
    self.tableView.tableHeaderView = self.headerView;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *homeStr;
    NSString *classifyStr;
    NSString *goShoppingStr;
    NSString *mineStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.headerView.titleLabel.text = @"热卖";
        
        homeStr = @"首页";
        classifyStr = @"分类";
        goShoppingStr = @"购物车";
        mineStr = @"我的";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){

        self.headerView.titleLabel.text = @"hot sale";

        homeStr = @"home";
        classifyStr = @"classify";
        goShoppingStr = @"cart";
        mineStr = @" mine";

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){

        self.headerView.titleLabel.text = @"kiemelt termékek";
        
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
    
    self.Loadview.hidden = NO;
    [self.Loadview appendActivityView:[UIColor lightGrayColor]];
    
    [self MJRefresh];
}

#pragma mark - Method
- (void)MJRefresh
{
    [self getData];
    GZWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        
        [weakSelf getData];

    }];
    
    self.tableView.mj_header = header;
    
#warning
    NSString *IdleStr;
    NSString *PullingStr;
    NSString *RefreshingStr;
    NSString *PullDownIdleStr;
    NSString *PullingDownStr;
    NSString *RefreshingDownStr;
    

    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        IdleStr = @"下拉可以刷新";
        PullingStr = @"松开立即刷新";
        RefreshingStr = @"正在刷新数据中...";

        PullDownIdleStr = @"上拉可以加载更多";
        PullingDownStr = @"松开立即加载更多";
        RefreshingDownStr = @"正在加载更多的数据...";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        IdleStr = @"Pull down to refresh";
        PullingStr = @"Release to refresh";
        RefreshingStr = @"Loading ...";

        PullDownIdleStr = @"上拉可以加载更多英文";
        PullingDownStr = @"松开立即加载更多英文";
        RefreshingDownStr = @"正在加载更多的数据...英文";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        IdleStr = @"";
        PullingStr = @"";
        RefreshingStr = @"";
        
        PullDownIdleStr = @"上拉可以加载更多匈牙利文";
        PullingDownStr = @"松开立即加载更多熊亚文";
        RefreshingDownStr = @"正在加载更多的数据...匈牙利文";
    }
    
    [header setTitle:IdleStr forState:MJRefreshStateIdle];
    [header setTitle:PullingStr forState:MJRefreshStatePulling];
    [header setTitle:RefreshingStr forState:MJRefreshStateRefreshing];
   
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _isFooter = YES;
        weakSelf.currentPage++;
        
        [weakSelf getData];

    }];

    self.tableView.mj_footer = footer;
    
    [footer setTitle:PullDownIdleStr forState:MJRefreshStateIdle];
    [footer setTitle:PullingDownStr forState:MJRefreshStatePulling];
    [footer setTitle:RefreshingDownStr forState:MJRefreshStateRefreshing];
    

}

#pragma mark - 拉取数据
- (void)getData
{

    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    
    NSString *uidStr;
    if ([GGZTool isUid] != nil) {
        uidStr = [GGZTool isUid];
    }else
    {
        uidStr = @"0";
    }
    //uid默认传0
    NSDictionary *param = @{
                            @"ye":page,
                            @"language":[GGZTool iSLanguageID],
                            @"uid":uidStr,
                            @"action":@"Index"
                            };
    
    [GZHttpTool post:URL params:param success:^(NSDictionary *obj) {
        
        GZResultHomeModel *resultModel = [[GZResultHomeModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
             self.Loadview.hidden = YES;
            [self.Loadview removeActivityView];

            self.noNetVC.hidden = YES;
            self.homeTopView.hidden = YES;
            
            GZDataHomeModel *dataModel = [[GZDataHomeModel alloc] initWithDictionary:resultModel.data error:nil];
            
            self.adlistModel = (GZAdlistModel *)dataModel.adlist;
    
            //轮播图数据
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
            for (GZAdlistModel *adlistModel in dataModel.adlist) {
                NSString * cycleImg = [NSString stringWithFormat:@"%@%@",YUMING,adlistModel.Ad_logo];
                [imagesURLStrings addObject:cycleImg];
            }
            self.headerView.imageURLStringsGroup = imagesURLStrings;
            
            //分类按钮数据
            self.headerView.classArray = dataModel.class_list;
            
            if (self.currentPage == 1) {
                [self.tableDataSource removeAllObjects];
            }
            //tableView数据
            if (dataModel.hotlist != nil && ![dataModel.hotlist isKindOfClass:[NSNull class]] && dataModel.hotlist.count !=0) {
                
                [self.tableDataSource addObjectsFromArray:dataModel.hotlist];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }else
            {
                
                self.Loadview.hidden = YES;
                [self.Loadview removeActivityView];
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];

                self.currentPage--;
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        self.Loadview.hidden = YES;
        [self.Loadview removeActivityView];
        
        self.noNetVC.hidden = NO;
        self.homeTopView.hidden = NO;
        
        GZWeakSelf;
        self.noNetVC.netWorkAgainBlock = ^{
            
            [weakSelf getData];
        };
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (_isFooter) {
            
            self.currentPage--;
        }
    }];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self configCell:cell indexpath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    GZHotListModel *hotListModel = self.tableDataSource[indexPath.row];
    
    //    if ([hotListModel.Ad_link_type isEqualToString:@"0"])
//    {
//        [self.clickedImagView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,hotListModel.Ad_logo]]];
//        //浏览大图
//        [GZScanImage scanBigImageWithImageView:self.clickedImagView];
//        
//    }else
    
    if ([hotListModel.Ad_link_type isEqualToString:@"1"])
    {
        GZWebViewController *webVC = [[GZWebViewController alloc] init];
        
        webVC.url = hotListModel.Ad_link_id;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.backBarButtonItem = backItem;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if ([hotListModel.Ad_link_type isEqualToString:@"2"])
    {
        GZOrderDetailViewController *orderDetailVC = [[GZOrderDetailViewController alloc] init];
        
        orderDetailVC.pid = hotListModel.Ad_link_id;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:orderDetailVC animated:YES];
        
    }else if ([hotListModel.Ad_link_type isEqualToString:@"3"])
    {
        GZHomeDetailsViewController *homeDetailVC = [[GZHomeDetailsViewController alloc] init];
        
        homeDetailVC.photoID = hotListModel.Ad_link_id;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:homeDetailVC animated:YES];
    }    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 132;
}

- (void)configCell:(GZHomeTableViewCell *)cell indexpath:(NSIndexPath *)index
{
   // cell.fd_enforceFrameLayout = NO;
    cell.hotListModel = self.tableDataSource[index.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return [tableView fd_heightForCellWithIdentifier:TableViewIdentity cacheByKey:indexPath configuration:^(GZHomeTableViewCell *cell) {
//        
//        [self configCell:cell indexpath:indexPath];
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
