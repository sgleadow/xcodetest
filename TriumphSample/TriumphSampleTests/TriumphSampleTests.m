//
//  TriumphSampleTests.m
//  TriumphSampleTests
//
//  Created by Stewart Gleadow on 16/07/12.
//  Copyright (c) 2012 Stewart Gleadow. All rights reserved.
//

#import "TriumphSampleTests.h"

@implementation TriumphSampleTests

- (void)testSampleThatRequiresTheUIKitEnvironment
{
    STAssertNotNil([UIApplication sharedApplication].delegate, @"There should be an app delegate");
}

@end
