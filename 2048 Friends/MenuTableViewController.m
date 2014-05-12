//
//  MenuTableViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/27/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "MenuTableViewController.h"
#import "Theme.h"
#import "HistoriesTableViewController.h"
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action: @selector(dismissNavigationBarController)];
	doneButton.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = doneButton;
	// Set some colors
	self.navigationController.navigationBar.backgroundColor = self.theme.tileColors[@(8)];
	self.view.backgroundColor = self.theme.backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissNavigationBarController {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"MenuShareCell";
	if (indexPath.section == 0) {
		cellIdentifier = @"MenuShareCell";
	} else if (indexPath.section == 1) {
		cellIdentifier = @"MenuLoginCell";
	} else if (indexPath.section == 2) {
		cellIdentifier = @"MenuThemeCell";
	} else if (indexPath.section == 3) {
		cellIdentifier = @"MenuHistoriesCell";
	}
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	if (indexPath.section%2 == 0) {
		cell.backgroundColor = self.theme.tileColors[@(2)];
	} else {
		cell.backgroundColor = self.theme.tileColors[@(4)];
	}
	if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		cell.accessoryView.tintColor = [UIColor whiteColor];
		cell.accessoryView.backgroundColor = [UIColor whiteColor];
	}
    cell.layer.cornerRadius = self.theme.buttonCornerRadius;
	cell.layer.masksToBounds = YES;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MenuToHistoriesSegue"]) {
		HistoriesTableViewController *hTableViewController = segue.destinationViewController;
		hTableViewController.gManager = [GameManager sharedGameManager];
		hTableViewController.histories = [History allHistories];
	}
}


@end
