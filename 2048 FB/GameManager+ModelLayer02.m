//
//  GameManager+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer02.h"
#import "AppDelegate.h"
#import "Tile+ModelLayer02.h"

@implementation GameManager (ModelLayer02)

+(GameManager *)createGameManagerInDatabaseWithUUID: (NSString *) uuid
										  bestScore: (NSUInteger) bestScore {
	NSDictionary *infoDictionary = @{kGameManager_UUIDKey: uuid,
									 kGameManager_BestScoreKey: [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lu", bestScore]]};
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [GameManager gameManagerWithGameManagerInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(GameManager *)searchGameManagerInDatabaseWithUUID: (NSString *) uuid {
	NSDictionary *infoDictionary = @{kGameManager_UUIDKey: uuid};
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [GameManager gameManagerWithGameManagerInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(BOOL)removeGameManagerInDatabaseWithUUID: (NSString *) uuid {
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [GameManager removeGameManagerWithUUID:uuid inManagedObjectContext:appDelegate.managedObjectContext];
}

+(NSArray *)allGameManagersInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kGameManager_CoreDataEntityName];
	if (sortDescriptor) {
		fetchRequest.sortDescriptors = @[sortDescriptor];
	}
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSError *error;
	NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
	return result;
}

+(NSArray *)allGameManagersInDatabase {
	return [self allGameManagersInDatabaseWithSortDescriptor:nil];
}

- (void)addTilesObjectWithValue:(NSInteger)value {
	Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:value]];
	if (tile == nil) {
		NSLog(@"Cannot find tile with value \"%ld\", not adding to board \"%@\".", value, self.uuid);
		return;
	}
	[self addTilesObject:tile];
}

- (void)removeTilesObjectWithValue:(NSInteger)value {
	Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:value]];
	if (tile == nil) {
		NSLog(@"Cannot find tile with value \"%ld\", not removing from board \"%@\".", value, self.uuid);
		return;
	}
	[self removeTilesObject:tile];
}

- (void)addTilesWithValues:(NSSet *) values {
	NSMutableSet *mutableSet = [NSMutableSet set];
	for (NSNumber *value in values) {
		Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:[value integerValue]]];
		if (tile == nil) {
			NSLog(@"Cannot find tile with value \"%ld\", not adding to board \"%@\".", [value integerValue], self.uuid);
		} else {
			[mutableSet addObject:tile];
		}
	}
	[self addTiles:mutableSet];
}

- (void)removeTilesWithValues:(NSSet *)values {
	NSMutableSet *mutableSet = [NSMutableSet set];
	for (NSNumber *value in values) {
		Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:[value integerValue]]];
		if (tile == nil) {
			NSLog(@"Cannot find tile with value \"%ld\", not removing board \"%@\".", [value integerValue], self.uuid);
		} else {
			[mutableSet addObject:tile];
		}
	}
	[self removeTiles:mutableSet];
}

@end
