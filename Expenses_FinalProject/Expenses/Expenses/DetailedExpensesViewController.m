//
//  DetailedExpensesViewController.m
//  Expenses
//
//  Created by  on 11/13/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "DetailedExpensesViewController.h"
#import "AddBillViewController.h"
#import "Friend.h"


@interface DetailedExpensesViewController ()

@end

@implementation DetailedExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    barButton.tag = 0;
    barButton.possibleTitles = [NSSet setWithObjects:@"Edit", @"Done", nil];
    self.navigationItem.rightBarButtonItem= barButton;
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    [self intializeData];
    
}

-(void) intializeData {
    self.categoryImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"Groceries"]];
    self.categoryLabel.text=self.billObj.category;
    self.amountLabel.text=[NSString stringWithFormat:@"$ %@", [self.billObj.amount stringValue] ];
    self.billImage.image=[UIImage imageWithData:self.billObj.image];
    NSString *paidName;
    if(self.billObj.friendId >0) {
        paidName=[Friend getFriendNameWhoseId:self.billObj.friendId];
        float amount=[self.billObj.amount floatValue]/4;
        self.oweLabel.text=[NSString stringWithFormat:@"You Owe %@ $%.2f.",paidName,amount];
        self.oweLabel.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:232.0/255.0 blue:225.0/255.0 alpha:1];
    }
    else {
        paidName=@"You";
        float amount=[self.billObj.amount floatValue]/4;
        float balance=[self.billObj.amount floatValue]-amount;
        self.oweLabel.text=[NSString stringWithFormat:@"3 people Owes %@ $%.2f.",paidName,balance];
        
    }
    self.descriptionLabel.text=@"Share by you and other 3 friends";
    NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"MMMM dd, YYYY"];
    NSString * dateString=[myFormatter stringFromDate:self.billObj.billAdded];
    self.paidLabel.text=[NSString stringWithFormat:@"Paid by %@ on %@",paidName,dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) edit:(UIBarButtonItem *) barBtnItem
{
    if (barBtnItem.tag == 0)
    {

        [self performSegueWithIdentifier:@"Details2Update" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Details2Update"])
    {
        AddBillViewController *billVC=[segue destinationViewController];
        billVC.billObject=_billObj;
        billVC.billNumber=_billObj.billId;
        
    }
}


- (IBAction)deleteButtonClicked:(id)sender {
    NSNumber *billno=self.billObj.billId;
    [self updateFriendsDetailsForUpdatedBill:self.billObj.amount paidFriendId:self.billObj.friendId];
    [Bill deleteBill:billno];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)backbuttonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) updateFriendsDetailsForUpdatedBill:(NSNumber *) amount paidFriendId:(NSNumber *)friendId {
   
    NSMutableArray * friendsArray= [Friend fetchAllFriendsRecords];
    int count = (int)[friendsArray count]+1;
    float billEachMemberAmount = [amount floatValue]/count;
    if(friendId==0) {
        for(int i=0; i<count-1 ; i++) {
            Friend * friendObj= [friendsArray objectAtIndex:i] ;
            float intialAmount=[friendObj.owesYou floatValue];
            float updatedAmount = intialAmount- billEachMemberAmount;
            [Friend updateBalanceForFriendId:friendObj.friendId youOwe:friendObj.youOwe owesYou:[NSNumber numberWithFloat:updatedAmount]];
            
        }
    }else {
        Friend * friendObj=[Friend getFriendRecordWithID:friendId];
        float intialAmount=[friendObj.youOwe floatValue];
        float updatedAmount = intialAmount-billEachMemberAmount;
        [Friend updateBalanceForFriendId:friendObj.friendId youOwe:[NSNumber numberWithFloat:updatedAmount] owesYou:friendObj.owesYou];
        
    }
    
}

@end
