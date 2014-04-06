//
//  Board+gameManagement.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer01.h"
#import "macro.h"

NSString *const kBoard_CoreDataEntityName = @"Board";
NSString *const kBoard_BoardDataKey = @"BoardDataKey";
NSString *const kBoard_GamePlayingKey = @"BoardGamePlayingKey";
NSString *const kBoard_ScoreKey = @"BoardScoreKey";
NSString *const kBoard_OnBoardBoardsKey = @"BoardOnBoardBoardsKey";
NSString *const kBoard_UUIDKey = @"BoardUUIDKey";
NSString *const kBoard_CreateDateKey = @"BoardCreateDateKey";

@implementation Board (ModelLayer01)

+(Board *)boardWithBoardInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context {
	Board *board = nil;
	
	NSDecimalNumber *uuid= infoDictionary[kBoard_UUIDKey];
	// Check if the board already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kBoard_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple boards with same value:
			NSLog(@"There are %lu duplicated boards with UUID \"%@\" in CoreData database.", [matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for board with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique board:
		board = matches[0]; // Return the board if it already exists.
	} else { // If there is nothing,
		board = [NSEntityDescription insertNewObjectForEntityForName: (NSString *)kBoard_CoreDataEntityName
											 inManagedObjectContext: context];
		NSData *boardData_Data = [NSKeyedArchiver archivedDataWithRootObject:infoDictionary[kBoard_BoardDataKey]];
		ASSIGN_IN_DATABASE(board.uuid, infoDictionary[kBoard_UUIDKey]);
		ASSIGN_IN_DATABASE(board.boardData, boardData_Data);
		ASSIGN_IN_DATABASE(board.gameplaying, infoDictionary[kBoard_GamePlayingKey]);
		ASSIGN_IN_DATABASE(board.score, infoDictionary[kBoard_ScoreKey]);
		ASSIGN_IN_DATABASE(board.createDate, [NSDate date]);
	}
	return board;
}

+(BOOL)removeBoardWithUUID: (NSString *) uuid inManagedObjectContext: (NSManagedObjectContext *) context {
	// Check if the board already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: (NSString *)kBoard_CoreDataEntityName];
	request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || error || [matches count] > 1) { // If there is an error:
		if (error) { // If there is an error.
			NSLog(@"%@", error);
		} else if ([matches count] > 1) { // If there are multiple boards with same value:
			NSLog(@"There are %lu duplicated boards with UUID \"%@\" in CoreData database.", (unsigned long)[matches count], uuid);
		} else { // If matches is nil
			NSLog(@"Matches is nil, when searching for board with UUID \"%@\" in CoreData database.", uuid);
		}
	} else if ([matches count] == 1) { // If there is one unique board:
		[context deleteObject:matches[0]];
		return YES;
	} else { // If there is nothing
		NSLog(@"Cannot find board with UUID \"%@\" to delete from CoreData database.", uuid);
	}
	
	return NO;
}

@end
