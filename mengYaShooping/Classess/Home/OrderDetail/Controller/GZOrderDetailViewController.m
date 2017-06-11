//
//  GZOrderDetailViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/6.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZOrderDetailViewController.h"
#import "GZPopShoppDetailView.h"
#import "GZOrderDetailHeader.h"
#import "GZHomeDetailsViewController.h"
#import "GZLoginViewController.h"

#import "GZHomeDetailResultModel.h"
#import "GZOrderDetailDataModel.h"
#import "GZDetailResultModel.h"

@interface GZOrderDetailViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) GZPopShoppDetailView *popShoppDetailView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) GGZButton *addShoppCarBtn;
@property (nonatomic, strong) GGZButton *addShoppBtn;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) GZOrderDetailHeader *headerView;

/** 轮播图数据源 */
@property (nonatomic, strong) NSMutableArray *cycleDataSource;

@property (nonatomic, strong) GZOrderDetailDataModel *dataModel;

@property (nonatomic, strong) UIImageView *clickedImagView;

@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *countNum;


/** 添加动画路径 */
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) UILabel *cntLabel;

@property (nonatomic) NSInteger addCarNumber;

@property (nonatomic, copy) NSString *cidStr;

//无网络时图片
@property (nonatomic, strong) GZNoNetWorking *noNetVC;
@property (nonatomic, strong) UIView *homeTopView;

@end

@implementation GZOrderDetailViewController
{
    CALayer     *layer;
    NSInteger    _cnt;         //购物车数据
    UIImageView *_imageView;
}

#pragma mark - Getter
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49)];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(UIImageView *)clickedImagView
{
    if (!_clickedImagView) {
        _clickedImagView = [[UIImageView alloc] init];
    }
    return _clickedImagView;
}

#pragma mark - 头视图（轮播）-
- (GZOrderDetailHeader *)headerView
{
    if (!_headerView) {
        _headerView = [GZOrderDetailHeader createCycleView];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

        //点击轮播图的回调
        GZWeakSelf;
        _headerView.addShoppSelectCycleScrollBlock = ^(NSString * imgStr) {
            [weakSelf.clickedImagView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
            //浏览大图
            [GZScanImage scanBigImageWithImageView:weakSelf.clickedImagView];
        };
        
        //class无数据时，数量的改变
        _headerView.NoClassDataChangeCountNumberBlock = ^(NSString *countNumber) {
            _countNum = countNumber;
        };
        
        //点击收藏按钮的回调
        _headerView.collectBtnClickBlock = ^(BOOL isSelect,UIButton *btn){
       
            if ([GGZTool iSSureLogin]) {
                if (isSelect) {
                    //取消收藏
                    NSDictionary *params = @{
                                             @"language":[GGZTool iSLanguageID],
                                             @"cid": weakSelf.cidStr,
                                             @"action":@"Del_Collection"
                                             };
                    
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                        GZDetailResultModel *resultModel = [[GZDetailResultModel alloc] initWithDictionary:obj error:nil];
                        
                        if ([resultModel.msgcode isEqualToString:@"1"]) {
                            [btn setImage:[UIImage imageNamed:@"weishoucang_"] forState:UIControlStateNormal];
                        }
                        
                        [MBProgressHUD showAlertMessage:resultModel.msg];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }else{
                    //添加收藏
                    NSDictionary *params = @{
                                             @"uid":[GGZTool isUid],
                                             @"language":[GGZTool iSLanguageID],
                                             @"pid":weakSelf.dataModel.p_id,
                                             @"action":@"Add_ShouChang"
                                             };
                    
                    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                        GZDetailResultModel *resultModel = [[GZDetailResultModel alloc] initWithDictionary:obj error:nil];
                        
                        if ([resultModel.msgcode isEqualToString:@"1"]) {
                            
                            [btn setImage:[UIImage imageNamed:@"yishoucang_"] forState:UIControlStateNormal];
                            _cidStr = [obj valueForKey:@"data"];
                        }
                        
                        [MBProgressHUD showAlertMessage:resultModel.msg];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }else
            {
                GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            }
        };
    }
    return _headerView;
}

-(GZPopShoppDetailView *)popShoppDetailView
{
    if (!_popShoppDetailView) {
        _popShoppDetailView = [[GZPopShoppDetailView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        
        GZWeakSelf;
        //  分类ID
        _popShoppDetailView.classClickBlock = ^(NSString *classID) {
            _classID = classID;
        };
        
        //数量
        _popShoppDetailView.countClickBlock = ^(NSString *countNum) {
            _countNum = countNum;
        };
        
        //点击弹出界面的购物车按钮
        _popShoppDetailView.carBtnClickBlock = ^{
            
            if ([weakSelf.ControllerID isEqualToString:@"goShopingVC"]) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GZHomeDetailsVC" object:nil userInfo:nil];
            }
        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_popShoppDetailView.alphaiView addGestureRecognizer:tap];
        [_popShoppDetailView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

        //弹出界面确定按钮
        _popShoppDetailView.sureClickBlock = ^{
            
            [weakSelf getSureData];
        };
    }
    return _popShoppDetailView;
}

-(NSMutableArray *)cycleDataSource
{
    if (!_cycleDataSource) {
        _cycleDataSource = [[NSMutableArray alloc] init];
    }
    return _cycleDataSource;
}

-(GZOrderDetailDataModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[GZOrderDetailDataModel alloc] init];
    }
    return _dataModel;
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

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.addShoppCarBtn.right, 1)];
        _lineLabel.backgroundColor = YHRGBA(204, 204, 204, 1.0);
    }
    return _lineLabel;
}

