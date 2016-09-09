//
//  MainVC.m
//  WCMoments
//
//  Created by QianKun on 9/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarUI];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UI componets actions
- (void)leftBarBtnTapped {
    NSLog(@"left bar button tapped");
}

- (void)rightBarBtnTapped {
    NSLog(@"right bar button tapped");
}

#pragma mark - Private methods
- (void)setupNavigationBarUI
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Moments";
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Discover"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(leftBarBtnTapped)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(rightBarBtnTapped)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

@end