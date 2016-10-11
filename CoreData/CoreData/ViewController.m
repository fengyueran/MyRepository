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
    stu1.name =@"13527466666";
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

/**
 添加Student实例
 */
- (IBAction)schoolAdd:(UIButton *)sender {
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.schoolMOC];
    student.name = @"13527499999";
     // 实体中所有基础数据类型，创建类文件后默认都是NSNumber类型的
    student.age = @17;
    
      // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:&error];
    }
    // 错误处理，可以在这实现自己的错误处理逻辑
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
    
}

/**
 删除Student实例
 */
- (IBAction)schoolDelete:(UIButton *)sender {
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"mxh"];
    
    // 建立获取数据的请求对象，指明对Student实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = predicate;
    
     // 执行获取操作，找到要删除的对象
    NSError *error = nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    // 遍历符合删除要求的对象数组，执行删除操作
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.schoolMOC deleteObject:obj];
    }];
    
     // 保存上下文，并判断当前上下文是否有改动
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:nil];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }

}

/**
 修改Student实例
 */
- (IBAction)schoolUpdate:(UIButton *)sender {
    // 创建谓词对象，设置过滤条件
    NSPredicate *predivate = [NSPredicate predicateWithFormat:@"name = %@",@"mxh"];
    // 建立获取数据的请求对象，并指明操作的实体为Student
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = predivate;
    
     // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    
     // 遍历获取到的数组，并执行修改操作
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj.age=%@",obj.age);
        obj.age = @19;
    }];
    
    // 将上面的修改进行存储
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:nil];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
    
    /**
     在上面简单的设置了NSPredicate的过滤条件，对于比较复杂的业务需求，还可以设置复合过滤条件，例如下面的例子
     [NSPredicate predicateWithFormat:@"(age < 25) AND (firstName = XiaoZhuang)"]
     
     也可以通过NSCompoundPredicate对象来设置复合过滤条件
     [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[predicate1, predicate2]]
     */

}

/**
 查找Student实例
 */
- (IBAction)schoolSearch:(UIButton *)sender {
    // 建立获取数据的请求对象，指明操作的实体为Student
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    // 执行获取操作，获取所有Student托管对象
    NSError *error = nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    
     // 遍历输出查询结果
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Student Name : %@, Age :%ld",obj.name,[obj.age integerValue]);
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
    
}

#pragma mark - ----- Page && Fuzzy ------

/**
 分页查询
 */
- (IBAction)pageSearch:(UIButton *)sender {
    // 创建获取数据的请求对象，并指明操作Student表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 设置查找起始点，这里是从搜索结果的第六个开始获取
    request.fetchOffset = 6;
    
     // 设置分页，每次请求获取六个托管对象
    request.fetchLimit = 6;
    
    // 设置排序规则，这里设置年龄升序排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
     // 执行查询操作
    NSError *error = nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    
     // 遍历输出查询结果
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Page Search Result Name : %@, Age : %ld", obj.name, [obj.age integerValue]);
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"Page Search Data Error : %@", error);
    }
}

/**
 模糊查询
 */
- (IBAction)fuzzySearch:(UIButton *)sender {
     // 创建模糊查询条件。这里设置的带通配符的查询，查询条件是结果包含lxz
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@",@"*mxh*"];
    
     NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";//[0-35-9]将匹配一个数字范围在0-3或5-9范围内的数字,[025-9]将匹配一个数字范围在0-2或5-9范围内的数字
     NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"name MATCHES %@", mobile];
    // 创建获取数据的请求对象，设置对Student表进行操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = predicate4;
    
    
    // 执行查询操作
    NSError *error =nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    
    // 遍历输出查询结果
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"Fuzzy Search Result Name : %@, Age : %ld", obj.name, [obj.age integerValue]);
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"Fuzzy Search Data Error : %@", error);
    }
    
    /**
    模糊查询的关键在于设置模糊查询条件，除了上面的模糊查询条件，还可以设置下面三种条件
    */
    // 以lxz开头
    // NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@", @"lxz"];
    // 以lxz结尾
    // NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"name ENDSWITH %@"  , @"lxz"];
    // 其中包含lxz
    // NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"name contains %@"  , @"lxz"];
    // 还可以设置正则表达式作为查找条件，这样使查询条件更加强大，下面只是给了个例子
    // NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";//[0-35-9]将匹配一个数字范围在0-3或5-9范围内的数字,[025-9]将匹配一个数字范围在0-2或5-9范围内的数字
    // NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];

    
}

