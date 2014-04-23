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

/// Animation phase 1
// NSValue(CGPoint): SKnode
@property (strong, nonatomic) NSMutableDictionary *nodeForIndexes; // Tiles for current indexes (CGPoint(row, col))
@property (strong, nonatomic) NSMutableDictionary *nextNodeForIndexes; // Tiles for indexes (CGPoint(row, col)) after swipe (not including the new random tile, but DO include the merged tiles) (technically this belongs to layer 2)

// SKNode: NSValue(CGPoint) dictionaries
@property (strong, nonatomic) NSMutableDictionary *positionsForNodes; // Postion on board for all current tiles
@property (strong, nonatomic) NSMutableDictionary *nextPositionsForNodes; // Position on board for all tiles after swipe (not including the new random tile or merged tile)

@property (strong, nonatomic) NSMutableSet *movingNodes; // Set of all nodes will be moving
@property (strong, nonatomic) NSMutableSet *removingNodes; // Set of all nodes will be moved after merging

/// Animation phase 2
@property (strong, nonatomic) NSMutableDictionary *positionForNewNodes; // Position for merged new tiles
@property (strong, nonatomic) NSMutableDictionary *indexesForNewNodes; // Position for merged new tiles

/// Animation phase 3
@property (strong, nonatomic) NSMutableDictionary *positionForNewRandomTile; // Postion on board for the new random tile
@property (strong, nonatomic) NSMutableDictionary *indexForNewRandomTile; // Get a CGPoint(row, col) from the new random tile

@property (strong, nonatomic) NSMutableArray *tileContainers; // A 2d array of tile containers

// For Core Data
@property (strong, nonatomic) NSMutableArray *nextData;
@property (nonatomic) BoardSwipeGestureDirection nextDirection;
@property (nonatomic) GameManager *gManager;
@property (nonatomic) History *history;
@property (strong, nonatomic) Board *board;

// Frequently used SKActions:
@property (strong, nonatomic) SKAction *scaleToFullSizeAction;
@property (strong, nonatomic) SKAction *popUpNewTileAction;

-(CGPoint)getPositionFromRow:(size_t)row andCol: (size_t)col;
-(BOOL)dataCanBeSwippedToDirection:(BoardSwipeGestureDirection) direction;
-(void)analyzeTilesForSwipeDirection:(BoardSwipeGestureDirection) direction
						  completion:(void (^)(void))completion;
-(void)analyzeTilesForSwipeDirection:(BoardSwipeGestureDirection) direction
					 generateNewTile:(BOOL) generateNewTile
						  completion:(void (^)(void))completion;
/*________________ Code Should be moved to .m file when Releasing _____________*/

@end
