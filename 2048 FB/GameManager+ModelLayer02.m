//
//  GameManager+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer02.h"

@implementation GameManager (ModelLayer02)

+(GameManager *)createGameManagerInDatabaseWithUUID: (NSString *) uuid
										  bestScore: (NSUInteger) bestScore {
	
}

+(GameManager *)searchGameManagerInDatabaseWithUUID: (NSString *) uuid {
	
}

+(BOOL)removeGameManagerInDatabaseWithUUID: (NSString *) uuid {
	
}

+(NSArray *)allGameManagersInDatabaseWithSortDescriptor: (NSSortDescriptor *) sortDescriptor {
	
}

+(NSArray *)allGameManagersInDatabase {
	
}

- (void)addTilesObjectWithValue:(NSInteger)value {
	
}

- (void)removeTilesObjectWithValue:(NSInteger *)value {
	
}

- (void)addTilesWithValue:(NSSet *)values {
	
}

- (void)removeTiles:(NSSet *)values {
	
}

@end
