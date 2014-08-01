//
//  HelloWorldScene.m
//  Bubbles
//
//  Created by Praktikant on 21.07.14.
//  Copyright Praktikant 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "LoseMenuScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------


#pragma mark Definitions
#define gameisOn 1
#define gamePaused 0


#pragma mark Implementation
@implementation HelloWorldScene

{
    
     OALSimpleAudio *audio;

    // SPRITES
    CCSprite *bubbles_1;
    CCSprite *bubbles_2;
    CCSprite *bubbles_10;
    CCSprite *bubbles_5;
    CCSprite *bubbles_7;
    
    
    CCSprite *bubbles_timeDown;
    CCSprite *bubbles_timeUp;
    CCSprite *bubbles_bomb;
    CCSprite *bubbles_shield;
    CCSprite *shield ;
    CCSprite *shieldBG;
    CCLabelTTF *shieldTimeLabel;
    
    
    CCSprite *bubble_live;
    CCSprite *xtraLive;
    BOOL liveActive;
    
    CCSprite *bubble_faster;
    int fasterTime;
    BOOL fasterActive;
    BOOL slowerActive;
    
    CCSprite *bubbles_slower;
    int slowerTime;
    
    int shieldTime;
    BOOL shieldActive;
    BOOL Collsion;
    BOOL labelBlink;
    
    
    CCSprite *player;
    
    
    CCSprite *pauseSprite;
    CCSprite *playSprite;
    
    CCPhysicsNode *physicsWorld;
    
    CCProgressNode *_progressNode;
 
    
    // BUBBLES Ueberpruefung
    int anzahlBubblesAufDemFeld;
    int anzahl ;
    
    int percentage;
    
   
    
    // TOUCH steuerung
    float playerRichtungX;
    CGPoint touchLoc;
    
    float alpha;
    
    
    // ACCELERATION Steuerung
    CMMotionManager *motionManager;
    
    
    
    // TIME and SCORE
    CCLabelTTF          *timeLabel;
    CCLabelTTF          *scoreLabel;
    CCLabelTTF          *highScoreLabel;
    
    float              timeInSec;
    
    CCButton *pause;
    CCButton *play;
    int gameStatus;
    int scoreBubbles;
       
    float sec;
    
    int opaqueFactor;
    int artDerBubbles ;
    
    int highScore;
    int highScoreEnd;
    
    int windowHeight;
    int windowWidth;
    CCNode *groupBubbles;
    
    
    
  

}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    gameStatus = gamePaused;
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    
    windowHeight = self.contentSize.height/2;
    windowWidth = self.contentSize.width/2;
    
    liveActive = NO;
    fasterActive = NO;
    slowerActive = NO;
    
    CCSprite* background = [CCSprite spriteWithImageNamed:@"hintergrund-mit.png"];
    background.position = ccp(windowWidth, windowHeight);

    [background setScaleX: self.contentSize.width/background.contentSize.width];
    [background setScaleY:self.contentSize.height/background.contentSize.height];
    
    [self addChild:background];

    CCSprite *linie = [CCSprite spriteWithImageNamed:@"linie-oben.png"];
    linie.positionType = CCPositionTypeNormalized;
     linie.position = ccp(0.5, 0.9 );
    
    [self addChild:linie];
    
        // PHYSIK WORLD
    
    physicsWorld = [CCPhysicsNode node];
    physicsWorld.gravity = ccp(0,0);
    physicsWorld.debugDraw = NO;
    physicsWorld.collisionDelegate = self;
    
    
    
   // physicsWorld.collisionDelegate = self;
    
    [self addChild:physicsWorld];
    //-------------------------------------------------------------------------------------------------------------------------

     // Add a sprite
    player = [CCSprite spriteWithImageNamed:@"faenger-Bobble-50-Prozent.png"];
    player.position  = ccp(windowWidth,self.contentSize.height/4);
    [self setOpacity:100];

    //player.scale = 0.8;

    
    
    player.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:player.contentSize.width/2.0f andCenter:player.anchorPointInPoints ];
    player.physicsBody.collisionType =@"playerCollision";
    player.physicsBody.collisionGroup= @"playerGroup";
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.sensor = YES;
    [physicsWorld addChild:player];
    
    
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------
 
    
    // Create a back button
    CCButton *backButton = [CCButton  buttonWithTitle:@"[ Menu ]" fontName:@"Helvetica-Neue-UltraLight" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.5f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
 
    
    
    
    
    
    pauseSprite = [ CCSprite spriteWithImageNamed:@"pause-icon-inactive.png"];
    pauseSprite.position  = ccp(0.19,0.95);
     pauseSprite.positionType = CCPositionTypeNormalized;
    
    [self addChild:pauseSprite];
    
    
    playSprite = [ CCSprite spriteWithImageNamed:@"play-icon-active.png"];
    playSprite.position  = ccp(0.1,0.95);
     playSprite.positionType = CCPositionTypeNormalized;
    
    [self addChild:playSprite];

    //Create the Labels
    //-------------------------------------------------------------------------------------------------------------------------
 
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i/100", scoreBubbles] fontName:@"Helvetica-Neue-UltraLight" fontSize:18.0f];
   [scoreLabel setPosition:player.position];
    scoreLabel.color = [CCColor blackColor];
    //scoreLabel.positionType = CCPositionTypePoints;
    
    [self addChild:scoreLabel];
    
    highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", highScore] fontName:@"Helvetica-Neue-UltraLight" fontSize:28.0f];
    highScoreLabel.positionType = CCPositionTypeNormalized;
    highScoreLabel.position = ccp(0.9,0.95);
    highScoreLabel.color = [CCColor blackColor];
    
    [self addChild:highScoreLabel];

    //-------------------------------------------------------------------------------------------------------------------------
    
    // ACCELERATION
    
    motionManager =  [[CMMotionManager alloc] init];
  
        
    
    motionManager.accelerometerUpdateInterval = 0.05;
 
    
    //-------------------------------------------------------------------------------------------------------------------------
  
    
    // TIMELINE
    
    CCSprite *whiteTimeline = [CCSprite spriteWithImageNamed:@"timeline_white.png"];
    whiteTimeline.position = CGPointMake(windowWidth, self.contentSize.height/10);
    whiteTimeline.scaleY = 2.0f;
    
    [self addChild:whiteTimeline];
    
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"timeline-red.png"];
    _progressNode = [CCProgressNode progressWithSprite:sprite];
    _progressNode.scaleY = 2.0f;
    _progressNode.type = CCProgressNodeTypeBar;
    _progressNode.midpoint = ccp(0.0f, 0.0f);
    _progressNode.barChangeRate = ccp(1.0f, 0.0f);
    _progressNode.percentage = 0.0f;
    
     _progressNode.position = CGPointMake(windowWidth, self.contentSize.height/10);
    [self addChild:_progressNode];
    
    self.userInteractionEnabled = YES;
    //-------------------------------------------------------------------------------------------------------------------------
 
  
     anzahlBubblesAufDemFeld = 0;
    
    scoreBubbles = 0;
    highScore = 0;
    percentage = 0;
    shieldActive = NO;
    
    labelBlink = NO;
    // done
    
   audio = [OALSimpleAudio sharedInstance];
  //
    [audio preloadEffect:@"Blop-Mark_DiAngelo-79054334.mp3"];
    
    [audio preloadEffect:@"Blow Up Balloon-SoundBible.com-1407502310.mp3"];

    [audio preloadEffect:@"Ready To Burst-SoundBible.com-1103504176.mp3"];

    
           gameStatus = gameisOn;
	return self;
}

