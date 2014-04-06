//
//  Board+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer02.h"
#import "Tile+ModelLayer02.h"
#import "AppDelegate.h"

@implementation Board (ModelLayer02)

+(Board *)createBoardInDatabaseWithUUID: (NSString *) uuid
							  boardData: (NSMutableArray *) dataArr
							gamePlaying: (BOOL) gamePlaying
								  score: (NSUInteger) score {
	NSDictionary *infoDictionary = @{kBoard_UUIDKey: uuid,
									 kBoard_BoardDataKey: dataArr,
									 kBoard_GamePlayingKey: @(gamePlaying),
									 kBoard_ScoreKey:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (unsigned long)score]]
									 };
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Board boardWithBoardInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(Board *)searchBoardInDatabaseWithUUID: (NSString *) uuid {
	NSDictionary *infoDictionary = @{kBoard_UUIDKey: uuid};
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Board boardWithBoardInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(BOOL)removeBoardInDatabaseWithUUID: (NSString *) uuid {
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Board removeBoardWithUUID: uuid inManagedObjectContext:appDelegate.managedObjectContext];
}

- (void)addOnBoardTilesObjectWithValue:(NSInteger)value {
	Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:value]];
	if (tile == nil) {
		NSLog(@"Cannot find tile with value \"%ld\", not adding to board \"%@\".", (long)value, self.uuid);
		return;
	}
	[self addOnBoardTilesObject:tile];
}

- (void)removeOnBoardTilesObjectWithValue:(NSInteger)value {
	Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:value]];
	if (tile == nil) {
		NSLog(@"Cannot find tile with value \"%ld\", not removing from board \"%@\".", (long)value, self.uuid);
		return;
	}
	[self removeOnBoardTilesObject:tile];
}

- (void)addOnBoardTilesWithValues:(NSSet *) values {
	NSMutableSet *mutableSet = [NSMutableSet set];
	for (NSNumber *value in values) {
		Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:[value integerValue]]];
		if (tile == nil) {
			NSLog(@"Cannot find tile with value \"%ld\", not adding to board \"%@\".", (long)[value integerValue], self.uuid);
		} else {
			[mutableSet addObject:tile];
		}
	}
	[self addOnBoardTiles:mutableSet];
}

- (void)removeOnBoardTilesWithValues:(NSSet *)values {
	NSMutableSet *mutableSet = [NSMutableSet set];
	for (NSNumber *value in values) {
		Tile *tile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:[value integerValue]]];
		if (tile == nil) {
			NSLog(@"Cannot find tile with value \"%ld\", not removing board \"%@\".", (long)[value integerValue], self.uuid);
		} else {
			[mutableSet addObject:tile];
		}
	}
	[self removeOnBoardTiles:mutableSet];
}

+(NSArray *)allBoardsInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kBoard_CoreDataEntityName];
	fetchRequest.sortDescriptors = @[sortDescriptor];
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSError *error;
	NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
	return result;
}

+(NSArray *)allBoardsInDatabase {
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES];
	return [self allBoardsInDatabaseWithSortDescriptor:sortDescriptor];
}

+(Board *)lastestBoard {
	return [[self allBoardsInDatabase] lastObject];
}

-(NSInteger)getIntegerScore {
	return [self.score integerValue];
}

-(BOOL)setIntegerScore: (NSInteger) score {
	self.score = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)score]];
	return YES;
}

@end
