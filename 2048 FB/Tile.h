//
//  Tile.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/1/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board;

@interface Tile : NSManagedObject

@property (nonatomic, retain) NSString * displayText;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSDecimalNumber * primeVal;
@property (nonatomic, retain) NSString * fbUserName;
@property (nonatomic, retain) NSString * fbUserID;
@property (nonatomic, retain) NSNumber * glowing;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) Board *onBoard;

@end
