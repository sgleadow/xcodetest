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
    loadedTests = dlopen([self unitTestObjectFilePath], RTLD_NOW);
    assert(loadedTests != NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:@"UIApplicationDidBecomeActiveNotification" 
                                               object:nil];
}

+ (char *)unitTestObjectFilePath
{
    char *unitTestPath = getenv("TR_UNIT_TEST_PATH");
    assert(unitTestPath != NULL);
    return unitTestPath;
}

+ (void)applicationDidBecomeActive:(NSNotification *)notification
{
    SenSelfTestMain();
}

@end
