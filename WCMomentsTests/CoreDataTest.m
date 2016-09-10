//
//  CoreDataTest.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataManager.h"
#import "User.h"
#import "UserDataResponseHandler.h"

@interface CoreDataTest : XCTestCase

@end

@implementation CoreDataTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testCreateAndQuery
{
    NSInteger total = 10000;
    NSArray *rawData = [self createXNumberOfUsersRawData:total];
    __weak typeof(self) weakSelf = self;
    UserDataResponseHandler *responseHandler = [[UserDataResponseHandler alloc] initWithSuccessHandler:^(id response) {
        XCTAssertEqual(total, [weakSelf getTotalUser]);
    } errorHandler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    for (NSDictionary *userDic in rawData) {
        [responseHandler successReceivedData:userDic];
    }
}

- (NSArray *)createXNumberOfUsersRawData:(NSInteger)total
{
    NSMutableArray *allUsers = [NSMutableArray array];
    for (int i = 0; i < total; i++)
    {
        [allUsers addObject:@{@"username":[NSString stringWithFormat:@"user%d",i],
                              @"nick":[NSString stringWithFormat:@"nick%d",i],
                              @"avatar":[NSString stringWithFormat:@"avatar%d",i],
                              @"profile-image":[NSString stringWithFormat:@"profile_image%d",i]}];
    }
    
    return allUsers;
}

- (NSInteger)getTotalUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([User class])];
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedDataManager] managedObjectContext] executeFetchRequest:request error:&error];
    
    return [result count];
}


@end