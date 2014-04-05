//
//  Tile+ModelLayer03.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Tile+ModelLayer03.h"

NSUInteger maxTilePower = 15; // 2 ^ 15 = 32,768

@implementation Tile (ModelLayer03)

// Initialize all the tiles without images. Should be called only once when the app launches, and there is no iCloud data to fetch.
+(BOOL)initializeAllTiles {
	for (int i = 0; i < maxTilePower; ++i) {
		NSInteger val = (NSInteger)pow(2.0f, (i + 1));
		Tile *tile = [Tile createTileInDatabaseWithUUID: [Tile getUUIDFromTileValue:val]
												  value: val
											displayText: [NSString stringWithFormat:@"%ld", val]
											   fbUserID: nil
											 fbUserName: nil];
		if (i != 0) {
			tile.previousTile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue: val/2]];
		}
		if (i != maxTilePower - 1) {
			tile.nextTile = [Tile searchTileInDatabaseWithUUID:[Tile getUUIDFromTileValue: val * 2]];
		}
	}
	return YES;
}

// Get images for 2, 4, 8.. tiles respectively.
+(NSArray *)imagesForAllTiles {
	NSArray *tilesArr = [Tile allTilesInDatabase];
	NSMutableArray *images = [NSMutableArray array];
	for (Tile *tile in tilesArr) {
		[images addObject:tile.image];
	}
	return images;
}

// Pass in an array of images, they are set to tiles with value 2, 4, 8... respectively.
+(BOOL)setImagesForTiles: (NSArray *) images {
	NSArray *tilesArr = [Tile allTilesInDatabase];
	for (int i = 0; i < [images count]; ++i) {
		((Tile *)tilesArr[i]).image = images[i];
	}
	return YES;
}

+(UIImage *)imageForTileWithValue: (NSInteger) value {
	return [Tile searchTileInDatabaseWithValue:value].image;
}

+(BOOL)setImage: (UIImage *) image forTileWithValue: (NSInteger) value {
	Tile *tile = [Tile searchTileInDatabaseWithValue:value];
	tile.image = image;
	return YES;
}

@end
