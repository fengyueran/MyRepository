//
//  Father.m
//  CircularReference
//
//  Created by intern08 on 10/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "Father.h"

@implementation Father

//- (id)init {
//    NSLog(@"父类初始化");
//    return self;
//}

- (id)initWithSon:(Son *)son {
    self.son = son;
     // NSLog(@"FatherSon=%@",self.son);
    return self;
}
- (void)dealloc
{
    NSLog(@"object=%@=Father----销毁",self);
}
@end
