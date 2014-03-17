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
#import <UIKit/UIKit.h>

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
    [super setup];
}

- (CardView *)createCardView
{
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    return cardView;
}

- (NSTimeInterval)performCustomActionsOnCardView:(PlayingCardView *)cardView forCard:(PlayingCard *)card
{
    BOOL cardViewWillBeFaceUp = card.isChosen;

    void (^operations)(void) = ^{
        cardView.faceUp = cardViewWillBeFaceUp;
        cardView.enabled = !card.isMatched;
        cardView.rank = card.rank;
        cardView.suit = card.suit;
    };

    if (cardView.faceUp != cardViewWillBeFaceUp) {
        UIViewAnimationOptions transitionDirection = (cardViewWillBeFaceUp ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight);
        [UIView transitionWithView:cardView duration:0.5 options:transitionDirection animations:operations completion:nil];
        return 0.5;
    } else {
        operations();
        return 0.0;
    }
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
@end
