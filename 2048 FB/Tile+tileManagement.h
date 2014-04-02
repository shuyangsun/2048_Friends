//
//  Tile+tileManagement.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile.h"

extern NSString *const kTile_CoreDataEntiryName;
extern NSString *const kTile_DisplayTextDictionaryKey;
extern NSString *const kTile_ValueKey;
extern NSString *const kTile_ImageKey;
extern NSString *const kTile_PrimeValKey;
extern NSString *const kTile_FbUserNameKey;
extern NSString *const kTile_FbUserIDKey;
extern NSString *const kTile_GlowingKey;
extern NSString *const kTile_BackgroundColorKey;
extern NSString *const kTile_BoardKey;

@interface Tile (tileManagement)

+(Tile *)tileWithTileInfo: (NSDictionary *) infoDictionary inManagedObjectContext: (NSManagedObjectContext *) context;
+(BOOL)removeTileWithValue: (NSDecimalNumber *) value inManagedObjectContext: (NSManagedObjectContext *) context;

@end
