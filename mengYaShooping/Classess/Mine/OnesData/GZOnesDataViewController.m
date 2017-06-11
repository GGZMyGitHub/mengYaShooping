//
//  GZOnesDataViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZOnesDataViewController.h"
#import "GZNiChengViewController.h"
#import "GZXiuGaiMiMaViewController.h"
#import "ImagePicker.h"
#import "GZNumberTieViewController.h"


@interface GZOnesDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIImageView *headerImageV;

@property (nonatomic, strong) GGZButton *rightBarBtn;

@property (nonatomic, strong) GGZButton *headerBtn;
@property (nonatomic, strong) GGZButton *photoBtn;
@property (nonatomic, strong) UILabel *niChengLabel;
@property (nonatomic, strong) UILabel *qianMingLabel;



/**
 调用系统相册
 */
@property (nonatomic, strong) ImagePicker *imagePicker;

@property (nonatomic, copy) NSString *miMaStr;

@end

static NSString *Identifier = @"cellID";
@implementation GZOnesDataViewController

-(NSArray *)dataSource
{
    NSString *niChengStr;
    NSString *qianMingStr;
    NSString *zhangHaoBangDingStr;
    NSString *xiuGaiMiMaStr;

    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {

        niChengStr = @"昵称";
        qianMingStr = @"签名";
        zhangHaoBangDingStr = @"账号绑定";
        xiuGaiMiMaStr = @"修改密码";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        niChengStr = @"nickname";
        qianMingStr = @"signature";
        zhangHaoBangDingStr = @"account binding";
        xiuGaiMiMaStr = @"change password";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        niChengStr = @"neve";
        qianMingStr = @"aláírás";
        zhangHaoBangDingStr = @"账号绑定匈牙利文";
        xiuGaiMiMaStr = @"jelszavak módosítás";
    }

    
    NSMutableDictionary *niCheng = [NSMutableDictionary dictionary];
    niCheng[@"title"] = niChengStr;
    niCheng[@"controller"] = [GZNiChengViewController class];

    NSMutableDictionary *qianMing = [NSMutableDictionary dictionary];
    qianMing[@"title"] = qianMingStr;
    qianMing[@"controller"] = [GZNiChengViewController class];
    
    NSMutableDictionary *zhangHaoBangDing = [NSMutableDictionary dictionary];
    zhangHaoBangDing[@"title"] = zhangHaoBangDingStr;
    zhangHaoBangDing[@"controller"] = [GZNumberTieViewController class];
    
    NSMutableDictionary *xiuGaiMiMa = [NSMutableDictionary dictionary];
    xiuGaiMiMa[@"title"] = xiuGaiMiMaStr;
    xiuGaiMiMa[@"controller"] = [GZXiuGaiMiMaViewController class];
    
    
    NSArray *section = @[niCheng,qianMing,zhangHaoBangDing,xiuGaiMiMa];
    
    _dataSource = [NSArray arrayWithObjects:section, nil];
    
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 465) style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIImageView *)headerImageV
{
    if (!_headerImageV) {
        _headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 225)];
        
        if ([self.fengMianStr isEqualToString:@"/upload/"]) {
            
            //图片模糊化
            UIImage *image = [GGZTool boxblurImage:[UIImage imageNamed:@"bj_"] withBlurNumber:20];
            
            _headerImageV.image = image;

        }else
        {
            [_headerImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,self.fengMianStr]]];
            
        //    UIImage *image = [GGZTool boxblurImage:_headerImageV.image withBlurNumber:20];
        }

        _headerImageV.userInteractionEnabled = YES;
    }
    return _headerImageV;
}

-(GGZButton *)headerBtn
{
    if (!_headerBtn) {
        _headerBtn = [GGZButton createGGZButton];
        _headerBtn.frame = CGRectMake((kScreenWidth - 82)/2, 50, 82, 82);
        _headerBtn.layer.masksToBounds = YES;
        _headerBtn.layer.cornerRadius = 82/2;
        
        if ([self.headerStr isEqualToString:@"/upload/"]) {
            
            [_headerBtn setImage:[UIImage imageNamed:@"MineTouxiang_"] forState:UIControlStateNormal];
        }else
        {
            [_headerBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,self.headerStr]] forState:UIControlStateNormal];
        }
        
        GZWeakSelf;
        _headerBtn.block = ^(GGZButton *btn) {
            
            //调用相册
            [weakSelf.imagePicker dwSetPresentDelegateVC:weakSelf SheetShowInView:weakSelf.view InfoDictionaryKeys:(long)nil];
            //回调
            [weakSelf.imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {
                
                
            } pickerImagePic:^(UIImage *pickerImagePic) {
                
                if (![UIImagePNGRepresentation(weakSelf.headerImageV.image) isEqual:UIImagePNGRepresentation(pickerImagePic)]) {
                    
                    NSData *imageData =UIImageJPEGRepresentation(pickerImagePic,0.4);
                    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:0];
                    
                    NSDictionary *params = @{
                         @"uid":[GGZTool isUid],
                         @"language":[GGZTool iSLanguageID],
                         @"head":imageBase64String,
                         @"action":@"User_Edit_info"
                         };
                    
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                       
                        [weakSelf.headerBtn setImage:pickerImagePic forState:UIControlStateNormal];

                    } failure:^(NSError *error) {
                        
                        [MBProgressHUD showAlertMessage:@"网络错误"];
                    }];
                }
            }];
        };
        [self.headerImageV addSubview:_headerBtn];
    }
    return _headerBtn;
}

