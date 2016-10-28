//
//  Father.h
//  CircularReference
//
//  Created by intern08 on 10/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Son;
@interface Father : NSObject
- (id)initWithSon:(Son *)son;

//@property (nonatomic, strong) Son *son;
@property (nonatomic, weak) Son *son;
@end
