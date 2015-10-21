//
//  ViewController.m
//  摇一摇
//
//  Created by 向伟 on 15/10/21.
//  Copyright © 2015年 WeiXiang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()
{
    SystemSoundID _soundID;
    UIImageView *_imageView;
    UIImage *_image;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    
    //摇一摇的音频路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    //创建播放对象
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
    //开启摇一摇
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    //让事件成为第一响应者
    [self becomeFirstResponder];
}

#pragma mark --摇一摇回调方法--
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSLog(@"开始摇动");
    if (motion == UIEventSubtypeMotionShake) {
        
        //调用截屏方法
        [self snapshot];
        //播放音频
        AudioServicesPlaySystemSound(_soundID);
    }
}
#pragma mark --摇一摇截屏方法－－
-(void)snapshot{
    
    //开启图像上下文
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将当前视图图层渲染到当前上下文
    [self.view.layer renderInContext:context];
    
    //从当前上下文获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    _image = image;
    //关闭图像上下文
    UIGraphicsEndImageContext();
    //保存图像到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

 #pragma mark 保存完成后调用的方法[格式固定]
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 {
         if (error) {
                 NSLog(@"error-%@", error.localizedDescription);
             }else{
                     NSLog(@"保存成功");
                }
     }

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSLog(@"取消摇动");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSLog(@"摇动结束");
    
    //将图片展示到界面
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc]initWithImage:_image];
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.borderColor = [UIColor redColor].CGColor;
    _imageView.layer.borderWidth = 3;
    _imageView.center = self.view.center;
    
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 0.4;
    } completion:^(BOOL finished) {
        _imageView.alpha = 1.0;
        _imageView.hidden = NO;
    }];
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
