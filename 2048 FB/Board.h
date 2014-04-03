//
//  Board.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Theme, Tile;

@interface Board : NSManagedObject

@property (nonatomic, retain) NSMutableArray *boardData;
@property (nonatomic, retain) NSNumber * gameEnd;
@property (nonatomic, retain) NSNumber * gameplaying;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSSet *onBoardTiles;
@property (nonatomic, retain) Theme *currentTheme;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addOnBoardTilesObject:(Tile *)value;
- (void)removeOnBoardTilesObject:(Tile *)value;
- (void)addOnBoardTiles:(NSSet *)values;
- (void)removeOnBoardTiles:(NSSet *)values;

@end
