//
//  UserDataResponseHandler.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "UserDataResponseHandler.h"
#import "CoreDataManager.h"

@implementation UserDataResponseHandler

- (void)successReceivedData:(id)response
{
    User *user = [[CoreDataManager sharedDataManager] getUserFromUserRawData:response];
    
    if (user) [super successReceivedData:user];
    else [super failedWithError:[NSError errorWithDomain:@"WCMoments"
                                                    code:0
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"failed user data:%@", response]}]];
}

- (void)failedWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [super failedWithError:error];
}

@end