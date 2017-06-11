//
//  GZHomeDetailsViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/22.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHomeDetailsViewController.h"
#import "GZLoginViewController.h"
#import "GZOrderDetailViewController.h"
#import "GZCollectionViewFlowLayout.h"
#import "GZPopShoppDetailView.h"
#import "GZHomeDetailCell.h"
#import "GZTopScrollMenu.h"
#import "GZLoginViewController.h"
#import "GZSearchViewController.h"
#import "GZMessageViewController.h"

#import "GZHomeDetailResultModel.h"
#import "GZHomeDetailDataModel.h"
#import "GZHomeDetailProlistModel.h"


@interface GZHomeDetailsViewController ()<GZTopScrollMenuDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CAAnimationDelegate>

/** 创建顶部菜单 */
@property (nonatomic, strong) GZTopScrollMenu *topScrollMenu;

@property (nonatomic, strong) UICollectionView *collectionView;

/** 如果分类数据不为空，弹出界面 */
@property (nonatomic, strong) GZPopShoppDetailView *popShoppDetailView;

/** 选择分类ID和数据 */
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *countNum;

/** collectionView总数据源 */
@property (nonatomic, strong) NSMutableArray *collectionDataSource;

/** 顶部菜单数据源和ID */
@property (nonatomic, strong) NSMutableArray *topMenuArr;
@property (nonatomic, strong) NSMutableArray *topMenuIDArr;

/** 全局数据源 */
@property (nonatomic, strong) GZHomeDetailDataModel *dataModelDataSource;

/** 当前页 */
@property (nonatomic) NSInteger currentPage;

/** 下拉刷新时的动画图片 */
@property (nonatomic, strong) NSArray *refreshImgArr;

/** 全部、价格按钮 */
@property (nonatomic, strong) GGZButton *totalBtn;
@property (nonatomic, strong) GGZButton *priceBtn;
@property (nonatomic, strong) GGZButton *topBtn;
@property (nonatomic, strong) GGZButton *bottomBtn;


@property (nonatomic, strong) UILabel *lineLabel;

/** 购物车动画路径 */
@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic, copy) NSString *ascStr;

@property (nonatomic) BOOL isDidClickCell;

@property (nonatomic) BOOL isPrice;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@property (nonatomic, strong) GZNoDataCommonView *NoDataView;

@end

static NSString *collectionIdentifier = @"collectionViewID";
@implementation GZHomeDetailsViewController
{
    CALayer     *layer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    UIImageView *_imageView;
    NSString *_pid;
    
}

#pragma mark - Getter
-(GZTopScrollMenu *)topScrollMenu
{
    if (!_topScrollMenu) {
        _topScrollMenu = [GZTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 64,kScreenWidth, 44)];
        
        //将原来的标题对应的ID以及现在的ID数组传过去，在topScrollMenu里面比较，让其默认选中居中
        _topScrollMenu.oldTitleIDStr = self.photoID;
        _topScrollMenu.scrollTItleIDArr = self.topMenuIDArr;
        _topScrollMenu.scrollTitleArr = self.topMenuArr;
        _topScrollMenu.topScrollMenuDelegate = self;
    }
    return _topScrollMenu;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.totalBtn.bottom + 10, kScreenWidth, kScreenHeight - self.totalBtn.bottom - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerNib:[UINib nibWithNibName:@"GZHomeDetailCell" bundle:nil] forCellWithReuseIdentifier:collectionIdentifier];
        
        
    }
    return _collectionView;
}

