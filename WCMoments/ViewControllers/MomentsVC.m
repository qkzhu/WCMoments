//
//  MomentsVC.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "MomentsVC.h"
#import "WebServiceManager.h"
#import "CoreDataManager.h"
#import "User.h"
#import "Tweet.h"
#import "ProfileCell.h"
#import "TweetCell.h"

static NSString *profileCellID = @"ProfileCellIdentifier";
static NSString *tweetCellID = @"TweetCellIdentifier";

@interface MomentsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) User *userData;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, assign) NSInteger totalShowed;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end


@implementation MomentsVC

#pragma mark - Life Cycle

- (instancetype)initWithUserName:(NSString *)username
{
    if (self = [super init])
    {
        self.username = username;
    }
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarUI];
    [self setupAndConfigTableView];
    [self loadDataAndUpdateView];
}

#pragma mark - UI componets actions
- (void)rightBarBtnTapped
{
    NSLog(@"right bar button tapped");
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // two sections: first is the user own profile and second for all tweets
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.userData ? 1 : 0;
    }
    else
    {
        return self.totalShowed > self.tweets.count ? self.tweets.count : self.totalShowed;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellID];
        [cell setupWithData:self.userData];
        return cell;
    }
    else
    {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:tweetCellID forIndexPath:indexPath];
        Tweet *tweetData = [self.tweets objectAtIndex:indexPath.row];
        [cell setupWithData:tweetData];
        
        if (indexPath.row + 1 == self.totalShowed)
        {
            self.totalShowed += 5;
            [tableView reloadData];
        }
        
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [ProfileCell getCellHeight];
    }
    else
    {
        Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
//        Tweet *tweet = [self.tweets objectAtIndex:5];
        return [TweetCell getCellHeightWithData:tweet withContentWidth:tableView.frame.size.width];
    }
}

#pragma mark - Private
- (void)setupNavigationBarUI
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Moments";
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(rightBarBtnTapped)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)setupAndConfigTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ProfileCell class] forCellReuseIdentifier:profileCellID];
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:tweetCellID];
    
    self.totalShowed = 5;
    // add refresh view and actions
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(tableEndRefreshed:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)loadDataAndUpdateView
{
    [self loadUserData];
    [self loadTweetData];
}

- (void)loadUserData
{
    NSString *userDataFlagKey = @"userDataLoaded";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:userDataFlagKey])
    {
        [self updateUserData];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[WebServiceManager sharedManager] getUserDataWithUserName:self.username onSuccess:^(id response) {
            NSLog(@"***** User data success: %@", response);
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:userDataFlagKey];
            [weakSelf updateUserData];
        } onFail:^(NSError *error) {
            NSLog(@"***** User data failed: %@", error);
        }];
    }
}

- (void)loadTweetData
{
    NSString *tweetDataFlagKey = @"tweetDataLoaded";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:tweetDataFlagKey])
    {
        [self updateTweetData];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[WebServiceManager sharedManager] getUserTweetsWithUserName:self.username onSuccess:^(id response) {
            NSLog(@"***** Tweet data success: %@", response);
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:tweetDataFlagKey];
            [weakSelf updateTweetData];
        } onFail:^(NSError *error) {
            NSLog(@"***** Tweet data failed: %@", error);
        }];
    }
}

- (void)updateUserData
{
    self.userData = [[CoreDataManager sharedDataManager] getUserByUserName:self.username];
    [self.tableView reloadData];
}

- (void)updateTweetData
{
    self.tweets = [[CoreDataManager sharedDataManager] getAllTweets];
    [self.tableView reloadData];
}

- (void)tableEndRefreshed:(UIRefreshControl *)refreshControl
{
    [NSThread sleepForTimeInterval:2];
    [self.refreshControl endRefreshing];
    self.totalShowed = 5;
    [self.tableView reloadData];
}

@end