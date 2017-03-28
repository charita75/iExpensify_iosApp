//
//  AddMemberViewController.h
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMemberViewController : UIViewController {
     NSMutableArray* _friendListArray;
        NSMutableArray* _searchResults;
}
@property (strong, nonatomic) NSMutableArray *membersArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarview;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
