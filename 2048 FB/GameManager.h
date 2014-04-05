//
//  GameManager.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, Tile;

@interface GameManager : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * bestScore;
@property (nonatomic, retain) NSString * currentThemeUUID;
@property (nonatomic, retain) NSData * maxOccuredTimesOnBoardForEachTile; // Should be a Dictionary with @(val):@(maxTimeOccured) key pair
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *tiles;
@property (nonatomic, retain) NSSet *boards;
@end

@interface GameManager (CoreDataGeneratedAccessors)

- (void)addTilesObject:(Tile *)value;
- (void)removeTilesObject:(Tile *)value;
- (void)addTiles:(NSSet *)values;
- (void)removeTiles:(NSSet *)values;

- (void)addBoardsObject:(Board *)value;
- (void)removeBoardsObject:(Board *)value;
- (void)addBoards:(NSSet *)values;
- (void)removeBoards:(NSSet *)values;

@end
