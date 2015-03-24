//
//  GameScene.m
//  maze-demo-spritekit
//
//  Created by Jeromy Evans (personal) on 25/01/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property BOOL contentCreated;

@property SKSpriteNode* pacmanSprite;

@property SKSpriteNode* ghost1Sprite;
@property SKSpriteNode* ghost2Sprite;
@property SKSpriteNode* ghost3Sprite;

@property SKSpriteNode* exitSprite;

@end

@implementation GameScene

/**
 These masks are used to categorise different kinds of contacts/collisions in the scene
 */
const uint32_t GHOST_COLLISION_MASK =   0x01;
const uint32_t EXIT_COLLISION_MASK =    0x02;
const uint32_t WALL_COLLISION_MASK =    0x04;
const uint32_t PACMAN_COLLISION_MASK =  0x08;
const uint32_t EDGE_COLLISION_MASK =    0x10;


-(void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated) {
        
        [self createSceneContents];
        [self startGame];
        self.contentCreated = true;
    }
    
}

/**
 Setup the scene sprites and animation
 */
-(void)createSceneContents {
    
    self.backgroundColor = [SKColor blackColor];

    SKView* skView = (SKView *)self.view;

    // setup an edge loop (boundary)
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:skView.bounds];
    self.physicsBody.categoryBitMask = EDGE_COLLISION_MASK;
    self.physicsBody.collisionBitMask = PACMAN_COLLISION_MASK | GHOST_COLLISION_MASK;
    self.physicsBody.contactTestBitMask = 0;
    
    // assign this class as the contact delegate so it's notified on contact/collision
    self.physicsWorld.contactDelegate = self;
    
//    [self createLabel:skView];
    
    [self createPacman];

    CGFloat sceneWidth = self.view.bounds.size.width;
    CGFloat sceneHeight = self.view.bounds.size.height;
    
    SKSpriteNode* wall4Sprite  = (SKSpriteNode*)[self.scene childNodeWithName:@"wall4"];
    SKSpriteNode* wall8Sprite  = (SKSpriteNode*)[self.scene childNodeWithName:@"wall8"];
    
    self.ghost1Sprite = [self createGhost:CGPointMake(wall4Sprite.position.x, 0.0)];
    self.ghost2Sprite = [self createGhost:CGPointMake(sceneWidth/2.0, sceneHeight)];
    self.ghost3Sprite = [self createGhost:CGPointMake(wall8Sprite.position.x, sceneHeight)];
    
    self.exitSprite = (SKSpriteNode*)[self.scene childNodeWithName:@"exit"];
    
    [self addChild:self.ghost1Sprite];
    [self addChild:self.ghost2Sprite];
    [self addChild:self.ghost3Sprite];
    
    [self addChild:self.pacmanSprite];
    
}


/** Setup inputs */
-(void)startGame
{
    CMAcceleration acceleration;
    acceleration.x=0.1;
    
    [self applyForceToPacman:acceleration];
}

-(void)createLabel:(SKView*) skView
{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    NSMutableString *labelText = [NSMutableString stringWithFormat:@"%f", skView.bounds.size.width];
    [ labelText appendString:@"x"];
    [ labelText appendString:[NSMutableString stringWithFormat:@"%f", skView.bounds.size.height]];
    [ labelText appendString:@","];
    [ labelText appendString:[NSMutableString stringWithFormat:@"%f", self.frame.size.width]];
    [ labelText appendString:@"x"];
    [ labelText appendString:[NSMutableString stringWithFormat:@"%f", self.frame.size.height]];
    
    myLabel.text =     labelText;
    myLabel.fontSize = 32;
    
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    //    [self addChild:myLabel];
}

/**
 Prepare the pacman. Setup the phsicals model so he has some mass
 */
-(void)createPacman
{
    
    self.pacmanSprite = [SKSpriteNode spriteNodeWithImageNamed:@"pacman"];
    
    self.pacmanSprite.xScale = 1;
    self.pacmanSprite.yScale = 1;
    self.pacmanSprite.position = CGPointMake(self.pacmanSprite.size.width/2, CGRectGetMidY(self.frame)); // left edge centre
    
    SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.pacmanSprite.frame.size];
    physicsBody.dynamic = true;
    physicsBody.affectedByGravity = false;
    physicsBody.mass = 0.2;
    
    physicsBody.categoryBitMask = PACMAN_COLLISION_MASK;
    physicsBody.collisionBitMask = EXIT_COLLISION_MASK | GHOST_COLLISION_MASK | WALL_COLLISION_MASK | EDGE_COLLISION_MASK;
    physicsBody.contactTestBitMask = EXIT_COLLISION_MASK | GHOST_COLLISION_MASK;
    
    self.pacmanSprite.physicsBody = physicsBody;
}

/**
 Update the position and rotation of the pacman.
 Note using animation to change the position.  That probably would be better
 */
