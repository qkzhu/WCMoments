//
//  TweetDataResponseHandler.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "TweetDataResponseHandler.h"
#import "Tweet.h"
#import "Media.h"
#import "User.h"
#import "TweetComment.h"
#import "CoreDataManager.h"

static const NSString *kTweetContent = @"content";
static const NSString *kImages = @"images";
static const NSString *kImageURL = @"url";
static const NSString *kComments = @"comments";
static const NSString *kCommentContent = @"content";

static const NSString *kSender = @"sender";
static const NSString *kUserName = @"username";
static const NSString *kNick = @"nick";
static const NSString *kAvatar = @"avatar";


@implementation TweetDataResponseHandler

- (void)successReceivedData:(id)response
{
    if (!response || ![response isKindOfClass:[NSArray class]] || [response count] == 0)
        return;
    
    NSArray *tweetsRaw = (NSArray *)response;
    for (NSDictionary *eachTweetRaw in tweetsRaw)
    {
        @autoreleasepool
        {
            // check sender
            NSDictionary *tweetSenderRaw = [eachTweetRaw objectForKey:kSender];
            User *tweetSenderObj = [[CoreDataManager sharedDataManager] getUserFromUserRawData:tweetSenderRaw];
            if (!tweetSenderObj) continue;
            
            // check content and image, if neighter has data then ignore
            NSString *tweetContent = [eachTweetRaw objectForKey:kTweetContent];
            NSArray *tweetImagesRaw = [eachTweetRaw objectForKey:kImages];
            if (!tweetContent && (!tweetImagesRaw || ![tweetImagesRaw isKindOfClass:[NSArray class]] || tweetImagesRaw.count > 0))
                continue;
            
            // create new tweet data
            Tweet *newTweet = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([Tweet class])];
            newTweet.content = tweetContent;
            newTweet.sender = tweetSenderObj;
             
            // images
            for (NSDictionary *eachImageRaw in tweetImagesRaw)
            {
                NSString *imageUrl = [eachImageRaw objectForKey:kImageURL];
                if (!imageUrl) continue;
                Media *newMedia = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([Media class])];
                newMedia.imageURL = imageUrl;
                [newTweet addImagesObject:newMedia];
            }
            
            
            // comments
            NSArray *tweetCommentsRaw = [eachTweetRaw objectForKey:kComments];
            if (tweetImagesRaw && tweetCommentsRaw.count > 0)
            {
                for (NSDictionary *eachCommentRaw in tweetCommentsRaw)
                {
                    NSString *commentContent = [eachCommentRaw objectForKey:kCommentContent];
                    User *commentSender = [[CoreDataManager sharedDataManager] getUserFromUserRawData:[eachCommentRaw objectForKey:kSender]];
                    if (!commentSender || !commentContent) continue;
                    
                    TweetComment *newComment = [[CoreDataManager sharedDataManager]
                                                createEntityWithName:NSStringFromClass([TweetComment class])];
                    newComment.content = commentContent;
                    newComment.sender = commentSender;
                    [newTweet addCommentsObject:newComment];
                }
            }
            
            // save
            [[CoreDataManager sharedDataManager] saveContext];
        }
    }
    
    [super successReceivedData:response];
}

- (void)failedWithError:(NSError *)error
{
    NSLog(@"blah blah");
    [super failedWithError:error];
}

@end