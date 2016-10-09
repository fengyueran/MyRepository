//
//  PthreadLoadViewController.m
//  Muti-Thread
//
//  Created by intern08 on 10/9/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "PthreadLoadViewController.h"
#import <pthread.h>

@interface PthreadLoadViewController ()

@end

@implementation PthreadLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)load:(UIButton *)sender {
    pthread_t thread;
    //创建一个线程并自动执行
    pthread_create(&thread, NULL, start, NULL);
}

void *start(void *data){
    NSLog(@"==current==%@",[NSThread currentThread]);
    return NULL;
}


@end
