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
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	[self addSubview:self.label];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = self.text;
}

@end
