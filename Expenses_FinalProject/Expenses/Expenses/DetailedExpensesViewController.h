//
//  DetailedExpensesViewController.h
//  Expenses
//
//  Created by  on 11/13/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@interface DetailedExpensesViewController : UIViewController
{
    NSArray *_pickerData;
    NSMutableArray* _friendListArray;
    NSMutableArray* _searchResults;
    
}

@property (nonatomic,retain) Bill *billObj;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *billImage;
@property (weak, nonatomic) IBOutlet UILabel *oweLabel;

@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;

- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)backbuttonClicked:(id)sender;

@end
