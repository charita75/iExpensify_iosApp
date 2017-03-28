//
//  Friend.h
//  Expenses
//
//  Created by  on 11/2/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSMutableArray *)fetchAllFriendsRecords;
+(bool)addFriendWithId:(NSNumber *) friendId name:(NSString *)name email:(NSString *)email youowe:(NSNumber *) youOwe owesyou:(NSNumber *) owesYou;
+(int)getNumberOfFriendsRecords;
+(bool) updateBalanceForFriendId:(NSNumber *) friendId youOwe:(NSNumber *)youOweAmount owesYou:(NSNumber *)owesYouAmount;
+(NSString *)getFriendNameWhoseId:(NSNumber *)friendId;
+(bool)deleteFriendWithId:(NSNumber *)friendId;
+(Friend *) getFriendRecordWithID:(NSNumber *) friendID;
+(bool) updatesettleupForFriendId:(NSNumber *) friendId youOwe:(NSNumber *)youOweAmount owesYou:(NSNumber *)owesYouAmount;

@end

NS_ASSUME_NONNULL_END

#import "Friend+CoreDataProperties.h"
