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
static const uint MAX_CARDS_ON_TABLE = 12;

// Implement Abstract Methods
- (void)setup
{
    self.maxCardsOnTable = MAX_CARDS_ON_TABLE;
    [super setup];
}

- (CardView *)createCardView
{
    SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 60.0)];
    return cardView;
}

- (NSTimeInterval)performCustomActionsOnCardView:(SetCardView *)cardView forCard:(SetCard *)card
{
    cardView.shape = card.shape;
    cardView.count = card.count;
    cardView.color = card.color;
    cardView.shading = card.shading;
    cardView.disabled = card.isChosen;

    return 0.0;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}
@end