#pragma mark MakeBubbles



- (void)addBubbles:(CCTime)dt



{
 
    
    if (gameStatus == gameisOn) {
        
           anzahl = ( arc4random()%3 + 1);
    
   //NSLog(@"anzahl : %d", anzahl);
     //   NSLog(@"anzahl der Bubbles %d", anzahlBubblesAufDemFeld);
    
    
    //if (anzahlBubblesAufDemFeld + anzahl  < 6)
  //  {
        
  
     
    
     for (int i = 1 ; i <= anzahl; i++) {
         
         artDerBubbles = arc4random()%150;
         
       //  NSLog(@"  Arte der Bubble : %d", artDerBubbles);

         // 1 Bubbles

         if (artDerBubbles > 0 && artDerBubbles <= 20&&!slowerActive) {
             
         
             Collsion = NO;
             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;

       
             bubbles_1 = [CCSprite spriteWithImageNamed:@"1-Pointer-Bobble.png"];

    int minX = bubbles_1.contentSize.width ;
    int maxX = self.contentSize.width - bubbles_1.contentSize.width * 2 ;
   // int rangeX = maxX - minX+1;
  
             
             
             int randomX = (arc4random() % (maxX-minX+1))  +minX ;
   // int randomX= arc4random()%(maxX-minX+1) + minX;

         bubbles_1.position = CGPointMake(randomX,self.contentSize.height + bubbles_1.contentSize.width/2);

    
    
        bubbles_1.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_1.contentSize.width/2.0f andCenter:bubbles_1.anchorPointInPoints ];
        bubbles_1.physicsBody.collisionType =@"bubbleCollision";
             bubbles_1.physicsBody.allowsRotation = NO;
             //bubbles_1.physicsBody.sensor = YES;
             
        [physicsWorld addChild:bubbles_1];
        
        
  
        
             int minDuration = 5.0 + ( 1/sec);
             int maxDuration = 8.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration;
         
     
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_1.contentSize.width/2)];
             actionMove.tag = 0;
         
         
       //  NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );

     CCAction *actionRemove = [CCActionRemove action];
     CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
     
            
      
        
    [bubbles_1 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             
             [groupBubbles addChild:bubbles_1];
 
         }
         
         // 2Bubbles
         else if( artDerBubbles > 20 && artDerBubbles <= 40&&!slowerActive)
             
         {         anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;

             Collsion = NO;
             bubbles_2 = [CCSprite spriteWithImageNamed:@"2-Pointer-Bobble.png"];

             int minX = bubbles_2.contentSize.width  ;
             int maxX = self.contentSize.width - bubbles_2.contentSize.width  ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_2.position = CGPointMake(randomX,self.contentSize.height + bubbles_2.contentSize.width/2);
             
             
             
             bubbles_2.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_2.contentSize.width/2.0f andCenter:bubbles_2.anchorPointInPoints ];
             bubbles_2.physicsBody.collisionType =@"bubble2Collision";
             bubbles_2.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_2];
            // bubbles_2.physicsBody.sensor = YES;

             
             
       
             
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
             
             
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_2.contentSize.width/2)];
             actionMove.tag = 1;

             
             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             
             
             
             
             [bubbles_2 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
 
             [groupBubbles addChild:bubbles_2];

             
             
         }
         
         // 5Bubbles
         else if ( artDerBubbles > 40 && artDerBubbles <= 60&&!slowerActive)
         {
             Collsion = NO;
             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
             bubbles_5 = [CCSprite spriteWithImageNamed:@"5-Pointer-Bobble.png"];

             
             
             int minX = bubbles_5.contentSize.width  ;
             int maxX = self.contentSize.width - bubbles_5.contentSize.width  ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_5.position = CGPointMake(randomX,self.contentSize.height + bubbles_5.contentSize.width/2);
             
             
             
             bubbles_5.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_5.contentSize.width/2.0f andCenter:bubbles_5.anchorPointInPoints ];
             bubbles_5.physicsBody.collisionType =@"bubble5Collision";
             bubbles_5.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_5];
            // bubbles_5.physicsBody.sensor = YES;

         
             
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
           //  NSLog(@"duration %d", randomDuration);
             
             
             
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_5.contentSize.width/2)];
             
             
             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             actionMove.tag = 2;

             
             
             
             [bubbles_5 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             [groupBubbles addChild:bubbles_5];

         }
          // 7 Bubbles
         else if ( artDerBubbles > 60 && artDerBubbles <= 70&&!slowerActive)
         {
             Collsion = NO;
             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
             bubbles_7 = [CCSprite spriteWithImageNamed:@"7-Pointer-Bobble.png"];

             
             
             int minX = bubbles_7.contentSize.width  ;
             int maxX = self.contentSize.width - bubbles_7.contentSize.width  ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_7.position = CGPointMake(randomX,self.contentSize.height + bubbles_7.contentSize.width/2);
             
             
             
             bubbles_7.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_7.contentSize.width/2.0f andCenter:bubbles_7.anchorPointInPoints ];
             bubbles_7.physicsBody.collisionType =@"bubble7Collision";
             bubbles_7.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_7];
            // bubbles_7.physicsBody.sensor = YES;

             
          
             
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
             
             
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_7.contentSize.width/2)];
             
             
             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             actionMove.tag = 3;

             
             
             
             [bubbles_7 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             [groupBubbles addChild:bubbles_7];

         }

        //10Bubbles
         else if ( artDerBubbles > 70 && artDerBubbles <= 77&&!slowerActive)
         {
             Collsion = NO;

             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
             bubbles_10 = [CCSprite spriteWithImageNamed:@"10-Pointer-Bobble.png"];

             
             int minX = bubbles_10.contentSize.width  ;
             int maxX = self.contentSize.width - bubbles_10.contentSize.width   ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_10.position = CGPointMake(randomX,self.contentSize.height + bubbles_10.contentSize.width/2);
             
             
             
             bubbles_10.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_10.contentSize.width/2.0f andCenter:bubbles_10.anchorPointInPoints ];
             bubbles_10.physicsBody.collisionType =@"bubble10Collision";
             bubbles_10.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_10];
           //  bubbles_10.physicsBody.sensor = YES;

             
          
        
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
             
             
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_10.contentSize.width/2)];
             actionMove.tag = 4;

             
             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             
             
             
             
             [bubbles_10 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             [groupBubbles addChild:bubbles_10];

         }
         
         // TIME DOWN
         
         
            if ( artDerBubbles > 77 && artDerBubbles <= 90 && highScore >= 70&&!slowerActive)
         {
             
             Collsion = NO;
             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;

             bubbles_timeDown = [CCSprite spriteWithImageNamed:@"time-down-Bobble.png"];

             int minX = bubbles_timeDown.contentSize.width  ;
             int maxX = self.contentSize.width - bubbles_timeDown.contentSize.width ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_timeDown.position = CGPointMake(randomX,self.contentSize.height + bubbles_10.contentSize.width/2);
             
             
             
             bubbles_timeDown.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_timeDown.contentSize.width/2.0f andCenter:bubbles_timeDown.anchorPointInPoints ];
             bubbles_timeDown.physicsBody.collisionType =@"bubbleTimeDownCollision";
             bubbles_timeDown.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_timeDown];
            // bubbles_timeDown.physicsBody.sensor = YES;

             
             
             
             
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
      
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_timeDown.contentSize.width/2)];
             
             
             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             
             actionMove.tag = 5;

             
             
             [bubbles_timeDown runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             [groupBubbles addChild:bubbles_timeDown];

         }
         //TIME UP

          else if ( artDerBubbles > 90 && artDerBubbles <= 100&& highScore >= 50&&!slowerActive)
         {
             
             Collsion = NO;
             anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;

             
             int minX = bubbles_timeUp.contentSize.width ;
             int maxX = self.contentSize.width - bubbles_timeUp.contentSize.width  ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
             
             bubbles_timeUp = [CCSprite spriteWithImageNamed:@"time-up-Bobble.png"];
             bubbles_timeUp.position = CGPointMake(randomX,self.contentSize.height + bubbles_timeUp.contentSize.width/2);
             
             
             
             bubbles_timeUp.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_timeUp.contentSize.width/2.0f andCenter:bubbles_timeUp.anchorPointInPoints ];
             bubbles_timeUp.physicsBody.collisionType =@"bubbleTimeUpCollision";
             bubbles_timeUp.physicsBody.allowsRotation = NO;

             [physicsWorld addChild:bubbles_timeUp];
             
           //  bubbles_timeUp.physicsBody.sensor = YES;

             
             
             int minDuration = 3.0;
             int maxDuration = 6.0;
             int rangeDuration = maxDuration - minDuration;
             int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
             
             CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_timeUp.contentSize.width/2)];
             
             actionMove.tag = 6;

             //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
             
             CCAction *actionRemove = [CCActionRemove action];
             CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
             
             
             
             
             [bubbles_timeUp runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
             [groupBubbles addChild:bubbles_timeUp];

         }
             // BOMB
          else if ( artDerBubbles > 100 && artDerBubbles <= 110&& highScore > 150&&!slowerActive)
          {
              
              Collsion = NO;
              anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;

              bubbles_bomb = [CCSprite spriteWithImageNamed:@"bomb-Bobble.png"];

              int minX = bubbles_bomb.contentSize.width  ;
              int maxX = self.contentSize.width - bubbles_bomb.contentSize.width  ;
               int randomX = (arc4random() % (maxX-minX+1))  +minX ;
              
              bubbles_bomb.position = CGPointMake(randomX,self.contentSize.height + bubbles_bomb.contentSize.width/2);
              
              
              
              bubbles_bomb.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_bomb.contentSize.width/2.0f andCenter:bubbles_bomb.anchorPointInPoints ];
              bubbles_bomb.physicsBody.collisionType =@"bubbleBombCollision";
              bubbles_bomb.physicsBody.allowsRotation = NO;

              [physicsWorld addChild:bubbles_bomb];
              
             // bubbles_bomb.physicsBody.sensor = YES;

              
              
              int minDuration = 3.0;
              int maxDuration = 6.0;
              int rangeDuration = maxDuration - minDuration;
              int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
              
              CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_bomb.contentSize.width/2)];
              actionMove.tag = 7;

              
              //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
              
              CCAction *actionRemove = [CCActionRemove action];
              CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
              
              
              
              
              [bubbles_bomb runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
              [groupBubbles addChild:bubbles_bomb];

          }
             //SHIELD
          else if ( artDerBubbles > 110 && artDerBubbles <= 119&& highScore >= 120&&!slowerActive)
          {
              
              Collsion = NO;
              anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
              bubbles_shield = [CCSprite spriteWithImageNamed:@"shield-Bobble.png"];

              int minX = bubbles_shield.contentSize.width  ;
              int maxX = self.contentSize.width - bubbles_shield.contentSize.width    ;
               int randomX = (arc4random() % (maxX-minX+1))  +minX ;
              
              bubbles_shield.position = CGPointMake(randomX,self.contentSize.height + bubbles_shield.contentSize.width/2);
              
              
              
              bubbles_shield.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_shield.contentSize.width/2.0f andCenter:bubbles_shield.anchorPointInPoints ];
              bubbles_shield.physicsBody.collisionType =@"bubbleShieldCollision";
              bubbles_shield.physicsBody.allowsRotation = NO;

              [physicsWorld addChild:bubbles_shield];
              
             // bubbles_shield.physicsBody.sensor = YES;

              
              
              int minDuration = 3.0;
              int maxDuration = 6.0;
              int rangeDuration = maxDuration - minDuration;
              int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
              
              CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_shield.contentSize.width/2)];
              actionMove.tag = 8;

              
              //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
              
              CCAction *actionRemove = [CCActionRemove action];
              CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
              
              
              
              
              [bubbles_shield runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
              [groupBubbles addChild:bubbles_shield];

          }
             //FASTER
          else if ( artDerBubbles > 119 && artDerBubbles <= 123&& !fasterActive && !fasterActive && highScore >100)
          {
              
              Collsion = NO;
              anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
              bubble_faster = [CCSprite spriteWithImageNamed:@"faster-Bobble.png"];
              
              int minX = bubble_faster.contentSize.width  ;
              int maxX = self.contentSize.width - bubble_faster.contentSize.width    ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
              
              bubble_faster.position = CGPointMake(randomX,self.contentSize.height + bubble_faster.contentSize.width/2);
              
              
              
              bubble_faster.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubble_faster.contentSize.width/2.0f andCenter:bubble_faster.anchorPointInPoints ];
              bubble_faster.physicsBody.collisionType =@"bubbleFasterCollision";
              bubble_faster.physicsBody.allowsRotation = NO;

              [physicsWorld addChild:bubble_faster];
              
              // bubbles_shield.physicsBody.sensor = YES;
              
              
              
              int minDuration = 3.0;
              int maxDuration = 6.0;
              int rangeDuration = maxDuration - minDuration;
              int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
              
              CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubble_faster.contentSize.width/2)];
              actionMove.tag = 9;

              
              //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
              
              CCAction *actionRemove = [CCActionRemove action];
              CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
              
              
              
              
              [bubble_faster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
              [groupBubbles addChild:bubble_faster];

          }
         //Slower
          else if ( artDerBubbles > 123 && artDerBubbles <= 130&& !slowerActive && !fasterActive && highScore > 120 )
          {
              
              Collsion = NO;
              anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
              bubbles_slower = [CCSprite spriteWithImageNamed:@"freeze-mode-Bobble.png"];
              
              int minX = bubbles_slower.contentSize.width  ;
              int maxX = self.contentSize.width - bubbles_slower.contentSize.width    ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
              
              bubbles_slower.position = CGPointMake(randomX,self.contentSize.height + bubbles_slower.contentSize.width/2);
              
              
              
              bubbles_slower.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubbles_slower.contentSize.width/2.0f andCenter:bubbles_slower.anchorPointInPoints ];
              bubbles_slower.physicsBody.collisionType =@"bubbleSlowerCollision";
              bubbles_slower.physicsBody.allowsRotation = NO;

              [physicsWorld addChild:bubbles_slower];
              
              // bubbles_shield.physicsBody.sensor = YES;
              
              
              
              int minDuration = 3.0;
              int maxDuration = 6.0;
              int rangeDuration = maxDuration - minDuration;
              int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
              
              CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubbles_slower.contentSize.width/2)];
              actionMove.tag = 10;

              
              //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
              
              CCAction *actionRemove = [CCActionRemove action];
              CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
              
              
              
              
              [bubbles_slower runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
              [groupBubbles addChild:bubbles_slower];

          }

 
         //Leben
          else if ( artDerBubbles > 130 && artDerBubbles <= 132 && ! liveActive && highScore > 80)
          {
              
              Collsion = NO;
              anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld + 1;
              bubble_live = [CCSprite spriteWithImageNamed:@"xtra-newlife-Bobble.png"];
              
              int minX = bubble_live.contentSize.width  ;
              int maxX = self.contentSize.width - bubble_live.contentSize.width    ;
              int randomX = (arc4random() % (maxX-minX+1))  +minX ;
              
              bubble_live.position = CGPointMake(randomX,self.contentSize.height + bubble_live.contentSize.width/2);
              
              
              
              bubble_live.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:bubble_live.contentSize.width/2.0f andCenter:bubble_live.anchorPointInPoints ];
              bubble_live.physicsBody.collisionType =@"bubbleLifeCollision";
              
              bubble_live.physicsBody.allowsRotation = NO;
              
              [physicsWorld addChild:bubble_live];
              
              // bubbles_shield.physicsBody.sensor = YES;
              
              
              
              int minDuration = 3.0;
              int maxDuration = 6.0;
              int rangeDuration = maxDuration - minDuration;
              int randomDuration = (arc4random() % rangeDuration) + minDuration + ( 1/sec);
              
              CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomX, -bubble_live.contentSize.width/2)];
              
              actionMove.tag = 11;

              //NSLog(@"anzahl auf dem feld1: %d", anzahlBubblesAufDemFeld );
              
              CCAction *actionRemove = [CCActionRemove action];
              CCActionCallFunc *callAfterMoving = [CCActionCallFunc actionWithTarget:self selector:@selector(callBack)];
              
              
              
              
              [bubble_live runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove,callAfterMoving]]];
              [groupBubbles addChild:bubble_live];
              
          }
         
         

         }
   //  anzahlBubblesAufDemFeld --;
        
         
        
        
          }
    
    if (anzahlBubblesAufDemFeld <= 2) {
        [self addBubbles:(CCTime)dt];
    }
    
     
        }
      
  //  }
 


    

    



 -(void)callBack
{
    
    
    
    
  
    
    
    
    
    
     if (!Collsion) {
     
         anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
     }
    
    
    NSLog(@" BUbble am BODEN !!!!!!!");
 
    
}
# pragma mark PlayerMovement

