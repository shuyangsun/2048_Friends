//
//  Tile+tileManagement.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer01.h"
#import "macro.h"

NSString *const kTile_CoreDataEntityName = @"Tile";
NSString *const kTile_DisplayTextKey = @"TileDisplayTextKey";
NSString *const kTile_ValueKey = @"TileValueKey";
NSString *const kTile_ImageKey = @"TileImageKey";
NSString *const kTile_FbUserNameKey = @"TileFbUserNameKey";
NSString *const kTile_FbUserIDKey = @"TileFbUserIDKey";
NSString *const kTile_UUIDKey = @"TileUUIDKey";

@implementation Tile (ModelLayer01)

+(Tile *)tileWithTileInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context {
	Tile *tile = nil;
	
	NSDecimalNumber *uuid= infoDictionary[kTile_UUIDKey];
	// Check if the tile already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kTile_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple tiles with same value:
			NSLog(@"There are %lu duplicated tiles with UUID \"%@\" in CoreData database.", (unsigned long)[matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for tile with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique tile:
		tile = matches[0]; // Return the tile if it already exists.
	} else { // If there is nothing,
		tile = [NSEntityDescription insertNewObjectForEntityForName: (NSString *)kTile_CoreDataEntityName
											 inManagedObjectContext: context];
		
		ASSIGN_IN_DATABASE(tile.uuid, infoDictionary[kTile_UUIDKey]);
		ASSIGN_IN_DATABASE(tile.displayText, infoDictionary[kTile_DisplayTextKey]);
		ASSIGN_IN_DATABASE(tile.value, infoDictionary[kTile_ValueKey]);
		ASSIGN_IN_DATABASE(tile.image, infoDictionary[kTile_ImageKey]);
		ASSIGN_IN_DATABASE(tile.fbUserName, infoDictionary[kTile_FbUserNameKey]);
		ASSIGN_IN_DATABASE(tile.fbUserID, infoDictionary[kTile_FbUserIDKey]);
	}
	
	return tile;
}

+(BOOL)removeTileWithUUID: (NSString *) uuid inManagedObjectContext: (NSManagedObjectContext *) context {
	
	// Check if the tile already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kTile_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple tiles with same value:
			NSLog(@"There are %lu duplicated tiles with UUID \"%@\" in CoreData database.", (unsigned long)[matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for tile with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique tile:
		[context deleteObject:matches[0]];
		return YES;
	} else { // If there is nothing
		NSLog(@"Cannot find tile with UUID \"%@\" to delete from CoreData database.", uuid);
	}
	
	return NO;
}

+(BOOL)removeTileWithValue: (NSDecimalNumber *) value inManagedObjectContext: (NSManagedObjectContext *) context {
	
	// Check if the tile already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kTile_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"value = %@", value];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple tiles with same value:
			NSLog(@"There are %lu duplicated tiles with value \"%@\" in CoreData database.", (unsigned long)[matches count], value);
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
