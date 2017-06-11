//
//  GZSearchViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/22.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSearchViewController.h"
#import "GZHomeDetailsViewController.h"
#import <objc/runtime.h>


#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MLSearchhistories.plist"] // 搜索历史存储路径

@interface GZSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

/* 搜索栏 */
@property (nonatomic, strong) UISearchBar *searchBar;

/** 搜索栏View */
@property (nonatomic, strong) UIView *titleView;

/** tableVie的头视图 */
@property (nonatomic, strong) UIView *headerView;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

/** 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH(PYSearchConst.h文件中的宏定义) */
@property (nonatomic, copy) NSString *searchHistoriesCachePath;

/**
 tableView的footerView，清空搜索
 */
@property (nonatomic, strong) UILabel *footerLabel;

@property (nonatomic, strong) UILabel *titleLabel;

/** 热门搜索的内容View */
@property (nonatomic, strong) UIView *tagsView;

@property (nonatomic, strong) UITableView *tableView;

/** 搜索历史记录缓存数量，默认为20 */
@property (nonatomic) NSUInteger searchHistoriesCount;

@end

static NSString *Identifier = @"cellID";
@implementation GZSearchViewController

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(-10, 7, kScreenWidth - 60, 30)];
    }
    return _titleView;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.titleView.frame.size.width - 60, 30)];
        _searchBar.placeholder = @"请输入商品名称";
    
        _searchBar.delegate = self;

        // 设置搜索框背景颜色
    
        
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        [_searchBar.layer setBorderWidth:1];
        [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];

    }
    return _searchBar;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;

        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.x = 0;
        _headerView.y = 0;
        _headerView.width = kScreenWidth;
    }
    return _headerView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _titleLabel.text = @"   大家都在搜";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = YHRGBA(237, 245, 245, 1.0);

    }
    return _titleLabel;
}

-(UIView *)tagsView
{
    if (!_tagsView) {
        _tagsView = [[UIView alloc] init];
        _tagsView.x = 10;
        _tagsView.y = self.titleLabel.bottom + 30;
        _tagsView.width = kScreenWidth - 20;
        
    }
    return _tagsView;
}

-(UILabel *)footerLabel
{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 124,5, 104, 30)];
        _footerLabel.backgroundColor = YHRGBA(145, 175, 194, 1.0);
        _footerLabel.layer.masksToBounds = YES;
        _footerLabel.layer.cornerRadius = 15;
        
        _footerLabel.textColor = [UIColor whiteColor];
        _footerLabel.font = [UIFont systemFontOfSize:13];
        _footerLabel.userInteractionEnabled = YES;
        _footerLabel.text = @"清空全部记录";
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        
        [_footerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
      
    }
    return _footerLabel;
}

- (NSMutableArray *)searchHistories
{
    
    if (!_searchHistories) {
        self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
        
    }
    return _searchHistories;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    // 刷新
    self.searchHistories = nil;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.searchHistoriesCount = 20;
    
    [self.titleView addSubview:self.searchBar];
    
    UITextField *field =  [self.searchBar valueForKey:@"searchField"];
    field.backgroundColor = YHRGBA(237, 245, 245, 1.0);

    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.tagsView];

    self.navigationItem.titleView = self.titleView;
    self.tableView.tableHeaderView = self.headerView;
    
    [self tagsViewWithTag];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    NSString *sureStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        self.searchBar.placeholder= @"请输入商品名称";
        self.titleLabel.text = @"   大家都在搜";
        sureStr = @"确定";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.searchBar.placeholder= @"please enter product name";
        self.titleLabel.text = @"   top search results";
        sureStr = @"confirm";

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.searchBar.placeholder= @"adja meg a termék nevét";
        self.titleLabel.text = @"   kedvenc keresések";
        sureStr = @"igen";

    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:sureStr style:UIBarButtonItemStyleDone target:self action:@selector(sureDidClick)];
    
    self.navigationItem.rightBarButtonItem.tintColor = YHRGBA(124, 124, 124, 1.0);
}

