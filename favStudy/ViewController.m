//
//  ViewController.m
//  favStudy
//
//  Created by 威杜 on 2018/8/14.
//  Copyright © 2018年 威杜. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+IconFont.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self imageIconFont];
    [self dispatchSemaphore];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//线程同步 -- 信号量
- (void)dispatchSemaphore {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1111111");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2222222");
        /* 任务1结束，发送信号告诉任务2可以开始了 */
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 等待任务1结束获得信号量, 无限等待 */
        dispatch_semaphore_wait(sem,DISPATCH_TIME_FOREVER);
        NSLog(@"3333333");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"4444444");
    });
}

//线程同步 --阻塞任务
- (void)dispatchBarrier {
    dispatch_queue_t queue = dispatch_queue_create("tes.current.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^(){
        NSLog(@"operationA");
    });
    dispatch_async(queue, ^(){
        sleep(3);
        NSLog(@"operationB");
    });
    /* 添加barrier障碍操作，会等待前面的并发操作结束，并暂时阻塞后面的并发操作直到其完成 */
    dispatch_barrier_async(queue, ^(){
        NSLog(@"===barrier===");
    });
    dispatch_async(queue, ^(){
        NSLog(@"operationC");
    });
}

//线程同步 -- 组队列
- (void)dispatchGroup {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        dispatch_async(queue, ^{
            NSLog(@"11111111");
        });
    });
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"2222222");
        
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3333333");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"thead end");
    });
    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"执行完成");
}

//矢量字体
- (void)iconFont {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    
    label.width = self.view.width;
    label.height = 80;
    label.backgroundColor = [UIColor yellowColor];
    label.sd_layout.leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 200);
    label.font = [UIFont fontWithName:@"iconfont" size:24];
    //在字体前面都要添加 \U0000 关键字
    label.text = @"展示的font：\U0000e604;";
    [label sizeToFit];
}
//矢量字体
- (void)imageIconFont {
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 350, 100, 100)];
    
    imageView1.image = [UIImage imageWithIconFontName:@"iconfont" fontSize:80 text:@"\U0000e604" color:[UIColor greenColor]];
    
    imageView1.layer.borderColor = [UIColor redColor].CGColor;
    
    imageView1.layer.borderWidth = 1;
    
    imageView1.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:imageView1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(20, CGRectGetMaxY(imageView1.frame)+20, 100, 50);
    
    [btn setTitle:@"狮子" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.layer.borderWidth = 1;
    
    btn.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.view addSubview:btn];
    
    UIImage *normalImage = [UIImage imageWithIconFontName:@"iconfont" fontSize:40 text:@"\U0000e604" color:[UIColor cyanColor]];
    
    [btn setImage:normalImage forState:UIControlStateNormal];
}


@end
