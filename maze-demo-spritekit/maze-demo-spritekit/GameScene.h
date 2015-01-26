//
//  GameScene.h
//  maze-demo-spritekit
//

//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface GameScene : SKScene

/**
 Update the position and rotation of the pacman sprite
 */
-(void)applyForceToPacman:(CMAcceleration) acceleration;

@end
