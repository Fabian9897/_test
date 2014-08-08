//
//  ContinueScene.m
//  Bubbles
//
//  Created by Fabian Töpfer on 08.08.14.
//  Copyright (c) 2014 Praktikant. All rights reserved.
//

#import "ContinueScene.h"

@implementation ContinueScene
+ (ContinueScene *)scene2
{
	return [[self alloc] init];
}
- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    
    CCSprite* background = [CCSprite spriteWithImageNamed:@"menue-hintergrund.png"];
    background.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    
    [background setScaleX: self.contentSize.width/background.contentSize.width];
    [background setScaleY:self.contentSize.height/background.contentSize.height];
    
    [self addChild:background];
    
    CCSprite *logo =  [CCSprite spriteWithImageNamed:@"bobbls-logo.png"];
    logo.positionType = CCPositionTypeNormalized;
    logo.position = ccp(0.5, 0.7);
    [logo setScaleX: 0.92*self.contentSize.width/logo.contentSize.width];
    [logo setScaleY: 0.17*self.contentSize.height/logo.contentSize.height];
    [self addChild:logo];
    
    
 
    
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"Continue" fontName:@"Helvetica" fontSize:35.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.25f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    helloWorldButton.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    
    [self addChild:helloWorldButton];
    
    CCButton *startNewButton = [CCButton buttonWithTitle:@"Start" fontName:@"Helvetica" fontSize:35.0f];
    startNewButton.positionType = CCPositionTypeNormalized;
    startNewButton.position = ccp(0.5f, 0.1f);
    [startNewButton setTarget:self selector:@selector(onstartClicked:)];
    
    startNewButton.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    
    [self addChild:startNewButton];
    
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------
-(void)onstartClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene] ];
    
    
}
- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    
    [[CCDirector sharedDirector] popScene];
    
    
}

@end
