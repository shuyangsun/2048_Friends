//
//  Theme.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *boardColor;
@property (nonatomic, strong) UIImage *boardImage;
@property (nonatomic, strong) UIColor *foldAnimationBackgroundColor;
@property (nonatomic, strong) UIColor *settingsPageColor;
@property (nonatomic, strong) UIImage *settingsPageImage;
@property (nonatomic, strong) UIColor *tileColor;
// Tile's image is stored in "Tile" object.
@property (nonatomic, strong) UIColor *tileFrameColor;
@property (nonatomic, strong) UIImage *tileFrameImage;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) NSNumber * boardCornerRadius;
@property (nonatomic, strong) NSNumber * tileCornerRadius;
@property (nonatomic, strong) NSNumber * boardWidthFraction; // Comparing with screen width
@property (nonatomic, strong) NSNumber * boardEdgeWidthFraction; // Comparing with board width
@property (nonatomic, strong) NSNumber * lineWidthFraction; // Comparing with board width
@property (nonatomic, strong) NSNumber * buttonCornerRadius;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * uuid;

@end
