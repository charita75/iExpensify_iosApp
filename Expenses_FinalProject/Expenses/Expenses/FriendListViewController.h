//
//  FriendListViewController.h
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FriendListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    NSMutableArray* _friendListArray;
    
}
@property (weak, nonatomic) IBOutlet UILabel *youOweLabel;
@property (weak, nonatomic) IBOutlet UILabel *owesYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *friendsListTableView;
- (IBAction)sendMail:(id)sender;

@end
