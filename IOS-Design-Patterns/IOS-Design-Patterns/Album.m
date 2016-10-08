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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _year = [aDecoder decodeObjectForKey:@"year"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _coverUrl = [aDecoder decodeObjectForKey:@"cover_url"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.coverUrl forKey:@"cover_url"];
    [aCoder encodeObject:self.genre forKey:@"genre"];
}
@end
