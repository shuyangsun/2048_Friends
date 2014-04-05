//
//  Tile+ModelLayer02.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer01.h"

// How many numbers the player can play
extern NSUInteger maxTilePower;

@interface Tile (ModelLayer02)

+(Tile *)createTileInDatabaseWithUUID: (NSString *) uuid
								value: (NSInteger) value
						  displayText: (NSString *) displayText
							 fbUserID: (NSString *) fbUserID
						   fbUserName: (NSString *) fbUserName;

+(Tile *)searchTileInDatabaseWithUUID: (NSString *) uuid;
+(BOOL)removeTileInDatabaseWithUUID: (NSString *) uuid;

+(NSArray *)allTilesInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor;
+(NSArray *)allTilesInDatabase; // Default value in ascending order.

+(NSString *)getUUIDFromTileValue: (NSInteger) val;

@end
