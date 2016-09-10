//
//  UserDataResponseHandler.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "UserDataResponseHandler.h"
#import "CoreDataManager.h"
#import "User.h"
#import "Media.h"

static const NSString *kNick = @"nick";
static const NSString *kUserName = @"username";
static const NSString *kProfileImage = @"profile-image";
static const NSString *kAvatar = @"avatar";

@implementation UserDataResponseHandler

- (void)successReceivedData:(id)response
{
    NSString *username = [response objectForKey:kUserName];
    if ([[CoreDataManager sharedDataManager] usernameExist:username]) return;
    
    User *newUser = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([User class])];
    newUser.nick = [response objectForKey:kNick];
    newUser.username = username;
    
    // profile image
    NSString *profileImgUrl = [response objectForKey:kProfileImage];
    if (profileImgUrl)
    {
        Media *profileImg = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([Media class])];
        profileImg.imageURL = profileImgUrl;
        newUser.profieImage = profileImg;
    }
    
    // avatar image
    NSString *avatarImgUrl = [response objectForKey:kAvatar];
    if (avatarImgUrl)
    {
        Media *avatarImg = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([Media class])];
        avatarImg.imageURL = avatarImgUrl;
        newUser.avatar = avatarImg;
    }
    
    [[CoreDataManager sharedDataManager] saveContext];
    
    [super successReceivedData:response];
}

- (void)failedWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [super failedWithError:error];
}

@end