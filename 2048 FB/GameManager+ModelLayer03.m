//
//  GameManager+ModelLayer03.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer03.h"
#import "AppDelegate.h"

@implementation GameManager (ModelLayer03)

+(BOOL) initializeGameManager {
	
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
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	NSError *error;
	[context save:&error];
	if (error) {
		NSLog(@"%@", error);
		return NO;
	}
	return YES;
}

+(NSString *) getCurrentThemeUUID {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	return gManager.currentThemeUUID;
}

+(BOOL) setCurrentThemeUUID: (NSString *) uuid {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	gManager.currentThemeUUID = uuid;
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	NSError *error;
	[context save:&error];
	if (error) {
		NSLog(@"%@", error);
		return NO;
	}
	return YES;
}

+(NSDictionary *) getMaxOccuredDictionary {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	return [NSKeyedUnarchiver unarchiveObjectWithData:gManager.maxOccuredTimesOnBoardForEachTile];
}

+(BOOL) setMaxOccuredDictionary:(NSDictionary *)dictionary {
	GameManager *gManager = [GameManager allGameManagersInDatabase][0];
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	NSError *error;
	[context save:&error];
	if (error) {
		NSLog(@"%@", error);
		return NO;
	}
	return YES;
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
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	NSError *error;
	[context save:&error];
	if (error) {
		NSLog(@"%@", error);
		return NO;
	}
	return YES;
}

@end