- (void)playerBewegung:(CCTime)dt


{
 
    
    if (gameStatus == gameisOn) {
         [motionManager startAccelerometerUpdates];
        // [player stopAllActions];
    CMAccelerometerData *acceleration = motionManager.accelerometerData;
  
playerRichtungX = acceleration.acceleration.x*7;

        
       // int position = player.position.x;
      //  int target = player.position.x + playerRichtungX;
      //  id act1 = [CCActionTween actionWithDuration:2 key:@"move" from:position to:target];
        
        //[player runAction:act1];
        
       
       // int neigung = acceleration.acceleration.x;
        
       
    float     targetX   = player.position.x + playerRichtungX ;
    float    targetY   = player.position.y;
 
        
    
    if (player.position.x + playerRichtungX < player.contentSize.width/2 ) {
        player.position = CGPointMake(player.contentSize.width/2, player.position.y);
        [scoreLabel setPosition:player.position];
        [shield setPosition:player.position];

    }
    
    else if (player.position.x + playerRichtungX > self.contentSize.width- player.contentSize.width/2)
    {
        player.position = CGPointMake(self.contentSize.width- player.contentSize.width/2, player.position.y);
        [scoreLabel setPosition:player.position];
        [shield setPosition:player.position];


        
    }
    else
    {
        
         
         
     player.position = CGPointMake(targetX, targetY);
        [scoreLabel setPosition:player.position];
        [shield setPosition:player.position];


        
     }
    
    
    }
    
    
 
 }


