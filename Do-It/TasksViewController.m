//
//  TasksViewController.m
//  Do-It
//
//  Created by Dan Brajkovic on 1/27/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import "TasksViewController.h"
#import "Task.h"
#import "NewTaskViewController.h"
#import "TaskViewController.h"

@interface TasksViewController ()

@end

@implementation TasksViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithResource:@"Task"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger status = [(NSHTTPURLResponse*)response statusCode];
                               NSLog(@"Status code %d", status);
                               id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSArray *objects = [jsonObject valueForKey:@"results"];
                               [self.context reset];
                               self.tasks = [NSMutableArray array];
                               for (NSDictionary *object in objects) {
                                   Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                                                 inManagedObjectContext:self.context];
                                   [newTask setValuesForKeysWithDictionary:object];
                                   [self.tasks addObject:newTask];
                               }
                               [self.tableView reloadData];
                           }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewTaskSegue"]) {
        UINavigationController *navVC = (UINavigationController *)segue.destinationViewController;
        NewTaskViewController *newTaskVC = navVC.viewControllers[0];
        newTaskVC.context = self.context;
    } else if ([segue.identifier isEqualToString:@"TaskDetailsSegue"]) {
        TaskViewController *taskVC = (TaskViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Task *task = self.tasks[indexPath.row];
        taskVC.task = task;
    }
    
}

- (void)checkButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGPoint origin = button.frame.origin;
    CGPoint translatedPoint = [button convertPoint:origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:translatedPoint];
    Task *task = self.tasks[indexPath.row];
    [button setSelected:!button.isSelected];
    task.completed = [NSNumber numberWithBool:button.isSelected];
    NSString *resource = [NSString stringWithFormat:@"Task/%@", task.objectId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithResource:resource];
    [request setHTTPMethod:@"PUT"];
    NSDictionary *dict = [task dictionaryWithValuesForKeys:@[@"name", @"completed"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [request setHTTPBody:jsonData];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger status = [(NSHTTPURLResponse*)response statusCode];
                               NSLog(@"Status code %d", status);
                           }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Task *task = [self.tasks objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:11];
    nameLabel.text = task.name;
    UIButton *doneButton = (UIButton *)[cell viewWithTag:10];
    if ([task.completed isEqual:@YES]) {
        [doneButton setSelected:YES];
    }
    [doneButton addTarget:self
                   action:@selector(checkButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Task *task = self.tasks[indexPath.row];
        [self.context deleteObject:task];
        [self.tasks removeObject:task];
        
        NSString *resource = [NSString stringWithFormat:@"Task/%@", task.objectId];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithResource:resource];
        [request setHTTPMethod:@"DELETE"];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSInteger status = [(NSHTTPURLResponse*)response statusCode];
                                   NSLog(@"Status code %d", status);
                               }];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


@end
