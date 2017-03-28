//
//  Friend+CoreDataProperties.h
//  Expenses
//
//  Created by  on 11/2/16.
//  Copyright © 2016 uhcl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *youOwe;
@property (nullable, nonatomic, retain) NSNumber *friendId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *owesYou;

@end

NS_ASSUME_NONNULL_END
