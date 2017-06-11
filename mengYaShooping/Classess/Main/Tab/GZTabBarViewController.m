//
//  GZTabBarViewController.m
//  DongHeng
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZTabBarViewController.h"
#import "GZHomeViewController.h"
#import "GZClassifyViewController.h"
#import "GZGoShoppingViewController.h"
#import "GZMineTableViewController.h"

#import "GZLoginViewController.h"
#import "GZHomeDetailsViewController.h"

@interface GZTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) GZClassifyViewController *classifyVC;
@property (nonatomic, strong) GZHomeViewController *homeVC;

@property (nonatomic, strong) GZGoShoppingViewController *goShoppingVC;

@end

@implementation GZTabBarViewController

-(GZClassifyViewController *)classifyVC
{
    if (!_classifyVC) {
        _classifyVC = [[GZClassifyViewController alloc] init];
    }
    return _classifyVC;
}

-(GZHomeViewController *)homeVC
{
    if (!_homeVC) {
        _homeVC = [[GZHomeViewController alloc] init];
    }
    return _homeVC;
}

- (GZGoShoppingViewController *)goShoppingVC
{
    if (!_goShoppingVC) {
        _goShoppingVC = [[GZGoShoppingViewController alloc] init];
    }
    return _goShoppingVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

    if ([GGZTool iSSureLogin]) {
        [self getCarNumberData];
    }
    
    GZWeakSelf;
    self.homeVC.selectHomeBolck = ^(NSInteger index) {
        weakSelf.classifyVC.index = index;
        
        weakSelf.selectedIndex = 1;
    };
    
    //接收将界面放到购物车的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClick) name:@"GZHomeDetailsVC" object:nil];
    
    //接收用户添加购物车数量的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCarNumber) name:@"takeNotesCountNumber" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginreceiveClick) name:@"NoDataView" object:nil];
    
    [self setupBasic];
}

- (void)getCarNumberData
{
    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"action":@"User_CarList_count"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            NSInteger carnumber = [[[obj valueForKey:@"data"] valueForKey:@"count"] integerValue];

            if (carnumber > 0) {
                
                self.goShoppingVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",carnumber];
            }else
            {
                self.goShoppingVC.tabBarItem.badgeValue = nil;
            }
        }
    } failure:^(NSError *error) {
    
    }];
}

- (void)setupBasic
{
#warning
    NSString *homeStr;
    NSString *classifyStr;
    NSString *goShoppingStr;
    NSString *mineStr;

    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        homeStr = @"首页";
        classifyStr = @"分类";
        goShoppingStr = @"购物车";
        mineStr = @"我的";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        homeStr = @"home";
        classifyStr = @"classification";
        goShoppingStr = @"cart";
        mineStr = @" mine";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        homeStr = @"főoldal";
        classifyStr = @"osztályozások";
        goShoppingStr = @"bevásárlókocsi";
        mineStr = @"saját";
        
    }
    
    [self addChildViewController:self.homeVC notmalimageNamed:@"shouye_" selectedImage:@"shouye_select_" title:homeStr];
    
    [self addChildViewController:self.classifyVC notmalimageNamed:@"fenlei_" selectedImage:@"fenlei_select_" title:classifyStr];

    [self addChildViewController:self.goShoppingVC notmalimageNamed:@"gouwuche_" selectedImage:@"gouwuche_select_" title:goShoppingStr];
    

    [self addChildViewController:[[GZMineTableViewController alloc] init] notmalimageNamed:@"wode_" selectedImage:@"wode_select_" title:mineStr];
}

- (void)receiveCarNumber
{
    
    [self getCarNumberData];
}

- (void)receiveClick
{
    
    self.selectedIndex = 2;
}

- (void)LoginreceiveClick
{
    self.selectedIndex = 0;
}

- (void)classifyClick
{
    self.selectedIndex = 1;
}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.title = title;
 
    [childController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];

    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];

    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : YHRGBA(228, 77, 56, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];

    [self addChildViewController:nav];
}

//点击tabbar
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == 3 ) {
        if ([GGZTool iSSureLogin]) {
            
        }else
        {
            GZLoginViewController *mvc= tabBarController.childViewControllers[tabBarController.selectedIndex];
            
            self.hidesBottomBarWhenPushed = YES;
            
            GZLoginViewController *loginVC = [[GZLoginViewController alloc]init];
            
            loginVC.selectTabBarBlock = ^{
                tabBarController.selectedIndex = 3;
                [self getCarNumberData];
            };
            
            UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [mvc presentViewController:nv animated:YES completion:nil];
            //回来的时候，显示tabBar。
            self.hidesBottomBarWhenPushed = NO;
            
            return NO;
        }
    }
    if ([tabBarController.childViewControllers indexOfObject:viewController] == 2) {
        if ([GGZTool iSSureLogin]) {

        }else
        {
            GZLoginViewController *mvc= tabBarController.childViewControllers[tabBarController.selectedIndex];
            
            self.hidesBottomBarWhenPushed = YES;
            
            GZLoginViewController *loginVC = [[GZLoginViewController alloc]init];
            
            loginVC.selectTabBarBlock = ^{
                tabBarController.selectedIndex = 2;
                [self getCarNumberData];
            };
            
            UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [mvc presentViewController:nv animated:YES completion:nil];
            //回来的时候，显示tabBar。
            self.hidesBottomBarWhenPushed = NO;
            
            return NO;
        }
    }
    
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"GZHomeDetailsVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"takeNotesCountNumber"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"NoDataView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
