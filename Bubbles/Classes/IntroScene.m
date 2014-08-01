//
//  IntroScene.m
//  Bubbles
//
//  Created by Praktikant on 21.07.14.
//  Copyright Praktikant 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
  

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    
    CCSprite* background = [CCSprite spriteWithImageNamed:@"hintergrund-mit.png"];
    background.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    
    [background setScaleX: self.contentSize.width/background.contentSize.width];
    [background setScaleY:self.contentSize.height/background.contentSize.height];
    
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bubbles" fontName:@"Helvetiva" fontSize:46.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.8f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCSprite *ball = [CCSprite spriteWithImageNamed:@"faenger-Bobble-100-Prozent-hd.png"];
    ball.positionType = CCPositionTypeNormalized;
    ball.position = ccp(0.5f, 0.15f);
    ball.scale = 1.5;
    [self addChild:ball];
    
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"Start" fontName:@"Helvetica" fontSize:35.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.15f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    helloWorldButton.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    
    [self addChild:helloWorldButton];

    
   
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f ]];
}

// -----------------------------------------------------------------------
@end
