//
//  pacman.m
//  ios-maze-demo
//
//  Implement model for the pacman

//  Created by Jeromy Evans (personal) on 25/01/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "pacman.h"

@interface PacmanModel ()

#define SCALE 500
#define kUpdateInterval (1.0f / 60.0f)

@end


@implementation PacmanModel

- (id)init {
    self = [ super init ];
    if (self) {
        self.lastUpdateTime = [[NSDate alloc] init];
        self.currentPoint = CGPointMake(0, 144);
    }
    return self;
}

/**
  Recalulate pacman position
 */
- (void) calculatePosition:(CMAcceleration) acceleration {
    
    self.previousPoint = self.currentPoint;

    NSTimeInterval intervalSeconds = -([self.lastUpdateTime timeIntervalSinceNow]);

    self.pacmanYVelocity = self.pacmanYVelocity - (acceleration.y * intervalSeconds);
    self.pacmanXVelocity = self.pacmanXVelocity - (acceleration.x * intervalSeconds);
    
    CGFloat xDelta = intervalSeconds * self.pacmanXVelocity * SCALE;
    CGFloat yDelta = intervalSeconds * self.pacmanYVelocity * SCALE;
    
    self.currentPoint = CGPointMake(self.currentPoint.x + xDelta,
                                    self.currentPoint.y + yDelta);
    
    //  this maths is wrong... fix it later

    // extract angle in degrees
    CGFloat newAngle = (self.pacmanXVelocity + self.pacmanYVelocity) * M_PI * 4;
    
    // it muls by 1/60 to reduce the change in anagle because this is how often it updates
    self.angle += newAngle * kUpdateInterval;
    
    self.lastUpdateTime = [NSDate date];    
}

@end
