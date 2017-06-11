//
//  GZGoShoppingViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZGoShoppingViewController.h"
#import "GZOrderDetailViewController.h"
#import "GZSureOrderController.h"
#import "GZGoShoppingCell.h"
#import "GZNoDataView.h"
#import "GZNoDataProlist.h"

#import "GZGoShoppResultModel.h"
#import "GZGoShoppDataModel.h"
#import "GZNoDataResultModel.h"
#import "GZNoDataDataModel.h"
#import "GZNoDataProlist.h"
#import "GZSureOrderResultModel.h"


@interface GZGoShoppingViewController ()<UITableViewDelegate,UITableViewDataSource,GZGoShoppingCellDelegate,UIAlertViewDelegate>

/** 广告label */
@property (nonatomic, strong) UIView *advertisementView;
@property (nonatomic, strong) UILabel *advertisementLabel;
@property (nonatomic, strong) UIImageView *advertisementImg;
@property (nonatomic, strong) UIBarButtonItem *editBarButton;

/** 下面支付View */
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) GGZButton *allSelectBtn;
@property (nonatomic, strong) GGZButton *payForBtn;
@property (nonatomic, strong) UILabel *totalPriceLabel;

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;

/** 判断选中商品的种类个数 */
@property (nonatomic,assign) NSInteger count;


@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 记录购物车ID */
@property (nonatomic, strong) NSMutableArray *totalCarIDArr;

/** 无数据时的View */
@property (nonatomic, strong) GZNoDataView *noDataView;

/** 无数据时展示推荐精品数据源 */
@property (nonatomic, strong) NSMutableArray *noDataArr;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic, copy) NSString *payforStr;
@property (nonatomic, copy) NSString *delegateStr;

@property (nonatomic, strong) UIView *Loadview;

@end

static NSString *TableViewIdentity = @"goShopingCellID";
@implementation GZGoShoppingViewController
{
    NSInteger _count;
    BOOL _isSelect;
}

#pragma mark - Getter
-(UIView *)advertisementView
{
    if (!_advertisementView) {
        _advertisementView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 34)];
        _advertisementView.backgroundColor = YHRGBA(255, 184, 0, 1.0);
        
        [self.view addSubview:_advertisementView];
    }
    return _advertisementView;
}

-(UILabel *)advertisementLabel
{
    if (!_advertisementLabel) {
        _advertisementLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.advertisementImg.right + 5, 0, kScreenWidth, 34)];

        _advertisementLabel.textColor = [UIColor whiteColor];
        _advertisementLabel.font = [UIFont systemFontOfSize:15];

    }
    return _advertisementLabel;
}

-(UIImageView *)advertisementImg
{
    if (!_advertisementImg) {
        _advertisementImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 20, 20)];

        _advertisementImg.image = [UIImage imageNamed:@"tishi_"];
    }
    return _advertisementImg;
}

-(UIBarButtonItem *)editBarButton
{
    if (!_editBarButton) {
        _editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick:)];
        //设置字体大小
        [_editBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    return _editBarButton;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kScreenWidth, 35)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIView *)Loadview
{
    if (!_Loadview) {
        _Loadview = [[UIView alloc] initWithFrame:self.view.bounds];
        _Loadview.backgroundColor = [UIColor clearColor];
        
        [self.tableView addSubview: _Loadview];
    }
    return _Loadview;
}

