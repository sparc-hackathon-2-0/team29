//
//  ButlerEventsViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerEventsViewController : UITableViewController <UITableViewDataSource>

// coreData
@property (nonatomic, strong) NSMutableArray *eventIDArray;
@property (nonatomic, strong) NSMutableArray *eventTitleArray;
@property (nonatomic, strong) NSMutableArray *eventEndDateArray;

// local ivars
@property BOOL addProjectFlag;

- (IBAction)handleAddButton:(id)sender;

@end
