//
//  TileView.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "TileView.h"

@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	if (self.image) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.image = self.image;
		imageView.layer.cornerRadius = self.layer.cornerRadius;
		imageView.layer.masksToBounds = YES;
		imageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:imageView];
		[self bringSubviewToFront:imageView];
	} else {
		self.label = [[UILabel alloc] initWithFrame:self.bounds];
		[self addSubview:self.label];
		self.label.textAlignment = NSTextAlignmentCenter;
		self.label.text = self.text;
		self.label.textColor = self.textColor;
		CGFloat fontSize = 25.0f;
		self.label.font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
	}
}

@end
