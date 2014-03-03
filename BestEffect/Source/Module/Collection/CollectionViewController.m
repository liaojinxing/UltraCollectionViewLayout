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
#import "CollectionFooterView.h"

#define CELL_IDENTIFIER        @"CollectionCell"
#define CELL_FOOTER_IDENTIFIER @"CollectionFooter"

@implementation CollectionViewController

- (UICollectionView *)collectionView
{
  if (!_collectionView) {
    UltraCollectionViewLayout *layout = [[UltraCollectionViewLayout alloc] init];
    layout.expandItemHeight = 300;
    layout.shrinkItemHeight = 120;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal / 10;
    [_collectionView registerClass:[CollectionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [_collectionView registerClass:[CollectionFooterView class]
        forSupplementaryViewOfKind:collectionKindSectionFooter withReuseIdentifier:CELL_FOOTER_IDENTIFIER];
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

  if (indexPath.row % 2 == 0) {
    [cell.displayLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
  } else {
    [cell.displayLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
  }
  [cell.coverImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg", indexPath.item+1]]];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableView =
  [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                     withReuseIdentifier:CELL_FOOTER_IDENTIFIER
                                            forIndexPath:indexPath];
  return reusableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGPoint point = scrollView.contentOffset;
  UltraCollectionViewLayout *layout = (UltraCollectionViewLayout *)self.collectionView.collectionViewLayout;
  CGPoint anotherPoint = CGPointMake(point.x, point.y + layout.expandItemHeight - layout.shrinkItemHeight);
  NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:anotherPoint];
  if (point.y <= layout.shrinkItemHeight) {
    path = [NSIndexPath indexPathForRow:0 inSection:0];
  }
  
  [self.collectionView performBatchUpdates:^{
    [layout setShowingIndex:path.item];
  } completion:nil];
  
  [self.collectionView scrollToItemAtIndexPath:path
                              atScrollPosition:UICollectionViewScrollPositionLeft
                                      animated:NO];
}

@end
