//
//  MotionEffectViewController.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-17.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "MotionEffectViewController.h"

@implementation MotionEffectViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadSubViews];
}

- (void)loadSubViews
{
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
  [imageView setImage:[UIImage imageNamed:@"bug"]];
  [self.view addSubview:imageView];
  
  UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  horizontalMotionEffect.minimumRelativeValue = @(-50);
  horizontalMotionEffect.maximumRelativeValue = @(50);
  [imageView addMotionEffect:horizontalMotionEffect];
  
  UIInterpolatingMotionEffect *shadowEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
  shadowEffect.minimumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(-10, 5)];
  shadowEffect.maximumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(10, 5)];
  [imageView addMotionEffect:shadowEffect];
}

@end
