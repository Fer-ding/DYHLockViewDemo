//
//  DYHCheckController.m
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/22.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "DYHCheckController.h"
#import "DYHLockView.h"

@interface DYHCheckController ()<DYHLockViewDelegate>
@property (nonatomic, weak) DYHLockView *lockView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic) NSUInteger unmatchCounter;
@property (nonatomic, weak) UILabel *counterLabel;
@end

@implementation DYHCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:39/255.0 blue:54/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @" to unlock";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(10, 60, self.view.bounds.size.width - 20, 20);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, self.view.bounds.size.width - 20, 20)];
    counterLabel.textColor = [UIColor redColor];
    counterLabel.textAlignment = NSTextAlignmentCenter;
    counterLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:counterLabel];
    self.counterLabel = counterLabel;
    self.counterLabel.hidden = YES;
    
    
    CGFloat viewWidth = self.view.bounds.size.width - 40;
    CGFloat viewHeight = viewWidth;
    
    DYHLockView *lockView = [[DYHLockView alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - viewHeight - 40 - 100, viewWidth, viewHeight)];
    [self.view addSubview:lockView];
    
    self.lockView = lockView;
    self.lockView.delegate = self;
    
    self.unmatchCounter = 5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DYHLockViewState)lockView:(DYHLockView *)lockView didEndSwipeWithPassword:(NSString *)password {
    
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    if ([savedPassword isEqualToString:password]) {
        [self dismiss];
        return DYHLockViewStateNormal;
    }else{
        self.unmatchCounter--;
        if (self.unmatchCounter == 0) {
            self.counterLabel.text = @"5 times unmatched";
            self.counterLabel.hidden = NO;
            
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            
        }else {
            self.counterLabel.text = [NSString stringWithFormat:@"unmatched, %lu times left", (unsigned long)self.unmatchCounter];
            self.counterLabel.hidden = NO;
        }
        return DYHLockViewStateWarning;
    }

}

- (void)dismiss {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
