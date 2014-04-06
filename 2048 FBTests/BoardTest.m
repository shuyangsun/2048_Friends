//
//  BoardTest.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/5/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameManager+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"

@interface BoardTest : XCTestCase

@property (nonatomic, strong) Board *board;

@end

@implementation BoardTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	[Tile initializeAllTiles];
	[Board initializeNewBoard];
	[GameManager initializeGameManager];
	self.board = [[Board allBoardsInDatabase] lastObject];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
	// Remove all boards:
	NSArray *arr = [Board allBoardsInDatabase];
	for (Board *b in arr) {
		[Board removeBoardInDatabaseWithUUID:b.uuid];
	}
	// Remove all Game managers:
	arr = [GameManager allGameManagersInDatabase];
	for (GameManager *g in arr) {
		[GameManager removeGameManagerInDatabaseWithUUID:g.uuid];
	}
	// Remove all Tiles:
	arr = [Tile allTilesInDatabase];
	for (Tile *t in arr) {
		[Tile removeTileInDatabaseWithUUID:t.uuid];
	}
}

-(void)testBoardExist {
	XCTAssertNotNil(self.board);
}

-(void)testBoardGamePLaying {
	XCTAssertTrue([self.board.gameplaying boolValue]);
	self.board.gameplaying = @(NO);
	XCTAssertFalse([self.board.gameplaying boolValue]);
}

-(void)testBoardScore {
	XCTAssertTrue([self.board getIntegerScore] == 0);
	NSInteger score = 4;
	[self.board setIntegerScore: score];
	XCTAssertTrue([self.board getIntegerScore] == score);
}

-(void)testBoardsRemoveBoard {
	NSArray *arr = [Board allBoardsInDatabase];
	for (Board *b in arr) {
		[Board removeBoardInDatabaseWithUUID:b.uuid];
	}
	arr = [Board allBoardsInDatabase];
	NSUInteger count = [arr count];
	XCTAssertTrue(count == 0);
}

-(void)testBoardDataObjectType {
	NSLog(@"boardData class: %@", [NSKeyedUnarchiver unarchiveObjectWithData:self.board.boardData]);
	XCTAssertTrue([[NSKeyedUnarchiver unarchiveObjectWithData:self.board.boardData] isKindOfClass:[NSArray class]]);
}

@end
