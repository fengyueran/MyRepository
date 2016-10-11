//
//  Employee+CoreDataProperties.h
//  CoreData
//
//  Created by intern08 on 10/11/16.
//  Copyright © 2016 snow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Employee.h"

NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *sectionName;
@property (nullable, nonatomic, retain) Department *department;

@end

NS_ASSUME_NONNULL_END
