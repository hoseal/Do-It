//
//  NSMutableURLRequest+Parse.m
//  Do-It
//
//  Created by Dan Brajkovic on 2/24/14.
//  Copyright (c) 2014 Dan Brajkovic. All rights reserved.
//

#import "NSMutableURLRequest+Parse.h"

static NSString *kBaseURL = @"https://api.parse.com/1/classes/";
static NSString *kApplicationId = @"iwudTs5VNNrbr8ZjRH7xHi4wdBhm2cpZekyQXs7Z";
static NSString *kRESTId = @"LxtQGwtvbZWdBGH4GqiakX8gccMJ9EHj3a6uGqHv";

@implementation NSMutableURLRequest (Parse)

+ (NSMutableURLRequest *)requestWithResource:(NSString *)resource
{
    NSString *urlString = [kBaseURL stringByAppendingString:resource];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:kApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:kRESTId forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [defaults stringForKey:@"SessionToken"];
    if (sessionToken) {
        [request addValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}

@end
