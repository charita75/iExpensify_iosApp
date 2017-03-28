//
//  AddBillViewController.m
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "AddBillViewController.h"
#import "Bill.h"
#import "Friend.h"

@interface AddBillViewController () {
    int display;
}

@end

@implementation AddBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.categoryTextField.inputView=self.categoryPicker;
    [self addBorderToTextField];
    [self initializePickerView];
    self.categoryTextField.delegate=self;
    //self.billNumber =[NSNumber numberWithInt:-1];
    display=1;
    if(display==1)
        [self resetFields];
    if(self.billNumber  != NULL) {
        [self updateUI];
    }
}

-(void) viewWillAppear:(BOOL)animated {
     [self loadFriendsData];
    
   
    
}

-(void) resetFields {
    [_categoryImageView setTitle:@"Add Image" forState:UIControlStateNormal];
    [_categoryImageView setBackgroundImage:nil forState:UIControlStateNormal];
    self.categoryTextField.text=@"";
    self.amountTextField.text=@"";
    self.paidbyLbl.text=@"You";
    display=0;
}

-(void)updateUI {
    self.navigationController.navigationBar.translucent = NO;
     [_categoryImageView setTitle:@"" forState:UIControlStateNormal];
     [_categoryImageView setBackgroundImage:[UIImage imageWithData:self.billObject.image] forState:UIControlStateNormal];
    if(self.billObject.friendId > 0) {
        self.paidbyLbl.text=[Friend getFriendNameWhoseId:self.billObject.friendId];
        _paidFriendId=self.billObject.friendId;
    }
    else
        self.paidbyLbl.text=@"You";
    self.categoryTextField.text=self.billObject.category;
    self.amountTextField.text=[self.billObject.amount stringValue];

}
-(void) addBorderToTextField {
    UITextField *myTextField = (UITextField *)[self.view viewWithTag:1];
    UITextField *myTextField1 = (UITextField *)[self.view viewWithTag:2];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    
    border.frame = CGRectMake(0, myTextField.frame.size.height - borderWidth, myTextField.frame.size.width, myTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [myTextField.layer addSublayer:border];
    myTextField.layer.masksToBounds = YES;
    
    CALayer *border1 = [CALayer layer];
    CGFloat borderWidth1 = 2;
    border1.borderColor = [UIColor darkGrayColor].CGColor;
    
    border1.frame = CGRectMake(0, myTextField1.frame.size.height - borderWidth1, myTextField1.frame.size.width, myTextField1.frame.size.height);
    border1.borderWidth = borderWidth1;
    
    [myTextField1.layer addSublayer:border1];
    myTextField1.layer.masksToBounds = YES;
}

-(void) initializePickerView {
    //initialize data
    _pickerData=@[@"Grocery", @"Utilities", @"Entertainment", @"Transportation", @"Food", @"other"];
    
}

-(void) loadFriendsData {
    
    _friendListArray=[Friend fetchAllFriendsRecords];
    
    _searchResults=[[NSMutableArray alloc] initWithArray:_friendListArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == _categoryTextField) {
        
        self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 250, 180, 193)];
        self.categoryPicker.delegate = self;
        self.categoryPicker.dataSource = self;
        [[UIPickerView appearance] setBackgroundColor:[UIColor blackColor]];
        self.categoryTextField.inputView=self.categoryPicker;

    }
    return YES;
       
}


#pragma mark - Picker View data source

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
     NSString *temp = [_pickerData objectAtIndex:row];
    
    self.categoryTextField.text=temp;
    [_categoryImageView setTitle:@"" forState:UIControlStateNormal];
    if([temp isEqualToString:@"Transportation"])
        [_categoryImageView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Transportaion"]] forState:UIControlStateNormal];
        
    else if([temp isEqualToString:@"Food"])
         [_categoryImageView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Food"]] forState:UIControlStateNormal];
    else if([temp isEqualToString:@"Entertainment"])
         [_categoryImageView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Entertainment"]] forState:UIControlStateNormal];
    else if([temp isEqualToString:@"Grocery"])
         [_categoryImageView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Groceries"]] forState:UIControlStateNormal];
    else
        [_categoryImageView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"receipt"]] forState:UIControlStateNormal];
    //self.categoryPicker.hidden=true;
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)]; // your frame, so picker gets "colored"
    //label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text =_pickerData[row];
    
    return label;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.friendsView.hidden=YES;
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:_friendListArray];
    self.friendSearchBar.text=@"";
    [self.view endEditing:YES];
    
}

- (IBAction)categoryImageViewBtn_Clicked:(id)sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Upload a Picture using"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Photos or Libraries" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self  openLibrary];
    }]];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}

