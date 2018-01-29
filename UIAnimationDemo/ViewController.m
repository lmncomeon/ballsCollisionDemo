//
//  ViewController.m
//  LYDynamicDemo
//
//  Created by CNFOL_iOS on 2017/6/13.
//  Copyright © 2017年 com.LYoung. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) CMMotionManager *manager;

@end

@implementation ViewController

- (NSMutableArray *)viewsArray
{
    if (!_viewsArray) {
        _viewsArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _viewsArray;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat subWH = 50;
    CGFloat padding = 10;
    for (int i = 0; i < 20; i++) {
        NSInteger row = i / 5;
        NSInteger col = i % 5;
        
        UIView *sub = [[UIView alloc] initWithFrame:CGRectMake(padding+ col*(subWH + padding), 100+row*(subWH + padding), subWH, subWH)];
        sub.backgroundColor = [UIColor purpleColor];
        sub.layer.masksToBounds = YES;
        sub.layer.cornerRadius = subWH*0.5;
        [self.view addSubview:sub];
        
        [self.viewsArray addObject:sub];
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
}

- (void)tapAction
{
    // garvity
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.viewsArray.copy];
    gravity.magnitude = 10;
    
    // collision
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.viewsArray.copy];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    // elastic
    UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:self.viewsArray.copy];
    dynamic.elasticity = 0.6;
    dynamic.allowsRotation = YES;
    
    
    [self.animator addBehavior:collision];
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:dynamic];
 
    self.manager = [[CMMotionManager alloc] init];
    self.manager.deviceMotionUpdateInterval = 1.0/30.;
    
    if (self.manager.isDeviceMotionAvailable) {
        [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            NSString *yaw   = [NSString stringWithFormat:@"%f",motion.attitude.yaw];
            NSString *pitch = [NSString stringWithFormat:@"%f",motion.attitude.pitch];
            NSString *roll  = [NSString stringWithFormat:@"%f",motion.attitude.roll];
            
            double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
            
            //重力角度
            gravity.angle = rotation;
        }];
    }
    
}

@end

