//
//  ViewController.m
//  JKExceptionHandler
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *bt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.view addSubview:self.bt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)bt {
    if (!_bt) {
        _bt = [UIButton buttonWithType:UIButtonTypeCustom];
        _bt.frame = CGRectMake(0, 0, 100, 100);
        _bt.center = self.view.center;
        _bt.backgroundColor = [UIColor redColor];
        
        [_bt addTarget:self action:@selector(crashBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bt;
}

- (IBAction)crashBtn:(id)sender {
    
    // 0
    id didi = nil;
    NSMutableArray *ma = [NSMutableArray array];
    [ma addObject:didi];
    
    // 1
//    NSArray *arry=[NSArray arrayWithObject:@"sss"];
//    NSLog(@"%@",[arry objectAtIndex:1]);

//    [self sendEmail];
    
}

- (void)sendEmail {
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto:676034647@qq.com"];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", @"dididididiidi,lao si ji  kaiche"];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
    
    NSLog(@".....");
}

@end