-(void) labelAfter
{
    
    
    labelBlink = NO;
    [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];

    
}
 -(void)labelRemoving
{
    
    labelBlink = YES;
    
    [scoreLabel setString:[NSString stringWithFormat:@""]];

}
-(void)playerBlink
{
    gameStatus = gamePaused;

     CCActionCallFunc *callBefore = [CCActionCallFunc actionWithTarget:self selector:@selector(labelRemoving)];
    CCActionCallFunc *callAfter = [CCActionCallFunc actionWithTarget:self selector:@selector(labelAfter)];

    
     CCAction *scaledown = [CCActionScaleBy actionWithDuration:2 scale:0.1];
    
     CCAction *scaleUp = [CCActionScaleBy actionWithDuration:2 scale:10.0];
    
   // CCAction *scaleNormal = [CCActionScaleBy actionWithDuration:2 scale:0.5];
    
    [player runAction:[CCActionSequence actionWithArray:@[ callBefore,scaledown, scaleUp,   callAfter]]];
     [audio playEffect:@"Ready To Burst-SoundBible.com-1103504176.mp3"];
    [audio playEffect:@"Blow Up Balloon-SoundBible.com-1407502310.mp3"];

    if (shieldActive) {
        
        [shield removeFromParent];
        [shieldBG removeFromParent];
        [shieldTimeLabel removeFromParent];
        
        
        shieldActive = NO;
    }
    [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-50-Prozent.png"]];

  
    scoreBubbles = 0;
    gameStatus = gameisOn;

 }

-(void)bubblesSound
{
    
    
    
    
 
     // Sound effect spielen
    [audio playEffect:@"Blop-Mark_DiAngelo-79054334.mp3"];
	
}
// -----------------------------------------------------------------------

#pragma mark Collision


#pragma mark Bubbles_Pointer
 - (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleCollision:(CCNode *)bubbles_1Node   playerCollision:(CCNode *)player2{
     
     if (labelBlink) {
         [bubbles_1Node removeFromParent];
         anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

         
         return YES;
         
         
     }
     Collsion = YES;
     
     [bubbles_1Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
 
      
   
     
 
     
     
     if (scoreBubbles + 1 > 100 && !liveActive) {
         gameStatus = gamePaused;

         
         highScoreEnd  = highScore;
         [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         // back to intro scene with transition
         
         
         [self takeScreenShot];
         [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                    withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
       
     }
     if (scoreBubbles +1 > 100 && liveActive) {
         liveActive = NO;
         [xtraLive removeFromParent];
         
         
     }
    else if (scoreBubbles +1 == 100) {
        scoreBubbles = scoreBubbles+ 1;
        highScore = highScore +1;
          [self playerBlink];
     }
     
     else if (scoreBubbles +1 < 100)
         
     {
         
         scoreBubbles = scoreBubbles+ 1;
         highScore = highScore +1;
         
         [self playerOpacity];
         
         
     }
     
     // Hier Neue Blase erschaffen und spiel fortsetzen
    // for (float i; i>= 0.1; i--) {
      //   [ player setScale:i];
     //}
     
     
     if (!labelBlink) {
    
     [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];
   
     [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
  }
     //   NSLog(@"anzahl auf dem feld3: %d", anzahlBubblesAufDemFeld);
   // bubbles.position =ccp(bubbles.position.x+ bubbles.contentSize.width, bubbles.position.y);
    
     
     
     [self bubblesSound];
       return YES;
    
    
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubble2Collision:(CCNode *)bubbles_2Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        [bubbles_2Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

        return YES;
        
        
    }
     Collsion = YES;
    
    
    [bubbles_2Node removeFromParent];
      anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    
    
   
 
    if (scoreBubbles+2 > 100 && !liveActive) {
        gameStatus = gamePaused;

        highScoreEnd  = highScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self takeScreenShot];

        // back to intro scene with transition
        [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];    }
    
    if (scoreBubbles+2 > 100 && liveActive) {
        liveActive = NO;
        [xtraLive removeFromParent];
    }
    // Hier Neue Blase erschaffen und spiel fortsetzen
   else if (scoreBubbles+2 == 100) {
       scoreBubbles = scoreBubbles+ 2;
       highScore = highScore + 2;

        [self playerBlink];
    }
    
    else if (scoreBubbles +2 < 100)
    {
        
        scoreBubbles = scoreBubbles+ 2;
        highScore = highScore +2;
         [self playerOpacity];
    }
    
    //for (float i; i>= 0.1; i--) {
    //    [ player setScale:i];
   // }
         if (!labelBlink) {
    [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];
       
    [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
  }
    //NSLog(@"anzahl auf dem feld3: %d", anzahlBubblesAufDemFeld);
    // bubbles.position =ccp(bubbles.position.x+ bubbles.contentSize.width, bubbles.position.y);
    
    return YES;
    
    
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubble7Collision:(CCNode *)bubbles_7Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        [bubbles_7Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        return YES;
        
        
    }
    
     Collsion = YES;
    
    [bubbles_7Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    
   

 
    if (scoreBubbles+7 > 100&& ! liveActive) {
        gameStatus = gamePaused;

        highScoreEnd  = highScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self takeScreenShot];

        // back to intro scene with transition
        [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
    }
    
    
    if (scoreBubbles+7>100 &&  liveActive) {
        liveActive =NO;
        [xtraLive removeFromParent];
    }
    
    // Hier Neue Blase erschaffen und spiel fortsetzen
    else if (scoreBubbles+7 == 100) {
        scoreBubbles = scoreBubbles+ 7;
        highScore = highScore +7;

        [self playerBlink];
    }
   
    else if (scoreBubbles + 7 < 100)
    {
    scoreBubbles = scoreBubbles+ 7;
    highScore = highScore +7;
         [self playerOpacity];
    }
    
         if (!labelBlink) {
    [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];
         
    [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
         }
    // NSLog(@"anzahl auf dem feld3: %d", anzahlBubblesAufDemFeld);
    // bubbles.position =ccp(bubbles.position.x+ bubbles.contentSize.width, bubbles.position.y);
    
    return YES;
    
    
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubble5Collision:(CCNode *)bubbles_5Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        
        [bubbles_5Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        

        return YES;
        
        
    }
     Collsion = YES;
    
    
    [bubbles_5Node removeFromParent];
       anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    
    


    
    if (scoreBubbles+5 > 100 && ! liveActive) {
        gameStatus = gamePaused;

        highScoreEnd  = highScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self takeScreenShot];

        // back to intro scene with transition
        [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
    }
    
    if (scoreBubbles+5 > 100 && liveActive) {
        liveActive = NO;
        [xtraLive removeFromParent];
    }
 
    
    // Hier Neue Blase erschaffen und spiel fortsetzen
    
    else if (scoreBubbles+5 == 100) {
        [self playerBlink];
        scoreBubbles = scoreBubbles+ 5;
        highScore = highScore +5;

    }
    
    else if (scoreBubbles+5 < 100)
    {
        
        scoreBubbles = scoreBubbles+ 5;
        highScore = highScore +5;
         [self playerOpacity];
        
        
    }
         if (!labelBlink) {
    [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];
         
    [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
         }
    // NSLog(@"anzahl auf dem feld3: %d", anzahlBubblesAufDemFeld);
    // bubbles.position =ccp(bubbles.position.x+ bubbles.contentSize.width, bubbles.position.y);
    
    return YES;
    
    
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubble10Collision:(CCNode *)bubbles_10Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        [bubbles_10Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

        return YES;
        
        
    }
    
     Collsion = YES;
    
    [bubbles_10Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    
    
   
     if (scoreBubbles+10 > 100 && !liveActive) {
         gameStatus = gamePaused;

         [self takeScreenShot];

         highScoreEnd  = highScore;
         [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        
        // back to intro scene with transition
         [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                    withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
    }
    
    if (scoreBubbles+10 > 100 && liveActive) {
        liveActive = NO;
        [xtraLive removeFromParent];
        
    }
    
    // Hier Neue Blase erschaffen und spiel fortsetzen
   else if (scoreBubbles+10 == 100) {
        [self playerBlink];
       scoreBubbles = scoreBubbles+ 10;
       highScore = highScore +10;

    }
    else if (scoreBubbles+10 < 100)
    {
        
        scoreBubbles = scoreBubbles+ 10;
        highScore = highScore +10;
         [self playerOpacity];

        
    }
    
         if (!labelBlink) {
    [scoreLabel setString:[NSString stringWithFormat:@"%d/100", scoreBubbles]];
       
    [highScoreLabel setString:[NSString stringWithFormat:@"%d", highScore]];
  }
   // NSLog(@"anzahl auf dem feld3: %d", anzahlBubblesAufDemFeld);
    // bubbles.position =ccp(bubbles.position.x+ bubbles.contentSize.width, bubbles.position.y);
    
    return YES;
    
    
}
#pragma mark Bubbles_Timer
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleTimeDownCollision:(CCNode *)bubbles_Time_Down_Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        
        [bubbles_Time_Down_Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

        return YES;
        
        
    }
    
     Collsion = YES;
    
    [bubbles_Time_Down_Node removeFromParent];
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    if (percentage +5 == 100 && !liveActive) {
       
        [self takeScreenShot];

        [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
        highScoreEnd  = highScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        gameStatus = gamePaused;
    }
     if (percentage +5 == 100 && liveActive) {
     
         liveActive = NO;
         [xtraLive removeFromParent];
     
     }
    else if (percentage+ 5 >= 0)
    {
        percentage = percentage +5;
    }
    [_progressNode setPercentage: percentage];

        return YES;
    
    
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleTimeUpCollision:(CCNode *)bubbles_Time_Up_Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink) {
        
        [bubbles_Time_Up_Node removeFromParent];
        anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld -1;
        

        
        return YES;
        
        
    }
     Collsion = YES;
    
    
    [bubbles_Time_Up_Node removeFromParent];
     anzahlBubblesAufDemFeld = anzahlBubblesAufDemFeld -1;
    if (percentage -5 < 0) {
        percentage = 0;
    }
    else if (percentage- 5 >= 0)
    {
    percentage = percentage -5;
    }
        [_progressNode setPercentage: percentage];

    return YES;
    
    
}
#pragma mark Bubbles_Bomb
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleBombCollision:(CCNode *)bubbles_bomb_Node   playerCollision:(CCNode *)player{
    [self bubblesSound];
    if (labelBlink) {
        [bubbles_bomb_Node removeFromParent];
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        
        return YES;
        
        
    }
     Collsion = YES;
    
    
    [bubbles_bomb_Node removeFromParent];
    
       anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    if (!shieldActive && !liveActive) {

        
        if (!labelBlink) {
            highScoreEnd  = highScore;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self takeScreenShot];

    gameStatus = gamePaused;
    
    
    
    [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f ]];
            
        }
    
    }
     if (shieldActive)
    
    {
        [shield removeFromParent];
        [shieldBG removeFromParent];
        [shieldTimeLabel removeFromParent];
        
        shieldActive = NO;
    }
    if (liveActive) {
        
        liveActive = NO;
        [xtraLive removeFromParent];
        
    }
    
    
    return YES;
    
    
}
#pragma mark Bubbles_Shield
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleShieldCollision:(CCNode *)bubbles_shield_Node   playerCollision:(CCNode *)player1{
     [self bubblesSound];
    if (labelBlink) {
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

        [bubbles_shield_Node removeFromParent];
 
        return YES;
        
        
    }
     Collsion = YES;
    
    anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;

    [bubbles_shield_Node removeFromParent];
     if (!shieldActive) {
        
        shieldTime = 11;
    
    shieldActive = YES;
    shield = [CCSprite spriteWithImageNamed:@"shield.png"];
    shield.position = player1.position;
     [self addChild:shield];
        
        
         shieldBG = [CCSprite spriteWithImageNamed:@"shield.png"];
        shieldBG.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/1.5);
        shieldBG.scale = 2.0f;
        shieldBG.opacity = 1;
        [self addChild:shieldBG];
        
        shieldTimeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:  @"%d",shieldTime] fontName:@"Helvetica-Neue-UltraLight" fontSize:30.0f];
        shieldTimeLabel.position= shieldBG.position;
        shieldTimeLabel.color = [CCColor colorWithUIColor:[UIColor redColor]];
        [self addChild:shieldTimeLabel];
       
       
    CCAction *rotate = [CCActionRotateBy actionWithDuration:20 angle:360];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rotate]];
    CCAction *repeat = [CCActionRepeatForever actionWithAction:seq];
        [shield runAction:repeat];
        
        
        [shieldBG setOpacity:1.0];
        CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1];
        CCAction *fadeOut = [CCActionFadeOut actionWithDuration:1];
        
        CCActionSequence *pulseSequence = [CCActionSequence actionWithArray:@[fadeIn, fadeOut]];
        CCAction *repeater = [CCActionRepeatForever actionWithAction:pulseSequence];
       
        
        
        [shieldBG runAction:repeater];
        
        
        [shieldTimeLabel setOpacity:1.0];
        CCAction *fadeIn2 = [CCActionFadeIn actionWithDuration:1];
        CCAction *fadeOut2 = [CCActionFadeOut actionWithDuration:1];
         CCActionCallFunc *callTime = [CCActionCallFunc actionWithTarget:self selector:@selector(shieldTimer)];

        
        
        CCActionSequence *pulseSequence2 = [CCActionSequence actionWithArray:@[callTime,fadeIn2 ,fadeOut2]];
        CCAction *repeater2 = [CCActionRepeatForever actionWithAction:pulseSequence2];
        
        
        [shieldTimeLabel runAction:repeater2];
    //[shieldBG runAction:repeat1];

    }
    
    else if (shieldActive)
    {
         [bubbles_shield_Node removeFromParent];
         shieldTime = 11;
        
    }
     return YES;
    
    

    
    
}

-(void)shieldTimer
{
    
    
    
    if (shieldActive) {
        shieldTime --;
        [shieldTimeLabel setString:[NSString stringWithFormat:@"%d", shieldTime]];
        
        if (shieldTime == 0) {
            shieldActive = NO;
            [shield removeFromParent];
            [shieldBG removeFromParent];
            [shieldTimeLabel removeFromParent];
            
        }
        
        
        
    }

}
#pragma mark Bubbles_Faster
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleFasterCollision:(CCNode *)bubbles_faster_Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
     if (labelBlink || fasterActive) {
        [bubbles_faster_Node removeFromParent];
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        
        return YES;
        
        
    }
    
    if (!fasterActive && !slowerActive) {
  
    Collsion = YES;
    
    
    [bubbles_faster_Node removeFromParent];
    
    anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
    
    
    
   /*
    CCActionCallFunc *callTime = [CCActionCallFunc actionWithTarget:self selector:@selector(fasterTimer)];
    CCActionSequence *pulseSequence2 = [CCActionSequence actionWithArray:@[callTime ]];
    CCAction *repeater2 = [CCActionRepeatForever actionWithAction:pulseSequence2];
    
    
    [sprite runAction:repeater2];
    */
    [self schedule:@selector(fasterTimer) interval:1 repeat:6 delay:0.01];

    
    fasterTime = 6;
    fasterActive = YES;
        return YES;
    }
    if (slowerActive) {
        
        [bubbles_faster_Node removeFromParent];

        physicsWorld.gravity = ccp(0, 0);
        slowerActive = NO;
        return YES;

    }
    return YES;
    
    
}
#pragma mark Bubbles_Slower
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleSlowerCollision:(CCNode *)bubbles_slower_Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink || slowerActive) {
        [bubbles_slower_Node removeFromParent];
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        
        return YES;
        
        
    }
    
    if (!slowerActive && !fasterActive) {
        
        Collsion = YES;
        
        
        [bubbles_slower_Node removeFromParent];
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        
        
        
        /*
         CCActionCallFunc *callTime = [CCActionCallFunc actionWithTarget:self selector:@selector(fasterTimer)];
         CCActionSequence *pulseSequence2 = [CCActionSequence actionWithArray:@[callTime ]];
         CCAction *repeater2 = [CCActionRepeatForever actionWithAction:pulseSequence2];
         
         
         [sprite runAction:repeater2];
         */
        [self schedule:@selector(slowerTimer) interval:1 repeat:6 delay:0.01];
        
        
        slowerTime = 4;
        slowerActive = YES;
        return YES;
    }
    
    if (fasterActive) {
        
        [bubbles_slower_Node removeFromParent];

        physicsWorld.gravity = ccp(0,  0);
        fasterActive = NO;
        return YES;
        
    }
    
    return YES;
    
    
}
#pragma mark Bubbles_xtraLife
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bubbleLifeCollision:(CCNode *)bubbles_life_Node   playerCollision:(CCNode *)player{
     [self bubblesSound];
    if (labelBlink || liveActive) {
        [bubbles_life_Node removeFromParent];
        
        anzahlBubblesAufDemFeld= anzahlBubblesAufDemFeld -1;
        
        return YES;
        
        
    }
    
    if (!liveActive) {
        
 
        liveActive = YES;
        
        xtraLive =  [CCSprite spriteWithImageNamed:@"xtra-newlife.png" ];
        xtraLive.positionType = CCPositionTypeNormalized;
        xtraLive.position  = ccp(0.5, 0.95);
        xtraLive.scale = 2;
     
        
        
       
        [self addChild:xtraLive];
        
        
        [bubbles_life_Node removeFromParent];

        
        
        
        
        return YES;
    }
    
    [bubbles_life_Node removeFromParent];

    
    return YES;
    
    
}

