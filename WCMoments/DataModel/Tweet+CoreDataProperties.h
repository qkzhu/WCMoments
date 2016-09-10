//
//  Tweet+CoreDataProperties.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSSet<TweetComment *> *comments;
@property (nullable, nonatomic, retain) NSSet<Media *> *images;
@property (nullable, nonatomic, retain) User *sender;

@end

@interface Tweet (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(TweetComment *)value;
- (void)removeCommentsObject:(TweetComment *)value;
- (void)addComments:(NSSet<TweetComment *> *)values;
- (void)removeComments:(NSSet<TweetComment *> *)values;

- (void)addImagesObject:(Media *)value;
- (void)removeImagesObject:(Media *)value;
- (void)addImages:(NSSet<Media *> *)values;
- (void)removeImages:(NSSet<Media *> *)values;

@end

NS_ASSUME_NONNULL_END
