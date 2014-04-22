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
	XCTAssertNotNil(self.scene.theNewNodes);
	XCTAssertNotNil(self.scene.nodeForIndexes);
	XCTAssertNotNil(self.scene.theNewNodeForIndexes);
	XCTAssertNotNil(self.scene.movingNodes);
	XCTAssertNotNil(self.scene.removingNodes);
	XCTAssertNotNil(self.scene.tileContainers);
	XCTAssertNotNil(self.scene.theNewNodes);
	
	XCTAssertNotNil(self.scene.gManager);
	XCTAssertNotNil(self.scene.history);
	XCTAssertNotNil(self.scene.board);
	
	// nil
	XCTAssertNil(self.scene.theNewData);
	
	// Other
	XCTAssertEqual(self.scene.score, 0);
	XCTAssertEqual(self.scene.theNewDirection, 0);
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
	XCTAssertEqual([[self.scene.nodeForIndexes allKeys] count], 2);
	XCTAssertEqual([[self.scene.theNewNodeForIndexes allKeys] count], 0);
	
	// No next state
	XCTAssertEqual([[self.scene.theNewNodes	allKeys] count], 0);
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
	XCTAssertEqual([[self.scene.theNewNodeForIndexes allKeys] count], 0);
	
	// No next state
	XCTAssertEqual([[self.scene.theNewNodes	allKeys] count], 0);
	XCTAssertEqual([self.scene.movingNodes  count], 0);
	XCTAssertEqual([self.scene.removingNodes  count], 0);
	
	// Test data:
	for (size_t i = 0; i < 4; ++i) {
		for (size_t j = 0; j < 4; ++j) {
			TileSKShapeNode *node = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i, j)]];
			XCTAssertEqual([self.scene.data[i][j] intValue], node.value);
		}
	}
	// Test UI:
	for (size_t i = 0; i < 3; ++i) {
		for (size_t j = 0; j < 3; ++j) {
			TileSKShapeNode *node1 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i, j)]];
			TileSKShapeNode *node2 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i + 1, j)]];
			XCTAssertTrue(node1.position.y > node2.position.y);
			node1 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i, j)]];
			node2 = self.scene.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i, j + 1)]];
			XCTAssertTrue(node1.position.x < node2.position.x);
		}
	}
}

@end
