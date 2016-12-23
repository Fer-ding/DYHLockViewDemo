//
//  DYHLockView.h
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/23.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYHLockViewState) {
    DYHLockViewStateNormal,
    DYHLockViewStateWarning,
    DYHLockViewStateSelected
};

@protocol DYHLockViewDelegate;

@interface DYHLockView : UIView

@property (nonatomic, weak) id<DYHLockViewDelegate> delegate;

@end

@protocol DYHLockViewDelegate <NSObject>

@optional

- (DYHLockViewState)lockView:(DYHLockView *)lockView didEndSwipeWithPassword:(NSString *)password;


@end
