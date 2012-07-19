//
//  XcodeTestSampleFailingTests.m
//  TriumphSampleTests
//
//  Created by Stewart Gleadow on 16/07/12.
//  Copyright (c) 2012 Stewart Gleadow. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface XcodeTestSampleFailingTests : SenTestCase
@end

@implementation XcodeTestSampleFailingTests

- (void)testSampleThatAlwaysFails
{
    STAssertNil(@"but I'm not nil", @"Should be nil");
}

@end
