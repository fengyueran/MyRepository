//
//  PersistencyManager.h
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
#import <UIKit/UIKit.h>

@interface PersistencyManager : NSObject

- (NSArray *)getAlbums;
- (void)addAlbum:(Album *)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;
- (void)saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage *)getImage:(NSString *)filename;
- (void)saveAlbums;
@end
