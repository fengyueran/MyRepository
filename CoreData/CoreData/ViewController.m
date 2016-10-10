//
//  ViewController.m
//  CoreData
//
//  Created by intern08 on 10/8/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"
#import "Department.h"
#import "Description.h"

@interface ViewController ()
@property (nonatomic, strong)NSManagedObjectContext *companyMOC;
@end

@implementation ViewController

#pragma mark - ----- CoreData简单创建流程 ------

/**
 模型文件操作
 1.1 创建模型文件，后缀名为.xcdatamodeld。创建模型文件之后，可以在其内部进行添加实体等操作(用于表示数据库文件的数据结构)
 1.2 添加实体(表示数据库文件中的表结构)，添加实体后需要通过实体，来创建托管对象类文件。
 1.3 添加属性并设置类型，可以在属性的右侧面板中设置默认值等选项。(每种数据类型设置选项是不同的)
 1.4 创建获取请求模板、设置配置模板等。
 1.5 根据指定实体，创建托管对象类文件(基于NSManagedObject的类文件)
 
 
 实例化上下文对象
 2.1 创建托管对象上下文(NSManagedObjectContext)
 2.2 创建托管对象模型(NSManagedObjectModel)
 2.3 根据托管对象模型，创建持久化存储协调器(NSPersistentStoreCoordinator)
 2.4 关联并创建本地数据库文件，并返回持久化存储对象(NSPersistentStore)
 2.5 将持久化存储协调器赋值给托管对象上下文，完成基本创建。
 */

#pragma mark - ----- Create CoreData Context ------

/**
创建上下文对象
*/

- (NSManagedObjectContext *)contextWithModelName:(NSString *)modelName {
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle]URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelPath];
    
     // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite",modelName];
    NSURL *storeURL = [NSURL fileURLWithPath:dataPath isDirectory:NO];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator =coordinator;
    
    return context;
    
}

- (IBAction)reverseRelationshipsAdd:(UIButton *)sender {
    // 创建Employee托管对象
    Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.companyMOC];
    emp1.name =@"emp1";
    emp1.birthday = [NSDate date];
    
    Employee *emp2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.companyMOC];
    emp2.name = @"emp2";
    emp2.birthday = [NSDate date];
    
    NSSet *set = [NSSet setWithObjects:emp1,emp2, nil];
    
    // 创建Department托管对象
    Department *dep1 = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.companyMOC];
    dep1.depName        = @"iOS";
    dep1.createDate     = [NSDate date];
    dep1.depDescription = [[Description alloc] init];
    dep1.employee       = set;
    
//    Department *dep2    = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.companyMOC];
//    dep2.depName        = @"Android";
//    dep2.createDate     = [NSDate date];
//    dep2.depDescription = [[Description alloc] init];
//    dep2.employee       = emp2;
    
    // 保存当前上下文
    NSError *error = nil;
    if (self.companyMOC.hasChanges) {
        [self.companyMOC save:&error];
    }
    
    /**
     从这条打印结果可以看出，虽然只有Department设置了employee属性，而Employee没有设置department属性。但是在Department设置关联属性后，Employee对应的属性也有值了，这就是设置inverse的区别所在。
     也就是两者发生了双向关联的关系后，一方设置关联属性，另一方关联属性会随之发生改变。这个改变也会体现在数据库一层，也就是外键的改变。
     */
        NSLog(@"emp1.department = %@, emp2.department = %@, dep1.employee = %@", emp1.department, emp2.department, dep1.employee);
//    NSLog(@"emp1.department = %@, emp2.department = %@, dep1.employee = %@, dep2.employee = %@", emp1.department, emp2.department, dep1.employee, dep2.employee);
    
    // 错误处理
    if (error) {
        NSLog(@"Insert CompanyMOC Managed Object Error : %@", error);
    }
}

- (NSManagedObjectContext *)companyMOC {
    if (!_companyMOC) {
        _companyMOC = [self contextWithModelName:@"Company"];
    }
    return _companyMOC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
