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
@property (nullable, nonatomic, retain) NSManagedObject *profieImage;
@property (nullable, nonatomic, retain) NSManagedObject *avatar;
@property (nullable, nonatomic, retain) Tweet *postedTweet;
@property (nullable, nonatomic, retain) NSSet<Comment *> *postedComment;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPostedCommentObject:(Comment *)value;
- (void)removePostedCommentObject:(Comment *)value;
- (void)addPostedComment:(NSSet<Comment *> *)values;
- (void)removePostedComment:(NSSet<Comment *> *)values;

@end

NS_ASSUME_NONNULL_END
