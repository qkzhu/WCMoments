//
//  TweetComment+CoreDataProperties.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TweetComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) User *sender;
@property (nullable, nonatomic, retain) Tweet *tweetOfComment;

@end

NS_ASSUME_NONNULL_END
