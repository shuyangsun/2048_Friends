//
//  GameManager.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Theme, Tile;

@interface GameManager : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * bestScore;
@property (nonatomic, retain) NSData *maxOccuredTimesOnBoardForEachTile; // This should be an encoded NSDictionary
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *tiles;
@property (nonatomic, retain) NSSet *themes;
@end

@interface GameManager (CoreDataGeneratedAccessors)

- (void)addTilesObject:(Tile *)value;
- (void)removeTilesObject:(Tile *)value;
- (void)addTiles:(NSSet *)values;
- (void)removeTiles:(NSSet *)values;

- (void)addThemesObject:(Theme *)value;
- (void)removeThemesObject:(Theme *)value;
- (void)addThemes:(NSSet *)values;
- (void)removeThemes:(NSSet *)values;

@end
