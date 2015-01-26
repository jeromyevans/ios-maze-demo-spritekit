//
//  GameScene.m
//  maze-demo-spritekit
//
//  Created by Jeromy Evans (personal) on 25/01/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property BOOL contentCreated;

@property SKSpriteNode* pacmanSprite;

@property SKSpriteNode* ghost1Sprite;
@property SKSpriteNode* ghost2Sprite;
@property SKSpriteNode* ghost3Sprite;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated) {
        
        [self createSceneContents];
        
        self.contentCreated = true;
    }
    
}

-(void)createSceneContents {
    
    self.backgroundColor = [SKColor blackColor];

    SKView* skView = (SKView *)self.view;

    /* Setup your scene here */
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
    
    [self createPacman];

    CGFloat sceneWidth = self.view.bounds.size.width;
    CGFloat sceneHeight = self.view.bounds.size.height;
    
    self.ghost1Sprite = [self createGhost:CGPointMake(sceneWidth/4.0,0.0)];
    self.ghost2Sprite = [self createGhost:CGPointMake(sceneWidth/2.0, sceneHeight)];
    self.ghost3Sprite = [self createGhost:CGPointMake(3*sceneWidth/4.0, 0.0)];
    
    [self addChild:self.ghost1Sprite];
    [self addChild:self.ghost2Sprite];
    [self addChild:self.ghost3Sprite];
    
    [self addChild:self.pacmanSprite];
}

-(void)createPacman
{
    
    self.pacmanSprite = [SKSpriteNode spriteNodeWithImageNamed:@"pacman"];
    
    self.pacmanSprite.xScale = 1;
    self.pacmanSprite.yScale = 1;
    self.pacmanSprite.position = CGPointMake(self.pacmanSprite.size.width/2, CGRectGetMidY(self.frame)); // left edge centre
    
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
    
    [ghostSprite runAction: repeatedSequence];
    
    return ghostSprite;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *pacmanSprite = [SKSpriteNode spriteNodeWithImageNamed:@"pacman"];
        
        pacmanSprite.xScale = 0.5;
        pacmanSprite.yScale = 0.5;
        pacmanSprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [pacmanSprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:pacmanSprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
