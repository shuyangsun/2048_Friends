//
//  TileView.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView

@property (nonatomic) int32_t val;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) TileView *nextTileView;

@end
