//
//  Bill.m
//  Expenses
//
//  Created by  on 11/4/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "Bill.h"
#import "AppDelegate.h"


@implementation Bill

// Insert code here to add functionality to your managed object subclass

+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

+(bool)addBillWithId:(NSNumber *) billId friendId:(NSNumber *)friendId billCategory:(NSString *)billCategory totalAmount:(NSNumber *) totalAmount image:(NSData *) image billAdded:(NSDate *) billAdded {
    
    NSManagedObjectContext *context = [[self class] getManagedObjectContext];
    //Create a blank new record
    Bill *addBillObj = (Bill *)[NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
    
    [addBillObj setBillId:billId];
    [addBillObj setFriendId:friendId];
    [addBillObj setCategory:billCategory];
    [addBillObj setAmount:totalAmount];
    [addBillObj setImage:image];
    [addBillObj setBillAdded:billAdded];
    //Save the new record
    NSError *error;
    if(![context save:&error])
    {
        return false;
    }
    else
    {
        NSLog(@"bill added");
        return true;
    }
    
}

+(bool)updateBillWithId:(NSNumber *) billId friendId:(NSNumber *)friendId billCategory:(NSString *)billCategory totalAmount:(NSNumber *) totalAmount image:(NSData *) image billAdded:(NSDate *) billAdded {

    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"billId=%@", billId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    NSManagedObject *obj=[fetchResults objectAtIndex:0];
    
    
    [obj setValue:friendId forKey:@"friendId"];
    [obj setValue:billCategory forKey:@"category"];
    [obj setValue:totalAmount forKey:@"amount"];
    [obj setValue:billAdded forKey:@"billAdded"];
    [obj setValue:image forKey:@"image"];
    //Save the new record

    if(![context save:&error])
    {
        return false;
    }
    else
    {
        NSLog(@"bill updated");
        return true;
    }

    
}

+(NSMutableArray *) fetchAllBills{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
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
    
    return mutableFetchResults;
}


+(NSMutableArray *) fetchAllBillsData{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
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

+(bool) deleteBill:(NSNumber *)billNumber {

    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"billId=%@", billNumber];
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



@end
