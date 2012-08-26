//
//  ButlerScheduleDetailViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerScheduleDetailViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate>

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
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *classStartDate;
@property (nonatomic, strong) NSString *classEndDate;

@end
