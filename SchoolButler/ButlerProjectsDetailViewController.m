//
//  ButlerProjectsDetailViewController.m
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import "ButlerProjectsDetailViewController.h"
#import "ButlerAppDelegate.h"



int const ProjectsDetailTextFieldCount = 3;



@implementation ButlerProjectsDetailViewController

@synthesize titleField, startDateField, dueDateField;
@synthesize incomingRow, storedButton, textFieldBeingEdited, textFieldOriginalValues;
@synthesize projectID, projectTitle, projectStartDate, projectDueDate;



#pragma mark - TextField Delegate



- (void)resetTextFieldsToOriginalValues
{
    for (int index = 0; index < ProjectsDetailTextFieldCount; index++) {
        switch (index) {
            case 0:
                titleField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            case 1:
                startDateField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            case 2:
                dueDateField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            default:
                NSLog(@"(resetTextFieldsToOriginalValues) switch(%d) invalid index!!", index);
                break;
        }
    }
}

- (IBAction)save:(id)sender
{
    ButlerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
        
    // send data to model
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Projects" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(kp_ProjectID = %d)", incomingRow];
    [request setPredicate:pred];
    [request setEntity:entityDescription];
    
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (objects == nil) {
        NSLog(@"(save)There was an error finding the ID!");
    }
   NSManagedObject *theData = [objects objectAtIndex:0];
    [theData setValue:[NSNumber numberWithInt:incomingRow] forKey:@"kp_ProjectID"];
    [theData setValue:titleField.text forKey:@"projectTitle"];
    
    // convert dates to strings
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:startDateField.text];
    [theData setValue:dateFromString forKey:@"startDate"];
    
    dateFromString = [dateFormatter dateFromString:dueDateField.text];
    [theData setValue:dateFromString forKey:@"dueDate"];
    
    [context save:&error];
    
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [textFieldBeingEdited resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    self.navigationItem.leftBarButtonItem = storedButton;
    self.navigationItem.rightBarButtonItem = nil;
    [textFieldBeingEdited resignFirstResponder];
    [self resetTextFieldsToOriginalValues];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL needsKeyboard = NO;
    [textFieldBeingEdited resignFirstResponder];
    textFieldBeingEdited = textField;
    
    // Add 2 buttons to Nav Bar: Save & Cancel
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    switch (textField.tag) {
        case 0:                     // titleField
            needsKeyboard = YES;
            break;
            
        case 1:                     // startDateField
            needsKeyboard = YES;
            //[self showTypePicker:textField];
            break;
            
        case 2:                     // dueDateField
            needsKeyboard = YES;
            //[self showDatePicker:textField];
            break;
            
        default:
            NSLog(@"switch (textFieldShouldBeginEditing) out of range!");
            break;
    }
    
    // Handle keyboard appearing
    return needsKeyboard;
}

- (IBAction)textFieldDone:(id)sender {
    [sender resignFirstResponder];
}



#pragma mark - View lifecycle



- (void)viewDidLoad
{
    // Load data from CoreData into local Model
    ButlerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Projects" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSLog(@"Row selected: %d", incomingRow);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(kp_ProjectID = %d)", incomingRow];
    [request setPredicate:pred];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Error, viewDidLoad - no objects returned!");
    } else {
        
        // compile local array
        for (NSManagedObject *oneObject in objects) {
            projectID = [oneObject valueForKey:@"kp_ProjectID"];
            projectTitle = [oneObject valueForKey:@"projectTitle"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yy"];
            NSString *dateString = [dateFormat stringFromDate:[oneObject valueForKey:@"dueDate"]];
            projectDueDate = dateString;
            projectStartDate = dateString;
        }
    }
    
    // configure static cells...
    titleField.text = projectTitle;
    dueDateField.text = projectDueDate;
    
    // capture initial values (for edit.cancel)
    textFieldOriginalValues = [[NSMutableArray alloc] initWithCapacity:ProjectsDetailTextFieldCount];
    // initialize our array
    [textFieldOriginalValues addObject:projectTitle];
    [textFieldOriginalValues addObject:projectStartDate];
    [textFieldOriginalValues addObject:projectDueDate];
    
    // Store left Nav button so that Cancel can restore it
    storedButton = self.navigationItem.leftBarButtonItem;
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:app];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
