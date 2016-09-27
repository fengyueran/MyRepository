//
//  LibraryAPI.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "LibraryAPI.h"

@implementation LibraryAPI

+ (LibraryAPI *)sharedInstance {
    static LibraryAPI *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[LibraryAPI alloc]init];
    });
    return  _shareInstance;
}
@end
