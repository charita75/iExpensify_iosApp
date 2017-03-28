//
//  AddMemberViewController.m
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "AddMemberViewController.h"
#import "Friend.h"

@interface AddMemberViewController ()

@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _friendListArray = [[NSMutableArray alloc] initWithObjects:@"Friend1", @"Friend2", @"Friend3", nil];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"plist"];
     _membersArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _searchResults=[[NSMutableArray alloc] initWithArray:_membersArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
  
    
    // Configure the cell...
    
    
    cell.textLabel.text=[_searchResults objectAtIndex:indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tileMessage=[NSString stringWithFormat:@"Do you want to add %@ to you friends list",_searchResults[indexPath.row]];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:tileMessage
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self  yesButtonClicked:_searchResults[indexPath.row]];
    }]];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];

    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alert animated:YES completion:nil];
    });

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length]==0) {
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:_membersArray];
    }
    else {
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF beginswith[c] %@",
                             searchText];
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:[_membersArray filteredArrayUsingPredicate:resultPredicate]];
        //_searchResults = [_membersArray filteredArrayUsingPredicate:resultPredicate];
    }
    [self.tableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    // Hide the cancel button
    //searchBar.showsCancelButton = false;
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:_membersArray];
    [self.tableView reloadData];
}

-(void) yesButtonClicked:(NSString *)name {
    
    NSString *message=[NSString stringWithFormat:@"Please enter the Email address of %@",name];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Email"
                                                                              message: message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"email";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType= UIKeyboardTypeEmailAddress;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * emailfield = textfields[0];
        [self addSelectedFriendToDatabase:name emailAddress:emailfield.text];
    }]];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) addSelectedFriendToDatabase:(NSString *) friendName emailAddress:(NSString *) email {
    NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    int records= (int)[data integerForKey:@"Record"];
    //int records=[Friend getNumberOfFriendsRecords];
    [Friend addFriendWithId:[NSNumber numberWithInt:(records+1)] name:friendName email:email youowe:[NSNumber numberWithFloat:0.00] owesyou:[NSNumber numberWithFloat:0.00]];
    records=records+1;
    [data setInteger:records forKey:@"Record"];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