-(GGZButton *)addShoppCarBtn
{
    if (!_addShoppCarBtn) {
        _addShoppCarBtn = [GGZButton createGGZButton];
        _addShoppCarBtn.frame = CGRectMake(0, 1, 71, self.bottomView.height - 1);
        [_addShoppCarBtn setImage:[UIImage imageNamed:@"gouwuche_select_"] forState:UIControlStateNormal];
        
        GZWeakSelf;
        _addShoppCarBtn.block = ^(GGZButton *btn) {
            
            if ([GGZTool iSSureLogin]) {
                if ([weakSelf.ControllerID isEqualToString:@"goShopingVC"]) {
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else
                {
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GZHomeDetailsVC" object:nil userInfo:nil];
                }
            }else
            {
                GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            }
            
        };
    }
    return _addShoppCarBtn;
}

-(GGZButton *)addShoppBtn
{
    if (!_addShoppBtn) {
        _addShoppBtn = [GGZButton createGGZButton];
        _addShoppBtn.frame = CGRectMake(71, 0, kScreenWidth - 71, self.bottomView.height);
        _addShoppBtn.backgroundColor = [UIColor redColor];
        [_addShoppBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addShoppBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addShoppBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        GZWeakSelf;
        _addShoppBtn.block = ^(GGZButton *btn) {
            
            if (self.dataModel.diylist !=nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] && self.dataModel.diylist.count != 0) {           //如果分类数据不为空，弹出弹框
                
                [UIView animateWithDuration: 0.35 animations: ^{
                    
                    [weakSelf.popShoppDetailView.addShoppCarBtn addSubview: weakSelf.cntLabel];
                    weakSelf.popShoppDetailView.center =weakSelf.view.center;
                    weakSelf.popShoppDetailView.frame =CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
                    
                } completion: nil];
            }else                   //如果分类数据为空，直接加入购物车
            {
                [weakSelf getSureData];
            }
        };
    }
    return _addShoppBtn;
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
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        self.title = @"详情";
        self.headerView.countPlace.text = @"数量";
        self.headerView.shoppingPlace.text = @"商品详情";
        [self.addShoppBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        
        [MBProgressHUD showMessage:@"加载中..."];

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.title = @"details";
        self.headerView.countPlace.text = @"quantity";
        self.headerView.shoppingPlace.text = @"item’s details";
        [self.addShoppBtn setTitle:@"add it to shopping cart" forState:UIControlStateNormal];

        [MBProgressHUD showMessage:@"英文..."];

        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.title = @"részletek";
        self.headerView.countPlace.text = @"darabszám";
        self.headerView.shoppingPlace.text = @"részletek";
        [self.addShoppBtn setTitle:@"a kosárban" forState:UIControlStateNormal];

        [MBProgressHUD showMessage:@"匈牙利文..."];

    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _countNum = @"1";
    _cnt = 0;
    

    [self getData];
    
    [self.view addSubview:self.mainScrollView];
    [self.bottomView addSubview:self.addShoppCarBtn];
    [self.bottomView addSubview:self.addShoppBtn];
    [self.bottomView addSubview:self.lineLabel];
    
    //弹出视图
    [self.view addSubview:self.popShoppDetailView];
    [self.mainScrollView addSubview:self.headerView];
    
    [self setAddCarAnimationUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self CarNumberData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self dismiss];
}

- (void)setAddCarAnimationUI
{
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addShoppCarBtn.right - 30, 7, 17, 17)];
    _cntLabel.textColor = [UIColor whiteColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:12];
    _cntLabel.backgroundColor = YHRGBA(232, 78, 68, 1.0);
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(self.addShoppBtn.centerX, kScreenHeight - 50)];
    [_path addQuadCurveToPoint:CGPointMake(self.addShoppCarBtn.centerX, kScreenHeight - 50) controlPoint:CGPointMake(kScreenWidth/3, kScreenHeight - 200)];
}

