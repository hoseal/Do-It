//
//  TasksViewController.h
//  Do-It
//
//  Created by Dan Brajkovic on 1/27/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
