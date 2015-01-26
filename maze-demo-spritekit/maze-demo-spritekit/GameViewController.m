//
//  GameViewController.m
//  maze-demo-spritekit
//
//  Created by Jeromy Evans (personal) on 25/01/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 Use this method instead of viewDidLoad to prepare the scene 
 This one knows dimensions in skView.bounds.size
*/

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView* skView = (SKView *)self.view;
    
    // setup the view only once.
    // if the device orientation is rotating this method will be invoked again
    if (!skView.scene)
    {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        GameScene * scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.size = skView.bounds.size;
        scene.scaleMode = SKSceneScaleModeAspectFill;  // simply stretches
        
        [self setupAccelerometer:scene];
        
        // Present the scene.
        [skView presentScene:scene];
    }

}

/**
 Setup a callback on the motionManager to queue accelerometer inputs and recalculate the 
 position of the pacman
 */
- (void)setupAccelerometer:(GameScene*) scene {
    self.motionManager = [[CMMotionManager alloc]  init];
    self.queue         = [[NSOperationQueue alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = ACCELEROMETER_READ_INTERVAL;
    
    [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:
     // invoke calculatePosition() with latest acceleration to recalculate position
     // invoke render on the main thread as we don't want to render within the callback block invoked by the motionManager
     ^(CMAccelerometerData *accelerometerData, NSError *error) {
         
         [scene applyForceToPacman:accelerometerData.acceleration ];
     }];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
