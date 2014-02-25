//
//  NSMutableURLRequest+Parse.h
//  Do-It
//
//  Created by Dan Brajkovic on 2/24/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Parse)

+ (NSMutableURLRequest *)requestWithResource:(NSString *)resource;

@end
