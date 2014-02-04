//
//  NewTaskViewController.m
//  Do-It
//
//  Created by Dan Brajkovic on 1/30/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import "NewTaskViewController.h"
#import "TasksViewController.h"
#import "Task.h"

@interface NewTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end

@implementation NewTaskViewController


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    UINavigationController *navVC = (UINavigationController *)self.presentingViewController;
    TasksViewController *tasksVC = (TasksViewController*)navVC.topViewController;
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                  inManagedObjectContext:self.context];
    newTask.name = self.taskTextField.text;
    [self.context save:nil];
    [tasksVC.tasks addObject:newTask];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