-(void)slowerTimer
{
   if (slowerActive) {
       
//
 
         CCNode *myNode;
        
         NSArray *childrenArray = [self children];
        
        for( myNode in childrenArray)
        {
        
        
   
 
            myNode.paused = YES;
        
            
        }
       
       
       physicsWorld.gravity = ccp(0, 20);
                slowerTime--;
        
       


        if (slowerTime== 0) {
            
            
            NSLog(@"Slower TIme ist um !!!");
            
            slowerActive = NO;
            physicsWorld.gravity = ccp(0, 0);

            for( myNode in childrenArray)
            {
                
                
                
                
                myNode.paused = NO;
                
                
            }
   
           
        }
   }
    }


-(void)fasterTimer
{
    if (fasterActive) {
  
    fasterTime--;
    physicsWorld.gravity = ccp(0, -300);

    
    if (fasterTime== 0) {
        
        physicsWorld.gravity = ccp(0, 0);

        fasterActive = NO;
        
    }
        
    }
    /*NSLog(@"faster !!!");
    
    if (fasterActive) {
  
    fasterTime --;
    physicsWorld.gravity = ccp(0, -500);

    if (fasterTime == 0) {
        physicsWorld.gravity = ccp(0, 0);
        fasterActive = NO;
        
        
    }
    
    
        
    }
    
    */
    
}

