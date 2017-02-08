//
//  ViewController.m
//  LiveApp
//
//  Created by zivInfo on 16/12/2.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

/*
 Live
 */
#import "ViewController.h"

#import "AFNetworking/AFNetworking.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    [self loadData];
    [self startLive];
}

-(void)initView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.imageView];
}

-(void)loadData
{
    // 映客数据url
    NSString *urlString = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    // 请求数据
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dicResponseObject = responseObject;
        NSLog(@"%@", dicResponseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"View Controller=>loadData Error %@", error);
    }];
}

-(void)startLive
{
    //设置直播占位图片
    NSString *strImage = @"http://img2.inke.cn/MTQ4MDU5OTkwNDk5NiMxMTgjanBn.jpg";
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@", strImage]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];

    // 拉流地址
    NSString *stream_addr = @"http://pull99.a8.com/live/1480657458785371.flv";
    NSURL *url = [NSURL URLWithString:stream_addr];
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    // 准备播放
    [playerVc prepareToPlay];
    
    // 强引用，反正被销毁
    _player = playerVc;
    
    playerVc.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:playerVc.view atIndex:1];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
