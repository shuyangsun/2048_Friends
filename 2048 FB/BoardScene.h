//
//  BoardScene.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern const NSTimeInterval kAnimationDuration_TileContainerPopup;

@class Theme;

@interface BoardScene : SKScene

@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) NSMutableArray *data;

+(instancetype)sceneWithSize:(CGSize)size andTheme: (Theme *)theme;
-(instancetype)initWithSize:(CGSize)size andTheme: (Theme *)theme;

@end
