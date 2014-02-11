//
//  TaskViewController.m
//  Do-It
//
//  Created by Dan Brajkovic on 2/10/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import "TaskViewController.h"


@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.nameLabel.text = self.task.name;
}

@end
