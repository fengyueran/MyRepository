//
//  Son.h
//  CircularReference
//
//  Created by intern08 on 10/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Father.h"

@class Father;
@interface Son : NSObject
@property (nonatomic, strong) Father *father;

@end
