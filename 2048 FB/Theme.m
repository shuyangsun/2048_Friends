//
//  Theme.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/2/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Theme.h"

// Import layer02 to get UUID from tile value.
#import "Tile+ModelLayer03.h"

const NSUInteger kGlowingStartPowValueDefault = 7;

const CGFloat kBoardCornerRadiusDefault_iPhone = 3.0f;
const CGFloat kBoardCornerRadiusDefault_iPad = 5.0f;

const CGFloat kTileCornerRadiusDefault_iPhone = 2.0f;
const CGFloat kTileCornerRadiusDefault_iPad = 3.0f;

const CGFloat kButtonCornerRadiusDefault_iPhone = 5.0f;
const CGFloat kButtonCornerRadiusDefault_iPad = 7.0f;

const CGFloat kBoardWidthFractionDefault_iPhone = 0.9f; // Comparing with screen width
const CGFloat kBoardWidthFractionDefault_iPad = 0.9f;

const CGFloat kBoardEdgeWidthFractionDefault_iPhone = 0.05f; // Comparing with board width
const CGFloat kBoardEdgeWidthFractionDefault_iPad = 0.05f;

const CGFloat kLineWidthFractionDefault_iPhone = 0.03f; // Comparing with board width
const CGFloat kLineWidthFractionDefault_iPad = 0.03f;

NSString *const kThemePriceKey_Free  = @"free";
NSString *const kThemePriceKey_Paid = @"paid";

// Using "_" as delemeter. Change middle element to change name of the theme, change the last word to change free/paid.
NSString *const kThemeUUIDDelimiter = @"_";
NSString *const kThemeUUID_Default = @"ThemeUUID_Default_free";
NSString *const kThemeUUID_Night = @"ThemeUUID_Night_free";
NSString *const kThemeUUID_LightBlue = @"ThemeUUID_Light Blue_paid";

@interface Theme()

+(Theme *)sharedTheme;
// Pass in an array of colors.
-(BOOL)setThemeTileColorsFor2048: (NSArray *) colorsArr;

@end

@implementation Theme

@synthesize index; // Read only, and overriding getter method.

// Always returning one singleton of theme in Memory.
+(id)allocWithZone:(struct _NSZone *)zone {
	return [self sharedTheme];
}

+(Theme *)sharedTheme {
	static Theme *sharedThm = nil;
	if (!sharedThm) {
		// Create the singleton
		sharedThm = [[super allocWithZone:nil] init];
	}
	return sharedThm;
}

+(Theme *)sharedThemeWithUUID: (NSString *)uuid {
	Theme *theme = [self sharedTheme];
	
	// Set the uuid, name and price
	theme.uuid = uuid;
	NSArray *uuidElementsArr = [uuid componentsSeparatedByString: kThemeUUIDDelimiter];
	theme.name = uuidElementsArr[1]; // The middle element
	if ([(NSString*)[uuidElementsArr lastObject] compare: kThemePriceKey_Paid] == 0) { // If theme is free
		theme.paid = YES;
	}
	theme.glowingStartPowValue = kGlowingStartPowValueDefault;
	
	// Need to set the corner radius, widthFraction, etc.
	theme.boardCornerRadius = kBoardCornerRadiusDefault_iPhone;
	
	// Variables varies in different themes.
	if ([uuid compare:kThemeUUID_Default] == 0) {
		theme.themeType = ThemeTypeDefault;
		theme.backgroundColor = [UIColor colorWithRed:0.976 green:0.969 blue:0.922 alpha:1.000];
		theme.boardColor = [UIColor colorWithRed:0.678 green:0.616 blue:0.561 alpha:1.000];
		theme.foldAnimationBackgroundColor = [UIColor colorWithRed:0.678 green:0.616 blue:0.561 alpha:1.000]; // TODO
		theme.settingsPageColor = [UIColor colorWithRed:0.486 green:0.404 blue:0.325 alpha:1.000]; // TODO
		theme.tileFrameColor = [UIColor colorWithRed:0.914 green:0.855 blue:0.737 alpha:1.000];
		theme.textColor = [UIColor whiteColor]; // TODO
		theme.buttonColor = [UIColor colorWithRed:0.914 green:0.855 blue:0.737 alpha:1.000];
		[theme setThemeTileColorsFor2048: @[[UIColor colorWithRed:0.918 green:0.871 blue:0.824 alpha:1.000], // 2
											[UIColor colorWithRed:0.914 green:0.855 blue:0.737 alpha:1.000], // 4
											[UIColor colorWithRed:0.933 green:0.635 blue:0.400 alpha:1.000], // 8
											[UIColor colorWithRed:0.945 green:0.506 blue:0.318 alpha:1.000], // 16
											[UIColor colorWithRed:0.945 green:0.396 blue:0.302 alpha:1.000], // 32
											[UIColor colorWithRed:0.945 green:0.275 blue:0.176 alpha:1.000], // 64
											[UIColor colorWithRed:0.910 green:0.776 blue:0.373 alpha:1.000], // 128
											[UIColor colorWithRed:0.910 green:0.765 blue:0.310 alpha:1.000], // 256
											[UIColor colorWithRed:0.910 green:0.745 blue:0.247 alpha:1.000], // 512
											[UIColor colorWithRed:0.910 green:0.733 blue:0.192 alpha:1.000], // 1024
											[UIColor colorWithRed:0.910 green:0.718 blue:0.141 alpha:1.000], // 2048
											[UIColor colorWithRed:0.176 green:0.173 blue:0.141 alpha:1.000]  // > 2048
											]];
	} else if ([uuid compare:kThemeUUID_Night] == 0) {
		
	} else if ([uuid compare:kThemeUUID_LightBlue] == 0) {
		
	}
	return theme;
}

+(Theme *)sharedThemeWithIndex: (NSUInteger)index {
	NSString *uuid;
	switch (index) {
		case ThemeTypeDefault:
			uuid = kThemeUUID_Default;
			break;
		case ThemeTypeNight:
			uuid = kThemeUUID_Night;
			break;
		case ThemeTypeLightBlue:
			uuid = kThemeUUID_LightBlue;
			break;
		default:
			uuid = kThemeUUID_Default;
			break;
	}
	return [self sharedThemeWithUUID:uuid];
}

-(BOOL)setThemeTileColorsFor2048: (NSArray *) colorsArr {
	if ([colorsArr count] <= 0) {
		return NO;
	}
	NSUInteger maxInd = [colorsArr count];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	for (NSUInteger i = 0; i < maxTilePower; ++i) {
		dictionary[[Tile getUUIDFromTileValue: (NSInteger)(pow(2.0f, (i + 1)))]] = colorsArr[MIN(i, maxInd)];
	}
	self.tileColors = [dictionary copy];
	return YES;
}

// Override getter method for index, it gets the "themeType", which is the int value of enum "ThemeType"
-(NSUInteger)getIndex {
	return (NSUInteger) self.themeType;
}

+(NSUInteger)themeTypeCount {
	return 3;
}

@end
