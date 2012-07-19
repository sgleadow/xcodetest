//
//  SGXcodeTest.m
//  XcodeTest
//
//  Created by Stewart Gleadow on 16/07/12.
//  Copyright (c) 2012 Stewart Gleadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import <dlfcn.h>

@interface SGXcodeTest : NSObject
@end

@implementation SGXcodeTest

+ (void)load
{
    char *unitTestPath = getenv("XCODE_TEST_PATH");
    assert(unitTestPath != NULL);
    
    void *loadedTests = NULL;
    loadedTests = dlopen(unitTestPath, RTLD_NOW);
    assert(loadedTests != NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:@"UIApplicationDidBecomeActiveNotification" 
                                               object:nil];
}

+ (void)applicationDidBecomeActive:(NSNotification *)notification
{
    SenSelfTestMain();
}

@end