-(GZPopShoppDetailView *)popShoppDetailView
{
    if (!_popShoppDetailView) {
        _popShoppDetailView = [[GZPopShoppDetailView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        
        GZWeakSelf;
        //分类ID
        _popShoppDetailView.classClickBlock = ^(NSString *classID) {
            _classID = classID;
        };
        
        //数量
        _popShoppDetailView.countClickBlock = ^(NSString *countNum) {
            _countNum = countNum;
        };
        
        //点击弹出界面购物车回调
        _popShoppDetailView.carBtnClickBlock = ^{
            
            weakSelf.tabBarController.tabBar.hidden = NO;
            [weakSelf dismiss];
            
            //发送通知，转换成购物车界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GZHomeDetailsVC" object:nil userInfo:nil];
        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_popShoppDetailView.alphaiView addGestureRecognizer:tap];
        [_popShoppDetailView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        //弹出界面确定按钮
        _popShoppDetailView.sureClickBlock = ^{
            
            if ([weakSelf.classID isEqualToString:@"0"]) {
                [MBProgressHUD showAlertMessage:@"请选择种类"];
            }else
            {
                [weakSelf getSureData];
            }
        };
    }
    return _popShoppDetailView;
}

- (NSMutableArray *)collectionDataSource
{
    if (!_collectionDataSource) {
        _collectionDataSource = [NSMutableArray array];
    }
    return _collectionDataSource;
}

-(NSMutableArray *)topMenuArr
{
    if (!_topMenuArr) {
        _topMenuArr = [NSMutableArray array];
    }
    return _topMenuArr;
}

-(NSMutableArray *)topMenuIDArr
{
    if (!_topMenuIDArr) {
        _topMenuIDArr = [NSMutableArray array];
    }
    return _topMenuIDArr;
}

- (NSArray *)refreshImgArr
{
    if (!_refreshImgArr) {
        _refreshImgArr = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    }
    return _refreshImgArr;
}

- (GZHomeDetailDataModel *)dataModelDataSource
{
    if (!_dataModelDataSource) {
        _dataModelDataSource = [[GZHomeDetailDataModel alloc] init];
    }
    return _dataModelDataSource;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 45, kScreenWidth, 9)];
        _lineLabel.backgroundColor = YHRGBA(237, 245, 245, 1.0);
        
        [self.view addSubview:_lineLabel];
    }
    return _lineLabel;
}

-(GGZButton *)totalBtn
{
    if (!_totalBtn) {
        _totalBtn = [GGZButton createGGZButton];
        _totalBtn.frame = CGRectMake(kScreenWidth/2 - 70, self.lineLabel.bottom + 10, 60, 20);
        [_totalBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_totalBtn setTitleColor:YHRGBA(228, 77, 56, 1.0) forState:UIControlStateNormal];

        _totalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _totalBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        GZWeakSelf;
        _totalBtn.block = ^(UIButton *btn){
            [weakSelf.totalBtn setTitleColor:YHRGBA(228, 77, 56, 1.0) forState:UIControlStateNormal];
            [weakSelf.priceBtn setTitleColor:YHRGBA(141, 141, 141, 1.0) forState:UIControlStateNormal];
           
            _ascStr = @"2";
            weakSelf.currentPage = 1;
            [weakSelf getData];

        };
    }
    return _totalBtn;
}

-(GGZButton *)priceBtn
{
    if (!_priceBtn) {
        _priceBtn = [GGZButton createGGZButton];
        _priceBtn.frame = CGRectMake(kScreenWidth/2 + 10, self.lineLabel.bottom + 10, 60, 20);
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTitleColor:YHRGBA(141, 141, 141, 1.0) forState:UIControlStateNormal];
        _priceBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _priceBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        GZWeakSelf;
        _priceBtn.block = ^(UIButton *btn){
            
            [weakSelf.totalBtn setTitleColor:YHRGBA(141, 141, 141, 1.0) forState:UIControlStateNormal];
            [weakSelf.priceBtn setTitleColor:YHRGBA(228, 77, 56, 1.0) forState:UIControlStateNormal];
           
            if (btn.selected) {
                
                _ascStr = @"0";
                [weakSelf.topBtn setImage:[UIImage imageNamed:@"shangjiantou_"] forState:UIControlStateNormal];
                [weakSelf.bottomBtn setImage:[UIImage imageNamed:@"xiajiantouSelect_"] forState:UIControlStateNormal];
            }else
            {
                
                _ascStr = @"1";
                [weakSelf.topBtn setImage:[UIImage imageNamed:@"shangjiantouselect_"] forState:UIControlStateNormal];
                [weakSelf.bottomBtn setImage:[UIImage imageNamed:@"xiajiantou_"] forState:UIControlStateNormal];
            }
            
            btn.selected = !btn.selected;
            
            weakSelf.currentPage = 1;
            [weakSelf getData];
            
        };
    }
    return _priceBtn;
}

-(GGZButton *)topBtn
{
    if (!_topBtn) {
        
        _topBtn = [GGZButton createGGZButton];
        _topBtn.frame = CGRectMake(self.priceBtn.right, self.priceBtn.top, 10, 10);
        [_topBtn setImage:[UIImage imageNamed:@"shangjiantou_"] forState:UIControlStateNormal];

        [self.view addSubview:_topBtn];

    }
    return _topBtn;
}

