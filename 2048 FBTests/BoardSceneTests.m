//
//  BoardSceneTests.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/21/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "Theme.h"
#import "BoardScene.h"
#import "TileSKShapeNode.h"

@interface BoardSceneTests : XCTestCase

@property (strong, nonatomic) GameManager *gManager;
@property (strong, nonatomic) History *history;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) BoardScene *scene;
@property (nonatomic) BOOL printBoard;

@end

@implementation BoardSceneTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	self.gManager = [GameManager initializeGameManager];
	self.board = [Board initializeNewBoard];
	[Tile initializeAllTiles];
	self.theme = [Theme sharedThemeWithID:self.gManager.currentThemeID];
	self.scene = [BoardScene sceneWithSize:CGSizeMake(280, 280) andTheme:self.theme];
	self.printBoard = NO;
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

-(void)testInitializing {
	// Not nil
	XCTAssertNotNil(self.scene.theme);
	XCTAssertNotNil(self.scene.positionsForNodes);
	XCTAssertNotNil(self.scene.nextPositionsForNodes);
	XCTAssertNotNil(self.scene.positionForNewRandomTile);
	XCTAssertNotNil(self.scene.positionForNewNodes);
	XCTAssertNotNil(self.scene.nodeForIndexes);
	XCTAssertNotNil(self.scene.nextNodeForIndexes);
	XCTAssertNotNil(self.scene.indexForNewRandomTile);
	XCTAssertNotNil(self.scene.movingNodes);
	XCTAssertNotNil(self.scene.removingNodes);
	XCTAssertNotNil(self.scene.tileContainers);
	XCTAssertNotNil(self.scene.positionForNewNodes);
	
	XCTAssertNotNil(self.scene.gManager);
	XCTAssertNotNil(self.scene.history);
	XCTAssertNotNil(self.scene.board);
	
	// Other
	XCTAssertEqual(self.scene.score, 0);
	XCTAssertEqual(self.scene.nextDirection, 0);
	XCTAssertFalse(self.scene.gamePlaying);
}

-(void)testStartGameFromBoardModel {
	[self.scene startGameFromBoard:self.board animated:YES];
	
	// Not nil
	XCTAssertNotNil(self.scene.data);
	XCTAssertNotNil(self.scene.gManager);
	XCTAssertNotNil(self.scene.history);
	XCTAssertNotNil(self.scene.board);
	
	// Equal
	XCTAssertEqualObjects(self.scene.data, [self.board getBoardDataArray]);
	XCTAssertEqual(self.scene.score, self.board.score);
	XCTAssertEqual(self.scene.gamePlaying, self.board.gameplaying);
}

-(void)testStartGameFromBoardUI_01 {
	[self.scene startGameFromBoard:self.board animated:YES];
	
	// 16 tile containers
	XCTAssertEqual([self.scene.tileContainers count], 4);
	for (size_t i = 0; i < 4; ++i) {
		XCTAssertEqual([self.scene.tileContainers[i] count], 4);
	}
	
	// 2 tiles
	XCTAssertEqual([[self.scene.positionsForNodes allKeys] count], 2);
	XCTAssertEqual([[self.scene.nextPositionsForNodes allKeys] count], 0);
	XCTAssertEqual([[self.scene.positionForNewRandomTile allKeys] count], 0);
	XCTAssertEqual([[self.scene.nodeForIndexes allKeys] count], 2);
	XCTAssertEqual([[self.scene.nextNodeForIndexes allKeys] count], 0);
	XCTAssertEqual([[self.scene.indexForNewRandomTile allKeys] count], 0);
	
	// No next state
	XCTAssertEqual([[self.scene.positionForNewNodes	allKeys] count], 0);
	XCTAssertEqual([self.scene.movingNodes  count], 0);
	XCTAssertEqual([self.scene.removingNodes  count], 0);
}

