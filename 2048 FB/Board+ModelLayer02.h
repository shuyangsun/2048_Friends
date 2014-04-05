//
//  Board+ModelLayer02.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer01.h"

@interface Board (ModelLayer02)

+(Board *)createBoardInDatabaseWithUUID: (NSString *) uuid
							  boardData: (NSArray *) dataArr
							gamePlaying: (BOOL) gamePlaying
								  score: (NSUInteger) score;

+(Board *)searchBoardInDatabaseWithUUID: (NSString *) uuid;
+(BOOL)removeBoardInDatabaseWithUUID: (NSString *) uuid;

+(NSArray *)allBoardsInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor;
+(NSArray *)allBoardsInDatabase; // Default createDate in ascending order.

- (void)addOnBoardTilesObjectWithValue:(NSInteger)value;
- (void)removeOnBoardTilesObjectWithValue:(NSInteger)value;
- (void)addOnBoardTilesWithValues:(NSSet *) values; // Should be a set of NSNumber
- (void)removeOnBoardTilesWithValues:(NSSet *)values; // Should be a set of NSNumber

@end
