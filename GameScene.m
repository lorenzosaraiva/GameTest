//
//  GameScene.m
//  GameTest
//
//  Created by Lorenzo Saraiva on 12/11/14.
//  Copyright (c) 2014 Lorenzo Saraiva. All rights reserved.
//

#import "GameScene.h"

static const uint32_t animalCategory = 0x1 << 0;
//static const uint32_t cloudCategory = 0x1 << 1;

@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.isMenu = false;
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"i.jpg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    self.animalArray = [[NSMutableArray alloc]init];
    self.menuArray = [[NSMutableArray alloc]init];
    self.sun = [SKSpriteNode spriteNodeWithImageNamed:@"sun.jpg"];
    self.sun.position = CGPointMake(170, 550);
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self addChild:background];
    [self addChild:self.sun];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    NSLog(@"TAP");
    
    // controla o sol
    
    if ([self.sun containsPoint:positionInScene]){
        [self sunResize];
        return;
    }
    
    // adiciona o elemento correto do pop-up menu
    
    for (int i = 0; i < self.menuArray.count; i++){
        SKSpriteNode *temp = self.menuArray[i];
        if ([temp containsPoint:positionInScene]){
            [self.menuArray removeObject:temp];
            [self removeChildrenInArray:self.menuArray];
            [self.menuArray removeAllObjects];
            [self.animalArray addObject:temp];
            self.isMenu = false;
            return;
        }
    }
    
    // remove o elemento clicado
    
    for (int i = 0; i < self.animalArray.count; i++){
        SKSpriteNode *temp = self.animalArray[i];
        if ([temp containsPoint:positionInScene]){
            [temp removeFromParent];
            return;
        }
    }

    // remove o resto do menu
    
    if (self.isMenu){
        [self removeChildrenInArray:self.menuArray];
        [self.menuArray removeAllObjects];
        self.isMenu = false;
        return;;
    }
    
    // cria o menu
    
    SKSpriteNode *nuvem  = [SKSpriteNode spriteNodeWithImageNamed:@"nuvem.png"];
    SKSpriteNode *animal = [SKSpriteNode spriteNodeWithImageNamed:@"animal.png"];
    nuvem.position = CGPointMake(positionInScene.x, positionInScene.y + 20);
    animal.position = CGPointMake(positionInScene.x, positionInScene.y - 20);
    [self.menuArray addObject:nuvem];
    [self.menuArray addObject:animal];
    [self addChild:animal];
    [self addChild:nuvem];
    self.isMenu = true;

}

-(void)sunResize{
    
    self.sun.size = CGSizeMake(self.sun.frame.size.width * 1.5f, self.sun.frame.size.height * 1.5f);
    
}


-(void)update:(CFTimeInterval)currentTime {
    
    for (int i = 0; i < self.animalArray.count; i++){
        int a = arc4random()%20;
        int b = arc4random()%20;
        int c = arc4random()%2;
        int d = arc4random()%2;
        if (!c)
            a = -a;
        if (!d)
            b = -b;
        a = a/10;
        b = b/10;
        SKSpriteNode *temp = self.animalArray[i];
        temp.position = CGPointMake(temp.position.x + a, temp.position.y + b);
        
        for (int j = 0; j< self.animalArray.count; j++){
            if (j == i)
                continue;
            SKSpriteNode *temp2 =self.animalArray[j];
                Boolean viewsOverlap = CGRectIntersectsRect(temp.frame, temp2.frame);
                if (viewsOverlap){
                    [temp2 removeFromParent];
                    [self.animalArray removeObject:temp2];
                    break;
            }
        }

    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if ((contact.bodyA.categoryBitMask == animalCategory)
        && (contact.bodyB.categoryBitMask == animalCategory))
    {
            NSLog(@"aaaaaaaaaaaanimal collision!!!!");
        firstNode.color = [UIColor redColor];
    }
    
}

@end
