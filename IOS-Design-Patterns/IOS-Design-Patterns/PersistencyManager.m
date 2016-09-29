//
//  PersistencyManager.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "PersistencyManager.h"
#import "Album.h"
#import <UIKit/UIKit.h>

@interface PersistencyManager()
{
    NSMutableArray *albums;
}

@end
@implementation PersistencyManager
- (instancetype)init {
    self = [super init];
    if (self) {
       
        albums = [NSMutableArray arrayWithArray:
                  @[[[Album alloc]initWithTitle:@"Best of Bowie" artist:@"David Bowie"  coverUrl:@"http://www.raywenderlich.com/wp-content/uploads/2013/07/facade.jpg" year:@"1992"],
                    [[Album alloc]initWithTitle:@"Best of jay" artist:@"David Bowie"  coverUrl:@"http://www.raywenderlich.com/wp-content/uploads/2013/07/facade.jpg" year:@"1992"],
                    [[Album alloc]initWithTitle:@"Best of snow" artist:@"David Bowie"  coverUrl:@"http://www.raywenderlich.com/wp-content/uploads/2013/07/facade.jpg" year:@"1992"],
                    [[Album alloc]initWithTitle:@"Best of tina" artist:@"David Bowie"  coverUrl:@"http://www.raywenderlich.com/wp-content/uploads/2013/07/facade.jpg" year:@"1992"]]];
        
    }
    return self;
}

- (NSArray *)getAlbums {
    return albums;
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Document/%@",filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}
- (void)addAlbum:(Album *)album atIndex:(int)index {
    if (albums.count >= index) {
        [albums insertObject:album atIndex:index];
    } else {
        [albums addObject:album];
    }
}

- (UIImage *)getImage:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Document/%@",filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}
- (void)deleteAlbumAtIndex:(int)index {
    [albums removeObjectAtIndex:index];
}

@end
