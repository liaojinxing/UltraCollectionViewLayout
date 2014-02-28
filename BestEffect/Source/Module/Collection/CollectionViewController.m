//
//  CollectionViewController.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-28.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"


#define CELL_IDENTIFIER @"CollectionCell"

@implementation CollectionViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
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

- (void)dealloc {
  _collectionView.delegate = nil;
  _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:self.collectionView];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 5;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CollectionCell *cell =
  (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                              forIndexPath:indexPath];
  cell.displayString = [NSString stringWithFormat:@"%d", indexPath.item];
  return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(300, indexPath.item * random() % 100 + 100);
}

@end
