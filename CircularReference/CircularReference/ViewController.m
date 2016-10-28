//
//  ViewController.m
//  CircularReference
//
//  Created by intern08 on 10/27/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"
#import "Father.h"
#import "Son.h"
typedef void(^TestCircleBlock)();
@interface ViewController ()

//@property (nonatomic, weak) TestCircleBlock testCircleBlock;
@property (nonatomic, strong) TestCircleBlock testCircleBlock;
@property (nonatomic, strong) UITableView *tableView;

- (IBAction)fatherSon:(UIButton *)sender;
- (IBAction)block:(UIButton *)sender;
- (IBAction)delegate:(UIButton *)sender;
- (IBAction)nstimer:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fatherSon:(UIButton *)sender {
    //对象:内存(堆空间)中一块已经正确分配的内存就是对象,son为指向对象的指针变量(栈空间)
    //指针变量son1,son2指向同一片内存区域，即指向同一个对象。
    Son *son1 = [[Son alloc]init];
    Father *father =[[Father alloc]init];
    
    Son *son2 =son1;
//1.
//出大括号后,指针变量son1,son2,father置为nil,不再引用对象，对象释放
// 打印：
// CircularReference[5093:245650] object=<Father: 0x7fe9d0f16fd0>=Father----销毁
// CircularReference[5093:245650] object=<Son: 0x7fe9d0f0b640>=Son----销毁

    
//2.
   // son1,father互相引用后，造成循环引用。出大括号后,指针变量son1,son2,father置为nil但son.father,father.son还互相引用着对方，计数不为0，无法释放对象，不输出销毁信息。
    father.son = son1;
    son1.father = father;
    
    
//3.
    //当Father类的son设置为weak，出大括号后,指针变量son1,son2,father置为nil，father.son也失去对son1的引用，计数为0，释放对象输出销毁信息。

}

- (IBAction)block:(UIButton *)sender {
//1.
    //block在copy,strong时都会对block内部用到的对象(没有__weak进行修饰)进行强引用。该类又将block作为自己的属性变量，而该类在block的方法体里面又使用了该类本身，此时就很简单的形成了一个环啦。
     Father *father =[[Father alloc]init];
     Father *weakFather = father;
    NSLog(@"weakFather= %@",weakFather);
    self.testCircleBlock = ^ {
        NSLog(@"weakFather - block = %@",weakFather);
    };
    self.testCircleBlock();
    father = nil;
    self.testCircleBlock();
// 1.1 testCircleBlock中用到了weakFather，若没有__weak修饰，block就会强引用weakFather指向的对象，当father为nil    时block还引用着weakFather不能销毁.
// 1.2 //当weakFather用__weak修饰时,block弱引用weakFather指向的对象，当father为nil时block不再引用weakFather，对象销毁.
//     CircularReference[5569:277527] weakFather= <Father: 0x7fcf0872c410>
//     CircularReference[5569:277527] weakFather - block = <Father: 0x7fcf0872c410>
//     CircularReference[5569:277527] object=<Father: 0x7fcf0872c410>=Father----销毁
//     CircularReference[5569:277527] weakFather - block = (null)
    
    
//2.
    //在ARC中，在被拷贝的block中无论是直接引用self,还是通过引用self的成员变量间接引用self(当前对象)，或单纯的将 self 作为值传递到一个局部变量中，该 block 都会 retain self。
    //我们可以通过在 block 内部声明一个 __strong 的变量来指向 weakSelf，使外部对象既能在 block 内部保持住，又能避免循环引用的问题。
    __weak typeof(self) weakSelf = self;
    self.testCircleBlock = ^ {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf doSomething];
    };
    
    
}

- (IBAction)delegate:(UIButton *)sender {
    //UITableView代理定义@property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;
    //若uitableview的代理设置为strong,则self.tableView会强引用self,self又强引用tableview，造成引用循环。
    self.tableView.delegate = self;
    
}

- (IBAction)nstimer:(UIButton *)sender {
//    __weak ViewController * weakSelf = self;
//    [NSTimer ypq_scheduledTimeWithTimeInterval:4.0f
//                                         block:^{
//                                             ViewController * strongSelf = weakSelf;
//                                             [strongSelf afterThreeSecondBeginAction];
//                                         }
//                                       repeats:YES];
}
- (void)doSomething {
    NSLog(@"1111");
}
@end
