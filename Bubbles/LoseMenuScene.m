//
//  LoseMenuScene.m
//  Bubbles
//
//  Created by Praktikant on 28.07.14.
//  Copyright 2014 Praktikant. All rights reserved.
//

#import "LoseMenuScene.h"
#import "HelloWorldScene.h"
#import "ActivityViewController.h"

@implementation LoseMenuScene

{
    
    int endScore;
    int highScore;
    
    CCLabelTTF * labelHighScore ;
    CCLabelTTF *labelHigh;
}





+ (LoseMenuScene *)scene
{
	return [[self alloc] init];
}


-(id)init
{
    self = [super init];
    if (!self) return(nil);
    
    
  
    CCSprite* background = [CCSprite spriteWithImageNamed:@"hintergrund-ohne.png"];
    background.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    
    [background setScaleX: self.contentSize.width/background.contentSize.width];
    [background setScaleY:self.contentSize.height/background.contentSize.height];
    
    [self addChild:background];

    
    // ENDSCORE lesen HighScore lesen
    endScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"] intValue ];
    highScore = [[[NSUserDefaults standardUserDefaults] objectForKey: @"AbsolutHighScore" ]intValue];

    
    
    CCLabelTTF *labelEnd  = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score"] fontName:@"Helvetica" fontSize:18.0f];
    labelEnd.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    labelEnd.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/1.7 + 30);
    [self addChild:labelEnd];
    
    CCLabelTTF *labelEndScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", endScore] fontName:@"Helvetica" fontSize:23.0f];
    labelEndScore.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    labelEndScore.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/1.7);
    [self addChild:labelEndScore];
    
 
  
    //HighScoreLabel
    labelHigh = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highscore"] fontName:@"Helvetica" fontSize:18.0f];
    labelHigh.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/1.3 + 30);
    labelHigh.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    [self addChild:labelHigh];
    
    labelHighScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", highScore] fontName:@"Helvetica" fontSize:23.0f];
    labelHighScore.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/1.3);
    labelHighScore.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];

    [self addChild:labelHighScore];
    [self highScore];
    
    
    
    
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];
    
    
    
    
    CCButton *shareButtn = [CCButton buttonWithTitle:@"[ Share ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    shareButtn.positionType = CCPositionTypeNormalized;
    shareButtn.position = ccp(0.5f, 0.2f);
    [shareButtn setTarget:self selector:@selector(share:)];
    [self addChild:shareButtn];
    
    
    return self;
    
    
}
//HIGHSCORE ÜBERPRÜFUNG
-(void)highScore
{
    
    if (endScore > highScore)
    
    {
        labelHighScore.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];
        labelHigh.color = [CCColor colorWithRed:1.0 green:0.0 blue:0.0];

        [labelHighScore setString:[NSString stringWithFormat:@"%d",endScore]];
        
        highScore = endScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScore] forKey:@"AbsolutHighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
     
        
        
    }
    else if (highScore >= endScore)
    {
        [labelHighScore setString:[NSString stringWithFormat:@"%d",highScore]];

        
    }
    
    
    
 
    
    
}

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f ]];
}
-(void)share:(id)sender
{
    
    
    
   ActivityViewController *vc = [[ActivityViewController alloc] init];
    [[CCDirector sharedDirector] presentViewController:vc animated:YES completion:nil  ];

    //AppControler *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
   // [[app navController] presentModalViewController:vc animated:YES];
    // [[CCDirector sharedDirector] replaceScene:[ActivityViewController ]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
   // [[[CCDirector sharedDirector] view] addSubview:vc];

}

@end
