//
//  GZCustomTableView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/27.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZCustomTableView.h"

@interface GZCustomTableView ()
{
    UITableView *tabView;
    NSString *cellIdentifierName;
    BOOL iSuseXib;
}

@end

@implementation GZCustomTableView

/**
 重写set方法，更换数据
 */
@synthesize dataArr=_dataArr;
-(void)setDataArr:(id)dataArr{
    _dataArr=dataArr;
    
    [tabView reloadData];
    
}

-(id)initWithTableView :(UITableView *)tableView
          tableViewCell:(Class)tableViewCellClass
         cellIdentifier:(NSString *)cellIdentifier
                 useXib:(BOOL)useXib
                   data:(id )data
                  click:(void(^)(NSIndexPath *indexPath,id dataArr))rowClick
{
    if (self = [super init]) {
        tabView=tableView;
        
        tableView.rowHeight=UITableViewAutomaticDimension;
        tableView.estimatedRowHeight=40;
        tabView.tableFooterView=[[UITableView alloc]initWithFrame:CGRectZero];
        
        tabView.delegate=self;
        tabView.dataSource=self;
        
        if (rowClick) {
            myClick=rowClick;
        }
        
        if (data) {
            _dataArr=data;
        }
        cellIdentifierName=cellIdentifier;
        
        if (useXib){
            [tabView registerNib:[UINib nibWithNibName:cellIdentifierName bundle:nil] forCellReuseIdentifier:cellIdentifierName];
        }else
        {
            [tableView registerClass:tableViewCellClass forCellReuseIdentifier:cellIdentifierName];
        }
        
    }
    return self;
}

#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableViewType == TableViewStyleGrouped) {
        return [_dataArr count];
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_tableViewType == TableViewStyleGrouped) {
        return [_dataArr[section] count];
    }
    
    return [_dataArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierName forIndexPath:indexPath];
    
    if (_tableViewType == TableViewStyleGrouped) {
            
        [cell setValue:indexPath forKey:@"indexPath"];
        
        //kvc 修改你自定义的cell的 data的值。
        [cell setValue:_dataArr[indexPath.section][indexPath.row] forKey:@"data"];
        
    }else if (_tableViewType == TableViewStylePlain) {
        
        [cell setValue:indexPath forKey:@"indexPath"];
        
        //kvc 修改你自定义的cell的 data的值。
        [cell setValue:_dataArr[indexPath.row] forKey:@"data"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    myClick(indexPath,_dataArr);
}

@end