-(GGZButton *)payForBtn
{
    if (!_payForBtn) {
        _payForBtn = [GGZButton createGGZButton];
        _payForBtn.frame = CGRectMake(self.bottomView.right - 100, 0, 100, self.bottomView.height);
        _payForBtn.backgroundColor = YHRGBA(229, 78, 57, 1.0);
        
        [_payForBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        _payForBtn.titleColor = [UIColor whiteColor];
        
        _payForBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _payForBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        GZWeakSelf;

        _payForBtn.block = ^(GGZButton *btn) {
            
            //将数组中的元素拼接成字符串
            NSString * totalCarStr = [weakSelf.totalCarIDArr componentsJoinedByString:@","];
            
            if (weakSelf.totalCarIDArr != nil && ![weakSelf.totalCarIDArr isKindOfClass:[NSNull class]] && weakSelf.totalCarIDArr.count != 0) {
                
                if ([weakSelf.editBarButton.title isEqualToString:@"取消"] || [weakSelf.editBarButton.title isEqualToString:@"cancel"] || [weakSelf.editBarButton.title isEqualToString:@"törlés"]) {
                    
                    GZAlertView * alert = [GZAlertView sharedAlertView];
                    [alert animationAlert];
                    
                    [alert alertViewMessage:@"确定删除商品?" cancelTitle:@"取消" sureTitle:@"确定" image:@"delete_" Block:^(NSString *status) {
                        
                        if ([status isEqualToString:@"sure"]) {
                            //删除
                            NSDictionary *params = @{
                                                     @"language": [GGZTool iSLanguageID],
                                                     @"car_id": totalCarStr,
                                                     @"action":@"Del_car"
                                                     };
                            
                            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                                if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                                    
                                    //添加购物车成功，通知TabbarController，调用数据更改角标
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                                    
                                    [weakSelf getData];
                                }else
                                    {
                                        [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
                                        
                                    }
                                //清空carID数组
                                [weakSelf.totalCarIDArr removeAllObjects];
                                weakSelf.count = 0;
                            } failure:^(NSError *error) {
                                [MBProgressHUD showAlertMessage:@"网络错误"];
                            }];
                        }
                    }];
                    
                }else if ([weakSelf.editBarButton.title isEqualToString:@"编辑"] || [weakSelf.editBarButton.title isEqualToString:@"edit"] || [weakSelf.editBarButton.title isEqualToString:@"szerkesztése"])
                {
                    if (totalCarStr != nil) {
                       
                        weakSelf.Loadview.hidden = NO;
                        [weakSelf.Loadview appendActivityView:[UIColor blackColor]];
                        
                        //立即购买，请求确认订单数据，请求成功后跳转确认订单界面。
                        NSDictionary *params = @{
                                                 @"car_idlist":totalCarStr,
                                                 @"uid":[GGZTool isUid],
                                                 @"language":[GGZTool iSLanguageID],
                                                 @"action":@"order_submin_show"
                                                 };
                        
                        [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                            
                            GZSureOrderResultModel *resultModel = [[GZSureOrderResultModel alloc] initWithDictionary:obj error:nil];
                            
                            if ([resultModel.msgcode isEqualToString:@"1"]) {
                                weakSelf.Loadview.hidden = YES;
                                [weakSelf.Loadview removeActivityView];
                                
                                GZSureOrderDataModel *dataModel = [[GZSureOrderDataModel alloc] initWithDictionary:resultModel.data error:nil];

                                GZSureOrderController *sureOrderVC = [[GZSureOrderController alloc] init];
                                
                                sureOrderVC.totoalCarID = totalCarStr;
                                
                                sureOrderVC.dataModel = dataModel;

                                weakSelf.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                
                                weakSelf.navigationController.navigationBar.tintColor = [UIColor blackColor];

                                [weakSelf.navigationController pushViewController:sureOrderVC animated:YES];
                                
                            }else
                            {
                                weakSelf.Loadview.hidden = YES;
                                [weakSelf.Loadview removeActivityView];
                                
                                [MBProgressHUD showAlertMessage:resultModel.msg];
                            }
                            //清空carID数组
                            [weakSelf.totalCarIDArr removeAllObjects];
                            
                        } failure:^(NSError *error) {
                            
                            weakSelf.Loadview.hidden = YES;
                            [weakSelf.Loadview removeActivityView];
        
                            [MBProgressHUD showAlertMessage:@"网络错误"];
                        }];
                    }
                }
            }else
            {
                [MBProgressHUD showAlertMessage:@"尚未选择商品"];
            }
        };
    }
    return _payForBtn;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineLabel.backgroundColor = YHRGBA(224, 224, 224, 1.0);
    }
    return _lineLabel;
}

