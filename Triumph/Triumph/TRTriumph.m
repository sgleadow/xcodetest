//
//  Triumph.m
//  Triumph
//
//  Created by Stewart Gleadow on 16/07/12.
//  Copyright (c) 2012 Stewart Gleadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import <dlfcn.h>

@interface TRTriumph : NSObject
@end

@implementation TRTriumph

+ (void)load
{
    void *loadedTests = NULL;
    loadedTests = dlopen("/Users/sgleadow/Dropbox/Documents/Tech/Testing/unit-test-runner/output/TriumphSampleTests.octest/TriumphSampleTests", RTLD_NOW);
    assert(loadedTests != NULL);
    
    // Try and load one of the test classes
    // TODO: this check needs to go in the final version
    if (NSClassFromString(@"TriumphSampleTests"))
    {
        printf("Could find test\n");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:@"UIApplicationDidBecomeActiveNotification" 
                                               object:nil];
}

+ (void)applicationDidBecomeActive:(NSNotification *)notification
{
    NSLog(@"\n\n\n==============\nLibrary loaded and automatically hooked into applicationDidBecomeActive\n==============\n\n\n");
    
    SenSelfTestMain();
}

@end
