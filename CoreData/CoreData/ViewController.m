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
#import "Student.h"
#import "Teacher.h"

@interface ViewController ()
@property (nonatomic, strong)NSManagedObjectContext *companyMOC;
@property (nonatomic, strong)NSManagedObjectContext *schoolMOC;
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

#pragma mark - ----- Reverse Relationships ------
/**
 设置了双向关联的托管对象执行添加操作
 */
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
    
    Department *dep2    = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.companyMOC];
    dep2.depName        = @"Android";
    dep2.createDate     = [NSDate date];
    dep2.depDescription = [[Description alloc] init];
    dep2.employee       = set;
    
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

/**
 删除Department托管对象
 在删除Department托管对象后，其对应的Employee会将关联属性设置为空，Employee并不会被一起删除
 在一个托管对象被删除时，其相关联的托管对象是否被删除，是由delete rule决定的
 */
- (IBAction)reverseRelationshipsDelete:(UIButton *)sender {
    // 创建谓词对象，指明查找depName为ios的托管对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"depName = %@",@"Android"];
    // 创建获取请求对象，指明操作Department实体，并设置谓词属性
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Department"];
    fetchRequest.predicate = predicate;
    
    // 执行获取请求操作，得到符合条件的结果数组
    NSError *error = nil;
    NSArray<Department *> *departments = [self.companyMOC executeFetchRequest:fetchRequest error:&error];
    
     // 遍历结果数组，并通过companyMOC上下文删除托管对象
    [departments enumerateObjectsUsingBlock:^(Department * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.companyMOC deleteObject:obj];
    }];
    
    // 执行保存上下文操作，将删除的数据同步到数据库中
    if (self.companyMOC.hasChanges) {
        [self.companyMOC save:nil];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"Delete Department Managed Object Error : %@", error);
    }
}

/**
 添加Student和Teacher托管对象，两者之间设置了关联关系但没有反向关联，也就是没有设置inverse。
 下面Teacher将Student对象添加到自己的集合属性后，在数据库中Teacher有一个指向Student的外键，而Student则不知道Teacher，也就是Student的外键没有指向Teacher。
 在下面NSLog的打印结果也可以看出，Teacher打印关联属性是有值的，而Student的关联属性没值。如果设置inverse结果则不同，这就是inverse设置与否的区别。
 */
- (IBAction)relationshipsAdd:(UIButton *)sender {
     // 创建Student托管对象并设置属性
    Student * stu1 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.schoolMOC];
    stu1.name =@"stu1";
    stu1.age =@16;
    
    Student *stu2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.schoolMOC];
    stu2.name = @"stu2";
    stu2.age = @17;
    
    // 创建Teacher托管对象并设置属性
    Teacher *tea1 = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.schoolMOC];
    tea1.name = @"tea1";
    tea1.subject = @"english";
    [tea1 addStudentsObject:stu1];
    
    Teacher *tea2 = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.schoolMOC];
    tea2.name = @"tea2";
    tea2.subject = @"history";
    [tea2 addStudentsObject:stu2];
    
     // 执行存储操作，向本地数据库中插入数据
    NSError *error = nil;
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:&error];
    }
    
    // 打印托管对象的关联属性的值
    NSLog(@"stu1.teacher = %@, stu2.teacher = %@, tea1.student = %@, tea2.student = %@", stu1.teacher, stu2.teacher, tea1.students, tea2.students);
    
    // 错误处理
    if (error) {
        NSLog(@"Association Table Add Data Error : %@", error);
    }

    
}

/**
 删除Teacher托管对象
 删除Teacher对象并不会对其关联属性关联的对象造成影响，这主要还是Delete rule设置的结果
 */
- (IBAction)relationshipsDelete:(UIButton *)sender {
    // 创建谓词对象，指明查找name为tea1的托管对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"tea1"];
    // 创建获取请求对象，指明操作Teacher实体，并设置predicate条件
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    fetchRequest.predicate =predicate;
    // 执行获取操作，并获取结果数组
    NSError *error = nil;
    NSArray<Teacher *> *teachers = [self.schoolMOC executeFetchRequest:fetchRequest error:&error];
    [teachers enumerateObjectsUsingBlock:^(Teacher * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.schoolMOC deleteObject:obj];
    }];
    
    // 执行save方法，将上下文中所做的改变，保存到持久化存储区中
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:nil];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"Delete Teacher Object Error : %@", error);
    }
    
}

- (NSManagedObjectContext *)companyMOC {
    if (!_companyMOC) {
        _companyMOC = [self contextWithModelName:@"Company"];
    }
    return _companyMOC;
}

- (NSManagedObjectContext *)schoolMOC {
    if (!_schoolMOC) {
        _schoolMOC = [self contextWithModelName:@"School"];
    }
    return _schoolMOC;
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
