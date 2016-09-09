//
//  WebResponseHandler.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  This is the root class of various responseHandlers, it job is the take received raw data from web and process it with its own logic.
//  After processing data, the last thing is to call success/fail block in main thread for UI purpose.


#import <Foundation/Foundation.h>

typedef void (^webResponseErrorHandler)(NSError *error);
typedef void (^webResponseSuccessHandler)(id response);


@interface WebResponseHandler : NSObject

@property (nonatomic, copy) webResponseSuccessHandler successHandler;
@property (nonatomic, copy) webResponseErrorHandler errorHandler;

- (instancetype)initWithSuccessHandler:(webResponseSuccessHandler)successHandler errorHandler:(webResponseErrorHandler)errorHandler;
- (void)successReceivedData:(id)response;
- (void)failedWithError:(NSError *)error;

@end