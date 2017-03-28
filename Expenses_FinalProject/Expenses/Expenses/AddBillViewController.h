//
//  AddBillViewController.h
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@interface AddBillViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
        NSArray *_pickerData;
    NSMutableArray* _friendListArray;
    NSMutableArray* _searchResults;

   }

@property (nonatomic,retain) Bill *billObject;
@property (nonatomic,retain) NSNumber *billNumber;
@property (strong, nonatomic) NSMutableArray *membersArray;
@property (nonatomic,retain) NSNumber * paidFriendId;

@property (weak, nonatomic) IBOutlet UIButton *categoryImageView;

@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) UIPickerView *categoryPicker;

@property (weak, nonatomic) IBOutlet UIView *friendsView;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *friendSearchBar;

@property (weak, nonatomic) IBOutlet UILabel *paidbyLbl;


- (IBAction)categoryImageViewBtn_Clicked:(id)sender;

- (IBAction)savebtnClicked:(id)sender;
@end
