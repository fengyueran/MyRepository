//
//  LibraryAPI.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "LibraryAPI.h"
#import "HTTPClient.h"
#import "PersistencyManager.h"

@interface LibraryAPI ()
{
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;
}

@end

@implementation LibraryAPI

+ (LibraryAPI *)sharedInstance {
    static LibraryAPI *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[LibraryAPI alloc]init];
    });
    return  _shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc]init];
        httpClient = [[HTTPClient alloc]init];
        isOnline = NO;
    }
    return self;
}

- (NSArray *)getAlbums {
    return [persistencyManager getAlbums];
}

- (void)addAlbum:(Album *)album atIndex:(int)index {
    [persistencyManager addAlbum:album atIndex:index];
    if (isOnline)
    {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

- (void)deleteAlbumAtIndex:(int)index {
    [persistencyManager deleteAlbumAtIndex:index];
    if (isOnline)
    {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}
@end