-(GGZButton *)allSelectBtn
{
    if (!_allSelectBtn) {
        _allSelectBtn = [GGZButton createGGZButton];
        _allSelectBtn.frame = CGRectMake(9, 5, 80, 25);
        [_allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        
        [_allSelectBtn setImage:[[UIImage imageNamed:@"weixuan_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_allSelectBtn setImage:[[UIImage imageNamed:@"redxuanzhong_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
      
        _allSelectBtn.titleColor = [UIColor blackColor];
        _allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_allSelectBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        
        _allSelectBtn.eventTimeInterval = 0.05;
        
        GZWeakSelf;
        _allSelectBtn.block = ^(GGZButton *btn) {
        
            //先把总价格赋值为 0
            weakSelf.totalPriceLabel.text = @"合计: 0";
            
            //如果在选中的状态，再次点击为不是选中的状态
            if (weakSelf.allSelectBtn.selected) {

                //不在选中的状态，商品全部不选中
                weakSelf.allSelectBtn.selected = NO;

                //记录carID
                [weakSelf.totalCarIDArr removeAllObjects];
                
                for (int i = 0; i < weakSelf.dataSource.count; i++) {
                    GZGoShoppAllModel *dataModel = weakSelf.dataSource[i];
                    dataModel.status = NO;
                    
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:dataModel];
                    
                    weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"合计: 0"];
                }
                //如果商品全部不选中，选中商品的个数为 0
                weakSelf.count = 0;
                
            }else{//如果不在选中的状态，再次点击的时候，为选中的状态
               
                //在选中的状态，商品全部选中
                weakSelf.allSelectBtn.selected = YES;
                
                //记录carID
                [weakSelf.totalCarIDArr removeAllObjects];
                
                
                for (int i = 0; i < weakSelf.dataSource.count; i++) {
                    GZGoShoppAllModel *dataModel = weakSelf.dataSource[i];
                    dataModel.status = YES;
                    
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:dataModel];
                    
                    NSString *money = [weakSelf.totalPriceLabel.text substringToIndex:weakSelf.totalPriceLabel.text.length];
                    
                    NSInteger intMoney = money.integerValue;
                    NSInteger surplus = intMoney + [dataModel.P_price integerValue] * dataModel.P_count;
                    
                    weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@" %ldFT",surplus];
                  
                    [weakSelf.totalCarIDArr addObject:dataModel.C_id];
                }
                //如果商品全部选中，选中商品的个数为 dataArray的个数
                weakSelf.count = weakSelf.dataSource.count;
            }
            
            //刷新数据
            [weakSelf.tableView reloadData];
        };
    }
    return _allSelectBtn;
}

-(UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allSelectBtn.right + 15, 5, 150, 25)];
        _totalPriceLabel.text = @"合计: 0";
        _totalPriceLabel.textColor = [UIColor blackColor];
        _totalPriceLabel.font = [UIFont systemFontOfSize:17];
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalPriceLabel;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.advertisementView.bottom, kScreenWidth, kScreenHeight - self.advertisementView.bottom - 64 - 49 - 35) style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.tableView registerNib:[UINib nibWithNibName:@"GZGoShoppingCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)totalCarIDArr
{
    if (!_totalCarIDArr) {
        _totalCarIDArr = [NSMutableArray array];
    }
    return _totalCarIDArr;
}

-(GZNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[GZNoDataView alloc] initWithFrame:self.view.bounds];
        
        GZWeakSelf;
        //点击collectionView时的回调
        _noDataView.didSelectCollectionCellClickClick = ^(NSString *photoID) {
            GZOrderDetailViewController *orderDetailVC = [[GZOrderDetailViewController alloc] init];
            orderDetailVC.pid = photoID;
            orderDetailVC.ControllerID = @"goShopingVC";
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            
            weakSelf.navigationItem.backBarButtonItem = backItem;
            [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
        };
        
    }
    return _noDataView;
}

