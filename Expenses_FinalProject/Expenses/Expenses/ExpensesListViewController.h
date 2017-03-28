//
//  ExpensesListViewController.h
//  Expenses
//
//  Created by  on 10/15/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface ExpensesListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_billsData;
    NSMutableDictionary *_arrangedBillsData;
    NSMutableArray *_titlesArray;
    Friend* selectedFriendObj;
}

@property (nonatomic,retain) NSString *nameLabeltxt;
@property (nonatomic,retain) NSNumber *memberID;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oweDetails;
@property (weak, nonatomic) IBOutlet UITableView *billDetailsTableView;
@property (weak, nonatomic) IBOutlet UIView *settledUPView;

- (IBAction)deleteFriendBtnClicked:(id)sender;
- (IBAction)settleupBtnClicked:(id)sender;

- (IBAction)backbtnClicked:(id)sender;


@end
