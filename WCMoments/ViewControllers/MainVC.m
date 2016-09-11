//
//  MainVC.m
//  WCMoments
//
//  Created by QianKun on 9/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "MainVC.h"
#import "MomentsVC.h"

@interface MainVC ()

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation MainVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarUI];
    [self setupAndConfigTableView];
    
    // show moment page
    MomentsVC *momentsVC = [[MomentsVC alloc] initWithUserName:@"jsmith"];
    [self.navigationController pushViewController:momentsVC animated:NO];
}

#pragma mark - Private methods
- (void)setupNavigationBarUI
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Discover";
}

- (void)setupAndConfigTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}

@end