-(NSMutableArray *)noDataArr
{
    if (!_noDataArr) {
        _noDataArr = [NSMutableArray array];
    }
    return _noDataArr;
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
    self.navigationController.title = @"购物车";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.advertisementView addSubview:self.advertisementLabel];
    [self.advertisementView addSubview:self.advertisementImg];
    
    
    self.currentPage = 1;
    
    //默认选中的
    self.count = 0;
    
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.lineLabel];
    [self.bottomView addSubview:self.allSelectBtn];
    [self.bottomView addSubview:self.totalPriceLabel];
    [self.bottomView addSubview:self.payForBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Loadview.hidden = NO;
    [self.Loadview appendActivityView:[UIColor blackColor]];
    
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
        self.editBarButton.title = @"编辑";
        [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.totalPriceLabel.text = @"合计: 0";
        _payforStr = @"立即购买";
        _delegateStr = @"删除";
 
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        homeStr = @"home";
        classifyStr = @"classify";
        goShoppingStr = @"cart";
        mineStr = @" mine";
        self.editBarButton.title = @"edit";
        [self.allSelectBtn setTitle:@"choose all items" forState:UIControlStateNormal];
        self.totalPriceLabel.text = @"in total: 0";
        _payforStr = @"purchase immediately";
        _delegateStr = @"delete";

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        homeStr = @"főoldal";
        classifyStr = @"osztályozások";
        goShoppingStr = @"bevásárlókocsi";
        mineStr = @"saját";
        self.editBarButton.title = @"szerkesztése";
        [self.allSelectBtn setTitle:@"összes" forState:UIControlStateNormal];
        self.totalPriceLabel.text = @"összeg: 0";
        _payforStr = @"vásárlás";
        _delegateStr = @"tőrlés";

    }
    
    self.payForBtn.title = _payforStr;

    UITabBarItem *item0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    item0.title = homeStr;
    item1.title = classifyStr;
    item2.title = goShoppingStr;
    item3.title = mineStr;
    
    self.allSelectBtn.selected = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //图片消失的时候，将totalCarIDArr清空。
    [self.totalCarIDArr removeAllObjects];
   //将个数置为0
    _count = 0;
}

#pragma mark - 界面接口
- (void)getData
{
    if ([self.editBarButton.title isEqualToString:@"取消"] || [self.editBarButton.title isEqualToString:@"cancel"] || [self.editBarButton.title isEqualToString:@"törlés"]) {
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            
            self.editBarButton.title = @"编辑";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.editBarButton.title = @"edit";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.editBarButton.title = @"szerkesztése";
            
        }
        
        _isSelect = NO;
        self.totalPriceLabel.hidden = NO;
    }
    
    NSDictionary *params = @{
                             @"language":[GGZTool iSLanguageID],
                             @"uid":[GGZTool isUid],
                             @"action":@"User_CarList"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        
        GZGoShoppResultModel *resultModel = [[GZGoShoppResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
        
            self.Loadview.hidden = YES;
            [self.Loadview removeActivityView];
        
            [self.view addSubview:self.bottomView];
            
            [self.dataSource removeAllObjects];
            
            GZGoShoppDataModel *dataModel = [[GZGoShoppDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
                
                self.advertisementLabel.text = [NSString stringWithFormat:@"订单满%@FT可成功下单, 感谢惠顾",dataModel.set_over_mony_noyunfeis];

            }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
                
                self.advertisementLabel.text = [NSString stringWithFormat:@"order can be placed successfully for purchasing at least %@FT worth of items, thanks for visit",dataModel.set_over_mony_noyunfeis];

            }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
                
                self.advertisementLabel.text = [NSString stringWithFormat:@"订单满%@FT可成功下单, 感谢惠顾匈牙利文",dataModel.set_over_mony_noyunfeis];
            }
            
            
            self.advertisementView.hidden = NO;
            self.noDataView.hidden = YES;
            self.tableView.hidden = NO;
            self.bottomView.hidden = NO;
            
            self.navigationItem.rightBarButtonItem = self.editBarButton;
            [self.navigationItem.rightBarButtonItem setTintColor:YHRGBA(138, 138, 138, 1.0)];
            
            if (dataModel.all != nil && ![dataModel.all isKindOfClass:[NSNull class]] && dataModel.all.count != 0) {
                
            }else
            {
                [self MJRefresh];
                
                //如果没有数据，显示无数据界面，刷推荐接口
                [self.view addSubview:self.noDataView];
                self.advertisementView.hidden = YES;
                self.bottomView.hidden = YES;
                self.noDataView.hidden = NO;
                self.navigationItem.rightBarButtonItem = nil;

            }
            
            [self.dataSource addObjectsFromArray:dataModel.all];
           
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
    }];
}

