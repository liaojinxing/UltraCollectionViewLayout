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
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 30;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor blueColor];
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
    [cell.displayLabel setBackgroundColor:[UIColor greenColor]];
  } else {
    [cell.displayLabel setBackgroundColor:[UIColor blueColor]];
  }
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
  
  [self.collectionView performBatchUpdates:^{
    [layout setShowingIndex:path.item];
  } completion:nil];
}

@end
