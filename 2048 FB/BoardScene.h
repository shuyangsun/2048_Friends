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
@class Board;

/*________________ Code Should be deleted when Releasing _____________*/
#import "Board+ModelLayer03.h"
@class GameManager, History, Board;
/*________________ Code Should be deleted when Releasing _____________*/

@interface BoardScene : SKScene

@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic) int32_t score;
@property (nonatomic) BOOL gamePlaying;

+(instancetype)sceneWithSize:(CGSize)size andTheme: (Theme *)theme;
-(instancetype)initWithSize:(CGSize)size andTheme: (Theme *)theme;

-(void)startGameFromBoard:(Board *)board animated:(BOOL)animated;

/*________________ Code Should be moved to .m file when Releasing _____________*/
@property (nonatomic) UIUserInterfaceIdiom uiIdiom;

// SKNode: NSValue(CGPoint) dictionaries
@property (strong, nonatomic) NSMutableDictionary *positionsForNodes;
@property (strong, nonatomic) NSMutableDictionary *nextPositionsForNodes;
@property (strong, nonatomic) NSMutableDictionary *theNewNodes;
// NSValue(CGPoint): SKnode
@property (strong, nonatomic) NSMutableDictionary *nodeForIndexes;
@property (strong, nonatomic) NSMutableDictionary *theNewNodeForIndexes;
// For analyzing algorithm:
@property (strong, nonatomic) NSMutableSet *movingNodes;
@property (strong, nonatomic) NSMutableSet *removingNodes;
@property (strong, nonatomic) NSMutableArray *tileContainers;

// For Core Data
@property (strong, nonatomic) NSMutableArray *theNewData;
@property (nonatomic) BoardSwipeGestureDirection theNewDirection;
@property (nonatomic) GameManager *gManager;
@property (nonatomic) History *history;
@property (strong, nonatomic) Board *board;

// Frequently used SKActions:
@property (strong, nonatomic) SKAction *scaleToFullSize;
/*________________ Code Should be moved to .m file when Releasing _____________*/

@end
