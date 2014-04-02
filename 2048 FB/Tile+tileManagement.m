//
//  Tile+tileManagement.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+tileManagement.h"

NSString *const kTile_CoreDataEntiryName = @"Tile";
NSString *const kTile_DisplayTextDictionaryKey = @"TileDisplayTextKey";
NSString *const kTile_ValueKey = @"TileValueKey";
NSString *const kTile_ImageKey = @"TileImageKey";
NSString *const kTile_PrimeValKey = @"TilePrimeValKey";
NSString *const kTile_FbUserNameKey = @"TileFbUserNameKey";
NSString *const kTile_FbUserIDKey = @"TileFbUserIDKey";
NSString *const kTile_GlowingKey = @"TileGlowingKey";
NSString *const kTile_BackgroundColorKey = @"TileBackgroundColorKey";
NSString *const kTile_BoardKey = @"TileBoardKey";

@implementation Tile (tileManagement)

+(Tile *)tileWithTileInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context {
	Tile *tile = nil;
	
	NSDecimalNumber *value = infoDictionary[kTile_ValueKey];
	// Check if the tile already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kTile_CoreDataEntiryName];
	request.predicate = [NSPredicate predicateWithFormat:@"value = %@", value];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple tiles with same value:
			NSLog(@"There are %d duplicated tiles with value \"%@\" in CoreData database.", [matches count], value);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for tile with value \"%@\" in CoreData database.", value);
		}
	} else if ([matches count] == 1) { // If there is one unique tile:
		tile = matches[0]; // Return the tile if it already exists.
		NSLog(@"Tile exists.");
	} else { // If there is nothing,
		tile = [NSEntityDescription insertNewObjectForEntityForName: (NSString *)kTile_CoreDataEntiryName
											 inManagedObjectContext: context];
		tile.displayText = (infoDictionary[kTile_DisplayTextDictionaryKey] == nil ? tile.displayText:infoDictionary[kTile_DisplayTextDictionaryKey]);
		tile.value = (infoDictionary[kTile_ValueKey] == nil ? tile.value:infoDictionary[kTile_ValueKey]);
		tile.image = (infoDictionary[kTile_ImageKey] == nil ? tile.image:infoDictionary[kTile_ImageKey]);
		tile.primeVal = (infoDictionary[kTile_PrimeValKey] == nil ? tile.primeVal:infoDictionary[kTile_PrimeValKey]);
		tile.fbUserName = (infoDictionary[kTile_FbUserNameKey] == nil ? tile.fbUserName:infoDictionary[kTile_FbUserNameKey]);
		tile.fbUserID = (infoDictionary[kTile_FbUserIDKey] == nil ? tile.fbUserID:infoDictionary[kTile_FbUserIDKey]);
		tile.glowing = (infoDictionary[kTile_GlowingKey] == nil ? tile.glowing: infoDictionary[kTile_GlowingKey]);
		tile.backgroundColor = (infoDictionary[kTile_BackgroundColorKey] == nil ? tile.backgroundColor:infoDictionary[kTile_BackgroundColorKey]);
		tile.board = (infoDictionary[kTile_BoardKey] == nil ? tile.board:infoDictionary[kTile_BoardKey]);
	}
	
	return tile;
}

+(BOOL)removeTileWithValue: (NSDecimalNumber *) value inManagedObjectContext: (NSManagedObjectContext *) context {
	
	// Check if the tile already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kTile_CoreDataEntiryName];
	request.predicate = [NSPredicate predicateWithFormat:@"value = %@", value];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple tiles with same value:
			NSLog(@"There are %d duplicated tiles with value \"%@\" in CoreData database.", [matches count], value);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for tile with value \"%@\" in CoreData database.", value);
		}
	} else if ([matches count] == 1) { // If there is one unique tile:
		[context deleteObject:matches[0]];
		return YES;
	} else { // If there is nothing
		NSLog(@"Cannot find tile with value \"%@\" to delete from CoreData database.", value);
	}
	
	return NO;
}

@end
