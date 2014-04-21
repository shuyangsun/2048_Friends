//
//  TileSKShapeNode.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/20/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TileSKShapeNode : SKShapeNode

@property (nonatomic) int32_t value;
@property (strong, nonatomic) NSString *displayText;
@property (strong, nonatomic) UIImage *image;

@end
