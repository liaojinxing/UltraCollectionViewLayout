//
//  UltraCollectionViewLayout.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-28.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "UltraCollectionViewLayout.h"

NSString *const collectionKindSectionFooter = @"KindSectionFooter";

@interface UltraCollectionViewLayout ()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, strong) NSMutableArray *itemYOffset;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, strong) NSMutableArray *footersAttrubite;
@end


@implementation UltraCollectionViewLayout

- (void)setItemWidth:(CGFloat)itemWidth
{
  if (_itemWidth != itemWidth) {
    _itemWidth = itemWidth;
    [self invalidateLayout];
  }
}

- (void)setExpandItemHeight:(CGFloat)expandItemHeight
{
  if (_expandItemHeight != expandItemHeight) {
    _expandItemHeight = expandItemHeight;
    [self invalidateLayout];
  }
}

- (void)setShrinkItemHeight:(CGFloat)shrinkItemHeight
{
  if (_shrinkItemHeight != shrinkItemHeight) {
    _shrinkItemHeight = shrinkItemHeight;
    [self invalidateLayout];
  }
}

- (void)setShowingIndex:(NSInteger)showingIndex
{
  if (_showingIndex != showingIndex) {
    _showingIndex = showingIndex;
    [self invalidateLayout];
  }
}

- (void)setFooterHeight:(CGFloat)footerHeight
{
  if (_footerHeight != footerHeight) {
    _footerHeight = footerHeight;
    [self invalidateLayout];
  }
}

- (NSMutableArray *)itemAttributes {
  if (!_itemAttributes) {
    _itemAttributes = [NSMutableArray array];
  }
  return _itemAttributes;
}

- (NSMutableArray *)itemYOffset
{
  if (!_itemYOffset) {
    _itemYOffset = [NSMutableArray array];
  }
  return _itemYOffset;
}

- (NSMutableArray *)footersAttrubite {
  if (!_footersAttrubite) {
    _footersAttrubite = [NSMutableArray array];
  }
  return _footersAttrubite;
}

- (void)commonInit
{
  _expandItemHeight = 250;
  _shrinkItemHeight = 100;
  _cellCount = 0;
  _itemWidth = 320;
  _showingIndex = 0;
  _footerHeight = 568 - _expandItemHeight;
}

- (id)init
{
  if (self = [super init]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}

- (void)prepareLayout
{
  [super prepareLayout];
  
  NSInteger numberOfSections = [self.collectionView numberOfSections];
  if (numberOfSections == 0) {
    _cellCount = 0;
  } else {
    _cellCount = [self.collectionView numberOfItemsInSection:0];
  }
  
  [self.itemYOffset removeAllObjects];
  [self.itemAttributes removeAllObjects];
  [self.footersAttrubite removeAllObjects];
  
  UICollectionViewLayoutAttributes *attributes;
  CGFloat width = self.collectionView.frame.size.width;
  CGFloat xOffset = ceilf((width - _itemWidth) / 2);
  CGFloat yOffset = 0;
  
  for (int i = 0; i < _cellCount; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemHeight = (i == _showingIndex) ? _expandItemHeight : _shrinkItemHeight;
    attributes.frame = CGRectMake(xOffset, yOffset, _itemWidth, itemHeight);
    attributes.zIndex = i;
    [self.itemYOffset addObject:@(yOffset)];
    [self.itemAttributes addObject:attributes];
    yOffset += itemHeight;
  }
  
  _footerHeight = MAX(self.collectionView.frame.size.height - _expandItemHeight - (_cellCount - _showingIndex) * _shrinkItemHeight, _footerHeight);
  attributes = [UICollectionViewLayoutAttributes
                layoutAttributesForSupplementaryViewOfKind:collectionKindSectionFooter
                withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  attributes.frame = CGRectMake(0, yOffset, width, _footerHeight);
  _footersAttrubite[0] = attributes;
}

- (CGSize)collectionViewContentSize
{
  if (_cellCount == 0) {
    return CGSizeZero;
  }
  CGSize contentSize = self.collectionView.bounds.size;
  contentSize.height = (_cellCount - 1) * _shrinkItemHeight + self.collectionView.frame.size.height;
  return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
  if (path.section != 0) {
    return nil;
  }
  if (path.item >= [self.itemAttributes count]) {
    return nil;
  }
  return self.itemAttributes[path.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  /*UICollectionViewLayoutAttributes *attribute = nil;
  if ([kind isEqualToString:collectionKindSectionFooter]) {
    attribute = self.footersAttrubite[0];
  }*/
  return self.footersAttrubite[0];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSMutableArray *layoutAttributes = [NSMutableArray array];
  
  for (int i = 0; i < _cellCount; i++) {
    NSNumber *yOffset = [self.itemYOffset objectAtIndex:i];
    CGFloat itemHeight = (i == _showingIndex) ? _expandItemHeight : _shrinkItemHeight;
    CGRect itemFrame = CGRectMake(0, yOffset.floatValue, self.collectionView.frame.size.width, itemHeight);
    if (CGRectIntersectsRect(rect, itemFrame)) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
      [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
  }
  
  NSNumber *yOffset = [self.itemYOffset objectAtIndex:_cellCount - 1];
  CGFloat footerYOffset = (_cellCount == _showingIndex) ? yOffset.floatValue + _expandItemHeight : yOffset.floatValue + _shrinkItemHeight;
  CGRect frame = CGRectMake(0, footerYOffset, self.collectionView.frame.size.width, _footerHeight);
  if (CGRectIntersectsRect(rect, frame)) {
    [layoutAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:collectionKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
  }
  return layoutAttributes;
}


@end
