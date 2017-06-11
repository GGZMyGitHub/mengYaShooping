//
//  GZSureOrderController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderController.h"
#import "GZSureOrderDiZhiGuanLiController.h"
#import "GZGoShoppingViewController.h"
#import "GZSureOrderHeaderView.h"
#import "GZSureOrderFooterView.h"
#import "GZSureOrderTableViewCell.h"
#import "GZTableViewCell.h"
#import "GZfinishOrderViewController.h"
#import "GZintegralRuleViewController.h"

#import "GZSureOrderResultModel.h"
#import "GZSureOrderProListModel.h"

@interface GZSureOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GZSureOrderHeaderView *headerView;
@property (nonatomic, strong) GZSureOrderFooterView *footerView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *totalGetLabel;
@property (nonatomic, strong) GGZButton *submitOrderBtn;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic) BOOL isSelect;

/** 判断是否是第一次进入该界面 */
@property (nonatomic) BOOL isFirst;

/** 刷新的地址数据 */
@property (nonatomic, strong) GZSureOrderDataModel *addressModel;

@end

static NSString *TableViewIdentity = @"OrderTableViewCell";
@implementation GZSureOrderController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 112;

        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GZSureOrderTableViewCell" bundle:nil] forCellReuseIdentifier:TableViewIdentity];
    }
    return _tableView;
}

-(GZSureOrderHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [GZSureOrderHeaderView sharedSureOrderHeaderView];
        _headerView.dataModel = self.dataModel;
                
        UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick)];
        
        _headerView.userInteractionEnabled=YES;
        [_headerView addGestureRecognizer:tapRecognizerWeibo];
        
    }
    return _headerView;
}

-(GZSureOrderFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [GZSureOrderFooterView sharedSureOrderFooterView];
        _footerView.dataModel = self.dataModel;
     
        _footerView.integralBtn.eventTimeInterval = 0.01;

        GZWeakSelf;
        _footerView.discountClickBlock = ^(BOOL isDiscount) {

            if (isDiscount) {
                
                float realityMoney = [self.dataModel.all_wei_youhui floatValue] + [[_footerView.freightLabel.text substringToIndex:_footerView.freightLabel.text.length] floatValue] - [self.dataModel.use_mony floatValue];
                
                weakSelf.totalGetLabel.text = [NSString stringWithFormat:@"%.2fFT",realityMoney];
                
                _isSelect =YES;
            }else
            {
                float realityMoney = [self.dataModel.all_wei_youhui floatValue] + [[_footerView.freightLabel.text substringToIndex:_footerView.freightLabel.text.length] floatValue];
                
                weakSelf.totalGetLabel.text = [NSString stringWithFormat:@"%.2fFT",realityMoney];
                
                _isSelect = NO;
            }
        };
        
        //点击常见问题回调
        _footerView.problemClickBlock = ^{
           
            GZintegralRuleViewController *integralRuleVC = [[GZintegralRuleViewController alloc] init];
            integralRuleVC.title = @"积分规则";
            
            weakSelf.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            weakSelf.navigationController.navigationBar.tintColor = [UIColor blackColor];
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:integralRuleVC animated:YES];
        };
    }
    return _footerView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 17, 80, 20)];
        _totalLabel.text = @"实际付款";
        _totalLabel.font = [UIFont systemFontOfSize:17];
        _totalLabel.textAlignment = NSTextAlignmentLeft;
        _totalLabel.textColor = [UIColor blackColor];
        
    }
    return _totalLabel;
}

-(UILabel *)totalGetLabel
{
    if (!_totalGetLabel) {
        _totalGetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.totalLabel.right + 5, self.totalLabel.top - 3, 90, 26)];
        
        float realityMoney = [self.dataModel.all_wei_youhui floatValue] + [[self.footerView.freightLabel.text substringToIndex:self.footerView.freightLabel.text.length] floatValue];
        
        _totalGetLabel.text = [NSString stringWithFormat:@"%.2fFT",realityMoney];
        
        _totalGetLabel.font = [UIFont systemFontOfSize:19];
        _totalGetLabel.textAlignment = NSTextAlignmentLeft;
        _totalGetLabel.textColor = YHRGBA(229, 77, 61, 1.0);
    }
    return _totalGetLabel;
}