// -----------------------------------------------------------------------



- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------


-(void)playerOpacity
{
    
    if (scoreBubbles <=17) {
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-50-Prozent.png"]];

    }
    else if (scoreBubbles <= 34 && scoreBubbles> 17) {
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-60-Prozent.png"]];

    }
    else if (scoreBubbles <= 51&& scoreBubbles > 34)
    {
        
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-70-Prozent.png"]];

    }
    else if (scoreBubbles <= 68&& scoreBubbles > 51)
    {
        
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-80-Prozent.png"]];

    }
    else if (scoreBubbles <= 85 &&scoreBubbles > 68)
        
    {
        
        
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-90-Prozent.png"]];

    }
    else if (scoreBubbles <= 100 && scoreBubbles > 85)
        
    {
        
        
        [ player setTexture:[CCTexture textureWithFile: @"faenger-Bobble-100-Prozent.png"]];
        
    }
    
    
    
}

#pragma mark Screenshot
    -(UIImage*) takeScreenShot
    {
        
        
        [CCDirector sharedDirector].nextDeltaTimeZero = YES;
        CGSize winSize = [CCDirector sharedDirector].viewSize;
        
  CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
        
        [rtx begin];
        [background visit];
        [[[CCDirector sharedDirector] runningScene] visit];
        [rtx end];
        
        
         UIImage *img = [rtx getUIImage];
        
       
        
      //   UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        //NSData * data = UIImagePNGRepresentation(img);

        //NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"testImage.png"];
        //NSLog(@"Path for Image : %@",imagePath);
        //[data writeToFile:imagePath atomically:YES];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(img)forKey:@"Screenshot"];

                 [[NSUserDefaults standardUserDefaults] synchronize];
        return img;
    }