#pragma mark - ----- Fetch Request ------

/**
 加载模型文件中设置的FetchRequest请求模板，模板名为StudentAge，在School.xcdatamodeld中设置
 */
- (IBAction)fetchRequest:(UIButton *)sender {
    // 通过MOC获取托管对象模型，托管对象模型相当于.xcdatamodeld文件，存储着.xcdatamodeld文件的结构
    NSManagedObjectModel *model = self.schoolMOC.persistentStoreCoordinator.managedObjectModel;
    
     // 通过.xcdatamodeld文件中设置的模板名，获取请求对象
    NSFetchRequest *request = [model fetchRequestTemplateForName:@"StudentAge"];
    
    // 请求数据，下面的操作和普通请求一样
    NSError *error = nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    
     // 遍历获取结果，并打印结果
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"Student.count = %ld, Student.age = %ld", students.count, [obj.age integerValue]);
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"Execute Fetch Request Error : %@", error);
    }
}

/**
 对请求结果进行排序
 这个排序是发生在数据库一层的，并不是将结果取出后排序，所以效率比较高
 */
- (IBAction)resultSort:(UIButton *)sender {
    // 设置请求条件，通过设置的条件，来过滤出需要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@",@"*mxh"];
    // 建立获取数据的请求对象，并指明操作Student表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate =predicate;
    
    // 设置请求结果排序方式，可以设置一个或一组排序方式，最后将所有的排序方式添加到排序数组中
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    // NSSortDescriptor的操作都是在SQLite层级完成的，不会将对象加载到内存中，所以对内存的消耗是非常小的
    // 下面request的sort对象是一个数组，也就是可以设置多种排序条件，但注意条件不要冲突
    request.sortDescriptors = @[sort];
    
     // 执行获取请求操作，获取的托管对象将会被存储在一个数组中并返回
    NSError *error =nil;
    NSArray<Student *> *students = [self.schoolMOC executeFetchRequest:request error:&error];
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Employee Name : %@, Age : %ld", obj.name, [obj.age integerValue]);
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Fetch Data Error : %@", error);
    }
    
    
}

/**
 获取返回结果的Count值，通过设置NSFetchRequest的resultType属性
 */
- (IBAction)getResultCount1:(UIButton *)sender {
    // 设置过滤条件，可以根据需求设置自己的过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 24"];
    
    // 创建请求对象，并指明操作Student表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = predicate;
    
     // 这一步是关键。设置返回结果类型为Count，返回结果为NSNumber类型
    request.resultType = NSCountResultType;
    
    // 执行查询操作，返回的结果还是数组，数组中只存在一个对象，就是计算出的Count值
    NSError *error = nil;
    NSArray *dataList = [self.schoolMOC executeFetchRequest:request error:&error];
    
    // 返回结果存在数组的第一个元素中，是一个NSNumber的对象，通过这个对象即可获得Count值
    NSInteger count = [dataList.firstObject integerValue];
    NSLog(@"fetch request result Employee.count = %ld", count);
    
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }

}

/**
 获取返回结果的Count值，通过调用MOC提供的特定方法
 */
- (IBAction)getResultCount2:(UIButton *)sender {
    // 设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 24"];
    
    // 创建请求对象，指明操作Student表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    fetchRequest.predicate = predicate;
    
    // 通过调用MOC的countForFetchRequest:error:方法，获取请求结果count值，返回结果直接是NSUInteger类型变量
    NSError *error = nil;
    NSUInteger count = [self.schoolMOC countForFetchRequest:fetchRequest error:&error];
    NSLog(@"fetch request result count is : %ld", count);
    
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
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

/**
 添加Student实体的测试数据
 */
- (IBAction)addTestData:(UIButton *)sender {
    for (int i=0; i<14; i++) {
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.schoolMOC];
        student.name = [NSString stringWithFormat:@"mxh %d", i];
        student.age  = @(i+15);
    }
    NSError *error = nil;
    if (self.schoolMOC.hasChanges) {
        [self.schoolMOC save:&error];
    }
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