-(GGZButton *)submitOrderBtn
{
    if (!_submitOrderBtn) {
        _submitOrderBtn = [GGZButton createGGZButton];
        
        _submitOrderBtn.frame = CGRectMake(kScreenWidth - 120, 10, 105, 34);
        _submitOrderBtn.backgroundColor = YHRGBA(227, 78, 61, 1.0);
        [_submitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitOrderBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        _submitOrderBtn.layer.masksToBounds = YES;
        _submitOrderBtn.layer.cornerRadius = 3;
        
        __weak typeof(self) weakSelf = self;
        _submitOrderBtn.block = ^(GGZButton *btn) {
           
            NSMutableArray *cidArr = [NSMutableArray array];
            for (GZSureOrderProListModel *prolistModel in weakSelf.dataModel.pro_list) {
                [cidArr addObject:prolistModel.c_id];
            }
            NSString *cidStr = [cidArr componentsJoinedByString:@","];
            
            NSString *jifenStr = nil;
            NSString *totalGetPriceStr = nil;
            totalGetPriceStr = [weakSelf.totalGetLabel.text substringToIndex:weakSelf.totalGetLabel.text.length - 2];
            
            if (weakSelf.isSelect) {
                
                jifenStr = weakSelf.dataModel.use_jifen;
                
            }else
            {
                jifenStr = @"0";
            }
            
            NSString *ad_person = nil;
            NSString *ad_tel = nil;
            NSString *ad_adress = nil;
            
            if ([weakSelf.headerView.nameLabel.text isEqualToString:@"\n暂无收货地址,快去添加地址吧~"]) {
              
                [MBProgressHUD showAlertMessage:@"请添加收货地址"];
                return ;
            }else
            {
                ad_person = self.headerView.nameLabel.text;
                ad_tel = self.headerView.telLabel.text;
                ad_adress = self.headerView.addressLabel.text;
            }
            
            if ([ad_adress isEqualToString:@""] && [ad_tel isEqualToString:@""] && [ad_person isEqualToString:@""]) {
                
                [MBProgressHUD showAlertMessage:@"无收货地址,请添加收货地址"];
            }else
            {
                
                NSDictionary *params = @{
                                         @"uid":[GGZTool isUid],
                                         @"language":[GGZTool iSLanguageID],
                                         @"adid":weakSelf.dataModel.sureOrderID,
                                         @"ad_person":ad_person,
                                         @"ad_tel":ad_tel,
                                         @"ad_adress":ad_adress,
                                         @"car_ids":cidStr,
                                         @"yunfei":[weakSelf.footerView.freightLabel.text substringToIndex:weakSelf.footerView.freightLabel.text.length - 2],
                                         @"usejifen":jifenStr,
                                         @"getjifen":weakSelf.dataModel.get_jifen,
                                         @"allprice":weakSelf.dataModel.all_wei_youhui,
                                         @"price":totalGetPriceStr,
                                         @"action":@"Submit_Product"
                                         };
                
                [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                    
                    if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                        
                        GZAlertView * alert = [GZAlertView sharedAlertView];
                        [alert animationAlert];
                        [alert alertViewMessage:@"订单提交成功" cancelTitle:@"返回购物车" sureTitle:@"去我的订单" image:@"chenggong_" Block:^(NSString *status) {
                            
                            if ([status isEqualToString:@"sure"]) {
                                //我的订单
                                GZfinishOrderViewController *finishOrderVC = [[GZfinishOrderViewController alloc] init];
                                
                                finishOrderVC.controllerID = 2;
                                finishOrderVC.order_id = [obj valueForKey:@"data"];
                                
                                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                
                                weakSelf.navigationItem.backBarButtonItem = backItem;
                                
                                weakSelf.hidesBottomBarWhenPushed = YES;
                                [weakSelf.navigationController pushViewController:finishOrderVC animated:YES];
                                
                            }else if ([status isEqualToString:@"cancel"])
                            {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }
                    _isFirst = NO;
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD showAlertMessage:@"网络错误"];
                    
                    _isFirst = NO;
                }];
            }
        };
        
    }
    return _submitOrderBtn;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineLabel.backgroundColor = YHRGBA(240, 240, 237, 1.0);
    }
    return _lineLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titleStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        titleStr = @"确认订单";
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        titleStr = @"confirm order";
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        titleStr = @"megrendelés megerősítése";
    }
    
    self.navigationItem.title = titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _isFirst = YES;
    
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.totalLabel];
    [self.bottomView addSubview:self.totalGetLabel];
    [self.bottomView addSubview:self.submitOrderBtn];
    [self.bottomView addSubview:self.lineLabel];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
       
        self.totalLabel.text = @"实际付款";
        [self.submitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
      
        self.totalLabel.text = @"actual payment";
        [self.submitOrderBtn setTitle:@"submit an order" forState:UIControlStateNormal];

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
       
        self.totalLabel.text = @"实际付款匈牙利文";
        [self.submitOrderBtn setTitle:@"rendelés megadása" forState:UIControlStateNormal];

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    self.tabBarController.tabBar.hidden = YES;
    
    [self freshVC];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)freshVC
{
    //立即购买，请求确认订单数据，请求成功后跳转确认订单界面。
    NSDictionary *params = @{
                             @"car_idlist":self.totoalCarID,
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"order_submin_show"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        GZSureOrderResultModel *resultModel = [[GZSureOrderResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {

            GZSureOrderDataModel *dataModel = [[GZSureOrderDataModel alloc] initWithDictionary:resultModel.data error:nil];
           
            self.addressModel = dataModel;
            self.headerView.dataModel = dataModel;
           
            self.footerView.dataModel = dataModel;

        }else
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showAlertMessage:resultModel.msg];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAlertMessage:@"网络错误"];
    }];
}

- (void)addressClick
{
    _isFirst = NO;
    
    GZSureOrderDiZhiGuanLiController *diZhiGuanLiVC = [[GZSureOrderDiZhiGuanLiController alloc] init];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        diZhiGuanLiVC.title = @"地址管理";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        diZhiGuanLiVC.title = @"address management";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        diZhiGuanLiVC.title = @"cím kezelés";
    }
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:diZhiGuanLiVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataModel.pro_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZSureOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewIdentity forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.OrderprolistModel = self.dataModel.pro_list[indexPath.row];
    
    return cell;
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