-(UILabel *)niChengLabel
{
    if (!_niChengLabel) {
        _niChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        _niChengLabel.center = CGPointMake(kScreenWidth / 2, self.headerBtn.bottom + 20);
        
        _niChengLabel.textColor = [UIColor blackColor];
        _niChengLabel.textAlignment = NSTextAlignmentCenter;
        _niChengLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return _niChengLabel;
}

-(UILabel *)qianMingLabel
{
    if (!_qianMingLabel) {
        _qianMingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        _qianMingLabel.center = CGPointMake(kScreenWidth / 2, self.niChengLabel.bottom + 10);
        
        _qianMingLabel.textColor = [UIColor blackColor];
        _qianMingLabel.textAlignment = NSTextAlignmentCenter;
        _qianMingLabel.font = [UIFont systemFontOfSize:12];
    }
    return _qianMingLabel;
}

-(GGZButton *)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [GGZButton createGGZButton];
        _photoBtn.frame = CGRectMake(self.headerBtn.right - 22, self.headerBtn.bottom - 22, 20, 20);
        
        [_photoBtn setImage:[[UIImage imageNamed:@"xiangji_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        _photoBtn.userInteractionEnabled = NO;
    }
    return _photoBtn;
}

-(GGZButton *)rightBarBtn
{
    if (!_rightBarBtn) {
        _rightBarBtn = [GGZButton createGGZButton];
        _rightBarBtn.frame = CGRectMake(kScreenWidth - 94, 15, 82, 20);
        [_rightBarBtn setTitle:@"更换封面" forState:UIControlStateNormal];
        
        [_rightBarBtn setImage:[[UIImage imageNamed:@"xiangji_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        _rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBarBtn.titleColor = [UIColor blackColor];
        
        GZWeakSelf;
        _rightBarBtn.block = ^(GGZButton *btn) {
            //调用相册
            [weakSelf.imagePicker dwSetPresentDelegateVC:weakSelf SheetShowInView:weakSelf.view InfoDictionaryKeys:(long)nil];
            //回调
            [weakSelf.imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {

            } pickerImagePic:^(UIImage *pickerImagePic) {
                if (![UIImagePNGRepresentation(weakSelf.headerImageV.image) isEqual:UIImagePNGRepresentation(pickerImagePic)]) {

                    NSData *imageData =UIImageJPEGRepresentation(pickerImagePic,0.4);
                    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:0];
                    NSDictionary *params = @{
                                             @"uid":[GGZTool isUid],
                                             @"language":[GGZTool iSLanguageID],
                                             @"Fengmian":imageBase64String,
                                             @"action":@"User_Edit_info"
                                             };
                    
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                        
                        UIImage *image = [GGZTool boxblurImage:pickerImagePic withBlurNumber:20];
                        
                        weakSelf.headerImageV.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        [MBProgressHUD showAlertMessage:@"网络错误"];
                    }];
                }
            }];
            
        };
        [self.headerImageV addSubview:_rightBarBtn];
    }
    return _rightBarBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = YHRGBA(243, 243, 243, 1.0);
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.navigationItem.title = @"个人资料";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.navigationItem.title = @"personal information";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.navigationItem.title = @"személyes adatok";
    }

    //初始化相册
    _imagePicker = [ImagePicker sharedManager];
    
    [self headerBtn];
    [self rightBarBtn];
    
    [self.headerImageV addSubview:self.photoBtn];
    [self.headerImageV addSubview:self.niChengLabel];
    [self.headerImageV addSubview:self.qianMingLabel];

    self.tableView.tableHeaderView = self.headerImageV;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setNavigationBarColor:[UIColor whiteColor] alpha:0];
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableDelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dict = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.detailTextLabel.text = self.niChengStr;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = YHRGBA(148, 148, 148, 1.0);
    }
    
    if (indexPath.section ==0 && indexPath.row == 1) {
        cell.detailTextLabel.text = self.qianMingStr;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = YHRGBA(148, 148, 148, 1.0);
   
    }
    
    self.niChengLabel.text = self.niChengStr;
    self.qianMingLabel.text = self.qianMingStr;
    
    cell.textLabel.text = dict[@"title"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        GZNiChengViewController *niChengVC = [[GZNiChengViewController alloc] init];
        niChengVC.title = @"修改昵称";
        niChengVC.popBlock = ^(NSString *str) {
            self.niChengStr = str;
        };
        
        [self pushViewController:niChengVC];
    }else if (indexPath.row == 1){
        GZNiChengViewController *niChengVC = [[GZNiChengViewController alloc] init];
        niChengVC.title = @"修改签名";
        niChengVC.popBlock = ^(NSString *str) {
            self.qianMingStr = str;
        };
        
        [self pushViewController:niChengVC];
        
    }else if (indexPath.row == 2) {
        GZNumberTieViewController *zhangHaoBangDingVC = [[GZNumberTieViewController alloc] init];
        zhangHaoBangDingVC.title = @"账号绑定";
        [self pushViewController:zhangHaoBangDingVC];
        
    }else if (indexPath.row == 3) {
       
        GZXiuGaiMiMaViewController *xiuGaiMiMaVC = [[GZXiuGaiMiMaViewController alloc] init];
        
        xiuGaiMiMaVC.changeMiMaClickBlock = ^(NSString *miMaStr) {
            _miMaStr = miMaStr;
        };
        
        xiuGaiMiMaVC.title = @"修改密码";
        [self pushViewController:xiuGaiMiMaVC];
    }
}

- (void)pushViewController:(UIViewController *)viewController
{
    UIBarButtonItem *bactItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = bactItem;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

    self.navigationController.navigationBar.hidden = NO;
}

@end
