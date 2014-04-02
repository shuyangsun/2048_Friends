//
//  Board.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tile;

@interface Board : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * bestScore;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSNumber * gameplaying;
@property (nonatomic, retain) NSNumber * gameEnd;
@property (nonatomic, retain) NSMutableArray *boardData;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) NSSet *tiles;
@property (nonatomic, retain) NSSet *onBoardTiles;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addTilesObject:(Tile *)value;
- (void)removeTilesObject:(Tile *)value;
- (void)addTiles:(NSSet *)values;
- (void)removeTiles:(NSSet *)values;

- (void)addOnBoardTilesObject:(Tile *)value;
- (void)removeOnBoardTilesObject:(Tile *)value;
- (void)addOnBoardTiles:(NSSet *)values;
- (void)removeOnBoardTiles:(NSSet *)values;

@end
