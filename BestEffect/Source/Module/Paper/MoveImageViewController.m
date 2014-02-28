//
//  MoveImageViewController.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-18.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "MoveImageViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MoveImageViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation MoveImageViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadSubViews];
}

- (void)loadSubViews
{
  self.mainScrollView = [[UIScrollView alloc] init];
  [self.view addSubview:self.mainScrollView];
  
  self.mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  self.mainScrollView.bounces = NO;
  
  self.mainScrollView.userInteractionEnabled = NO;
  
  //set up the image view
  UIImage *image= [UIImage imageNamed:@"orionfull_jcc_big"];
  UIImageView *movingImageView = [[UIImageView alloc]initWithImage:image];
  [self.mainScrollView addSubview:movingImageView];
  
  //set up the content size based on the image size
  //in facebook paper case, vertical rotation doesn't do anything
  //so we dont have to set up the content size height
  self.mainScrollView.contentSize = CGSizeMake(movingImageView.frame.size.width, self.mainScrollView.frame.size.height);
  
  //center the image at intial
  self.mainScrollView.contentOffset = CGPointMake((self.mainScrollView.contentSize.width - self.view.frame.size.width) / 2, 0);
  
  //inital the motionManager and detec the Gyroscrope for every 1/60 second
  //the interval may not need to be that fast
  self.motionManager = [[CMMotionManager alloc] init];
  self.motionManager.gyroUpdateInterval = 1/60;
  
  //this is how fast the image should move when rotate the device, the larger the number, the less the roation required.
  CGFloat motionMovingRate = 4;
  
  //get the max and min offset x value
  int maxXOffset = self.mainScrollView.contentSize.width - self.mainScrollView.frame.size.width;
  int minXOffset = 0;
  
  [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                  withHandler:^(CMGyroData *gyroData, NSError *error) {
                                    //since our hands are not prefectly steady
                                    //so it will always have small rotation rate between 0.01 - 0.05
                                    //i am ignoring if the rotation rate is less then 0.1
                                    //if you want this to be more sensitive, lower the value here
                                    if (fabs(gyroData.rotationRate.y) >= 0.1) {
                                      CGFloat targetX = self.mainScrollView.contentOffset.x - gyroData.rotationRate.y * motionMovingRate;
                                      //check if the target x is less than min or larger than max
                                      //if do, use min or max
                                      if(targetX > maxXOffset)
                                        targetX = maxXOffset;
                                      else if (targetX < minXOffset)
                                        targetX = minXOffset;
                                      
                                      //set up the content off
                                      self.mainScrollView.contentOffset = CGPointMake(targetX, 0);
                                    }
                                  }];
}

@end
