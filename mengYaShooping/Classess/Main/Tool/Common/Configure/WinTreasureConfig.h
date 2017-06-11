//
//  WinTreasureConfig.h
//  WinTreasure
//
//  Created by Apple on 16/5/31.
//  Copyright © 2016年 linitial. All rights reserved.
//

#ifndef WinTreasureConfig_h
#define WinTreasureConfig_h

#pragma mark - base
    #import "BaseViewController.h"
    #import "BaseNavigationController.h"
    #import "BaseTableViewController.h"

#pragma mark - system
    #import "WTSystemInfo.h"

#pragma mark - common
    #import "YYKit.h"
    #import "SVProgressHUD.h"
    #import "TSAnimation.h"
    #import "AppDelegate.h"
    #import "MJRefresh.h"
    #import "Masonry.h"
    #import "SDCycleScrollView.h"
    #import "MBProgressHUD+MJ.h"
    #import "MBProgressHUD.h"
    #import "MJExtension.h"
    #import "UIImageView+WebCache.h"
    #import "UIButton+WebCache.h"
    #import <UITableView+FDTemplateLayoutCell.h>
    #import <YYInfiniteLoopView.h>
    #import "HXLanguageManager.h"
    #import <Accelerate/Accelerate.h>
    #import "GZCustomTableView.h"
    #import "GZNoNetWorking.h"
    #import "GZTabBarViewController.h"
    #import "GZNoDataCommonView.h"


#pragma mark - category
    #import "UIButton+Block.h"
    #import "UILabel+StringFrame.h"
    #import "NSString+TSTime.h"
    #import "NSString+GZ.h"
    #import "UINavigationBar+CoverView.h"
    #import "UITableView+Custom.h"
    #import "UIAlertView+CallBack.h"
    #import "UITabBar+Badge.h"
    #import "UIScrollView+EmptyDataSet.h"
    #import "UIView+GZExtension.h"
    #import "UIButton+GZExtension.h"
    #import "NSString+Encrypt.h"
    #import "NSString+Helper.h"
    #import "ClockObject.h"
    #import "UIButton+ImageTitleSpacing.h"
    #import "UIImage+GZExtension.h"
    #import "UIView+GZExtension.h"
    #import "UIViewController+GZExtension.h"
    #import "CABasicAnimation+Category.h"
    #import "UILabel+GZChangeLineSpaceAndWordSpace.h"
    #import "UIButton+GZCS_FixMultiClick.h"
    #import "UIViewController+BackButtonHandler.h"
    #import "UIView+GZactivityView.h"


#pragma mark - Tools
    #import "GZFMDBTool.h"
    #import "GZHttpTool.h"
    #import "ClockObject.h"
    #import "GGZButton.h"
    #import "GGZTool.h"
    #import "GZAlertView.h"
    #import "LoadingView.h"
    #import "GZScanImage.h"

#pragma mark - Model
    #import "GZModel.h"

#pragma mark - 接口
#define YUMING (@"http://mysy.ruanmengapp.com")

#define URL (@"http://mysy.ruanmengapp.com/tools/Interface1.ashx")


#pragma mark - 宏


//登录加密
#define APPKEY (@"my@x#S*csy")
#define APPSECRET (@"%LDEmysy6")

    //首页
    #define Button_Width 43.f   //按钮宽
    #define Button_Height 60.f   //按钮宽
    #define Width_Space (kScreenWidth -Button_Width *5 - 16*2)/4   //按钮宽
    #define Height_Space 11.f   //按钮宽

    #define YHRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

    #define CollegeSprintRightBtnTag  100
    #define categoryBtnTag     1000

    #define kScaleLength(length) (length) * [UIScreen mainScreen].bounds.size.width / kScreenWidth

    #define UIImageNamed(imageName) [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAutomatic]


//和后台约定的算法密码key
#define AES_KEY (@"123456")

#ifdef DEBUG // 调试状态, 打开LOG功能
#define GZLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define GZLog(...)
#endif

/**
 缓存的有效期  单位是s
 */
#define kYBCache_Expire_Time (3600*24)

/**
 请求的API
 */
#define kAPI_URL @""

/**
 弱引用
 */
#define GZWeakSelf __weak typeof(self) weakSelf = self;


/**
 *  沙盒Cache路径
 */
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])

#endif /* WinTresureConfig_h */
