//
//  GameManager+ModelLayer01.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer01.h"
#import "macro.h"

NSString *const kGameManager_CoreDataEntityName = @"GameManager";
NSString *const kGameManager_BestScoreKey = @"GameManagerBestScoreKey";
NSString *const kGameManager_MaxOccuredTimesOnBoardForEachTileKey = @"GameManagerMaxOccuredTimesOnBoardForEachTileKeyKey";
NSString *const kGameManager_UUIDKey = @"GameManagerUUIDKey";
NSString *const kGameManager_CurrentThemeUUIDKey = @"GameManagerCurrentThemeUUIDKey";

@implementation GameManager (ModelLayer01)

+(GameManager *)gameManagerWithGameManagerInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context {
	GameManager *gManager = nil;
	
	NSDecimalNumber *uuid= infoDictionary[kGameManager_UUIDKey];
	// Check if the board already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kGameManager_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple boards with same value:
			NSLog(@"There are %lu duplicated game manager with UUID \"%@\" in CoreData database.", [matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for game manager with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique board:
		gManager = matches[0]; // Return the board if it already exists.
	} else { // If there is nothing,
		gManager = [NSEntityDescription insertNewObjectForEntityForName: (NSString *)kGameManager_CoreDataEntityName
											  inManagedObjectContext: context];
		
		NSData *maxOccuredTimesOnBoardForEachTile_Data;
		if (infoDictionary[kGameManager_MaxOccuredTimesOnBoardForEachTileKey] &&
			[infoDictionary[kGameManager_MaxOccuredTimesOnBoardForEachTileKey] isKindOfClass: [NSMutableDictionary class]]) {
			NSMutableDictionary *maxOccuredTimesOnBoardForEachTile_Dictionary = (NSMutableDictionary *)infoDictionary[kGameManager_MaxOccuredTimesOnBoardForEachTileKey];
			maxOccuredTimesOnBoardForEachTile_Data = [NSKeyedArchiver archivedDataWithRootObject:maxOccuredTimesOnBoardForEachTile_Dictionary];
		}
		ASSIGN_IN_DATABASE(gManager.bestScore, infoDictionary[kGameManager_BestScoreKey]);
		ASSIGN_IN_DATABASE(gManager.maxOccuredTimesOnBoardForEachTile, maxOccuredTimesOnBoardForEachTile_Data);
		ASSIGN_IN_DATABASE(gManager.uuid, infoDictionary[kGameManager_UUIDKey]);
		ASSIGN_IN_DATABASE(gManager.currentThemeUUID, infoDictionary[kGameManager_CurrentThemeUUIDKey]);
	}
	
	return gManager;
}

+(BOOL)removeGameManagerWithUUID: (NSDecimalNumber *) uuid inManagedObjectContext: (NSManagedObjectContext *) context {
	// Check if the board already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kGameManager_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple boards with same value:
			NSLog(@"There are %lu duplicated game managers with UUID \"%@\" in CoreData database.", (unsigned long)[matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for game manager with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique board:
		[context deleteObject:matches[0]];
		return YES;
	} else { // If there is nothing
		NSLog(@"Cannot find game manager with UUID \"%@\" to delete from CoreData database.", uuid);
	}
	
	return NO;
}

@end
