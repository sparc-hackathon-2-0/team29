//
//  ButlerProjectsViewController.h
//  SchoolButler
//
//  Created by Leland Long on 8/25/12.
//

#import <UIKit/UIKit.h>

@interface ButlerProjectsViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *projectIDArray;
@property (nonatomic, strong) NSMutableArray *projectTitleArray;
@property (nonatomic, strong) NSMutableArray *projectDueDateArray;

@end