-(void)applyForceToPacman:(CMAcceleration) acceleration;
{
//    [self.pacmanSprite.physicsBody applyImpulse: CGVectorMake(acceleration.x*100.0, acceleration.y*100.0)];
    // y and z are used becayse the device is rotated 90 degrees
    [self.pacmanSprite.physicsBody applyImpulse: CGVectorMake(-acceleration.y*2, -acceleration.z*2)];
    
    // todo: I'm actually interested in roration around the xaxis (reported by gyro), and
    // data from the accelometer only from y axis. ie rotation for steering, accel for accel/decel
    
}

-(SKSpriteNode*)createGhost:(CGPoint) position
{
    SKSpriteNode *ghostSprite = [SKSpriteNode spriteNodeWithImageNamed:@"ghost"];
    
    ghostSprite.xScale = 1;
    ghostSprite.yScale = 1;

    CGFloat midY = CGRectGetMidY(self.view.bounds);

    // adjust position by 1/2 height of the ghost.
    if (position.y > midY)
    {
        ghostSprite.position = CGPointMake(position.x, position.y-ghostSprite.size.height/2);
    }
    else
    {
        ghostSprite.position = CGPointMake(position.x, position.y+ghostSprite.size.height/2);
    }
    
    // add animation for the ghost.

    CGFloat animationHeight = self.view.bounds.size.height - ghostSprite.size.height;
    
    SKAction *moveDown = [SKAction moveByX:0 y:-animationHeight duration: 2];
    SKAction *moveUp= [SKAction moveByX:0 y:animationHeight duration: 2];

    SKAction *sequence;
    if (position.y > midY)
    {
        sequence = [SKAction sequence: @[moveDown, moveUp]];
    }
    else
    {
        sequence = [SKAction sequence: @[moveUp, moveDown]];
    }
    
    SKAction *repeatedSequence = [SKAction repeatActionForever:sequence];
    
    // enable physics for the ghost.
    
    SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: ghostSprite.frame.size];
    physicsBody.dynamic = true;
    physicsBody.affectedByGravity = false;
    physicsBody.mass = 0.2;
    physicsBody.categoryBitMask = GHOST_COLLISION_MASK;
    physicsBody.collisionBitMask = PACMAN_COLLISION_MASK | WALL_COLLISION_MASK | EDGE_COLLISION_MASK;
    physicsBody.contactTestBitMask = PACMAN_COLLISION_MASK;
    
    ghostSprite.physicsBody = physicsBody;
    
    [ghostSprite runAction: repeatedSequence];
    
    return ghostSprite;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint pacmanPosition = self.pacmanSprite.position;
        
        CGFloat dx = pacmanPosition.x - touchLocation.x;
        CGFloat dy = pacmanPosition.y - touchLocation.y;
        
        CMAcceleration acceleration;
        acceleration.x = dx / 500.0;
        acceleration.y = dy / 500.0;
        
        [self applyForceToPacman: acceleration];
       
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


- (void)didBeginContact: (SKPhysicsContact *)contact {
    
    uint32_t bitMaskA = contact.bodyA.categoryBitMask;
    uint32_t bitMaskB = contact.bodyB.categoryBitMask;
    
    // check the type of collision
    if (((bitMaskA & PACMAN_COLLISION_MASK) != 0 && (bitMaskB & GHOST_COLLISION_MASK)) != 0 ||
        ((bitMaskB & PACMAN_COLLISION_MASK) != 0 && (bitMaskA & GHOST_COLLISION_MASK)) != 0)
    {
        // pacman vs ghost
        SKNode *ghost;
        if ([contact.bodyA.node.name rangeOfString:@"ghost"].location == NSNotFound)
        {
            ghost = contact.bodyB.node;
        }
        else {
            ghost = contact.bodyA.node;
        }
        
        [self flashGhost:(SKSpriteNode*) ghost];
    }
    else if (((bitMaskA & PACMAN_COLLISION_MASK) != 0 && (bitMaskB & EXIT_COLLISION_MASK)) != 0 ||
             ((bitMaskB & PACMAN_COLLISION_MASK) != 0 && (bitMaskA & EXIT_COLLISION_MASK)) != 0)
         {
             // pacman vs exit
             SKNode *exitSprite;
             if ([contact.bodyA.node.name isEqualToString: @"exit"])
             {
                 exitSprite = contact.bodyA.node;
             }
             else {
                 exitSprite = contact.bodyB.node;
             }
             
             [self flashExit:(SKSpriteNode*) exitSprite];
            
         }

}

-(void)flashGhost:(SKSpriteNode*) ghost
{
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.1];
    SKAction *fadeIn= [SKAction fadeInWithDuration:0.1];
    
    SKAction *sequence = [SKAction sequence: @[fadeOut, fadeIn]];
    
    SKAction *repeatedSequence = [SKAction repeatAction:sequence count:3];
    
    [ghost runAction:repeatedSequence];
}

-(void)flashExit:(SKSpriteNode*) exitSprite
{
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
    SKAction *fadeIn= [SKAction fadeInWithDuration:0.5];
    
    SKAction *sequence = [SKAction sequence: @[fadeOut, fadeIn]];
    
    SKAction *repeatedSequence = [SKAction repeatAction:sequence count:3];
    
    [exitSprite runAction:repeatedSequence];
}

@end
