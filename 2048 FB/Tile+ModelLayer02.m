//
//  Tile+ModelLayer02.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/3/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer02.h"

NSUInteger maxTilePower = 15; // 2 ^ 15 = 32,768

@implementation Tile (ModelLayer02)

+(NSString *)getUUIDFromTileValue:(NSDecimalNumber *)val {
	return [NSString stringWithFormat:@"TileUUID_%@", val];
}

@end
