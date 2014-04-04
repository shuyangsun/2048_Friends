//
//  GameManager+ModelLayer01.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager.h"

extern NSString *const kGameManager_CoreDataEntityName;
extern NSString *const kGameManager_BestScoreKey;
extern NSString *const kGameManager_MaxOccuredTimesOnBoardForEachTileKey;
extern NSString *const kGameManager_UUIDKey;

@interface GameManager (ModelLayer01)

+(GameManager *)gameManagerWithGameManagerInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context;
+(BOOL)removeGameManagerWithUUID: (NSDecimalNumber *) uuid inManagedObjectContext: (NSManagedObjectContext *) context;

@end

