//
//  Board.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tile;

@interface Board : NSManagedObject

@property (nonatomic, retain) NSData * boardData; // Should be a 3D NSMutableArray
@property (nonatomic, retain) NSNumber * gameplaying;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * createDate; // The only property that is not in the dictionary
@property (nonatomic, retain) NSSet *onBoardTiles;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addOnBoardTilesObject:(Tile *)value;
- (void)removeOnBoardTilesObject:(Tile *)value;
- (void)addOnBoardTiles:(NSSet *)values;
- (void)removeOnBoardTiles:(NSSet *)values;

@end
