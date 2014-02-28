//
//  UltraCollectionViewLayout.h
//  BestEffect
//
//  Created by liaojinxing on 14-2-28.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const collectionKindSectionFooter;

@interface UltraCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat expandItemHeight;
@property (nonatomic, assign) CGFloat shrinkItemHeight;
@property (nonatomic, assign) NSInteger showingIndex;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat footerHeight;

@end
