//
//  CoreDataManager.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "CoreDataManager.h"
#import "User.h"

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

#pragma mark - Lazy
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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