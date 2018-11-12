//
//  ZZViewController.m
//  AlertHelper
//
//  Created by SunnyXG on 11/09/2018.
//  Copyright (c) 2018 SunnyXG. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZAlertHelper.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)defaultTextTapped:(id)sender {
//    AlertText(self.view).title(@"这是一条提示信息").show();
    AlertView(self.view).title(@"标题标题").message(@"这是辩题信息是不多见啊看得见撒个谎框架的").cancelButton(@"取消").confirmButton(@"确定").cancelHandler(^{
        NSLog(@"cancel!");
    }).confirmHandler(^{
        NSLog(@"confirm!");
    }).show();
}

- (IBAction)buttonConfirmTapped:(id)sender {
    AlertView(self.view).title(@"这是一条提示信息 \n 提示信息").cancelButton(@"取消").confirmButton(@"确定").cancelHandler(^{
        NSLog(@"cancel!");
    }).confirmHandler(^{
        NSLog(@"confirm!");
    }).show();
}

- (IBAction)imageTextTapped:(id)sender {
    AlertView(self.view).image([UIImage imageNamed:@"tishi"]).title(@"这是一条提示信息").confirmButton(@"确定").cancelButton(@"取消").confirmHandler(^{
        NSLog(@"confirm tapped!");
    }).show();
}

- (IBAction)alertWithSingleButton:(id)sender {
    AlertView(self.view).title(@"这是一条提示信息").confirmButton(@"确认").confirmHandler(^{
        NSLog(@"confirm!");
    }).show();
}

- (IBAction)alertAtWindow:(id)sender {
//    AlertTextInWindow().title(@"这是一条提示信息").show();
    AlertViewInWindow().title(@"这是一条提示信息").confirmButton(@"确定").cancelButton(@"取消").confirmHandler(^{
        NSLog(@"confirm tapped!");
    }).show();
}

@end
