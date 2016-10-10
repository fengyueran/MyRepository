//
//  Description.h
//  CoreData
//
//  Created by intern08 on 10/10/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对应Department类的depDescription属性
 */
@interface Description : NSObject<NSCoding>
@property (nonatomic ,copy)NSString *leaderName;
@property (nonatomic ,assign)NSInteger employeeCount;

@end
