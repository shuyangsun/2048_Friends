//
//  TileSKShapeNode.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/20/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, TileType) {
	TileTypeImage = 0,
	TileTypeNumber
};

@interface TileSKShapeNode : SKShapeNode <NSCopying>

@property (nonatomic) int32_t value;
@property (strong, nonatomic) NSString *displayText;
@property (strong, nonatomic) SKColor *textColor;
@property (nonatomic) TileType type;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSUUID *uuid;

-(void)setValue: (int32_t)val
		   text: (NSString *)text
	  textColor: (UIColor *)textColor
		   type: (TileType) type;

@end
