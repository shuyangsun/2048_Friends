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
@property (nonatomic, retain) UIImage *foldAnimationBackgroundImage;
@property (nonatomic, retain) UIColor *settingsPageColor;
@property (nonatomic, retain) UIImage *settingsPageImage;
@property (nonatomic, retain) UIColor *tileColor;
// Titles do NOT have "image" in themes, their images are stored in their own "Tile" object.
@property (nonatomic, retain) UIColor *tileFrameColor;
@property (nonatomic, retain) UIImage *tileFrameImage;
@property (nonatomic, retain) Board *baord;
@property (nonatomic, retain) GameManager *gameManager;

@end
