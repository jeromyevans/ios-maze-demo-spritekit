//
//  pacman.h
//  ios-maze-demo
//
//  Model header for the pacman character
//
//  Created by Jeromy Evans (personal) on 25/01/2015.
//

#ifndef ios_maze_demo_pacman_h
#define ios_maze_demo_pacman_h

#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/CAAnimation.h>

@interface PacmanModel : NSObject

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGFloat pacmanXVelocity;
@property (assign, nonatomic) CGFloat pacmanYVelocity;
@property (assign, nonatomic) CGFloat angle;
@property (strong, nonatomic) NSDate *lastUpdateTime;

/**
 Recalculate pacman's new position given the acceleration and last position and velocity
 */
- (void) calculatePosition:(CMAcceleration) acceleration;

@end

#endif
