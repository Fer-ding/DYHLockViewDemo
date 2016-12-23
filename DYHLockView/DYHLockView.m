//
//  DYHLockView.m
//  DYHLockViewDemo
//
//  Created by YueHui on 16/12/23.
//  Copyright © 2016年 LeapDing. All rights reserved.
//

#import "DYHLockView.h"
#import "DYHLockNodeView.h"

@interface DYHLockView ()

@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *selectedNodes;

@property (nonatomic, strong) CAShapeLayer *polygonLineLayer;
@property (nonatomic, strong) UIBezierPath *polygonLinePath;

@property (nonatomic, strong) NSMutableArray *points;

@property (nonatomic, assign) DYHLockViewState viewState;

@end

@implementation DYHLockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self.layer addSublayer:self.polygonLineLayer];
    
    _nodes = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 9; i++) {
        DYHLockNodeView *nodeView = [[DYHLockNodeView alloc] init];
        nodeView.tag = i;
        [_nodes addObject:nodeView];
        [self addSubview:nodeView];
    }
    
    _selectedNodes = [NSMutableArray arrayWithCapacity:9];
    _points = [NSMutableArray array];
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.viewState = DYHLockNodeViewStatusNormal;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    // 查找手指滑过的node
    NSInteger index = [self indexForNodeAtPoint:touchPoint];
    if (index >= 0) {
        DYHLockNodeView *node = self.nodes[index];
        
        if (![self addSelectedNode:node]) {
            //移动线到手势位置
            [self moveLineWithFingerPosition:touchPoint];
        }
        
    } else {
        [self moveLineWithFingerPosition:touchPoint];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeLastFingerPosition];
    if([self.delegate respondsToSelector:@selector(lockView:didEndSwipeWithPassword:)]) {
        
        NSMutableString *password = [NSMutableString new];
        for(DYHLockNodeView *nodeView in self.selectedNodes) {
            NSString *index = [@(nodeView.tag) stringValue];
            [password appendString:index];
        }
        self.viewState = [self.delegate lockView:self didEndSwipeWithPassword:password];
        
    } else {
        self.viewState = DYHLockViewStateSelected;
    }
}

- (BOOL)addSelectedNode:(DYHLockNodeView *)nodeView {
    
    if (![self.selectedNodes containsObject:nodeView]) {
        nodeView.nodeViewStatus = DYHLockNodeViewStatusSelected;
        [self.selectedNodes addObject:nodeView];
        
        [self addLineToNode:nodeView];
        
        return YES;
    }
    return NO;
}

- (void)addLineToNode:(DYHLockNodeView *)nodeView {
    
    if (self.selectedNodes.count == 1) {
        
        //path move to start point
        CGPoint startPoint = nodeView.center;
        [self.polygonLinePath moveToPoint:startPoint];
        [self.points addObject:[NSValue valueWithCGPoint:startPoint]];
        self.polygonLineLayer.path = self.polygonLinePath.CGPath;
        
    } else {
        
        //path add line to point
        [self.points removeLastObject];
        CGPoint middlePoint = nodeView.center;
        [self.points addObject:[NSValue valueWithCGPoint:middlePoint]];
        
        [self.polygonLinePath removeAllPoints];
        CGPoint startPoint = [self.points.firstObject CGPointValue];
        [self.polygonLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.points.count; i++) {
            CGPoint middlePoint = [self.points[i] CGPointValue];
            [self.polygonLinePath addLineToPoint:middlePoint];
        }
        self.polygonLineLayer.path = self.polygonLinePath.CGPath;
    }
}

- (void)moveLineWithFingerPosition:(CGPoint)touchPoint {
    
    if (self.points.count) {
        if (self.points.count > self.selectedNodes.count) {
            [self.points removeLastObject];
        }
        [self.points addObject:[NSValue valueWithCGPoint:touchPoint]];
        [self.polygonLinePath removeAllPoints];
        CGPoint startPoint = [self.points.firstObject CGPointValue];
        [self.polygonLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.points.count; i++) {
            CGPoint middlePoint = [self.points[i] CGPointValue];
            [self.polygonLinePath addLineToPoint:middlePoint];
        }
        self.polygonLineLayer.path = self.polygonLinePath.CGPath;
    }
}

