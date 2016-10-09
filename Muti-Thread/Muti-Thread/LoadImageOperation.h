//
//  LoadImageOperation.h
//  Muti-Thread
//
//  Created by intern08 on 10/9/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LoadImageDelegate <NSObject>

-(void)loadImageFinish:(UIImage *) image;

@end
@interface LoadImageOperation : NSOperation

@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,weak) id<LoadImageDelegate> loadDelegate;

@end
