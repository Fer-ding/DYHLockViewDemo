//
//  ViewController.m
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/23.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "ViewController.h"
#import "DYHCheckController.h"
#import "DYHInitPasswordController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    label.text = @"hello world";
    CGFloat margin = 20.0f;
    CGFloat width = self.view.bounds.size.width - margin * 2;
    
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, width, 20)];
    [setButton setTitle:@"set gesture password" forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, width, 20)];
    [checkButton setTitle:@"check gesture password" forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkButton];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setButtonBeTouched {
    DYHInitPasswordController *controller = [[DYHInitPasswordController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)checkButtonBeTouched {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"]) {
        DYHCheckController *controller = [[DYHCheckController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"no gesture password set" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}



@end
