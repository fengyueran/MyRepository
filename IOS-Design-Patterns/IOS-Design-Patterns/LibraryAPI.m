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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification"  object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)downloadImage:(NSNotification *)notification {
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];    if (imageView.image == nil)
    {
        // 3
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            // 4
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
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
