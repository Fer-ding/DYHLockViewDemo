//
//  DYHInitPasswordController.m
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/22.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "DYHInitPasswordController.h"
#import "DYHLockView.h"

@interface DYHInitPasswordController () <DYHLockViewDelegate>
@property (nonatomic, weak) DYHLockView *lockView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSString *passwordString;
@property (nonatomic, weak) UIButton *resetButton;
@end

@implementation DYHInitPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:39/255.0 blue:54/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"set your gesture password";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(40, 60, self.view.bounds.size.width - 80, 20);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    CGFloat viewWidth = self.view.bounds.size.width - 40;
    CGFloat viewHeight = viewWidth;
    
    DYHLockView *lockView = [[DYHLockView alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - viewHeight - 40 - 100, viewWidth, viewHeight)];
    [self.view addSubview:lockView];
    
    self.lockView = lockView;
    self.lockView.delegate = self;
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, 60, 40, 20)];
    [resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    self.resetButton = resetButton;
    self.resetButton.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DYHLockViewState)lockView:(DYHLockView *)lockView didEndSwipeWithPassword:(NSString *)password {
    
    if (!self.passwordString) {
        self.passwordString = password;
        self.titleLabel.text = @"confirm your gesture password again";
        return DYHLockViewStateNormal;
    }else if ([self.passwordString isEqualToString:password]){
        self.titleLabel.text = @"set succeed";
        self.passwordString = nil;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:password forKey:@"gesturePassword"];
        
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        return DYHLockViewStateSelected;
    }else{
        self.titleLabel.text = @"different from last time";
        self.resetButton.hidden = NO;
        return DYHLockViewStateWarning;
    }

}

- (void)dismiss {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)reset {
    self.passwordString = nil;
    self.titleLabel.text = @"set your gesture password";
    self.resetButton.hidden = YES;
}

@end
