//
//  User+CoreDataProperties.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nick;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) Media *avatar;
@property (nullable, nonatomic, retain) NSSet<TweetComment *> *postedComment;
@property (nullable, nonatomic, retain) NSSet<Tweet *> *postedTweet;
@property (nullable, nonatomic, retain) Media *profieImage;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPostedCommentObject:(TweetComment *)value;
- (void)removePostedCommentObject:(TweetComment *)value;
- (void)addPostedComment:(NSSet<TweetComment *> *)values;
- (void)removePostedComment:(NSSet<TweetComment *> *)values;

- (void)addPostedTweetObject:(Tweet *)value;
- (void)removePostedTweetObject:(Tweet *)value;
- (void)addPostedTweet:(NSSet<Tweet *> *)values;
- (void)removePostedTweet:(NSSet<Tweet *> *)values;

@end

NS_ASSUME_NONNULL_END