#pragma mark - 无数据时调用接口获取数据
- (void)MJRefresh
{
    [self getNoData];
    
    GZWeakSelf;
    MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        
        [weakSelf getNoData];
    }];
    
    self.noDataView.collectionView.mj_header = header;
   
    self.noDataView.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage++;
        [weakSelf getNoData];
    }];
}

#pragma mark - 无数据时刷推荐精品接口
- (void)getNoData
{
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];
    NSDictionary *params = @{
                             @"language": [GGZTool iSLanguageID],
                             @"ye": page,
                             @"action":@"Tuijian_Product_list"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        GZNoDataResultModel *resultModel = [[GZNoDataResultModel alloc] initWithDictionary:obj error:nil];
        
        //将数据传到GZNoDataView中
        if ([resultModel.msgcode isEqualToString:@"1"]) {
        
            GZNoDataDataModel *dataModel = [[GZNoDataDataModel alloc] initWithDictionary:resultModel.data error:nil];

            if (self.currentPage == 1) {
                
                [self.noDataArr removeAllObjects];
            }

            //将推荐精品数据传到noDataView中。
            [self.noDataArr addObjectsFromArray:dataModel.prolist];
            
            self.noDataView.prolistArr = self.noDataArr;
            
            [self.noDataView.collectionView reloadData];
            
            [self.noDataView.collectionView.mj_header endRefreshing];
            [self.noDataView.collectionView.mj_footer endRefreshing];
            
        }else
        {
            [self.noDataView.collectionView.mj_footer endRefreshingWithNoMoreData];
            
            self.currentPage--;

        }
        
    } failure:^(NSError *error) {
        
        [self.noDataView.collectionView.mj_header endRefreshing];
        [self.noDataView.collectionView.mj_footer endRefreshing];
    }];
}

- (void)editClick:(UIBarButtonItem *)buttonItem
{
    
    if (_isSelect) {
        _isSelect = NO;

        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            
            self.editBarButton.title = @"编辑";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.editBarButton.title = @"edit";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.editBarButton.title = @"szerkesztése";
            
        }
        
        [self.payForBtn setTitle:_payforStr forState:UIControlStateNormal];
        self.totalPriceLabel.hidden = NO;
    }else
    {
        _isSelect = YES;
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            
            self.editBarButton.title = @"取消";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.editBarButton.title = @"cancel";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.editBarButton.title = @"törlés";
            
        }
        
        [self.payForBtn setTitle:_delegateStr forState:UIControlStateNormal];
        self.totalPriceLabel.hidden = YES;
    }
}

