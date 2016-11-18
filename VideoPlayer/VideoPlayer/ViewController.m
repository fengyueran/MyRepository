//
//  ViewController.m
//  VedeoPlayer
//
//  Created by intern08 on 11/18/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) MPMoviePlayerController *mpMovieplayer;
@property (nonatomic, strong) MPMoviePlayerViewController *mpMovieViewplayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.AVPlayer
    AVPlayer *player = self.player;
    
    //2.MPMoviePlayerController,已弃用
    //  MPMoviePlayerController *player = self.mpMovieplayer;
    //3.MPMoviePlayerViewController，已弃用
    // [self presentMoviePlayerViewControllerAnimated:self.mpMovieViewplayer];
    
    [player play];
    
    
}

- (AVPlayer *)player {
    if (_player == nil) {
        // 1.获取URL(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        //    duration   当前播放元素的总时长
        //    status  加载的状态          AVPlayerItemStatusUnknown,  未知状态
        //    AVPlayerItemStatusReadyToPlay,  准备播放的状态
        //    AVPlayerItemStatusFailed   失败的状态
        
        //    时间控制的类目
        //    current
        //    forwordPlaybackEndTime   跳到结束位置
        //    reversePlaybackEndTime    跳到开始位置
        //    seekToTime   跳到指定位置
        
        // 3.创建AVPlayer
        //也可以直接WithURL来获得一个地址的视频文件
        //    externalPlaybackVideoGravity    视频播放的样式
        //AVLayerVideoGravityResizeAspect   普通的
        //    AVLayerVideoGravityResizeAspectFill   充满的
        //    currentItem  获得当前播放的视频元素
        
        _player = [AVPlayer playerWithPlayerItem:item];
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width* 9 / 16);
        // 显示播放视频的视图层要添加到self.view的视图层上面
        [self.view.layer addSublayer:layer];
        
    }
    return _player;
}







//9.0后弃用
- (MPMoviePlayerController *)mpMovieplayer {
    if (_mpMovieplayer == nil) {
        // 1.获取视频的URL
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        // 2.创建控制器
        _mpMovieplayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
        // 3.设置控制器的View的位置
        _mpMovieplayer.view.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        // 4.将View添加到控制器上
        [self.view addSubview:_mpMovieplayer.view];
        // 5.设置属性
        _mpMovieplayer.controlStyle = MPMovieControlStyleNone;
    }
    return _mpMovieplayer;
}

//已弃用
- (MPMoviePlayerViewController *)mpMovieViewplayer {
    if (_mpMovieViewplayer == nil) {
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        _mpMovieViewplayer = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    return _mpMovieViewplayer;
}

@end
