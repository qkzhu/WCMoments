//
//  TweetDataResponseHandler.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "TweetDataResponseHandler.h"

@implementation TweetDataResponseHandler

- (void)successReceivedData:(id)response
{
    NSLog(@"blah blah");
    [super successReceivedData:response];
}

- (void)failedWithError:(NSError *)error
{
    NSLog(@"blah blah");
    [super failedWithError:error];
}

@end