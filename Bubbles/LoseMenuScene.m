//
//  LoseMenuScene.m
//  Bubbles
//
//  Created by Praktikant on 28.07.14.
//  Copyright 2014 Praktikant. All rights reserved.
//

#import "LoseMenuScene.h"
#import "HelloWorldScene.h"

@implementation LoseMenuScene

{
    
    int endScore;
    int highScore;
    
    CCLabelTTF * labelHighScore ;
    CCLabelTTF *labelHigh;
    
    UIImage *screenshot;
    NSString *theImagePath;
    
    UIView *backgroundView;
}





+ (LoseMenuScene *)scene
{
	return [[self alloc] init];
}


-(id)init
{
    self = [super init];
    if (!self) return(nil);
    
    
  
    
    // ENDSCORE lesen HighScore lesen
    endScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"] intValue ];
    highScore = [[[NSUserDefaults standardUserDefaults] objectForKey: @"AbsolutHighScore" ]intValue];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Screenshot"];
  screenshot = [UIImage imageWithData:imageData];
    
    CCSprite* background = [CCSprite spriteWithImageNamed:@"hintergrund-mit.png"];
     background.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    
    [background setScaleX: self.contentSize.width/background.contentSize.width];
    [background setScaleY:self.contentSize.height/background.contentSize.height];
    
   [self addChild:background];

    
     //UIImage *customImage = [UIImage imageWithContentsOfFile:theImagePath];
    
    CCLabelTTF *labelEnd  = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score"] fontName:@"Helvetica" fontSize:20.0f];
    labelEnd.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    labelEnd.positionType = CCPositionTypeNormalized;
    labelEnd.position = ccp(0.5f, 0.68f);
    [self addChild:labelEnd];
    
    CCLabelTTF *labelEndScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", endScore] fontName:@"Helvetica" fontSize:27.0f];
    labelEndScore.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    labelEndScore.positionType = CCPositionTypeNormalized;
    labelEndScore.position = ccp(0.5f, 0.63f);
    [self addChild:labelEndScore];
    
 
  
    
    
    CCLabelTTF *gameOver = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Game Over"] fontName:@"Helvetica" fontSize:40.0f];
    gameOver.positionType = CCPositionTypeNormalized;
    gameOver.position = ccp(0.5f, 0.9f);
    gameOver.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    [self addChild:gameOver];
    
    
    
    //HighScoreLabel
    labelHigh = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highscore"] fontName:@"Helvetica" fontSize:20.0f];
    labelHigh.positionType = CCPositionTypeNormalized;
    labelHigh.position = ccp(0.5f, 0.8f);
    labelHigh.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];
    [self addChild:labelHigh];
    
    labelHighScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", highScore] fontName:@"Helvetica" fontSize:27.0f];
    labelHighScore.positionType = CCPositionTypeNormalized;
    labelHighScore.position = ccp(0.5f, 0.75f);
    labelHighScore.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];

    [self addChild:labelHighScore];
    [self highScore];
    
    
    CCSprite *ball = [CCSprite spriteWithImageNamed:@"faenger-Bobble-100-Prozent-hd.png"];
    ball.positionType = CCPositionTypeNormalized;
    ball.position = ccp(0.5f, 0.15f);
    ball.scale = 1.5;
    [self addChild:ball];
    
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"Retry" fontName:@"Helvetica" fontSize:35.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.15f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    helloWorldButton.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];

    [self addChild:helloWorldButton];
    
    
    
    
    CCButton *shareButtn = [CCButton buttonWithTitle:@"Facebook" fontName:@"Helvetica" fontSize:24.0f];
    
    shareButtn.positionType = CCPositionTypeNormalized;
    shareButtn.position = ccp(0.5f, .45f);
    [shareButtn setTarget:self selector:@selector(share:)];
    shareButtn.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];

    [self addChild:shareButtn];
    
    CCButton *shareButtnTwitter = [CCButton buttonWithTitle:@"Twitter" fontName:@"Helvetica" fontSize:24.0f];
    
    shareButtnTwitter.positionType = CCPositionTypeNormalized;
    shareButtnTwitter.position = ccp(0.5f, 0.35f);
    [shareButtnTwitter setTarget:self selector:@selector(shareTwitter:)];
    
    shareButtnTwitter.color = [CCColor colorWithRed:0.0 green:0.0 blue:0.0];

    [self addChild:shareButtnTwitter];
    
    
/*
    CGImage *blurImg = [UIImage imageWithCGImage :screenshot.CGImage ];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:blurImg forKey:@"Screenshot"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImg = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[blurImg extent]];
    UIImage *outputImg = [UIImage imageWithCGImage:cgImg];
    
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentSize.width/2, self.contentSize.height/2,  self.contentSize.width, self.contentSize.height)];
    imgView.image = outputImg;
    
    CCSprite *blur = [CCSprite spriteWithCGImage:screenshot.CGImage key:@"Screenshot"];
    [self addChild:blur];
 */
    
    
    
 
    // Create filter.
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
    
        
    
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted");
                }
                    break;
            }};
        
        [fbController addImage:screenshot];
        [fbController setInitialText:[ NSString stringWithFormat:@"Hey, I scored %d Points in Bubbles",endScore]];
       
        [fbController setCompletionHandler:completionHandler];
        
 
         [[CCDirector sharedDirector] presentViewController:fbController animated:YES completion:nil  ];

     }
   
    
   
}
-(void)shareTwitter:(id)sender
{
    
    
    
    
    SLComposeViewController *twController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted");
                }
                    break;
            }};
        
        [twController addImage: screenshot];
        [twController setInitialText:[ NSString stringWithFormat:@"Hey, I scored %d Points in Bubbles ",endScore]];
        
        [twController setCompletionHandler:completionHandler];
        
        
        [[CCDirector sharedDirector] presentViewController:twController animated:YES completion:nil  ];
        

     }
    
}

@end
