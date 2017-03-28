//
//  ExpensesListViewController.m
//  Expenses
//
//  Created by  on 10/15/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "ExpensesListViewController.h"
#import "Bill.h"
#import "Friend.h"
#import "DetailedExpensesViewController.h"

@interface ExpensesListViewController ()

@end

@implementation ExpensesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.nameLabel.text=_nameLabeltxt;
    _arrangedBillsData=[[NSMutableDictionary alloc] init];
    _titlesArray=[[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    selectedFriendObj= [Friend getFriendRecordWithID:_memberID];
    [self loadBillstableData];
    if([selectedFriendObj.owesYou floatValue] > [selectedFriendObj.youOwe floatValue]) {
        _oweDetails.text = [NSString stringWithFormat:@"%@ Owes you %.2f",selectedFriendObj.name,([selectedFriendObj.owesYou floatValue]-[selectedFriendObj.youOwe floatValue])];
    }else if([selectedFriendObj.owesYou floatValue] < [selectedFriendObj.youOwe floatValue]) {
        _oweDetails.text = [NSString stringWithFormat:@"You Owe %@  %.2f",selectedFriendObj.name,([selectedFriendObj.youOwe floatValue]-[selectedFriendObj.owesYou floatValue])];
    }
    else {
        _oweDetails.text = [NSString stringWithFormat:@"You and %@ are settled up",selectedFriendObj.name];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) loadBillstableData {
    if(([selectedFriendObj.owesYou floatValue] == 0.0) && ([selectedFriendObj.youOwe floatValue] == 0.0)) {
        self.billDetailsTableView.hidden=YES;
        self.settledUPView.hidden=NO;
    }
    else {
    _billsData=[Bill fetchAllBillsData];
    [self prepareDictonaryArray:_billsData];
    }
}


-(void)prepareDictonaryArray:(NSMutableArray *)data {
    
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSString *dateString;
    if([data count] >0) {
    Bill *billObj=[data objectAtIndex:0];
    NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"MMMM YYYY"];
    dateString=[myFormatter stringFromDate:billObj.billAdded];
    [temp addObject:[data objectAtIndex:0]];
    [_titlesArray addObject:dateString];
    for(int i=1;i<[data count];i++)
    {
        NSString *tempString;
        Bill *Obj=[data objectAtIndex:i];
        tempString=[myFormatter stringFromDate:Obj.billAdded];
        if([dateString isEqualToString:tempString])
        {
            [temp addObject:[data objectAtIndex:i]];

        }
        else {
            [_arrangedBillsData setObject:temp forKey:dateString];
            [temp removeAllObjects];
            [temp addObject:[data objectAtIndex:i]];
            dateString=tempString;
            [_titlesArray addObject:dateString];
        }
    }
    
    [_arrangedBillsData setObject:temp forKey:dateString];
    
    
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_titlesArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_titlesArray objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *title=[_titlesArray objectAtIndex:section];
    NSMutableArray *tmp=[_arrangedBillsData objectForKey:title];
    return [tmp count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"mycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *title=[_titlesArray objectAtIndex:indexPath.section];
    NSMutableArray *tmp=[_arrangedBillsData objectForKey:title];
    Bill *billObj=[tmp objectAtIndex:indexPath.row];
    
    UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:5];
    UILabel* categoryLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel* paidLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel* oweLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel* amountLabel = (UILabel *)[cell.contentView viewWithTag:4];
    
    img.image=[UIImage imageNamed:[NSString stringWithFormat:@"Groceries"]];
    categoryLabel.text=billObj.category;
    if(billObj.friendId==0) {
        paidLabel.text=[NSString stringWithFormat:@"you paid $%.2f",[billObj.amount floatValue]];
        oweLabel.text= @"You lent";
        oweLabel.textColor=[UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
        float lentAmount=[billObj.amount floatValue]- ([billObj.amount floatValue]/4);
        amountLabel.text=[NSString stringWithFormat:@"$%.2f", lentAmount];
        amountLabel.textColor=[UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
    }else {
        NSString *paidName=[Friend getFriendNameWhoseId:billObj.friendId];
        paidLabel.text=[NSString stringWithFormat:@"%@ paid $%.2f",paidName,[billObj.amount floatValue]];
        oweLabel.text= @"You borrowed";
        oweLabel.textColor=[UIColor orangeColor];
        float borrowedAmount=([billObj.amount floatValue]/4);
        amountLabel.text=[NSString stringWithFormat:@"$%.2f", borrowedAmount];
        amountLabel.textColor=[UIColor orangeColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self performSegueWithIdentifier:@"Expenses2Detail" sender:self];
    
}

- (IBAction)deleteFriendBtnClicked:(id)sender {
    
    NSString *message=[NSString stringWithFormat:@"Do you want to delete %@ from your friends list?",_nameLabel.text];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: message
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [Friend deleteFriendWithId:_memberID];
        [self.navigationController popViewControllerAnimated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }]];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)settleupBtnClicked:(id)sender {
    
    NSString *message=[NSString stringWithFormat:@"Do you want to settle up with  %@ ?",_nameLabel.text];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: message
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [Friend updatesettleupForFriendId:_memberID youOwe:[NSNumber numberWithFloat:0.0] owesYou:[NSNumber numberWithFloat:0.0]];
        [self.navigationController popViewControllerAnimated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }]];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    

}
- (IBAction)backbtnClicked:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Expenses2Detail"])
    {
        DetailedExpensesViewController *detailVC=[segue destinationViewController];
        
        NSIndexPath *selectedindex=[self.billDetailsTableView indexPathForSelectedRow];
        NSString *title=[_titlesArray objectAtIndex:selectedindex.section];
        NSMutableArray *tmp=[_arrangedBillsData objectForKey:title];
        Bill *billObj=[tmp objectAtIndex:selectedindex.row];
        
        detailVC.billObj=billObj;
        
    }
}

@end
