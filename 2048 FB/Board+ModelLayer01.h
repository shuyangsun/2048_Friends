//
//  Board+gameManagement.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board.h"

extern NSString *const kBoard_CoreDataEntityName;
extern NSString *const kBoard_BoardDataKey;
extern NSString *const kBoard_GamePlayingKey;
extern NSString *const kBoard_ScoreKey;
extern NSString *const kBoard_OnBoardTilesKey;
extern NSString *const kBoard_UUIDKey;
extern NSString *const kBoard_CreateDateKey;

@interface Board (ModelLayer01)

+(Board *)boardWithBoardInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context;
+(BOOL)removeBoardWithUUID: (NSString *) uuid inManagedObjectContext: (NSManagedObjectContext *) context;

@end
