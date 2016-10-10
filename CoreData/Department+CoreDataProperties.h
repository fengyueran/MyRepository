//
//  Department+CoreDataProperties.h
//  CoreData
//
//  Created by intern08 on 10/10/16.
//  Copyright © 2016 snow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Department.h"
#import "Description.h"

NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) Description *depDescription;
@property (nullable, nonatomic, retain) NSString *depName;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *employee;

@end

@interface Department (CoreDataGeneratedAccessors)

- (void)addEmployeeObject:(NSManagedObject *)value;
- (void)removeEmployeeObject:(NSManagedObject *)value;
- (void)addEmployee:(NSSet<NSManagedObject *> *)values;
- (void)removeEmployee:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
