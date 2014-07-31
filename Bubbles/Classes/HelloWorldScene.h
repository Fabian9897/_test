//
//  HelloWorldScene.h
//  Bubbles
//
//  Created by Praktikant on 21.07.14.
//  Copyright Praktikant 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "CCActionTween.h"
#include <math.h>
 
 
 
// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate>

// -----------------------------------------------------------------------


    
@property (nonatomic,strong) NSString * HS;

 
+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end