#pragma mark - UITableViewDeleagate-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZGoShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];
    
    cell.indexpath = indexPath;
    
    cell.allModel = self.dataSource[indexPath.row];
    
    cell.delegate = self;
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;

    cell.NoSelect.eventTimeInterval = 0.01;
    
    GZWeakSelf;
    //点击减号的回调
    cell.reduceClickBlock = ^(UIButton *reduceBtn) {
        GZGoShoppAllModel *model = weakSelf.dataSource[reduceBtn.tag];

        //判断商品的个数>1的时候，才会减1
        if (model.P_count > 1) {
            
            NSDictionary *params = @{
                                     @"cid": model.C_id,
                                     @"type": @"1",
                                     @"action":@"Update_Car_count"
                                     };
            
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                
                model.P_count--;
                [weakSelf.dataSource replaceObjectAtIndex:reduceBtn.tag withObject:model];
                
                
                //添加购物车成功，通知TabbarController，调用数据更改角标
                [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                
                
                //刷新减后的数量的数据
                //    [self.tableView reloadData];
                NSIndexPath *indepath = [NSIndexPath indexPathForRow:reduceBtn.tag inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indepath] withRowAnimation:UITableViewRowAnimationNone];
                
                //判断如果这个商品在选中的时候，要更新总价格
                if (model.status) {
                    //选中总价格的更新
                    
                    NSString *money = [weakSelf.totalPriceLabel.text substringToIndex:weakSelf.totalPriceLabel.text.length];
                    
                    NSInteger intMoney = money.integerValue;
                    NSInteger surplus = intMoney - [model.P_price integerValue];
                    weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"%ldFT",surplus];
                }

            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"网络错误"];
            }];
        }else
        {
            //阻止在数量为1的时候，下面的代码不会再次执行
            return;
        }
    };
    
    //点击加号的回调
    cell.addClickBlock = ^(UIButton *addBtn) {
        
        //加数量
        GZGoShoppAllModel *model = weakSelf.dataSource[addBtn.tag];
        
        NSDictionary *params = @{
                                 @"cid": model.C_id,
                                 @"type": @"0",
                                 @"action":@"Update_Car_count"

                                 };

        [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
          
            //添加购物车成功，通知TabbarController，调用数据更改角标
            [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
            
            model.P_count++;
            [weakSelf.dataSource replaceObjectAtIndex:addBtn.tag withObject:model];
            //更新加的数量的数据
            //    [self.tableView reloadData];
            NSIndexPath *indepath = [NSIndexPath indexPathForRow:addBtn.tag inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indepath] withRowAnimation:UITableViewRowAnimationNone];
            
            //判断如果这个商品在选中的时候，要更新总价格
            if (model.status) {
                
                NSString *money = [weakSelf.totalPriceLabel.text substringToIndex:weakSelf.totalPriceLabel.text.length];
                NSInteger intMoney = money.integerValue;
                NSInteger surplus = intMoney + [model.P_price integerValue];
                weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"%ldFT",surplus];
            }
 
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误"];
        }];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZGoShoppAllModel *model = self.dataSource[indexPath.row];
    GZOrderDetailViewController *orderDetailVC = [[GZOrderDetailViewController alloc] init];
    orderDetailVC.pid = model.P_id;
    orderDetailVC.ControllerID = @"goShopingVC";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

/**
 *  shopPlatformTableViewCellDelegate的代理方法，是否选中商品,不对
 */
- (void)shopPlatformTableViewCell:(GZGoShoppingCell *)cell andTag:(NSInteger)tag
{

    GZGoShoppAllModel *dataModel = self.dataSource[tag];
    
    if (dataModel.status == YES) {      //取消选中
       
        dataModel.status = NO;
        
        //取消，删除数组中选中的对应的carID
        [self.totalCarIDArr removeObject:dataModel.C_id];
        
        //计算价钱
        NSString *money = [self.totalPriceLabel.text substringToIndex:self.totalPriceLabel.text.length];
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney - [dataModel.P_price integerValue] * dataModel.P_count;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%ldFT",surplus];
        self.count--;
        
    }else        //选中
    {
        dataModel.status = YES;
        
        //添加carID
        [self.totalCarIDArr addObject:dataModel.C_id];
        
        //计算价钱
        NSString *money = [self.totalPriceLabel.text substringToIndex:self.totalPriceLabel.text.length];
        
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney + [dataModel.P_price integerValue] * dataModel.P_count;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%ldFT",surplus];
        self.count++;
    }

    //replaceObjectAtIndex:方
    //更新数据
    [self.dataSource replaceObjectAtIndex:tag withObject:dataModel];
    //刷新数据
    //    [self.tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    
    //判断选中的个数，如果选中的个数是dataArray的个数，代表全选
    if (self.count == self.dataSource.count) {
        
        self.allSelectBtn.selected = YES;
    }else{

        self.allSelectBtn.selected = NO;
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
