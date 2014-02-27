//
//  PlayingCardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PLayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardMatchingGameViewController ()

@end

@implementation PlayingCardMatchingGameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSString *)titleForCard:(Card *) card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

static const uint MAX_CARDS_ON_TABLE = 30;

// Implement Abstract Methods
- (void)setup
{
    self.maxCardsOnTable = MAX_CARDS_ON_TABLE;
}

- (CardView *)createCardViewForCard:(Card *)card
{
    PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(100.0, 100.0, 40.0, 60.0)];
    PlayingCard *playingCard = (PlayingCard *)card;
    cardView.rank = playingCard.rank;
    cardView.suit = playingCard.suit;
    return cardView;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
@end