#pragma mark - 界面数据
- (void)getData
{
    NSString *uid = nil;
    
    if ([GGZTool iSSureLogin]) {
        uid = [GGZTool isUid];
    }else
    {
        uid = @"0";
    }
    NSDictionary *params = @{
                                 @"language": [GGZTool iSLanguageID],
                                 @"pid": self.pid,
                                 @"uid":uid,
                                 @"action":@"Pro_info"
                                 };
        
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
            
        GZHomeDetailResultModel *resultModel = [[GZHomeDetailResultModel alloc] initWithDictionary:obj error:nil];
        
        self.noNetVC.hidden = YES;
        self.homeTopView.hidden = YES;
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            GZOrderDetailDataModel *dataModel = [[GZOrderDetailDataModel alloc] initWithDictionary:resultModel.data error:nil];
            
            self.headerView.dataModel = dataModel;
            
            //如果分类数据不为空，将数据传过去
            if (dataModel.diylist !=nil && ![dataModel.diylist isKindOfClass:[NSNull class]] && dataModel.diylist.count != 0) {
                self.popShoppDetailView.dataModel = dataModel;
            }
            
            self.dataModel = dataModel;
            _cidStr = dataModel.C_id;

            if (self.dataModel.diylist != nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] &&self.dataModel.diylist.count != 0) {
                
                [self.popShoppDetailView.addShoppCarBtn addSubview:_cntLabel];
            }else
            {
                [self.addShoppCarBtn addSubview:_cntLabel];
            }
            
        }else
        {
            [MBProgressHUD hideHUD];

        }
        
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

#pragma mark - 添加购物车数据
- (void)getSureData
{
    if (self.dataModel.diylist != nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] &&self.dataModel.diylist.count != 0) {
       
        if (_classID ==nil) {
            [MBProgressHUD showAlertMessage:@"请选择分类"];
        }else
        {
            if ([GGZTool iSSureLogin]) {
                [self getSureNetWorking];
            }else
            {
                GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
        }
    }else
    {
        _classID = @"0";
        if ([GGZTool iSSureLogin]) {
            [self getSureNetWorking];
        }else
        {
            GZLoginViewController *loginVC = [[GZLoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
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
                
                [self.addShoppCarBtn addSubview:_cntLabel];
            }else
            {
                _cntLabel.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showAlertMessage:@"网络错误"];
    }];
}

- (void)getSureNetWorking
{
    NSDictionary *parmas = @{
                             @"language":[GGZTool iSLanguageID],
                             @"uid":[GGZTool isUid],
                             @"diyid":_classID,
                             @"count":_countNum,
                             @"pid":self.pid,
                             @"action":@"Add_car"
                             };
    
    [GZHttpTool post:URL params:parmas success:^(NSDictionary *obj) {
        
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            
            //添加购物车成功，通知TabbarController，调用数据更改角标
            [[NSNotificationCenter defaultCenter] postNotificationName:@"takeNotesCountNumber" object:nil userInfo:nil];
            
            [self dismiss];
            
            //添加购物车成功，动画
            if (!layer) {
                if (self.dataModel.diylist != nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] &&self.dataModel.diylist.count != 0) {
                    
                    self.popShoppDetailView.bt_sure.enabled = NO;
                }else
                {
                    self.addShoppBtn.enabled = NO;
                }
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
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showAlertMessage:@"添加失败~"];
    }];
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

#pragma mark - CAAnimationDelegate -
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [layer animationForKey:@"group"]) {
        
        if (self.dataModel.diylist != nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] &&self.dataModel.diylist.count != 0) {
            
            self.popShoppDetailView.bt_sure.enabled = YES;
        }else
        {
            self.addShoppBtn.enabled = YES;
            
        }        [layer removeFromSuperlayer];
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
        if (self.dataModel.diylist != nil && ![self.dataModel.diylist isKindOfClass:[NSNull class]] &&self.dataModel.diylist.count != 0) {
            
        [self.popShoppDetailView.addShoppCarBtn.layer addAnimation:shakeAnimation forKey:nil];
        }else
        {
            [self.addShoppCarBtn.layer addAnimation:shakeAnimation forKey:nil];
        }
    }
}

/**
 *  弹出框消失
 */
-(void)dismiss
{
    [UIView animateWithDuration: 0.35 animations: ^{
    
        [self.addShoppCarBtn addSubview:_cntLabel];
        
        self.popShoppDetailView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"GZHomeDetailsVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
