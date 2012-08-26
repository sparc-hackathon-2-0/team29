//
//  ButlerClassesViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerClassesViewController : UITableViewController <UITableViewDataSource>

// coreData
@property (nonatomic, strong) NSMutableArray *classIDArray;
@property (nonatomic, strong) NSMutableArray *classTitleArray;
@property (nonatomic, strong) NSMutableArray *classEndDateArray;

// local ivars
@property BOOL addProjectFlag;

- (IBAction)handleAddButton:(id)sender;

@end
