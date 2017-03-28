//
//  HomeViewController.m
//  Expenses
//
//  Created by  on 9/28/16.
//  Copyright © 2016 uhcl. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTabBarUI];
}

-(void)loadTabBarUI {
    
    UITabBarItem *firstTab = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *secondTab = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *thirdTab = [self.tabBar.items objectAtIndex:2];
    
    firstTab.image = [[UIImage imageNamed:[NSString stringWithFormat:@"friends"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    firstTab.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"friends"]]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    secondTab.image = [[UIImage imageNamed:[NSString stringWithFormat:@"member"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondTab.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"member"]]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    thirdTab.image = [[UIImage imageNamed:[NSString stringWithFormat:@"receipt"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    thirdTab.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"receipt"]]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:65/255.0 green:181/255.0 blue:178/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
