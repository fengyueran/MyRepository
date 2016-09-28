//
//  Album+TableRepresentation.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/28/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

- (NSDictionary *)tr_tableRepresentation {
    return @{@"titles":@[@"Artist",@"Album",@"Genre",@"Year"],
             @"values":@[self.artist,self.title,self.genre,self.year]};
}

@end
