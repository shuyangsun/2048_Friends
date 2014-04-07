//
//  Board.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/6/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Board : NSManagedObject

/** This boardData is one of the most important part of Board object.
 *  It's a 4 x 4 2D array, holding all the game playing informations about boardData.
 */
@property (nonatomic, retain) NSData *boardData;
@property (nonatomic) NSTimeInterval createDate;
@property (nonatomic) BOOL gameplaying;
@property (nonatomic) int32_t score;
@property (nonatomic, retain) NSUUID *uuid;
@property (nonatomic) int16_t swipeDirection;
@property (nonatomic, retain) NSManagedObject *boardHistory;

@end