- (void)removeLastFingerPosition {
    
    if (self.points.count) {
        if (self.points.count > self.selectedNodes.count) {
            [self.points removeLastObject];
        }
        [self.polygonLinePath removeAllPoints];
        CGPoint startPoint = [self.points.firstObject CGPointValue];
        [self.polygonLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.points.count; i++) {
            CGPoint middlePoint = [self.points[i] CGPointValue];
            [self.polygonLinePath addLineToPoint:middlePoint];
        }
        self.polygonLineLayer.path = self.polygonLinePath.CGPath;
        
    }
}

- (void)layoutSubviews {
    
    //添加一个mask层
    self.polygonLineLayer.frame = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.lineWidth = 1.0f;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    //每行3个nodeView，没列3个，上下左右间距为一个nodeView的宽
    for (int i = 0; i < self.nodes.count; i++) {
        DYHLockNodeView *nodeView = self.nodes[i];
        CGFloat min = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height;
        CGFloat width = min / 5;
        CGFloat height = width;
        int row = i % 3;
        int column = i / 3;
        CGRect frame = CGRectMake(row * (width * 2), column * (width * 2), width, height);
        nodeView.frame = frame;
        [maskPath appendPath:[UIBezierPath bezierPathWithOvalInRect:frame]];
    }
    
    maskLayer.path = maskPath.CGPath;
    self.polygonLineLayer.mask = maskLayer;
}

- (NSInteger)indexForNodeAtPoint:(CGPoint)point {
    
    for (int i = 0; i < self.nodes.count; i++) {
        DYHLockNodeView *node = self.nodes[i];
        CGPoint pointInNode = [node convertPoint:point fromView:self];
        if ([node pointInside:pointInNode withEvent:nil]) {
            NSLog(@"点中了第%d个~~", i);
            return i;
        }
    }
    return -1;
}

- (void)cleanNodes {
    
    for (int i = 0; i < self.nodes.count; i++) {
        DYHLockNodeView *node = self.nodes[i];
        node.nodeViewStatus = DYHLockNodeViewStatusNormal;
    }
    
    [self.selectedNodes removeAllObjects];
    [self.points removeAllObjects];
    self.polygonLinePath = [UIBezierPath new];
    self.polygonLineLayer.strokeColor = LIGHTBLUE.CGColor;
    self.polygonLineLayer.path = self.polygonLinePath.CGPath;
}

- (void)cleanNodesIfNeeded {
    
    if(self.viewState != DYHLockNodeViewStatusNormal){
        [self cleanNodes];
    }
}

- (void)makeNodesToWarning {
    
    for (int i = 0; i < self.selectedNodes.count; i++) {
        DYHLockNodeView *node = self.selectedNodes[i];
        node.nodeViewStatus = DYHLockNodeViewStatusWarning;
    }
    self.polygonLineLayer.strokeColor = [UIColor redColor].CGColor;
}

- (void)setViewState:(DYHLockViewState)viewState {
    
    _viewState = viewState;
    switch (_viewState){
        case DYHLockViewStateNormal:
            [self cleanNodes];
            break;
        case DYHLockViewStateWarning:
            [self makeNodesToWarning];
            [self performSelector:@selector(cleanNodesIfNeeded) withObject:nil afterDelay:1];
            break;
        case DYHLockViewStateSelected:
        default:
            break;
    }
}

- (CAShapeLayer *)polygonLineLayer {
    
    if (!_polygonLineLayer) {
        _polygonLineLayer = [[CAShapeLayer alloc] init];
        _polygonLineLayer.lineWidth = 1.0f;
        _polygonLineLayer.strokeColor = LIGHTBLUE.CGColor;
        _polygonLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _polygonLineLayer;
}


@end
