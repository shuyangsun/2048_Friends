//
//  Theme.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

// Change the order of this enum to change the order of themes in settings table.
typedef enum ThemeType {
	ThemeTypeDefault = 0,
	ThemeTypeNight,
	ThemeTypeLightBlue
} ThemeType;

extern const NSUInteger kglowingStartPowValueDefault;
extern const CGFloat kBoardCornerRadiusDefault_iPhone;
extern const CGFloat kBoardCornerRadiusDefault_iPad;
extern const CGFloat kTileCornerRadiusDefault_iPhone;
extern const CGFloat kTileCornerRadiusDefault_iPad;
extern const CGFloat kButtonCornerRadiusDefault_iPhone;
extern const CGFloat kButtonCornerRadiusDefault_iPad;
extern const CGFloat kBoardWidthFractionDefault_iPhone; // Comparing with screen width
extern const CGFloat kBoardWidthFractionDefault_iPad;
extern const CGFloat kBoardEdgeWidthFractionDefault_iPhone; // Comparing with board width
extern const CGFloat kBoardEdgeWidthFractionDefault_iPad;
extern const CGFloat kLineWidthFractionDefault_iPhone; // Comparing with board width
extern const CGFloat kLineWidthFractionDefault_iPad;

extern NSString *const kThemePriceKey_Free;
extern NSString *const kThemePriceKey_Paid;

extern NSString *const kThemeUUIDDelimiter;
extern NSString *const kThemeUUID_Default;
extern NSString *const kThemeUUID_Night;
extern NSString *const kThemeUUID_LightBlue;

@interface Theme : NSObject

@property (nonatomic) ThemeType themeType;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic) BOOL paid; // Indicate if the user need to pay to use the theme.
@property (nonatomic, readonly) NSInteger index; // Corresponding to ThemeType

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *boardColor;
@property (nonatomic, strong) UIImage *boardImage;
@property (nonatomic, strong) UIColor *foldAnimationBackgroundColor;
@property (nonatomic, strong) UIColor *settingsPageColor;
@property (nonatomic, strong) UIImage *settingsPageImage;
@property (nonatomic, strong) UIColor *tileFrameColor;
@property (nonatomic, strong) UIImage *tileFrameImage;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *buttonColor;
// This dictionary is using @{ (NSString *) tileUUID : (UIColor *) tileColor}
@property (nonatomic, strong) NSDictionary *tileColors;
// Tile's image is stored in "Tile" object.
// Where does the glowing start.
@property (nonatomic) NSUInteger glowingStartPowValue;

// Width and corner radius.
@property (nonatomic) CGFloat boardCornerRadius;
@property (nonatomic) CGFloat tileCornerRadius;
@property (nonatomic) CGFloat buttonCornerRadius;
@property (nonatomic) CGFloat boardWidthFraction; // Comparing with screen width
@property (nonatomic) CGFloat boardEdgeWidthFraction; // Comparing with board width
@property (nonatomic) CGFloat lineWidthFraction; // Comparing with board width

+(Theme *)sharedThemeWithUUID: (NSString *)uuid;
+(Theme *)sharedThemeWithIndex: (NSUInteger)index;

// Return how many theme types are there.
+(NSUInteger)themeTypeCount;

@end
