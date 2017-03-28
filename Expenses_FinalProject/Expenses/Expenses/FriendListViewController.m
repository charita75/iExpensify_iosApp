//
//  FriendListViewController.m
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "FriendListViewController.h"
#import "ExpensesListViewController.h"
#import "Friend.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // _friendListArray = [[NSMutableArray alloc] initWithObjects:@"Friend1", @"Friend2", @"Friend3", nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    _friendListArray= [Friend fetchAllFriendsRecords];
    [self.friendsListTableView reloadData];
    [self calculateTotal:_friendListArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_friendListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    Friend *friendObj=[_friendListArray objectAtIndex:indexPath.row];
  
    UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:4];
    UILabel* nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel* oweLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel* valueLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel* settleLabel = (UILabel *)[cell.contentView viewWithTag:5];

    NSLog(@"%@",friendObj.friendId);
    nameLabel.text=[NSString stringWithFormat:@"%@",friendObj.name];
    if([friendObj.youOwe floatValue] > [friendObj.owesYou floatValue]) {
    oweLabel.text=@"You Owe";
    oweLabel.textColor=[UIColor orangeColor];
        float bal = [friendObj.youOwe floatValue]-[friendObj.owesYou floatValue];
    valueLabel.text=[NSString stringWithFormat:@"$%.2f",bal];
    valueLabel.textColor=[UIColor orangeColor];
        settleLabel.text=@"";
    }else if([friendObj.youOwe floatValue] < [friendObj.owesYou floatValue]) {
        oweLabel.text=@"Owes You";
        oweLabel.textColor=[UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
        float bal = [friendObj.owesYou floatValue]-[friendObj.youOwe floatValue];
        valueLabel.text=[NSString stringWithFormat:@"$%.2f",bal];
        valueLabel.textColor=[UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
        settleLabel.text=@"";
    }else {
        settleLabel.text=@"settled up";
        valueLabel.text=@"";
        oweLabel.text=@"";
    }
    
    img.image=[UIImage imageNamed:[NSString stringWithFormat:@"Face"]];
    return cell;
}

- (void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self performSegueWithIdentifier:@"Friends2detailExpenses" sender:self];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Friends2detailExpenses"])
    {
        ExpensesListViewController *expensesVC=[segue destinationViewController];
        NSIndexPath *selectedindex=[self.friendsListTableView indexPathForSelectedRow];
        Friend *friendObj=[_friendListArray objectAtIndex:selectedindex.row];
        expensesVC.nameLabeltxt=friendObj.name;
        expensesVC.memberID=friendObj.friendId;
    }
        
}


