//
//  LoadImageOperation.m
//  Muti-Thread
//
//  Created by intern08 on 10/9/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "LoadImageOperation.h"


@implementation LoadImageOperation

- (void)main {
    if (self.isCancelled) return;
    
    NSURL *url = [NSURL URLWithString:self.imgUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    if (self.isCancelled) {
        url = nil;
        imageData = nil;
        return;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (self.loadDelegate!=nil&&[self.loadDelegate respondsToSelector:@selector(loadImageFinish:)]) {
        
        [(NSObject *)self.loadDelegate performSelectorOnMainThread:@selector(loadImageFinish:) withObject:image waitUntilDone:NO];
    }

}

@end
