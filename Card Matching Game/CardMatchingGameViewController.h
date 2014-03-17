//
//  CardMatchingGameViewController.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@class CardView;

@interface CardMatchingGameViewController : UIViewController
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger maxCardsOnTable;
@property (strong, nonatomic) NSMutableArray *cardViews;

- (CardMatchingGame *)createGame;
- (void)setup;
@end
