//
//  Friend.m
//  Expenses
//
//  Created by  on 11/2/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "Friend.h"
#import "AppDelegate.h"

@implementation Friend

// Insert code here to add functionality to your managed object subclass
+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

+(NSMutableArray *) fetchAllFriendsRecords{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        return nil;
    }
    
    return mutableFetchResults;
}

+(bool)addFriendWithId:(NSNumber *) friendId name:(NSString *)name email:(NSString *)email youowe:(NSNumber *) youOwe owesyou:(NSNumber *) owesYou {

NSManagedObjectContext* context =[[self class] getManagedObjectContext];
//Create a blank new record
Friend *friendObj = (Friend *)[NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
    
    //Fill the new record
    [friendObj setFriendId:friendId];
    [friendObj setName:name];
    [friendObj setEmail:email];
   // [friendObj setBalance:balance];
    [friendObj setYouOwe:youOwe];
    [friendObj setOwesYou:owesYou];
    //Save the new record
    NSError *error;
    if(![context save:&error])
    {
        return false;
    }
    else
    {
        return true;
    }

}
+(int)getNumberOfFriendsRecords {
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];


    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        return 0;
    }
    
    int number= (int)[mutableFetchResults count];
    return number;

}

+(bool) updateBalanceForFriendId:(NSNumber *) friendId youOwe:(NSNumber *)youOweAmount owesYou:(NSNumber *)owesYouAmount {
    
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendId=%@", friendId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    NSManagedObject *obj=[fetchResults objectAtIndex:0];
    [obj setValue:youOweAmount forKey:@"youOwe"];
    [obj setValue:owesYouAmount forKey:@"owesYou"];
    if(![context save:&error])
    {
        return false;
    }
    else
    {
        return true;
    }

}

+(bool)deleteFriendWithId:(NSNumber *)friendId {
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendId=%@", friendId];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults.count > 0)
    {
        NSManagedObject *managedObject = [mutableFetchResults objectAtIndex:0];
        [context deleteObject:managedObject];
        if (![context save:&error])
        {
            return false;
        }
    }
    return true;
    
}

+(Friend *) getFriendRecordWithID:(NSNumber *) friendID {
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendId=%@", friendID];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        return nil;
    }
    return [mutableFetchResults objectAtIndex:0];
}

+(NSString *)getFriendNameWhoseId:(NSNumber *)friendId {
    
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendId=%@", friendId];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        return nil;
    }
    Friend *friendObj=[mutableFetchResults objectAtIndex:0];
    
    return friendObj.name;

}
+(bool) updatesettleupForFriendId:(NSNumber *) friendId youOwe:(NSNumber *)youOweAmount owesYou:(NSNumber *)owesYouAmount  {
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friendId=%@", friendId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    NSManagedObject *obj=[fetchResults objectAtIndex:0];
    [obj setValue:youOweAmount forKey:@"youOwe"];
    [obj setValue:owesYouAmount forKey:@"owesYou"];
   // [obj setValue:settledupDate forKey:@"updatedSettledUpDate"];
    if(![context save:&error])
    {
        return false;
    }
    else
    {
        return true;
    }
}

@end
