//
//  GZCustomTableView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/27.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GZtableViewType){
    
    TableViewStylePlain,        //plain类型
    TableViewStyleGrouped,      // 组类型
};

@interface GZCustomTableView : NSObject <UITableViewDelegate,UITableViewDataSource>
{
    void(^myClick)(NSIndexPath *indexPath,id dataArr);
   
}

/** 数据源 */
@property (nonatomic, retain) id  dataArr;

/** tableView类型，是组还是Plain */
@property (nonatomic, assign) GZtableViewType tableViewType;

/**
 创建自定义tableView

 @param tableView          需要显示的tableView
 @param cellIdentifier     需要显示的tableView
 @param useXib             cellIdentifier，必须和创建的tableViewCell的类名一样
 @param data               是否需要xib
 @param rowClick           数据
 @return                   点击每一行的事件
 */
-(id)initWithTableView :(UITableView *)tableView
          tableViewCell:(Class)tableViewCellClass
         cellIdentifier:(NSString *)cellIdentifier
                 useXib:(BOOL)useXib
                   data:(id )data
                  click:(void(^)(NSIndexPath *indexPath,id dataArr))rowClick;


@end
