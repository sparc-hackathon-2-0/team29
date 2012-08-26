//
//  ButlerProjectsViewController.m
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import "ButlerProjectsViewController.h"
#import "ButlerProjectsDetailViewController.h"
#import "ButlerAppDelegate.h"

@implementation ButlerProjectsViewController

@synthesize projectIDArray, projectTitleArray, projectDueDateArray;
@synthesize addProjectFlag;



#pragma mark - Add button



- (IBAction)handleAddButton:(id)sender
{

        NSString *message = [[NSString alloc] initWithFormat:@"Create a new Project?"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
    
}



#pragma mark - Alert Delegate methods



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.title == @"Confirm") {
        if (buttonIndex == 0) { 
            // Cancel button
        } else if (buttonIndex == 1) { 
            // Yes button
            addProjectFlag = YES;
            [self performSegueWithIdentifier:@"ProjectDetail" sender:self];
        }
    }
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [projectIDArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"projectsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if ([projectIDArray count] > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [projectTitleArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [projectDueDateArray objectAtIndex:indexPath.row]];
    } else {
        cell.textLabel.text = @"project not found";
    }
    
    
    
    return cell;
}



#pragma mark - Segue handler



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ProjectDetail"])
    {
        ButlerProjectsDetailViewController *vc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        if (addProjectFlag) {
            vc.incomingRow = 0;  // flag for new Project
        } else {
            vc.incomingRow = path.row + 1;  // index starts at 0, ID's start at 1
        }
    }
}



#pragma mark - View lifecycle



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    addProjectFlag = NO;
    
    // Load data from CoreData into local Model
    ButlerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Projects" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"kp_ProjectID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Error, viewDidLoad - no objects returned!");
    } else {
        // compile local array
        projectIDArray = [[NSMutableArray alloc] initWithCapacity:1];
        projectTitleArray = [[NSMutableArray alloc] initWithCapacity:1];
        projectDueDateArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSManagedObject *oneObject in objects) {
            [projectIDArray addObject:[oneObject valueForKey:@"kp_ProjectID"]];
            [projectTitleArray addObject:[oneObject valueForKey:@"projectTitle"]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yy"];
            NSString *dateString = [dateFormat stringFromDate:[oneObject valueForKey:@"dueDate"]];
            [projectDueDateArray addObject:dateString];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
