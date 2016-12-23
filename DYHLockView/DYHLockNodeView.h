//
//  DYHLockNodeView.h
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/23.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LIGHTBLUE [UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1]

typedef NS_ENUM(NSInteger, DYHLockNodeViewStatus) {
    DYHLockNodeViewStatusNormal,
    DYHLockNodeViewStatusSelected,
    DYHLockNodeViewStatusWarning
};


@interface DYHLockNodeView : UIView

@property (nonatomic, assign) DYHLockNodeViewStatus nodeViewStatus;

@end
