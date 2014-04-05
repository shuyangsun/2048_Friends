//
//  Tile+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer02.h"
#import "AppDelegate.h"

NSUInteger maxTilePower = 15; // 2 ^ 15 = 32,768

@interface Tile()

+(NSManagedObjectContext *)getManagedObjectContext;

@end

@implementation Tile (ModelLayer02)

+(Tile *)createTileInDatabaseWithUUID: (NSString *) uuid
								value: (NSInteger) value
						  displayText: (NSString *) displayText
							 fbUserID: (NSString *) fbUserID
						   fbUserName: (NSString *) fbUserName {
	NSDictionary *infoDictionary = @{kTile_UUIDKey: uuid,
									 kTile_DisplayTextKey: displayText,
									 kTile_ValueKey: [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", value]],
									 kTile_FbUserNameKey: fbUserName,
									 kTile_FbUserIDKey: fbUserID};
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
	return [NSString stringWithFormat:@"TileUUID_%ld", val];
}

@end