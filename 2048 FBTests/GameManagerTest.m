//
//  GameManagerTest.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/7/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"

@interface GameManagerTest : XCTestCase

@property (nonatomic, strong) GameManager *gManager;

@end

@implementation GameManagerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	[GameManager initializeGameManager];
	[Board initializeNewBoard];
	[Tile initializeAllTiles];
	self.gManager = [GameManager sharedGameManager];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
	// Remove all boards:
	NSArray *arr = [Board allBoards];
	for (Board *b in arr) {
		[Board removeBoardWithUUID:b.uuid];
	}
	// Remove all histories:
	arr = [History allHistories];
	for (History *h in arr) {
		[History removeHistoryWithUUID:h.uuid];
	}
	// Remove all Game managers:
	arr = [GameManager allGameManagers];
	for (GameManager *g in arr) {
		[GameManager removeGameManagerWithUUID:g.uuid];
	}
	// Remove all Tiles:
	arr = [Tile allTiles];
	for (Tile *t in arr) {
		[Tile removeTileWithValue:t.value];
	}

}

-(void)testGameManagerExists
{
	XCTAssertNotNil(self.gManager);
}

-(void)testHighScoreZero
{
	XCTAssertEqual(self.gManager.bestScore, 0);
}

-(void)testMaxOccuredTimeForEachTileZero
{
	NSDictionary *maxOccuredTimeDictionary = [GameManager getMaxOccuredDictionary];
	for (int i = 0; i < maxTilePower; ++i) {
		XCTAssertEqualObjects(maxOccuredTimeDictionary[@((NSInteger)pow(2.0f, i + 1))], @(0));
	}
}

@end
