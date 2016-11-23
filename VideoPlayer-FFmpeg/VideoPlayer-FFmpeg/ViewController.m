//
//  ViewController.m
//  VideoPlayer-FFmpeg
//
//  Created by intern08 on 11/21/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"
#import "KxMovieViewController.h"
#include "avformat.h"
#include "avcodec.h"

@interface ViewController ()
- (IBAction)playVideo:(id)sender;

@end

@implementation ViewController

//viewController载入内存，view 初始化完毕，还未显示时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//在viewDidLoad中presentViewController不行,view此时步骤window层级
- (void)viewDidAppear:(BOOL)animated {
//    NSString *path =@"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4";
//    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
//                                                                               parameters:nil];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)playVideo:(id)sender {
        NSString *path =@"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4";
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                                   parameters:nil];
        [self presentViewController:vc animated:YES completion:nil];
}
@end
