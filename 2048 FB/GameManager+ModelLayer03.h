//
//  GameManager+ModelLayer03.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameManager+ModelLayer02.h"

@interface GameManager (ModelLayer03)

+(BOOL) initializeGameManager;
+(NSUInteger) getBestScore;
+(BOOL) setBestScore: (NSUInteger) bestScore;
+(NSString *) getCurrentThemeUUID;
+(BOOL) setCurrentThemeUUID: (NSString *) uuid;
+(NSDictionary *) getMaxOccuredDictionary;
+(BOOL) setMaxOccuredDictionary: (NSDictionary *) dictionary;
+(NSUInteger) getMaxOccuredTimeForTileWithValue: (NSInteger) value;
+(BOOL) setMaxOccuredTime: (NSUInteger) count ForTileWithValue: (NSInteger) value;

@end
