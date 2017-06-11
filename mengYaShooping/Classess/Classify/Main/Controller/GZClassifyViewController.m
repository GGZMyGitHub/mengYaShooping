//
//  GZClassifyViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZClassifyViewController.h"
#import "GZHomeDetailsViewController.h"
#import "GZCollectionViewFlowLayout.h"
#import "CollectionViewHeaderView.h"
#import "GZCollectionViewCell.h"
#import "GZLeftTableViewCell.h"
#import "GZResultModel.h"
#import "GZDataModel.h"
#import "GZFirstModel.h"
#import "GZSecondModel.h"


@interface GZClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/** 一级分类 */
@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UILabel *lineLabel;

/** 二级分类 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 一级数据源 */
@property (nonatomic, strong) NSMutableArray *tableDataOneSource;

/** 二级数据源 */
@property (nonatomic, strong) NSMutableArray *collectionOneDataSource;

/** 三级数据源 */
@property (nonatomic, strong) NSMutableArray *collectionTwoDataSource;

@property (nonatomic, strong) UIImageView *headerImg;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;
@property (nonatomic, strong) UIView *Loadview;


@end

static NSString *leftTableViewIdentifier = @"tableCellID";
static NSString *collectionIdentifier = @"collectionCellID";
static NSString *collectionHeaderIdentifier = @"CollectionViewHeaderView";
@implementation GZClassifyViewController
{
    /**
     判断是否是第一次进入ViewDidLoad，其作用是如果是第一次进入控制器，
     不让它走viewWillAppear里面的方法，往后才走viewWillAppear的方法
     */
    BOOL _iSenterViewDiDLoad;
}

#pragma mark - Getter
-(UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, kScreenHeight - 49)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.rowHeight = 55;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        
        [_leftTableView registerClass:[GZLeftTableViewCell class] forCellReuseIdentifier:leftTableViewIdentifier];
    }
    return _leftTableView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        GZCollectionViewFlowLayout *flowLayout = [[GZCollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.minimumLineSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15 +80, 102, kScreenWidth - 80 - 30, kScreenHeight - 64 - 49 - 102) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerClass:[GZCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:collectionHeaderIdentifier];
    }
    return _collectionView;
}

-(NSMutableArray *)tableDataOneSource
{
    if (!_tableDataOneSource) {
        _tableDataOneSource = [NSMutableArray array];
    }
    return _tableDataOneSource;
}

-(NSMutableArray *)collectionOneDataSource
{
    if (!_collectionOneDataSource) {
        _collectionOneDataSource = [NSMutableArray array];
    }
    return _collectionOneDataSource;
}

-(NSMutableArray *)collectionTwoDataSource
{
    if (!_collectionTwoDataSource) {
        _collectionTwoDataSource = [NSMutableArray array];
    }
    return _collectionTwoDataSource;
}

-(UIImageView *)headerImg
{
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(15 +80, 10, kScreenWidth - 80 - 30, 92)];
    }
    return _headerImg;
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

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftTableView.right, 0, 1, kScreenHeight)];
        _lineLabel.backgroundColor = YHRGBA(214, 214, 214, 1.0);
    }
    return _lineLabel;
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
    
    _iSenterViewDiDLoad = YES;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerImg];
    [self.view addSubview:self.lineLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        homeStr = @"home";
        classifyStr = @"classify";
        goShoppingStr = @"cart";
        mineStr = @" mine";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
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
    [self.Loadview appendActivityView:[UIColor blackColor]];
    
    if (_iSenterViewDiDLoad == NO) {
        //默认选中第几行
        NSIndexPath * selIndex = [NSIndexPath indexPathForRow:self.index inSection:0];
        
        [self.leftTableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [self tableView:self.leftTableView didSelectRowAtIndexPath:selIndex];
    }
}

- (void)getData
{
    NSDictionary *params = @{
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"Class_list2",
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        
        _iSenterViewDiDLoad = NO;

        [self handleData:obj];

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

- (void)handleData:(NSDictionary *)obj
{
    [self.tableDataOneSource removeAllObjects];
    
    GZResultModel *resultModel = [[GZResultModel alloc] initWithDictionary:obj error:nil];
    
    if ([resultModel.msgcode isEqualToString:@"1"]) {
        
        self.Loadview.hidden = YES;
        [self.Loadview removeActivityView];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",YUMING,[[resultModel.data valueForKey:@"ad"] valueForKey:@"Ad_logo"]];
        
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone) {
                self.headerImg.alpha = 0;
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                    self.headerImg.alpha = 1.0;
                }];
            }
            else
            {
                self.headerImg.alpha = 1.0;
            }
        }];
        
        GZDataModel *dataModel = [[GZDataModel alloc] initWithDictionary:resultModel.data error:nil];
        //一级
        [self.tableDataOneSource addObjectsFromArray:dataModel.one_dic_list];
        
    }
    
    [self.leftTableView reloadData];
    [self.collectionView reloadData];
    
    //默认选中第一行
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:self.index inSection:0];
    
    [self.leftTableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.leftTableView didSelectRowAtIndexPath:selIndex];
}

#pragma mark - UITableView DataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataOneSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftTableViewIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.firstModel = self.tableDataOneSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;

    [self.collectionOneDataSource removeAllObjects];
    [self.collectionTwoDataSource removeAllObjects];
    
    GZFirstModel *firstModel = self.tableDataOneSource[indexPath.row];
    [self.collectionOneDataSource addObjectsFromArray:firstModel.two_dic_list];
    
    for (GZSecondModel *secondModel in firstModel.two_dic_list) {
        [self.collectionTwoDataSource addObject:secondModel.three_dic_list];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionOneDataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [self.collectionOneDataSource valueForKey:@"three_dic_list"];
    return [arr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    
    cell.secondModel = self.collectionTwoDataSource[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZSecondModel *secondModel = self.collectionTwoDataSource[indexPath.section][indexPath.row];
    
    GZHomeDetailsViewController *detailsVC = [[GZHomeDetailsViewController alloc] init];
    
    detailsVC.photoID = secondModel.one_id;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [self.navigationController pushViewController:detailsVC animated:YES];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:collectionHeaderIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {

        GZSecondModel *secondModel = self.collectionOneDataSource[indexPath.section];
        view.title.text = secondModel.one_name;
       
    }
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collectionView.width - 4) / 3,
                      (self.collectionView.width - 4) / 3 + 40);
}

//返回header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
