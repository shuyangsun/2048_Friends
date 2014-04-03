//
//  Theme.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, GameManager;

@interface Theme : NSManagedObject

@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIColor *boardColor;
@property (nonatomic, retain) UIImage *boardImage;
@property (nonatomic, retain) UIColor *foldAnimationBackgroundColor;
@property (nonatomic, retain) UIColor *settingsPageColor;
@property (nonatomic, retain) UIImage *settingsPageImage;
@property (nonatomic, retain) UIColor *tileColor;
// Tile's image is stored in "Tile" object.
@property (nonatomic, retain) UIColor *tileFrameColor;
@property (nonatomic, retain) UIImage *tileFrameImage;
@property (nonatomic, retain) NSNumber * boardCornerRadius;
@property (nonatomic, retain) NSNumber * tileCornerRadius;
@property (nonatomic, retain) NSNumber * boardWidthFraction; // Comparing with screen width
@property (nonatomic, retain) NSNumber * lineWidthFraction; // Comparing with board width
@property (nonatomic, retain) NSNumber * buttonCornerRadius;
@property (nonatomic, retain) Board *baord;
@property (nonatomic, retain) GameManager *gameManager;

@end