#pragma mark Timer
-(void)ticker:(CCTime)dt
{
    if (gameStatus == gameisOn) {
        
        [pauseSprite setTexture:[CCTexture textureWithFile:@"pause-icon-inactive.png"]];
        
        [playSprite setTexture:[CCTexture textureWithFile:@"play-icon-active.png"]];
        

       
       //  percentage= percentage +10;
        
      //  [self progressBarTimer];
       timeInSec +=dt;
        
      
           sec = timeInSec;
        
        
         // NSLog(@"time in sec %d", sec);
        
        percentage = percentage + 1;
        [_progressNode setPercentage: percentage];
        
        
        
        
        if (percentage == 100 && ! liveActive)
        {
            [self takeScreenShot];
            highScoreEnd  = highScore;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
             gameStatus = gamePaused;
            NSLog(@"time is over ");
            
            
            
            [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f ]];
            
        }
        else if (percentage == 100 && liveActive)
        {
            liveActive = NO;
            [xtraLive removeFromParent];
            
        }
        
       // [timeLabel setString:[NSString stringWithFormat:@"%.2d " ,sec]];
       
        NSLog(@"percentage %d", percentage);
        
        
    }
}




#pragma mark - Enter & Exit

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
   
  
    
    
  
    [self schedule:@selector(playerBewegung:) interval:0.01];
    [self schedule:@selector(addBubbles:) interval:1];
    [self schedule:@selector(ticker:) interval:1];
 

 

 
     timeInSec = 0.0f;
     // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------






