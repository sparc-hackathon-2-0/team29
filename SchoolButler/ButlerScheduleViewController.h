//
//  ButlerScheduleViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerScheduleViewController : UITableViewController <UITableViewDataSource>

// coreData
@property (nonatomic, strong) NSMutableArray *classIDArray;
@property (nonatomic, strong) NSMutableArray *classTitleArray;
@property (nonatomic, strong) NSMutableArray *classEndDateArray;

// local ivars
@property BOOL addProjectFlag;

@end
