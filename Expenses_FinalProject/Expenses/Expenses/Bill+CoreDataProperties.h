//
//  Bill+CoreDataProperties.h
//  Expenses
//
//  Created by  on 11/4/16.
//  Copyright © 2016 uhcl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Bill.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bill (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSNumber *billId;
@property (nullable, nonatomic, retain) NSNumber *friendId;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *billAdded;

@end

NS_ASSUME_NONNULL_END
