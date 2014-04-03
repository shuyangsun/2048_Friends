//
//  Tile+tileManagement.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile.h"

extern NSString *const kTile_CoreDataEntityName;
extern NSString *const kTile_DisplayTextKey;
extern NSString *const kTile_FbUserIDKey;
extern NSString *const kTile_FbUserNameKey;
extern NSString *const kTile_UUIDKey;
extern NSString *const kTile_ImageKey;
extern NSString *const kTile_ValueKey;

@interface Tile (tileManagement)

+(Tile *)tileWithTileInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context;
+(BOOL)removeTileWithUUID: (NSDecimalNumber *) uuid inManagedObjectContext: (NSManagedObjectContext *) context;
+(BOOL)removeTileWithValue: (NSDecimalNumber *) value inManagedObjectContext: (NSManagedObjectContext *) context;

@end