- (IBAction)sendMail:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        NSString *totalbalance;
        NSString *friend1Name,*friend1Balance;
        NSString *friend2Name,*friend2Balance;
        NSString *friend3Name,*friend3Balance;
        
        if([_totalLabel.text floatValue] >0.0)
            totalbalance=[NSString stringWithFormat:@"Owes You $%@",_totalLabel.text];
        else
            totalbalance=[NSString stringWithFormat:@"You Owe $%@",_totalLabel.text];
        
        for(int i=0; i< _friendListArray.count ; i++) {
            Friend *friendObj=[_friendListArray objectAtIndex:i];
            if(i==0) {
               friend1Name=friendObj.name;
                friend1Balance=[self calculateBalance:friendObj];
            }
            else  if(i==1) {
                friend2Name=friendObj.name;
                friend2Balance=[self calculateBalance:friendObj];
            }
            else  if(i==2) {
                friend3Name=friendObj.name;
                friend3Balance=[self calculateBalance:friendObj];
            }


        }

        
        
        
        [mailCont setSubject:@"Email subject"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"varunmamindla@gmail.com"]];
        
        NSString *msgBody=[NSString stringWithFormat:@"<h4> Hi user </h4></br>December is over. <b>Here's the overview</b> of your account on iExpensify:</br></br><b>Total balance &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp	%@</br><hr />%@&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp %@ </br>%@&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp %@ </br> %@&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp %@ </br><hr />",totalbalance,friend1Name,friend1Balance,friend2Name,friend2Balance,friend3Name,friend3Balance];
        
        [mailCont setMessageBody:msgBody isHTML:YES];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Simulator cannont send Email"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancel];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alert animated:YES completion:nil];
        });
        

    }
    
}

    
-(NSString *) calculateBalance:(Friend *) friendObj {
    if([friendObj.youOwe floatValue] > [friendObj.owesYou floatValue]) {
        float bal = [friendObj.youOwe floatValue]-[friendObj.owesYou floatValue];
        NSString  *valueLabel =[NSString stringWithFormat:@"you Owe $%.2f",bal];
        return valueLabel;
       
    }else if([friendObj.youOwe floatValue] < [friendObj.owesYou floatValue]) {
        float bal = [friendObj.youOwe floatValue]-[friendObj.owesYou floatValue];
        NSString  *valueLabel =[NSString stringWithFormat:@"Owes You $%.2f",bal];
        return valueLabel;
    }else {
        
        NSString  *valueLabel =@"Settled Up";
        return valueLabel;
    }

    
}
    
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) calculateTotal:(NSMutableArray* ) friendListArray {
    float youOwetotal=0.0;
    float OwesYoutotal=0.0;
    
    for(int i=0; i< friendListArray.count ; i++) {
        Friend *friendObj=[_friendListArray objectAtIndex:i];
        if([friendObj.owesYou floatValue] > [friendObj.youOwe floatValue]) {
            OwesYoutotal = OwesYoutotal+([friendObj.owesYou floatValue]-[friendObj.youOwe floatValue]);
        }else {
            youOwetotal = youOwetotal + ([friendObj.youOwe floatValue]-[friendObj.owesYou floatValue]);
        }
        
    }
    
    
    float total = OwesYoutotal-youOwetotal;
    
    NSString *temp,*temp1;
    
    temp1=[NSString stringWithFormat:@"$%.2f",youOwetotal];
    temp=[NSString stringWithFormat:@"You Owe: %@", temp1 ];
   
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: self.youOweLabel.textColor,
                              NSFontAttributeName: self.youOweLabel.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:temp
                                           attributes:attribs];
    
    // green text attributes
    UIColor *orangeColor =[UIColor orangeColor];
    NSRange orangeTextRange = [temp rangeOfString:temp1];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:orangeColor}
                            range:orangeTextRange];
    _youOweLabel.attributedText=attributedText;
    
    
    
   // _owesYouLabel.text= [NSString stringWithFormat:@"Owes You: $%.2f", OwesYoutotal];
    
    temp1=[NSString stringWithFormat:@"$%.2f",OwesYoutotal];
    temp=[NSString stringWithFormat:@"Owes You: %@", temp1 ];
   // _youOweLabel.text =[NSString stringWithFormat:@"You Owe: $%.2f", youOwetotal ];
    NSDictionary *attribs1 = @{
                              NSForegroundColorAttributeName: self.owesYouLabel.textColor,
                              NSFontAttributeName: self.owesYouLabel.font
                              };
    NSMutableAttributedString *attributedText1 =
    [[NSMutableAttributedString alloc] initWithString:temp
                                           attributes:attribs1];
    
    // orange text attributes
    UIColor *greenColor = [UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
    NSRange greenTextRange = [temp rangeOfString:temp1];
    [attributedText1 setAttributes:@{NSForegroundColorAttributeName:greenColor}
                            range:greenTextRange];
    _owesYouLabel.attributedText=attributedText1;

    
    
    //_totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", total];
    if(total > 0.0) {
        temp1=[NSString stringWithFormat:@"$%.2f",total];
        temp=[NSString stringWithFormat:@"Total: %@", temp1 ];
        // _youOweLabel.text =[NSString stringWithFormat:@"You Owe: $%.2f", youOwetotal ];
        NSDictionary *attribs2 = @{
                                   NSForegroundColorAttributeName: self.totalLabel.textColor,
                                   NSFontAttributeName: self.totalLabel.font
                                   };
        NSMutableAttributedString *attributedText2 =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attribs2];
        
        // orange text attributes
        UIColor *greenColor = [UIColor colorWithRed:37/255.0 green:147/255.0 blue:8/255.0 alpha:1.0];
        NSRange greenTextRange = [temp rangeOfString:temp1];
        [attributedText2 setAttributes:@{NSForegroundColorAttributeName:greenColor}
                                 range:greenTextRange];
        _totalLabel.attributedText=attributedText2;

    }
    else {
        float temp3 = youOwetotal-OwesYoutotal;
        temp1=[NSString stringWithFormat:@"-$%.2f",temp3];
        temp=[NSString stringWithFormat:@"Total: %@", temp1 ];
        // _youOweLabel.text =[NSString stringWithFormat:@"You Owe: $%.2f", youOwetotal ];
        NSDictionary *attribs2 = @{
                                   NSForegroundColorAttributeName: self.totalLabel.textColor,
                                   NSFontAttributeName: self.totalLabel.font
                                   };
        NSMutableAttributedString *attributedText2 =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attribs2];
        
        // orange text attributes
        UIColor *orangeColor =[UIColor orangeColor];
        NSRange orangeTextRange = [temp rangeOfString:temp1];
        [attributedText2 setAttributes:@{NSForegroundColorAttributeName:orangeColor}
                                 range:orangeTextRange];
        _totalLabel.attributedText=attributedText2;
    }
    
    
}

@end
