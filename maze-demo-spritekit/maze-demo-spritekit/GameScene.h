//
//  GameScene.h
//  maze-demo-spritekit
//

//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "pacman.h"

@interface GameScene : SKScene

/**
 Update the position and rotation of the pacman sprite
 */
-(void)repaintPacman;

@property (strong, nonatomic) PacmanModel *packmanModel;

@end
