//
//  WebServiceManager.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  This class is for handling all network communications such as get/post to web server.
//  All the communications to web happens in a background thread: backgroundQueue
//  Once all data processed in background thread, the last thing is to notify main thread through WebResponseHandler


#import <AFNetworking/AFNetworking.h>
#import "WebResponseHandler.h"

@interface WebServiceManager : AFHTTPSessionManager

+ (WebServiceManager *)sharedManager;

- (void)getUserDataWithUserName:(NSString *)username
                      onSuccess:(webResponseSuccessHandler)success
                         onFail:(webResponseErrorHandler)fail;

- (void)getUserTweetsWithUserName:(NSString *)username
                        onSuccess:(webResponseSuccessHandler)success
                           onFail:(webResponseErrorHandler)fail;

@end