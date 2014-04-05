//
//  GameManager+ModelLayer03.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "AppDelegate.h"
#import "Theme.h"

@implementation GameManager (ModelLayer03)

+(BOOL) initializeGameManager {
	// If there is not a game manager in data base:
	if ([[GameManager allGameManagersInDatabase] count]) {
		GameManager *gManager = [GameManager createGameManagerInDatabaseWithUUID:[[NSUUID UUID] UUIDString] bestScore:0];
		gManager.currentThemeUUID = kThemeUUID_Default;
		NSMutableDictionary *maxOccuredDictionary = [NSMutableDictionary dictionary];
		for (int i = 0; i < maxTilePower; ++i) {
			maxOccuredDictionary[@((NSInteger)pow(2.0f, i + 1))] = @(0);
		}
		[GameManager setMaxOccuredDictionary:maxOccuredDictionary];
		[gManager addTiles:[NSSet setWithArray:[Tile allTilesInDatabase]]];
		[gManager addBoardsObject:[Board lastestBoard]];
		
		AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		return [appDelegate saveContext];
	}
	
	return YES;
}

+(NSUInteger) getBestScore {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	NSUInteger bestScore = [gManager.bestScore unsignedIntegerValue];
	return bestScore;
}

+(BOOL) setBestScore: (NSUInteger) bestScore {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	gManager.bestScore = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lu", bestScore]];
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

+(NSString *) getCurrentThemeUUID {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	return gManager.currentThemeUUID;
}

+(BOOL) setCurrentThemeUUID: (NSString *) uuid {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	gManager.currentThemeUUID = uuid;
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

+(NSDictionary *) getMaxOccuredDictionary {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	return [NSKeyedUnarchiver unarchiveObjectWithData:gManager.maxOccuredTimesOnBoardForEachTile];
}

+(BOOL) setMaxOccuredDictionary:(NSDictionary *)dictionary {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	
	NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
	gManager.maxOccuredTimesOnBoardForEachTile = dictionaryData;
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

+(NSUInteger) getMaxOccuredTimeForTileWithValue: (NSInteger) value {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	NSData *dictionaryData = gManager.maxOccuredTimesOnBoardForEachTile;
	NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
	return [(NSNumber *)dictionary[@(value)] unsignedIntegerValue];
}

+(BOOL) setMaxOccuredTime: (NSUInteger) count ForTileWithValue: (NSInteger) value {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	
	NSData *dictionaryData = gManager.maxOccuredTimesOnBoardForEachTile;
	NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
	NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
	mutableDictionary[@(value)] = @(count);
	NSData *resultDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:[mutableDictionary copy]];
	gManager.maxOccuredTimesOnBoardForEachTile = resultDictionaryData;
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

@end