-(GGZButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [GGZButton createGGZButton];
        _bottomBtn.frame = CGRectMake(self.priceBtn.right, self.topBtn.bottom + 1, 10, 10);
        [_bottomBtn setImage:[UIImage imageNamed:@"xiajiantou_"] forState:UIControlStateNormal];

        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
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
        _NoDataView.frame = CGRectMake(0, self.lineLabel.bottom, kScreenWidth, kScreenHeight - self.lineLabel.bottom - 44);

        _NoDataView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_NoDataView];
    }
    return _NoDataView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.currentPage = 1;
    _countNum = @"1";
    _classID = @"0";
    _cnt = 0;
    _ascStr = @"2";
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"TabCartSelected@2x.png"];
    _imageView.center = CGPointMake(270, 320);
    [self.view addSubview:_imageView];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.popShoppDetailView];
    [self.view addSubview:self.priceBtn];
    [self.view addSubview:self.totalBtn];

    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [MBProgressHUD showMessage:@"加载中..."];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        [MBProgressHUD showMessage:@"英文..."];
        
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
   
        [MBProgressHUD showMessage:@"匈牙利文..."];
    }

    [self MJRefresh];
    [self setAddCarAnimationUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self CarNumberData];
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [self.totalBtn setTitle:@"全部" forState:UIControlStateNormal];
        [self.priceBtn setTitle:@"价格" forState:UIControlStateNormal];

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        [self.totalBtn setTitle:@"in total" forState:UIControlStateNormal];
        [self.priceBtn setTitle:@"price" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        [self.totalBtn setTitle:@"összes" forState:UIControlStateNormal];
        [self.priceBtn setTitle:@"árak" forState:UIControlStateNormal];
        
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!_isDidClickCell) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    _isDidClickCell = NO;
}

- (void)setAddCarAnimationUI
{
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.popShoppDetailView.addShoppCarBtn.right - 30, 7, 17, 17)];
    _cntLabel.textColor = [UIColor whiteColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:12];
    _cntLabel.backgroundColor = YHRGBA(232, 78, 68, 1.0);
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    
    [self.popShoppDetailView.addShoppCarBtn addSubview:_cntLabel];
    
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(self.popShoppDetailView.bt_sure.centerX, kScreenHeight - 50)];
    [_path addQuadCurveToPoint:CGPointMake(self.popShoppDetailView.addShoppCarBtn.centerX, kScreenHeight - 50) controlPoint:CGPointMake(kScreenWidth/3, kScreenHeight - 200)];
}

- (void)MJRefresh
{
    [self getData];
    
    GZWeakSelf;
    MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    
        weakSelf.currentPage = 1;
        
        [weakSelf getData];
    }];
    
    self.collectionView.mj_header = header;
    
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
    self.collectionView.mj_footer = footer;
    
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

