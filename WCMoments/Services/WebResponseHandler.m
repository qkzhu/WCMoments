//
//  WebResponseHandler.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "WebResponseHandler.h"

@implementation WebResponseHandler

#pragma mark - Life Cycle
- (instancetype)initWithSuccessHandler:(webResponseSuccessHandler)successHandler errorHandler:(webResponseErrorHandler)errorHandler
{
    if (self = [super init])
    {
        self.successHandler = successHandler;
        self.errorHandler = errorHandler;
    }
    
    return self;
}

#pragma mark - Public
- (void)successReceivedData:(id)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.successHandler) {
            self.successHandler(response);
        }
    });
}

- (void)failedWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.errorHandler) {
            self.errorHandler(error);
        }
    });
}

@end