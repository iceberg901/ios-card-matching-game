//
//  SetMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/20/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "SetMatchingGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetMatchingGameViewController ()

@end

@implementation SetMatchingGameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// Overrides
- (CardMatchingGame *)createGame
{
    CardMatchingGame *game = [super createGame];
    game.cardsToMatch = 3;
    return game;
}

//Implement abstract methods
- (CardView *)createCardViewForCard:(Card *)card
{
    SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 60.0)];
    return cardView;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}
@end
