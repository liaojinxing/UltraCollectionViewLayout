//
//  CollectionViewController.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-28.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "UltraCollectionViewLayout.h"


#define CELL_IDENTIFIER @"CollectionCell"

@implementation CollectionViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
  if (!_collectionView) {
    UltraCollectionViewLayout *layout = [[UltraCollectionViewLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 30;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CollectionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
  }
  return _collectionView;
}

#pragma mark - Life Cycle

- (void)dealloc
{
  _collectionView.delegate = nil;
  _collectionView.dataSource = nil;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CollectionCell *cell =
  (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                              forIndexPath:indexPath];
  cell.displayString = [NSString stringWithFormat:@"%d", indexPath.item];
  int a = random() % 255;
  int b = random() % 255;
  int c = random() % 255;
  [cell.displayLabel setBackgroundColor:[UIColor colorWithRed:a / 255.0
                                                        green:b / 255.0
                                                         blue:c / 255.0
                                                        alpha:1.0f]];
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGPoint point = scrollView.contentOffset;
  UltraCollectionViewLayout *layout = (UltraCollectionViewLayout *)self.collectionView.collectionViewLayout;
  CGPoint anotherPoint = CGPointMake(point.x, point.y + 100);
  NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:anotherPoint];
  
  [self.collectionView performBatchUpdates:^{
    [layout setShowingIndex:path.item];
  } completion:nil];
}

@end
