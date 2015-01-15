//
//  GameScene.m
//  GameTest
//
//  Created by Lorenzo Saraiva on 12/11/14.
//  Copyright (c) 2014 Lorenzo Saraiva. All rights reserved.
//

#import "GameScene.h"



@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    
    self.isMenu = false;
    self.temperature = 27;
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"i.jpg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    self.animalArray = [[NSMutableArray alloc]init];
    self.menuArray = [[NSMutableArray alloc]init];
    self.sun = [SKSpriteNode spriteNodeWithImageNamed:@"sun.jpg"];
    self.sun.position = CGPointMake(170, 550);
    [self addChild:background];
    [self addChild:self.sun];
    
    
    // configura os gesture recognizer
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    // mostra o termometro
    
    self.temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 50, 50)];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.f",self.temperature];
    [self.view addSubview:self.temperatureLabel];
    
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    
    touchLocation = [self convertPointFromView:touchLocation];
    
    if ([self.sun containsPoint:touchLocation]){
        if ([(UISwipeGestureRecognizer*)recognizer direction] == UISwipeGestureRecognizerDirectionLeft){
            self.sun.size = CGSizeMake(self.sun.frame.size.width * 0.8f, self.sun.frame.size.height * 0.8f);
            self.temperature--;
        }
        else if ([(UISwipeGestureRecognizer*)recognizer direction] == UISwipeGestureRecognizerDirectionRight ){
            self.sun.size = CGSizeMake(self.sun.frame.size.width * 1.2f, self.sun.frame.size.height * 1.2f);
            self.temperature++;
        }
        self.temperatureLabel.text = [NSString stringWithFormat:@"%.f",self.temperature];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    NSLog(@"TAP");
    
    // controla o sol
    
    if ([self.sun containsPoint:positionInScene]){
//        [self sunResize];
        return;
    }
    
    // adiciona o elemento correto do pop-up menu
    
    for (int i = 0; i < self.menuArray.count; i++){
//        if ([self.menuArray objectAtIndex:i] isKindOfClass: [SKAnimals class])
        SKAnimals *temp = self.menuArray[i];
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
        SKAnimals *temp = self.animalArray[i];
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
    SKAnimals *animal = [SKAnimals spriteNodeWithImageNamed:@"animal.png"];
    animal.strenght = arc4random()%10;
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
        
        // movimento
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
        SKAnimals *temp = self.animalArray[i];
        temp.position = CGPointMake(temp.position.x + a, temp.position.y + b);
        
        //checagem de temperatura
        
        if (self.temperature > 33){
            int a = arc4random()%(int)self.temperature;
            if (a > 32){
                [self.animalArray removeObject:temp];
                [temp removeFromParent];
            }
        }
        
        
        for (int j = 0; j< self.animalArray.count; j++){
            SKSpriteNode *temp2 =self.animalArray[j];
            if (j == i)
                continue;
            
                Boolean viewsOverlap = CGRectIntersectsRect(temp.frame, temp2.frame);
                if (viewsOverlap){
                    if ([(SKAnimals*)temp strenght] > [(SKAnimals*)temp2 strenght]){
                    [temp2 removeFromParent];
                    [self.animalArray removeObject:temp2];
                        NSLog(@"Foi removido o animal de forca %d e o que ficou tinha %d", [(SKAnimals*)temp strenght], [(SKAnimals*)temp2 strenght]);
                        break;
                    }
                    else{
                        [temp removeFromParent];
                        [self.animalArray removeObject:temp];
                        NSLog(@"Foi removido o animal de forca %d e o que ficou tinha %d", [(SKAnimals*)temp strenght], [(SKAnimals*)temp2 strenght]);
                        break;
                    }
                    
            }
        }

    }
    
}

//-(void)didBeginContact:(SKPhysicsContact *)contact{
//    
//    SKSpriteNode *firstNode, *secondNode;
//    
//    firstNode = (SKSpriteNode *)contact.bodyA.node;
//    secondNode = (SKSpriteNode *) contact.bodyB.node;
//    
//    if ((contact.bodyA.categoryBitMask == animalCategory)
//        && (contact.bodyB.categoryBitMask == animalCategory))
//    {
//            NSLog(@"aaaaaaaaaaaanimal collision!!!!");
//        firstNode.color = [UIColor redColor];
//    }
//    
//}

@end
