//
//  Tile+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer02.h"
#import "AppDelegate.h"

@interface Tile()

+(NSManagedObjectContext *)getManagedObjectContext;

@end

@implementation Tile (ModelLayer02)

+(Tile *)createTileInDatabaseWithUUID: (NSString *) uuid
								value: (NSInteger) value
						  displayText: (NSString *) displayText
							 fbUserID: (NSString *) fbUserID
						   fbUserName: (NSString *) fbUserName {
	NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionaryWithDictionary:@{kTile_UUIDKey: uuid,
																						  kTile_DisplayTextKey: displayText,
																						  kTile_ValueKey: [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)value]]}];
	if (fbUserID) {
		infoDictionary[kTile_FbUserIDKey] = fbUserID;
	}
	if (fbUserName) {
		infoDictionary[kTile_FbUserNameKey] = fbUserName;
	}
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Tile tileWithTileInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(Tile *)searchTileInDatabaseWithUUID: (NSString *) uuid {
	NSDictionary *infoDictionary = @{kTile_UUIDKey: uuid};
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Tile tileWithTileInfo:infoDictionary inManagedObjectContext:appDelegate.managedObjectContext];
}

+(BOOL)removeTileInDatabaseWithUUID: (NSString *) uuid {
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [Tile removeTileWithUUID:uuid inManagedObjectContext:appDelegate.managedObjectContext];
}

+(Tile *)searchTileInDatabaseWithValue: (NSInteger) val {
	return [self searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue:val]];
}

+(BOOL)removeTileInDatabaseWithVal: (NSInteger) val {
	return ([self searchTileInDatabaseWithUUID:[self getUUIDFromTileValue:val]] != nil);
}

+(NSArray *)allTilesInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kTile_CoreDataEntityName];
	fetchRequest.sortDescriptors = @[sortDescriptor];
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSError *error;
	NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
	return result;
}

+(NSArray *)allTilesInDatabase {
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
	return [self allTilesInDatabaseWithSortDescriptor:sortDescriptor];
}

+(NSString *)getUUIDFromTileValue:(NSInteger) val {
	return [NSString stringWithFormat:@"TileUUID_%ld", (long)val];
}

@end
