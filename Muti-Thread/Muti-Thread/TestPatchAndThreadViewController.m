//
//  TestPatchAndThreadViewController.m
//  Muti-Thread
//
//  Created by intern08 on 10/20/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "TestPatchAndThreadViewController.h"

@interface TestPatchAndThreadViewController ()
- (IBAction)testRlsPatchVsThread:(UIButton *)sender;
- (IBAction)blockMainThread:(UIButton *)sender;

@end

@implementation TestPatchAndThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testRlsPatchVsThread:(UIButton *)sender {
    //队列一般就是系统的主队列和全局队列还有自己手动创建的串行队列和并行队列,在自定义队列中被调度的所有 block 最终都将被放入到系统的全局队列中和线程池中
    //自定义串行队列
    dispatch_queue_t queue_serial = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
    
    //自定义并行队列
    dispatch_queue_t queue_concurrent = dispatch_queue_create("并行队列", DISPATCH_QUEUE_CONCURRENT);
    
    //系统提供主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //系统提供全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //方法有两个  dispatch_sync 和 dispatch_async  dispatch_async方法是立刻返回的，也就是说把block内容加到相应队列里后会立马返回，而dispatch_sync要等到加到队列里执行完之后才会返回。
    //这时候总共有2*4 = 8种组合，接下来我们来说一下这八种组合
    
//1.dispatch_sync,同步添加操作。他是等待添加进队列里面的操作完成之后再继续执行
//1.1
    //   for (int i = 0; i < 3; i++) {
    //        dispatch_sync(queue_serial, ^{
    //            NSLog(@"dispatch_sync-%d\n currentThread:%@",i,[NSThread currentThread]);
    //        });
    //    }
    //    打印，这种方式可见，串行队列是在主线程里完成的，因为是串行队列，所以打印%d是有顺序的。
    //    2016-10-20 11:15:44.425 Muti-Thread[1564:61859] dispatch_sync-0
    //currentThread:<NSThread: 0x7fd1d2c084f0>{number = 1, name = main}
    //    2016-10-20 11:15:44.425 Muti-Thread[1564:61859] dispatch_sync-1
    //currentThread:<NSThread: 0x7fd1d2c084f0>{number = 1, name = main}
    //    2016-10-20 11:15:44.425 Muti-Thread[1564:61859] dispatch_sync-2
    //currentThread:<NSThread: 0x7fd1d2c084f0>{number = 1, name = main}
    
//1.2
    //    for (int i = 0; i < 3; i++) {
    //        dispatch_sync(queue_concurrent, ^{
    //             NSLog(@"dispatch_sync-%d\n currentThread:%@",i,[NSThread currentThread]);
    //        });
    //    }
    //
    //}
    //打印,可以发现同样还是在主线程里执行并行队列，(虽然是并行队列，但这时候依然在同一个线程里执行,且按顺序执行)
    //2016-10-20 11:23:10.242 Muti-Thread[1636:66717] dispatch_sync-0
    //currentThread:<NSThread: 0x7ffd6bf007a0>{number = 1, name = main}
    //2016-10-20 11:23:10.242 Muti-Thread[1636:66717] dispatch_sync-1
    //currentThread:<NSThread: 0x7ffd6bf007a0>{number = 1, name = main}
    //2016-10-20 11:23:10.242 Muti-Thread[1636:66717] dispatch_sync-2
    //currentThread:<NSThread: 0x7ffd6bf007a0>{number = 1, name = main}
    
//1.3
    //    for (int i = 0; i < 3; i++) {
    //         NSLog(@"dispatch_sync-mainQueue");
    //        dispatch_sync(mainQueue, ^{
    //            NSLog(@"dispatch_sync-%d\n currentThread:%@",i,[NSThread currentThread]);
    //
    //        });
    //    }
    
    //打印结果：dispatch_sync-mainQueue，发现主线程被堵塞。
    //2016-10-20 11:31:32.729 Muti-Thread[1738:73990] dispatch_sync-mainQueue
    
    
//1.4
    //        for (int i = 0; i < 3; i++) {
    //            dispatch_sync(globalQueue, ^{
    //                  NSLog(@"dispatch_sync-%d\n currentThread:%@",i,[NSThread currentThread]);
    //            });
    //        }
    
    //打印结果可以看出依然是主线程,且顺序执行。
    //    2016-10-20 11:36:52.764 Muti-Thread[1802:77776] dispatch_sync-0
    //currentThread:<NSThread: 0x7ff990f029c0>{number = 1, name = main}
    //    2016-10-20 11:36:52.764 Muti-Thread[1802:77776] dispatch_sync-1
    //currentThread:<NSThread: 0x7ff990f029c0>{number = 1, name = main}
    //    2016-10-20 11:36:52.764 Muti-Thread[1802:77776] dispatch_sync-2
    //currentThread:<NSThread: 0x7ff990f029c0>{number = 1, name = main}
    
    
    
    
//2.dispatch_async,异步添加进任务队列，它不会做任何等待
//2.1
    //            for (int i = 0; i < 3; i++) {
    //                dispatch_async(queue_serial, ^{
    //                      NSLog(@"dispatch_async-%d\n currentThread:%@",i,[NSThread currentThread]);
    //                });
    //            }
    
    //打印：可以看出创建了一个线程， 在串行队列里串行执行的
    //    2016-10-20 11:43:00.696 Muti-Thread[1874:81886] dispatch_async-0
    //currentThread:<NSThread: 0x7f9eb2f0bd60>{number = 2, name = (null)}
    //    2016-10-20 11:43:00.697 Muti-Thread[1874:81886] dispatch_async-1
    //currentThread:<NSThread: 0x7f9eb2f0bd60>{number = 2, name = (null)}
    //    2016-10-20 11:43:00.697 Muti-Thread[1874:81886] dispatch_async-2
    //currentThread:<NSThread: 0x7f9eb2f0bd60>{number = 2, name = (null)}
    
//2.2
//    for (int i = 0; i < 3; i++) {
//        dispatch_async(queue_concurrent, ^{
//            NSLog(@"dispatch_async-%d\n currentThread:%@",i,[NSThread currentThread]);
//        });
//    }
//    

//打印：分析可以看出创建了多个线程，任务执行顺序不一定
//2016-10-20 11:46:14.890 Muti-Thread[1915:83626] dispatch_async-0
//currentThread:<NSThread: 0x7fa23841aa00>{number = 2, name = (null)}
//2016-10-20 11:46:14.890 Muti-Thread[1915:83633] dispatch_async-2
//currentThread:<NSThread: 0x7fa238400870>{number = 4, name = (null)}
//2016-10-20 11:46:14.890 Muti-Thread[1915:83739] dispatch_async-1
//currentThread:<NSThread: 0x7fa2384e2690>{number = 3, name = (null)}
    
//2.3
//        for (int i = 0; i < 3; i++) {
//            dispatch_async(mainQueue, ^{
//                NSLog(@"dispatch_async-%d\n currentThread:%@",i,[NSThread currentThread]);
//            });
//        }
 
//打印：可以看出这种情况还是在当前线程环境中执行，并不创建线程，因为是在主队列里，顺序执行
//    2016-10-20 16:33:25.552 Muti-Thread[6555:268129] dispatch_async-0
//currentThread:<NSThread: 0x7fb9e3c06510>{number = 1, name = main}
//    2016-10-20 16:33:25.553 Muti-Thread[6555:268129] dispatch_async-1
//currentThread:<NSThread: 0x7fb9e3c06510>{number = 1, name = main}
//    2016-10-20 16:33:25.554 Muti-Thread[6555:268129] dispatch_async-2
//currentThread:<NSThread: 0x7fb9e3c06510>{number = 1, name = main}
    
//2.4
    for (int i = 0; i < 3; i++) {
        dispatch_async(globalQueue, ^{
            NSLog(@"dispatch_async-%d\n currentThread:%@",i,[NSThread currentThread]);
        });
    }
    
//打印：可以看出创建了多个线程，执行顺序并不一定
//    2016-10-20 16:37:45.963 Muti-Thread[6608:270871] dispatch_async-0
//currentThread:<NSThread: 0x7f9368d13cc0>{number = 2, name = (null)}
//    2016-10-20 16:37:45.963 Muti-Thread[6608:271053] dispatch_async-2
//currentThread:<NSThread: 0x7f9368d8f010>{number = 4, name = (null)}
//    2016-10-20 16:37:45.963 Muti-Thread[6608:270878] dispatch_async-1
//currentThread:<NSThread: 0x7f9368f0d5e0>{number = 3, name = (null)}
    
}

- (IBAction)blockMainThread:(UIButton *)sender {
    
    
}





@end