-(void)testStartGameFromBoardUI_02 {
	self.board = [Board createBoardWithBoardData:[NSMutableArray arrayWithArray:@[@[@(2), @(4), @(8), @(16)],
																				  @[@(8), @(2), @(1048), @(16)],
																				  @[@(2), @(4), @(8), @(2048)],
																				  @[@(16), @(4), @(8), @(16)]]]
									 gamePlaying:YES
										   score:0
								  swipeDirection:0];
	[self.scene startGameFromBoard:self.board animated:YES];
	
	// 16 tile containers
	XCTAssertEqual([self.scene.tileContainers count], 4);
	for (size_t i = 0; i < 4; ++i) {
		XCTAssertEqual([self.scene.tileContainers[i] count], 4);
	}
	
	// 2 tiles
	XCTAssertEqual([[self.scene.positionsForNodes allKeys] count], 16);
	XCTAssertEqual([[self.scene.nextPositionsForNodes allKeys] count], 0);
	XCTAssertEqual([[self.scene.nodeForIndexes allKeys] count], 16);
	XCTAssertEqual([[self.scene.nextNodeForIndexes allKeys] count], 0);
	
	// No next state
	XCTAssertEqual([[self.scene.positionForNewNodes	allKeys] count], 0);
	XCTAssertEqual([self.scene.movingNodes  count], 0);
	XCTAssertEqual([self.scene.removingNodes  count], 0);
	
	// Test data:
	for (size_t row = 0; row < 4; ++row) {
		for (size_t col = 0; col < 4; ++col) {
			TileSKShapeNode *node = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]];
			XCTAssertEqual([self.scene.data[row][col] intValue], node.value);
		}
	}
	// Test UI:
	for (size_t row = 0; row < 3; ++row) {
		for (size_t col = 0; col < 3; ++col) {
			TileSKShapeNode *node1 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]];
			TileSKShapeNode *node2 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row + 1, col)]];
			XCTAssertTrue(node1.position.y > node2.position.y);
			node1 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]];
			node2 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col + 1)]];
			XCTAssertTrue(node1.position.x < node2.position.x);
		}
	}
}

-(void)testStartGameFromBoardUI_03 {
	self.board = [Board createBoardWithBoardData:[NSMutableArray arrayWithArray:@[@[@(0), @(4), @(8), @(16)],
																				  @[@(8), @(2), @(0), @(16)],
																				  @[@(0), @(4), @(8), @(2048)],
																				  @[@(16), @(4), @(8), @(0)]]]
									 gamePlaying:YES
										   score:0
								  swipeDirection:0];
	[self.scene startGameFromBoard:self.board animated:YES];
	
	for (size_t row = 0; row < 4; ++row) {
		for (size_t col = 0; col < 4; ++col) {
			if ((row == 0 && col == 0) ||
				(row == 1 && col == 2) ||
				(row == 2 && col == 0) ||
				(row == 3 && col == 3)) {
				XCTAssertNil(self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]], @"Node at (row:%lu, col:%lu) should be nil.", row, col);
			} else {
				XCTAssertNotNil(self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]], @"Node at (row:%lu, col:%lu) should NOT be nil.", row, col);
			}
		}
	}
	
	XCTAssertNil(self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(0, 0)]]);
	XCTAssertNil(self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(0, 0)]]);
}

-(void)testDataCanBeSwipped {
	self.board = [Board createBoardWithBoardData:[NSMutableArray arrayWithArray:@[@[@(2), @(4), @(8), @(16)],
																				  @[@(8), @(2), @(1048), @(16)],
																				  @[@(2), @(4), @(8), @(2048)],
																				  @[@(16), @(4), @(8), @(16)]]]
									 gamePlaying:YES
										   score:0
								  swipeDirection:0];
	[self.scene startGameFromBoard:self.board animated:YES];
	XCTAssertFalse([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionLeft]);
	XCTAssertFalse([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionRight]);
	XCTAssertTrue([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionUp]);
	XCTAssertTrue([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionDown]);
	
	self.board = [Board createBoardWithBoardData:[NSMutableArray arrayWithArray:@[@[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)]]]
									 gamePlaying:YES
										   score:0
								  swipeDirection:0];
	[self.scene startGameFromBoard:self.board animated:YES];
	XCTAssertTrue([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionLeft]);
	XCTAssertFalse([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionRight]);
	XCTAssertTrue([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionUp]);
	XCTAssertTrue([self.scene dataCanBeSwippedToDirection:BoardSwipeGestureDirectionDown]);
}

