//
//  Album.h
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic,copy,readonly)NSString *title, *artist, *genre, *coverUrl, *year;
- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year;

@end