#pragma mark - 获取界面数据
- (void)getData
{
    
    NSString *page = [NSString stringWithFormat:@"%zd",self.currentPage];

    if (self.key == nil) {
        self.key = @"";
    }
    
    NSDictionary *params = @{
                            @"language":[GGZTool iSLanguageID],
                            @"class_id":self.photoID,
                            @"asc":_ascStr,
                            @"ye":page,
                            @"key":self.key,
                            @"action":@"Product_list"
                            };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        self.NoDataView.hidden = YES;
        
        GZHomeDetailResultModel *resultModel = [[GZHomeDetailResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            [MBProgressHUD hideHUD];
            GZHomeDetailDataModel *dataModel = [[GZHomeDetailDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            if (self.currentPage == 1) {
                
                [self.collectionDataSource removeAllObjects];
            }

            self.dataModelDataSource = dataModel;
            
            //此处是当从搜索界面进来时，无顶部菜单,当从分类跳过来时，菜单数据一定有
            if ([self.photoID isEqualToString:@"-1"]) {
                
                self.totalBtn.frame = CGRectMake(kScreenWidth/2 - 70, 64 + 15, 60, 20);
                self.priceBtn.frame = CGRectMake(kScreenWidth/2 + 10, 64 + 15, 60, 20);
                self.collectionView.frame = CGRectMake(0, self.totalBtn.bottom, kScreenWidth, kScreenHeight - 64 -44);

                self.lineLabel.hidden = YES;
                
                if (dataModel.prolist != nil && ![dataModel.prolist isKindOfClass:[NSNull class]] && dataModel.prolist.count != 0) {
                    
                    [self.collectionDataSource addObjectsFromArray:dataModel.prolist];
                    
                    self.totalBtn.hidden = NO;
                    self.priceBtn.hidden = NO;
                    self.topBtn.hidden = NO;
                    self.bottomBtn.hidden = NO;
                    
                }else
                {
                    if (self.currentPage == 1) {
                        self.NoDataView.hidden = NO;
                        
                        self.priceBtn.hidden = YES;
                        self.topBtn.hidden = YES;
                        self.bottomBtn.hidden = YES;
                        self.totalBtn.hidden = YES;

                    }
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                
            }else{
                self.lineLabel.hidden = NO;
                //top数据源
                for (GZHomeDetailClassListModel *classListModel in dataModel.class_list) {
                    
                    [self.topMenuArr addObject:classListModel.class_name];
                    [self.topMenuIDArr addObject:classListModel.class_id];
                }
                [self.view addSubview:self.topScrollMenu];
             
                if (dataModel.prolist != nil && ![dataModel.prolist isKindOfClass:[NSNull class]] && dataModel.prolist.count != 0) {
                    
                    [self.collectionDataSource addObjectsFromArray:dataModel.prolist];
                    
                    self.totalBtn.hidden = NO;
                    self.priceBtn.hidden = NO;
                    self.topBtn.hidden = NO;
                    self.bottomBtn.hidden = NO;
                    self.topScrollMenu.hidden =NO;
                    
                }else
                {
                    if (self.currentPage == 1) {
                        self.NoDataView.hidden = NO;
                        
                        self.priceBtn.hidden = YES;
                        self.topBtn.hidden = YES;
                        self.bottomBtn.hidden = YES;
                        self.totalBtn.hidden = YES;
                    }
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        }else
        {
            [MBProgressHUD hideHUD];
            
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.currentPage--;
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];

        self.noNetVC.hidden = NO;
        self.homeTopView.hidden = NO;
        self.totalBtn.hidden = YES;
        self.priceBtn.hidden = YES;
        self.topBtn.hidden = YES;
        self.bottomBtn.hidden = YES;
        self.NoDataView.hidden = YES;
        
        if ([self.photoID isEqualToString:@"-1"]) {
           
        }else{
             self.topScrollMenu.hidden = YES;
        }
        
        GZWeakSelf;
        self.noNetVC.netWorkAgainBlock = ^{
            
            weakSelf.currentPage = 1;
            
            [weakSelf getData];
        };
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];                                                                                        self.currentPage--;
    }];
}

#pragma mark - 添加购物车数据
- (void)getSureData
{
   
    if ([GGZTool iSSureLogin]) {
        NSDictionary *parmas = @{
                                 @"language":[GGZTool iSLanguageID],
                                 @"uid":[GGZTool isUid],
                                 @"diyid":_classID,
                                 @"count":_countNum,
                                 @"pid":_pid,
                                 @"action":@"Add_car"
                                 };
        
        [GZHttpTool post:URL params:parmas success:^(NSDictionary *obj) {
            
            if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                
                //添加购物车成功，通知TabbarController，调用数据更改角标
                [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
                
                if ([_classID isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showAlertMessage:@"添加成功，快去购物车看看吧~"];
                }else
                {
                    if (!layer) {
                        self.popShoppDetailView.bt_sure.enabled = NO;
                        
                        layer = [CALayer layer];
                        layer.contents = (__bridge id)[UIImage imageNamed:@"test01"].CGImage;
                        layer.contentsGravity = kCAGravityResizeAspectFill;
                        layer.bounds = CGRectMake(0, 0, 30, 30);
                        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
                        layer.masksToBounds = YES;
                        layer.position =CGPointMake(50, 150);
                        [self.view.layer addSublayer:layer];
                    }
                    [self groupAnimation];
                }
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showAlertMessage:@"添加失败~"];
        }];
    }else
    {
        GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 1.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

#pragma mark - 购物车数量接口
- (void)CarNumberData
{
    NSString *uidStr;
    if ([GGZTool isUid] != nil) {
        uidStr = [GGZTool isUid];
    }else
    {
        uidStr = @"0";
    }
    
    NSDictionary *params = @{
                             @"uid":uidStr,
                             @"action":@"User_CarList_count"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            NSInteger carnumber = [[[obj valueForKey:@"data"] valueForKey:@"count"] integerValue];
            
            _cnt = carnumber;
            
            if (_cnt > 0) {
                
                _cntLabel.hidden = NO;
                _cntLabel.text = [NSString stringWithFormat:@"%zd",_cnt];

                [self.popShoppDetailView.addShoppCarBtn addSubview:_cntLabel];
            }else
            {
                _cntLabel.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showAlertMessage:@"网络错误"];
    }];
}

#pragma mark - CAAnimationDelegate -
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [layer animationForKey:@"group"]) {
        self.popShoppDetailView.bt_sure.enabled = YES;

        [layer removeFromSuperlayer];
        layer = nil;
        
        _cnt = _cnt + [_countNum integerValue];
        
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        _cntLabel.text = [NSString stringWithFormat:@"%zd",_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [self.popShoppDetailView.addShoppCarBtn.layer addAnimation:shakeAnimation forKey:nil];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}

#pragma mark - GZTopScrollMenu代理方法
- (void)GZTopScrollMenu:(GZTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    [MBProgressHUD showMessage:@"加载中..."];
    //找到点击的label，用label上的text来找到classID，最后请求数据
    UILabel *label = (UILabel *)topScrollMenu.subviews[index];
    
    for (GZHomeDetailClassListModel *classListModel in self.dataModelDataSource.class_list) {
        
        if ([label.text isEqualToString:classListModel.class_name]) {
           
            self.photoID = classListModel.class_id;
        
            self.currentPage = 1;
            [self getData];
            
            break;
        }
    }
}

#pragma mark - 重写父类的messageClick方法
- (void)messageClick:(UIButton *)btn
{
    _isDidClickCell = YES;
    
    if ([GGZTool iSSureLogin]) {
        GZMessageViewController *messageVC = [[GZMessageViewController alloc] init];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.backBarButtonItem = backItem;
        
        self.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else
    {
        GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 重写父类的方法 UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    textField.enabled = NO;
    
    _isDidClickCell = YES;
    GZSearchViewController *searchVC = [[GZSearchViewController alloc] init];
    
    NSDictionary *parmas = @{
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"Hotserch"
                             };
    
    [GZHttpTool post:URL params:parmas success:^(NSDictionary *obj) {
        
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            
            if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                
                searchVC.tagsArray = [[obj valueForKey:@"data"] valueForKey:@"s_name"];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:searchVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                textField.enabled = NO;
                
            }
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}

#pragma - collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    
    return self.collectionDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    GZHomeDetailCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    
    cell.prolistModel = self.collectionDataSource[indexPath.row];
    
    //点击cell上面购物车
    GZWeakSelf;
    cell.addGoShoppingBlock = ^{
        
        GZHomeDetailProlistModel *prolistModel= self.collectionDataSource[indexPath.row];
        
        _pid = prolistModel.p_id;
        
        if ([GGZTool iSSureLogin]) {
            if (prolistModel.diylist != nil && ![prolistModel.diylist isKindOfClass:[NSNull class]] && prolistModel.diylist.count != 0) {
                
                self.tabBarController.tabBar.hidden = YES;
                self.popShoppDetailView.dataModel = self.collectionDataSource[indexPath.row];
                
                [UIView animateWithDuration:0.35 animations:^{
                    weakSelf.popShoppDetailView.center =weakSelf.view.center;
                    weakSelf.popShoppDetailView.frame =CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                } completion:nil];
            }else           //如果分类数据为空，则不不弹出视图，直接加入购物车
            {
                
                [self getSureData];
            }
        }else{
            GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    };
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isDidClickCell = YES;
    
    GZOrderDetailViewController *orderDetailVC = [[GZOrderDetailViewController alloc] init];
    orderDetailVC.pid = [self.collectionDataSource[indexPath.row] valueForKey:@"p_id"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - UICollectionViewFlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake((self.collectionView.width - 40) / 2,
                      (self.collectionView.width - 40) / 2 +120);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
}

/**
 *  弹出框消失
 */
-(void)dismiss
{
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration: 0.35 animations: ^{
        
        self.popShoppDetailView.buyCountView.lb_count.text = @"1";
        _countNum = @"1";

        _classID = @"0";
        
        self.popShoppDetailView.selectBtn.backgroundColor = [UIColor whiteColor];

        self.popShoppDetailView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
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
