//
//  GameScene.h
//  GameTest
//

//  Copyright (c) 2014 Lorenzo Saraiva. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString * const sunNode = @"movable";

@interface GameScene : SKScene <UIGestureRecognizerDelegate, SKPhysicsContactDelegate>

@property (strong,nonatomic) SKSpriteNode *sun;

@property (strong ,nonatomic) NSMutableArray *animalArray;

@property (strong, nonatomic) NSMutableArray *menuArray;

@property BOOL isMenu;

@end
