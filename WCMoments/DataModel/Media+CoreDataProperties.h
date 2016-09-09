//
//  Media+CoreDataProperties.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Media.h"

NS_ASSUME_NONNULL_BEGIN

@interface Media (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) User *avatarOwner;
@property (nullable, nonatomic, retain) User *profileImageOwner;
@property (nullable, nonatomic, retain) Tweet *tweetOfImage;

@end

NS_ASSUME_NONNULL_END
