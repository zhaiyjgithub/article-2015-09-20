//
//  ViewController.m
//  Basic
//
//  Created by Czc on 15/9/16.
//  Copyright (c) 2015年 Kson. All rights reserved.
//

#import "ViewController.h"

/*
 **** 实现的目标 ****
 1,第一次进入界面就正确加载可见cell的图片
 2,用户拖动期间加载
 3,滑动过程中,不加载略过的cell
 4,滑动结束后,加载停止点可见cell的图片
 5,配合SDWebImage加载图片
 
 
 */

#define TABLEVIEW_SECTIONFOOTER_HEIGHT_DEFAULT  7.5


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.sectionHeaderHeight = 0; // 每一组的头部高度
    _tableView.sectionFooterHeight = TABLEVIEW_SECTIONFOOTER_HEIGHT_DEFAULT; // 每一组的尾部高度
    
}


//注意-64
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:(UITableViewStyleGrouped)];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;//_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"UITableViewCell";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"hello - %d",indexPath.row];
   // NSLog(@"indexpath.row:%d",indexPath.row);
    NSLog(@"drag:%@   access:%@",self.userDragging == YES ? @"YES" : @"NO",tableView.decelerating == YES ? @"YES" : @"NO");
    
    if (self.userDragging == NO && tableView.decelerating == YES) {
        cell.textLabel.text = nil;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"row:%d",indexPath.row];
    }
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.userDragging = YES;
    [self loadImage];
}

//获取最后的停止位置的起始点,该点就是屏幕的最左边的点相对于整个contentsize的位置点.
//该方法就是告诉我们,当停止的拉伸的那一刻,系统就可以告诉我将要在哪里停止了.very good(当然你可以人为修改它的最后停止点的,比如在page,以及UICollectionView中也是有的)
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
//    self.targetRect = [NSValue valueWithCGRect:targetRect];
    NSLog(@"%s",__PRETTY_FUNCTION__);

    //self.userDragging = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"scrollViewDidEndDragging:%@",decelerate == YES ? @"YES" : @"NO");
    self.userDragging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView // 当它使连续触发时候,就会不执行这里,通知也不经过reload data的方法.那么这里就会导致没有加载到
{
    NSLog(@"%s",__PRETTY_FUNCTION__); //该方法必须执行过后才会触发cellForRowIndexPath,连续触发是会导致前者的方法不会执行.
    [self loadImage];
}

- (void)loadImage{
    NSArray * cells = [self.tableView visibleCells];
    for(UITableViewCell * cell in cells){
        NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
        [self setupCell:cell indexpath:indexpath];
    }
}

- (void)setupCell:(UITableViewCell *)cell indexpath:(NSIndexPath *)indexpath{
    //其实这里就是可以使用SDWebImage来加载图片即可
    cell.textLabel.text = [NSString stringWithFormat:@"row:%d",indexpath.row];
}



@end
