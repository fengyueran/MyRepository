//
//  Description.m
//  CoreData
//
//  Created by intern08 on 10/10/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "Description.h"

static NSString *const KLeaderNameKey = @"leaderName";
static NSString *const KEmployeeCountKey = @"employeeCount";

@implementation Description

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.leaderName = [aDecoder decodeObjectForKey:KLeaderNameKey];
        self.employeeCount = [aDecoder decodeIntegerForKey:KEmployeeCountKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.leaderName forKey:KLeaderNameKey];
    [aCoder encodeInteger:self.employeeCount forKey:KEmployeeCountKey];
}
@end
