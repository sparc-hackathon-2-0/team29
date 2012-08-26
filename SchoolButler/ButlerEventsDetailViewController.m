//
//  ButlerEventsDetailViewController.m
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import "ButlerEventsDetailViewController.h"
#import "ButlerAppDelegate.h"



int const EventsDetailTextFieldCount = 3;



@implementation ButlerEventsDetailViewController

@synthesize titleField, startDateField, endDateField;
@synthesize incomingRow, storedButton, textFieldBeingEdited, textFieldOriginalValues, datePicker;
@synthesize eventID, eventTitle, eventStartDate, eventEndDate;



#pragma mark - New Event



- (void)createNewEvent
{
    NSLog(@"createNewEvent...");
    [self.titleField becomeFirstResponder];
}



#pragma mark - iPhone Picker Delegate Methods



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0) {
        // Cancel
    } else if (buttonIndex == 1) {
        // Save
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yy"];
        NSString *rawStr = [dateFormat stringFromDate:datePicker.date];
        textFieldBeingEdited.text = rawStr;
    }
}

- (void) showDatePicker:(id)sender {
    // iPhone uses a UIDatePicker added to a UIActionSheet, this controller acting as dataSource and delegate for the picker
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:textFieldBeingEdited.text delegate:self cancelButtonTitle:@"Save" destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,185,0,0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [menu addSubview:datePicker];
    [menu showFromTabBar:self.tabBarController.tabBar];
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            [menu setBounds:CGRectMake(0,0,320, 700)];
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            [menu setBounds:CGRectMake(0,0,320, 700)];
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            [menu setBounds:CGRectMake(0,0,480, 460)];
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            [menu setBounds:CGRectMake(0,0,480, 460)];
            break;
    }
    
    UITextField *theField = sender;
    NSString *dateString = [[NSString alloc] initWithString:theField.text];
    if (![dateString isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        
        [datePicker setDate:dateFromString animated:YES];
    }
    
    
}



#pragma mark - TextField Delegate



- (void)resetTextFieldsToOriginalValues
{
    for (int index = 0; index < EventsDetailTextFieldCount; index++) {
        switch (index) {
            case 0:
                titleField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            case 1:
                startDateField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            case 2:
                endDateField.text = [textFieldOriginalValues objectAtIndex:index];
                break;
                
            default:
                NSLog(@"(resetTextFieldsToOriginalValues) switch(%d) invalid index!!", index);
                break;
        }
    }
}

- (IBAction)save:(id)sender
{
    // no empty fields allowed...
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy"];
    NSString *rawStr = [dateFormat stringFromDate:[NSDate date]];
    if ([titleField.text isEqualToString:@""]) {
        titleField.text = @"(no name)";
    }
    if ([startDateField.text isEqualToString:@""]) {
        startDateField.text = rawStr;
    }
    if ([endDateField.text isEqualToString:@""]) {
        endDateField.text = rawStr;
    }
    
    // create/update coreData model
    ButlerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    if (incomingRow == 0) {
        // new project
        
        // Find all Projects
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        NSMutableArray *projectIDArray = [[NSMutableArray alloc] initWithCapacity:1];
        if (objects == nil) {
            NSLog(@"Error, save - no objects returned!");
        } else {
            // compile local array
            for (NSManagedObject *oneObject in objects) {
                [projectIDArray addObject:[oneObject valueForKey:@"kp_EventID"]];
            }
        }
        
        
        NSManagedObject *theLine = nil;
        theLine = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:context];
        
        // title
        int existingCount = [projectIDArray count];
        [theLine setValue:[NSNumber numberWithInt:existingCount + 1] forKey:@"kp_EventID"];
        [theLine setValue:titleField.text forKey:@"eventName"];
        
        // convert string to date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        
        // startDate
        dateFromString = [dateFormatter dateFromString:startDateField.text];
        [theLine setValue:dateFromString forKey:@"startDate"];
        
        // dueDate
        dateFromString = [dateFormatter dateFromString:endDateField.text];
        [theLine setValue:dateFromString forKey:@"endDate"];
        
        [context save:&error];
    } else {
        // save/update existing record
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(kp_EventID = %d)", incomingRow];
        [request setPredicate:pred];
        [request setEntity:entityDescription];
        
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        if (objects == nil) {
            NSLog(@"(save)There was an error finding the ID!");
        }
        NSManagedObject *theData = [objects objectAtIndex:0];
        [theData setValue:[NSNumber numberWithInt:incomingRow] forKey:@"kp_EventID"];
        [theData setValue:titleField.text forKey:@"eventName"];
        
        // convert dates to strings
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        
        dateFromString = [dateFormatter dateFromString:startDateField.text];
        [theData setValue:dateFromString forKey:@"startDate"];
        
        dateFromString = [dateFormatter dateFromString:endDateField.text];
        [theData setValue:dateFromString forKey:@"endDate"];
        
        [context save:&error];
    }    
    
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
            needsKeyboard = NO;
            [self showDatePicker:textField];
            break;
            
        case 2:                     // endDateField
            needsKeyboard = NO;
            [self showDatePicker:textField];
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
    if (incomingRow == 0) {
        // new Project triggered
        [self.titleField becomeFirstResponder];
    } else {
        // Load data from CoreData into local Model
        ButlerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(kp_EventID = %d)", incomingRow];
        [request setPredicate:pred];
        [request setEntity:entityDescription];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if (objects == nil) {
            NSLog(@"Error, viewDidLoad - no objects returned!");
        } else {
            
            // compile local array
            for (NSManagedObject *oneObject in objects) {
                eventID = [oneObject valueForKey:@"kp_EventID"];
                eventTitle = [oneObject valueForKey:@"eventName"];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yy"];
                NSString *dateString = [dateFormat stringFromDate:[oneObject valueForKey:@"startDate"]];
                eventStartDate = dateString;
                dateString = [dateFormat stringFromDate:[oneObject valueForKey:@"endDate"]];
                eventEndDate = dateString;
            }
        }
        
        // configure static cells...
        titleField.text = eventTitle;
        startDateField.text = eventStartDate;
        endDateField.text = eventEndDate;
        
        
        // capture initial values (for edit.cancel)
        textFieldOriginalValues = [[NSMutableArray alloc] initWithCapacity:EventsDetailTextFieldCount];
        // initialize our array
        [textFieldOriginalValues addObject:eventTitle];
        [textFieldOriginalValues addObject:eventStartDate];
        [textFieldOriginalValues addObject:eventEndDate];
    }
    
    // Store left Nav button so that Cancel can restore it
    storedButton = self.navigationItem.leftBarButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