-(void)testAnalyzeSwiping_01_Left {
	self.board = [Board createBoardWithBoardData:[NSMutableArray arrayWithArray:@[@[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)],
																				  @[@(0), @(0), @(0), @(2)]]]
									 gamePlaying:YES
										   score:0
								  swipeDirection:0];
	[self.scene startGameFromBoard:self.board animated:YES];
	
	// Before analyzing swipe
	XCTAssertEqual([[self.scene.positionsForNodes allKeys] count], 4, @"positionsForNodes should have %d keys, instead it has %lu keys.", 4, (unsigned long)[[self.scene.positionsForNodes allKeys] count]);
	XCTAssertEqual([[self.scene.nodeForIndexes allKeys] count], 4, @"nodeForIndexes should have %d keys, instead it has %lu keys.", 4, (unsigned long)[[self.scene.nodeForIndexes allKeys] count]);
	
	[self.scene analyzeTilesForSwipeDirection:BoardSwipeGestureDirectionLeft generateNewTile:NO completion:nil];
	// After analyzing swipe
	XCTAssertEqual([[self.scene.nextPositionsForNodes allKeys] count], 4, @"nextPositionsForNodes should have %d keys, instead it has %lu keys.", 4, (unsigned long)[[self.scene.nextPositionsForNodes allKeys] count]);
	XCTAssertEqual([[self.scene.positionForNewNodes allKeys] count], 0, @"positionForNewNodes should have %d keys, instead it has %lu keys.", 0, (unsigned long)[[self.scene.positionForNewNodes allKeys] count]);
	XCTAssertEqual([[self.scene.nextNodeForIndexes allKeys] count], 4, @"nextNodeForIndexes should have %d keys, instead it has %lu keys.", 4, (unsigned long)[[self.scene.nextNodeForIndexes allKeys] count]);
	XCTAssertEqual([self.scene.movingNodes count], 4, @"movingNodes should have %d elements, instead it has %lu elements.", 4, (unsigned long)[self.scene.movingNodes count]);
	XCTAssertEqual([self.scene.removingNodes count], 0, @"removingNodes should have %d elements, instead it has %lu elements.", 0, (unsigned long)[self.scene.removingNodes count]);
	
	NSMutableArray *theNewData = [NSMutableArray arrayWithArray:@[@[@(2), @(0), @(0), @(0)],
																  @[@(2), @(0), @(0), @(0)],
																  @[@(2), @(0), @(0), @(0)],
																  @[@(2), @(0), @(0), @(0)]]];
	XCTAssertEqualObjects(self.scene.nextData, theNewData);
	for (size_t row = 0; row < 4; ++row) {
		for (size_t col = 0; col < 4; ++col) {
			int val = [self.scene.nextData[row][col] intValue];
			if (val == 0) {
				XCTAssertNil(self.scene.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]]);
			} else {
				TileSKShapeNode *node = self.scene.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]];
				XCTAssertEqual(node.value, val);
				XCTAssertEqualObjects(self.scene.nextPositionsForNodes[[NSValue valueWithNonretainedObject:node]], [NSValue valueWithCGPoint:[self.scene getPositionFromRow:row andCol:col]]);
				XCTAssertTrue([self.scene.movingNodes containsObject:node]);
			}
		}
	}
	
}

@end
