//
//  ButlerProjectsDetailViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerProjectsDetailViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>

// tableView
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UITextField *startDateField;
@property (nonatomic, strong) IBOutlet UITextField *dueDateField;

// local ivars
@property NSInteger incomingRow;
@property (nonatomic, strong) UIBarButtonItem *storedButton;
@property (nonatomic, strong) UITextField *textFieldBeingEdited;
@property (nonatomic, strong) NSMutableArray *textFieldOriginalValues;

// coreData
@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) NSString *projectTitle;
@property (nonatomic, strong) NSString *projectStartDate;
@property (nonatomic, strong) NSString *projectDueDate;

@end
