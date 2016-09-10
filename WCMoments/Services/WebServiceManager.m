//
//  WebServiceManager.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "WebServiceManager.h"
#import "UserDataResponseHandler.h"
#import "TweetDataResponseHandler.h"

@interface WebServiceManager()

@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

@end

@implementation WebServiceManager

#pragma mark - Life Cycle
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.backgroundQueue = dispatch_queue_create("com.thoughtworks.wcmoments", 0);
        self.completionQueue = self.backgroundQueue;
    }
    
    return self;
}


#pragma mark - Public
+ (WebServiceManager *)sharedManager
{
    static WebServiceManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://thoughtworks-ios.herokuapp.com"]];
    });
    
    return _sharedInstance;
}

- (void)getUserDataWithUserName:(NSString *)username
                      onSuccess:(webResponseSuccessHandler)success
                         onFail:(webResponseErrorHandler)fail
{
    if (!username) return;
    
    NSString *method = [NSString stringWithFormat:@"user/%@", username];
    UserDataResponseHandler *userDataHandler = [[UserDataResponseHandler alloc] initWithSuccessHandler:success errorHandler:fail];
    [self receiveDataWithMethod:method responseHandler:userDataHandler];
}

- (void)getUserTweetsWithUserName:(NSString *)username
                        onSuccess:(webResponseSuccessHandler)success
                           onFail:(webResponseErrorHandler)fail
{
    if (!username) return;
    
    NSString *method = [NSString stringWithFormat:@"user/%@/tweets", username];
    TweetDataResponseHandler *tweetrDataHandler = [[TweetDataResponseHandler alloc] initWithSuccessHandler:success errorHandler:fail];
    [self receiveDataWithMethod:method responseHandler:tweetrDataHandler];
    
}

#pragma mark - Privates
- (void)receiveDataWithMethod:(NSString *)method responseHandler:(WebResponseHandler *)responseHandler
{
    if (!method || !responseHandler) return;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(self.backgroundQueue, ^{
        
        [weakSelf GET:method parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [responseHandler successReceivedData:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [responseHandler failedWithError:error];
        }];
    });
}

@end