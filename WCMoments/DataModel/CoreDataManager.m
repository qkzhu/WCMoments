//
//  CoreDataManager.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "CoreDataManager.h"
#import "User.h"
#import "Media.h"
#import "Tweet.h"
#import "TweetComment.h"

static const NSString *kNick = @"nick";
static const NSString *kUserName = @"username";
static const NSString *kProfileImage = @"profile-image";
static const NSString *kAvatar = @"avatar";

@implementation CoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory = _applicationDocumentsDirectory;

#pragma mark - Life Cycle

+ (id)sharedDataManager
{
    static CoreDataManager *cdManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cdManager = [[self alloc] init];
        
    });
    
    return cdManager;
}

#pragma mark - Public
- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (id)createEntityWithName:(NSString *)inClassName
{
    return [NSEntityDescription insertNewObjectForEntityForName:inClassName inManagedObjectContext:self.managedObjectContext];
}

- (User *)getUserByUserName:(NSString *)username
{
    if (!username) return nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([User class])];
    request.predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return [result firstObject];
}


- (BOOL)usernameExist:(NSString *)username
{
    return [self getUserByUserName:username] != nil;
}

- (User *)getUserFromUserRawData:(NSDictionary *)userRawData
{
    if (!userRawData || ![userRawData isKindOfClass:[NSDictionary class]]) return nil;
    
    NSString *username = [userRawData objectForKey:kUserName];
    if (!username) return nil;
    
    User *userObj = [self getUserByUserName:username];
    if (userObj) return userObj;
    
    // create new user if user does not exist
    userObj = [[CoreDataManager sharedDataManager] createEntityWithName:NSStringFromClass([User class])];
    userObj.nick = [userRawData objectForKey:kNick];
    userObj.username = username;
    
    // profile image
    NSString *profileImgUrl = [userRawData objectForKey:kProfileImage];
    if (profileImgUrl)
    {
        Media *profileImg = [self createEntityWithName:NSStringFromClass([Media class])];
        profileImg.imageURL = profileImgUrl;
        userObj.profieImage = profileImg;
    }
    
    // avatar image
    NSString *avatarImgUrl = [userRawData objectForKey:kAvatar];
    if (avatarImgUrl)
    {
        Media *avatarImg = [self createEntityWithName:NSStringFromClass([Media class])];
        avatarImg.imageURL = avatarImgUrl;
        userObj.avatar = avatarImg;
    }
    
    [self saveEntity:userObj];
    
    return userObj;
}

- (NSArray *)getAllTweets
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tweet class])];
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return result;
}

#pragma mark - Lazy
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WCMomentsModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WCMomentsModel.sqlite"];
        
        NSLog(@"storeURL: %@", [storeURL absoluteString]);
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    if (!_applicationDocumentsDirectory)
    {
        _applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    
    return _applicationDocumentsDirectory;
}

#pragma mark - Private
- (BOOL)saveEntity:(id)inEntity
{
    if (!inEntity)
        return NO;
    
    NSError *error;
    
    @try
    {
        return [self.managedObjectContext save:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"saveEntity exception %@", exception);
    }
    
    if (!error) {
        NSLog(@"saveEntity Error: %@", error);
    }
}

@end