- (IBAction)savebtnClicked:(id)sender {
    //[UIImage imageNamed:[NSString stringWithFormat:@"Transportaion"]]
    NSString * category = _categoryTextField.text;
    
    NSString * amount = _amountTextField.text;
    UIImage *image = _categoryImageView.currentBackgroundImage;//[UIImage imageNamed:[NSString stringWithFormat:@"Transportaion"]];
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 0.0);
    NSMutableArray * allBillsArray= [Bill fetchAllBills];
    if([self.paidbyLbl.text isEqualToString:@"You"]) {
        _paidFriendId=0;
        
    }
    NSDate *addedDate=[NSDate date];
    
    if(self.billNumber !=NULL ) {
          [self updateFriendsDetailsForUpdatedBill:self.billObject.amount paidFriendId:self.billObject.friendId];
        [Bill updateBillWithId:self.billObject.billId friendId:_paidFriendId billCategory:category totalAmount:[NSNumber numberWithFloat:[amount floatValue]]  image:dataImage billAdded:addedDate];
        self.billNumber=NULL;
      
        [self updateFriendsDetails:[NSNumber numberWithFloat:[amount floatValue]] paidFriendId:_paidFriendId];
        //[self callAlert:@"Bill Updated Successfully"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else {
    [Bill addBillWithId:[NSNumber numberWithInt:((int)[allBillsArray count]+1)] friendId:_paidFriendId billCategory:category totalAmount:[NSNumber numberWithFloat:[amount floatValue]]  image:dataImage billAdded:addedDate];
    [self updateFriendsDetails:[NSNumber numberWithFloat:[amount floatValue]] paidFriendId:_paidFriendId];
        [self callAlert:@"Bill Added Successfully"];
    }
    
}

-(void) callAlert :(NSString *)title {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alert animated:YES completion:nil];
    });

    [self resetFields];

}

- (void) openCamera {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(isCamera == YES) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Cannot Access Camera"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alert animated:YES completion:nil];
        });

    }
    
    
}

-(void) openLibrary {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     [_categoryImageView setTitle:@"" forState:UIControlStateNormal];
    [_categoryImageView setBackgroundImage:chosenImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Friend *frndObj=[_searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = frndObj.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    Friend *frndObj=[_searchResults objectAtIndex:indexPath.row ];
    NSString *name=frndObj.name;
    self.paidbyLbl.text=name;
    self.paidFriendId = frndObj.friendId;
    self.friendsView.hidden=YES;
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:_friendListArray];
    self.friendSearchBar.text=@"";
    [self.view endEditing:YES];
}


#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
    if([searchText length]==0) {
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:_friendListArray];
    }
    else {
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"name beginswith[c] %@",
                                        searchText];
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:[_friendListArray filteredArrayUsingPredicate:resultPredicate]];
    }
    
 [self.friendsTableView reloadData];
 
 
 }


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    // Hide the cancel button
    //searchBar.showsCancelButton = false;
    [_searchResults removeAllObjects];
    [_searchResults addObjectsFromArray:_friendListArray];
      self.friendsView.hidden=YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //self.view.hidden=YES;
    self.friendsView.hidden=NO;
    
    [self.view addSubview:self.friendsView];
    [self.friendsTableView reloadData];
    
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void) updateFriendsDetails:(NSNumber *) amount paidFriendId:(NSNumber *)friendId {
    NSMutableArray * friendsArray= [Friend fetchAllFriendsRecords];
    int count = (int)[friendsArray count]+1;
    float billEachMemberAmount = [amount floatValue]/count;
    if(friendId==0) {
        for(int i=0; i<(count-1) ; i++) {
            Friend * friendObj= [friendsArray objectAtIndex:i] ;
            float intialAmount=[friendObj.owesYou floatValue];
            float updatedAmount = intialAmount+billEachMemberAmount;
            [Friend updateBalanceForFriendId:friendObj.friendId youOwe:friendObj.youOwe owesYou:[NSNumber numberWithFloat:updatedAmount]];
            
        }
    }else {
        Friend * friendObj=[Friend getFriendRecordWithID:friendId];
        float intialAmount=[friendObj.youOwe floatValue];
        float updatedAmount = intialAmount+billEachMemberAmount;
        [Friend updateBalanceForFriendId:friendObj.friendId youOwe:[NSNumber numberWithFloat:updatedAmount] owesYou:friendObj.owesYou];

    }
}

-(void) updateFriendsDetailsForUpdatedBill:(NSNumber *) amount paidFriendId:(NSNumber *)friendId {
    NSLog(@"initaiamount %@ id %@",amount,friendId);
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
