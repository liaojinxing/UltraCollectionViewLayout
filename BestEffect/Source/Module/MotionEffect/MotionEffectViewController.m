//
//  MotionEffectViewController.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-17.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "MotionEffectViewController.h"
#import "NGAParallaxMotion.h"

@interface MotionEffectViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation MotionEffectViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadSubViews];
}

- (void)loadSubViews
{
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
  [self.imageView setImage:[UIImage imageNamed:@"bug"]];
  [self.view addSubview:self.imageView];
  
  self.label = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
  [self.label setText:@"bug"];
  [self.label setHidden:YES];
  [self.view addSubview:self.label];
  
  UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 330, 100, 100)];
  [button1 setTitle:@"pause" forState:UIControlStateNormal];
  [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [button1 addTarget:self action:@selector(pauseLayer) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button1];
  
  UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 330, 100, 100)];
  [button2 setTitle:@"resume" forState:UIControlStateNormal];
  [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [button2 addTarget:self action:@selector(resumeLayer) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button2];
}

- (void)addMotionEffect
{
  UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  horizontalMotionEffect.minimumRelativeValue = @(-50);
  horizontalMotionEffect.maximumRelativeValue = @(50);
  [self.imageView addMotionEffect:horizontalMotionEffect];
  
  UIInterpolatingMotionEffect *shadowEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  shadowEffect.minimumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(-10, 5)];
  shadowEffect.maximumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(10, 5)];
  
  [self.imageView addMotionEffect:shadowEffect];
}

- (void)addImageAnimation
{
  [UIView animateWithDuration:1.0f animations:^{
    CAKeyframeAnimation* widthAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderWidth"];
    widthAnim.delegate = self;
    NSArray* widthValues = [NSArray arrayWithObjects:@1.0, @10.0, @5.0, @30.0, @0.5, @15.0, @2.0, @50.0, @0.0, nil];
    widthAnim.values = widthValues;
    widthAnim.calculationMode = kCAAnimationPaced;
    
    // Animation 2
    CAKeyframeAnimation* colorAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    NSArray* colorValues = [NSArray arrayWithObjects:(id)[UIColor greenColor].CGColor,
                            (id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor,  nil];
    colorAnim.values = colorValues;
    colorAnim.calculationMode = kCAAnimationPaced;
    
    // Animation group
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:colorAnim, widthAnim, nil];
    group.duration = 5.0;
    
    colorAnim.delegate = self;
    
    [self.imageView.layer addAnimation:group forKey:@"BorderChanges"];
  }];
}

- (void)transitionEffect
{
  [UIView animateWithDuration:2.0f animations:^{
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 2.0;
    
    // Add the transition animation to both layers
    [self.imageView.layer addAnimation:transition forKey:@"transition"];
    [self.label.layer addAnimation:transition forKey:@"transition"];
    // Finally, change the visibility of the layers.
    self.imageView.hidden = YES;
    self.label.hidden = NO;
  }];
}

-(void)pauseLayer {
  CALayer *layer = self.imageView.layer;
  CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
  layer.speed = 0.0;
  layer.timeOffset = pausedTime;
}

-(void)resumeLayer {
  CALayer *layer = self.imageView.layer;
  CFTimeInterval pausedTime = [layer timeOffset];
  layer.speed = 1.0;
  layer.timeOffset = 0.0;
  layer.beginTime = 0.0;
  CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
  layer.beginTime = timeSincePause;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
  NSLog(@"%@, begin", anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  NSLog(@"%@, stop", anim);
}

@end
