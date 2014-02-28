//
//  CollectionCell.m
//  BestEffect
//
//  Created by liaojinxing on 14-2-28.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (UILabel *)displayLabel {
	if (!_displayLabel) {
		_displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
		_displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_displayLabel.backgroundColor = [UIColor lightGrayColor];
		_displayLabel.textColor = [UIColor whiteColor];
		_displayLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
	if (![_displayString isEqualToString:displayString]) {
		_displayString = [displayString copy];
		self.displayLabel.text = _displayString;
	}
}

#pragma mark - Life Cycle
- (void)dealloc {
	[_displayLabel removeFromSuperview];
	_displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self.contentView addSubview:self.displayLabel];
	}
	return self;
}

@end