#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}
-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event

{
    
    [[CCDirector sharedDirector] resume];

    
    
        touchLoc = [touch locationInNode:self ];
        //CGPoint target =  CGPointMake(touchLoc.x, touchLoc.y) ;
        
        // CGPoint location = [touch locationInView: [touch view]];
        
        //location = [[CCDirector sharedDirector] convertToGL:location];
        NSLog(@"Touch !!!");
        
        if(CGRectContainsPoint([pauseSprite boundingBox], touchLoc) ){
            
    
                
                
                [pauseSprite setTexture:[CCTexture textureWithFile:@"pause-icon-active.png"]];
                
                [playSprite setTexture:[CCTexture textureWithFile:@"play-icon-inactive.png"]];
              [[CCDirector sharedDirector] pause];
                
                
         
            
           

    
}
     if(CGRectContainsPoint([playSprite boundingBox], touchLoc) ){
        
      
        
            [pauseSprite setTexture:[CCTexture textureWithFile:@"pause-icon-inactive.png"]];
            
            [playSprite setTexture:[CCTexture textureWithFile:@"play-icon-active.png"]];
    [[CCDirector sharedDirector] resume];
         
         

    }
    
    
    
}
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender


{
    gameStatus = gameisOn;
    
    [self takeScreenShot];

    highScoreEnd  = highScore;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highScoreEnd] forKey:@"HighScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
 
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[LoseMenuScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f  ]];
    gameStatus = gamePaused;
}

// -----------------------------------------------------------------------
@end
