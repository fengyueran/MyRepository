//
//  Album.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "Album.h"

@implementation Album


- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year
{
    self = [super init];
    if (self)
    {
        _title = title;
        _artist = artist;
        _coverUrl = coverUrl;
        _year = year;
        _genre = @"Pop";
    }
    return self;
}

@end
