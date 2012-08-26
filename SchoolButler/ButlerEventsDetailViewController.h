//
//  ButlerEventsDetailViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerEventsDetailViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate>

// tableView
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UITextField *startDateField;
@property (nonatomic, strong) IBOutlet UITextField *endDateField;

// local ivars
@property NSInteger incomingRow;
@property (nonatomic, strong) UIBarButtonItem *storedButton;
@property (nonatomic, strong) UITextField *textFieldBeingEdited;
@property (nonatomic, strong) NSMutableArray *textFieldOriginalValues;
@property (nonatomic, strong) UIDatePicker *datePicker;

// coreData
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *eventEndDate;

@end
