//
//  Teacher+CoreDataProperties.h
//  CoreData
//
//  Created by intern08 on 10/10/16.
//  Copyright © 2016 snow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSManagedObject *students;

@end

NS_ASSUME_NONNULL_END
