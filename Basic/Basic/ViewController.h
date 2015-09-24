//
//  ViewController.h
//  Basic
//
//  Created by Czc on 15/9/16.
//  Copyright (c) 2015年 Kson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property (strong, nonatomic) NSValue *targetRect;
@property(nonatomic,assign)BOOL userDragging;

@end