/** 视图完全显示 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 弹出键盘
    [self.searchBar becomeFirstResponder];
    
}

/** 视图即将消失 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 回收键盘
    [self.searchBar resignFirstResponder];
}

- (void)tagsViewWithTag
{
    CGFloat allLabelWidth = 0;
    CGFloat allLabelHeight = 0;
    int rowHeight = 0;
    
    for (int i = 0; i < self.tagsArray.count; i++) {
        if (i != self.tagsArray.count-1) {
            
            CGFloat width = [self getWidthWithTitle:self.tagsArray[i+1] font:[UIFont systemFontOfSize:14]];
            if (allLabelWidth + width+10 > self.tagsView.frame.size.width) {
                rowHeight++;
                allLabelWidth = 0;
                allLabelHeight = rowHeight*40;
            }
        }
        else
        {
            
            CGFloat width = [self getWidthWithTitle:self.tagsArray[self.tagsArray.count-1] font:[UIFont systemFontOfSize:14]];
            if (allLabelWidth + width+10 > self.tagsView.frame.size.width) {
                rowHeight++;
                allLabelWidth = 0;
                allLabelHeight = rowHeight*40;
            }
        }
        
        UILabel *rectangleTagLabel = [[UILabel alloc] init];
        // 设置属性
        rectangleTagLabel.userInteractionEnabled = YES;
        rectangleTagLabel.font = [UIFont systemFontOfSize:15];
        rectangleTagLabel.textColor = YHRGBA(169, 169, 169, 1.0);
        rectangleTagLabel.backgroundColor = [UIColor whiteColor];
        rectangleTagLabel.text = self.tagsArray[i];
        rectangleTagLabel.textAlignment = NSTextAlignmentCenter;
        [rectangleTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        
        CGFloat labelWidth = [self getWidthWithTitle:self.tagsArray[i] font:[UIFont systemFontOfSize:14]];
        
        rectangleTagLabel.layer.cornerRadius = 5;
        rectangleTagLabel.layer.borderWidth = 1;
        rectangleTagLabel.layer.borderColor = YHRGBA(239, 239, 239, 1.0).CGColor;
        
        [rectangleTagLabel.layer setMasksToBounds:YES];
        
        rectangleTagLabel.frame = CGRectMake(allLabelWidth, allLabelHeight, labelWidth, 25);
        [self.tagsView addSubview:rectangleTagLabel];
        
        allLabelWidth = allLabelWidth+10+labelWidth;
    }
    
    self.tagsView.mj_h = rowHeight*40+40;
    self.headerView.mj_h = self.tagsView.mj_y+self.tagsView.mj_h+10;
}

/** 选中标签 */
- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    self.searchBar.text = label.text;
    
    // 缓存数据并且刷新界面
    [self saveSearchCacheAndRefreshView];
    

    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"searchBarDidChange" object:nil userInfo:@{@"searchText":label.text}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [self sureDidClick];
}

/** 进入搜索状态调用此方法 */
- (void)saveSearchCacheAndRefreshView
{
    if (![self.searchBar.text isEqualToString:@""]) {

        UISearchBar *searchBar = self.searchBar;
        // 回收键盘
        [searchBar resignFirstResponder];
        // 先移除再刷新
        [self.searchHistories removeObject:searchBar.text];
        [self.searchHistories insertObject:searchBar.text atIndex:0];
        
        // 移除多余的缓存
        if (self.searchHistories.count > self.searchHistoriesCount) {
            // 移除最后一条缓存
            [self.searchHistories removeLastObject];
        }
        // 保存搜索信息
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        
        [self.tableView reloadData];
    }
    
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width+10;
}

- (void)sureDidClick
{
    if (self.searchBar.text.length > 0) {
        
        //取消第一响应
        [self.searchBar resignFirstResponder];
        
        GZHomeDetailsViewController *homeDetailsVC = [[GZHomeDetailsViewController alloc] init];
        
        homeDetailsVC.photoID = @"-1";
        homeDetailsVC.key = self.searchBar.text;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [self.navigationController pushViewController:homeDetailsVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动时，回收键盘
    [self.searchBar resignFirstResponder];
}

- (void)closeDidClick:(UIButton *)sender
{
    // 获取当前cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    // 移除搜索信息
    [self.searchHistories removeObject:cell.textLabel.text];
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
    
    // 刷新
    [self.tableView reloadData];
}

/** 点击清空历史按钮 */
- (void)emptySearchHistoryDidClick
{
    

    // 移除所有历史搜索
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    
    [self.tableView reloadData];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 缓存数据并且刷新界面
    [self saveSearchCacheAndRefreshView];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"searchBarDidChange" object:nil userInfo:@{@"searchText":searchBar.text}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return self.searchHistories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    // 添加关闭按钮
    UIButton *closetButton = [[UIButton alloc] init];
    // 设置图片容器大小、图片原图居中
    closetButton.mj_size = CGSizeMake(cell.mj_h, cell.mj_h);
    [closetButton setTitle:@"x" forState:UIControlStateNormal];
    [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = closetButton;
    [closetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.searchHistories[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (self.searchHistories.count != 0) {
        
        NSString *headerStr;
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
            
            headerStr = @"搜索历史";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            headerStr = @"search history";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            headerStr = @"előzmények";
            
        }
        return headerStr;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    view.backgroundColor = YHRGBA(237, 245, 245, 1.0);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
    
    NSString *headerStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        headerStr = @"搜索历史";
        self.footerLabel.text = @"清空全部记录";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        headerStr = @"search history";
        self.footerLabel.text = @"clear all records";

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        headerStr = @"előzmények";
        self.footerLabel.text = @"előzmények törlése";

    }
    
    titleLabel.text = [NSString stringWithFormat:@"   %@",headerStr];
    
    titleLabel.font = [UIFont systemFontOfSize:14];

    [view addSubview:titleLabel];
    [view addSubview:self.footerLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出选中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = cell.textLabel.text;
    
    // 缓存数据并且刷新界面
    [self saveSearchCacheAndRefreshView];
    
    [self searchBarSearchButtonClicked:self.searchBar];
    
    self.tableView.hidden = YES;

    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"searchBarDidChange" object:nil userInfo:@{@"searchText":cell.textLabel.text}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [self sureDidClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
