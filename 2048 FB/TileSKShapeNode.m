//
//  TileSKShapeNode.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/20/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "TileSKShapeNode.h"

@interface TileSKShapeNode()

@property (strong, nonatomic) SKLabelNode *labelNode;

@end

@implementation TileSKShapeNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uuid = [NSUUID UUID];
    }
    return self;
}

-(void)setValue:(int32_t)val
		 text:(NSString *)text
	textColor:(UIColor *)textColor
		 type:(TileType)type {
	self.value = val;
	self.textColor = textColor;
	self.displayText = text;
	self.type = type;
}

-(void)setDisplayText:(NSString *)displayText {
	_displayText = displayText;
	if (self.labelNode) { [self.labelNode removeFromParent]; }
	self.labelNode = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
	self.labelNode.fontSize = 25.0f;
	self.labelNode.fontColor = self.textColor; // TODO
	self.labelNode.text = displayText;
	self.labelNode.position = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f - 10);
	[self addChild:self.labelNode];
}

-(id)copy {
	TileSKShapeNode *res = [super copy];
	[res setValue:self.value
					text:self.displayText
			   textColor:self.textColor
					type:self.type];
	res.image = self.image;
	res.uuid = self.uuid;
	return res;
}

-(BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		TileSKShapeNode *node = object;
		return [node.uuid isEqual:self.uuid];
	} else {
		return NO;
	}
}

@end
