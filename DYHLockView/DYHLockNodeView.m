//
//  DYHLockNodeView.m
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/23.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "DYHLockNodeView.h"

@interface DYHLockNodeView ()

/**
 手势外部的空心圆
 */
@property (nonatomic, strong) CAShapeLayer *outlineLayer;

/**
 手势内部的实心圆
 */
@property (nonatomic, strong) CAShapeLayer *innerCircleLayer;

@end

@implementation DYHLockNodeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self.layer addSublayer:self.outlineLayer];
    [self.layer addSublayer:self.innerCircleLayer];
    self.nodeViewStatus = DYHLockNodeViewStatusNormal;
    
    return self;
}

- (void)layoutSubviews {
    
    self.outlineLayer.frame = self.bounds;
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.outlineLayer.path = outlinePath.CGPath;
    
    //中心圆的直径为外部圆的1/3
    CGFloat innerWidth = self.bounds.size.width / 3;
    self.innerCircleLayer.frame = CGRectMake(innerWidth, innerWidth, innerWidth, innerWidth);
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.innerCircleLayer.bounds];
    self.innerCircleLayer.path = innerPath.CGPath;
}

- (void)setNodeViewStatus:(DYHLockNodeViewStatus)nodeViewStatus {
    
    _nodeViewStatus = nodeViewStatus;
    switch (_nodeViewStatus) {
        case DYHLockNodeViewStatusNormal:
            [self setStatusNormal];
            break;
        case DYHLockNodeViewStatusSelected:
            [self setStatusSelected];
            break;
        case DYHLockNodeViewStatusWarning:
            [self setStatusWarning];
            break;
        default:
            break;
    }
}

- (void)setStatusNormal {
    
    self.outlineLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setStatusSelected {
    
    self.outlineLayer.strokeColor = LIGHTBLUE.CGColor;
    self.innerCircleLayer.fillColor = LIGHTBLUE.CGColor;
}

- (void)setStatusWarning {
    
    self.outlineLayer.strokeColor = [UIColor redColor].CGColor;
    self.innerCircleLayer.fillColor = [UIColor redColor].CGColor;
}

- (CAShapeLayer *)outlineLayer {
    
    if (!_outlineLayer) {
        _outlineLayer = [[CAShapeLayer alloc] init];
        _outlineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _outlineLayer.lineWidth = 1.0f;
        _outlineLayer.fillColor  = [UIColor clearColor].CGColor;
    }
    return _outlineLayer;
}

- (CAShapeLayer *)innerCircleLayer {
    
    if (!_innerCircleLayer) {
        _innerCircleLayer = [[CAShapeLayer alloc] init];
        _innerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        _innerCircleLayer.lineWidth = 1.0f;
        _innerCircleLayer.fillColor  = LIGHTBLUE.CGColor;;
    }
    return _innerCircleLayer;
}


@end
