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
#import "SetCardMatchingGameHistoryItemStatusMessageGenerator.h"

@interface SetMatchingGameViewController ()

@end

@implementation SetMatchingGameViewController

- (Class)statusMessageGeneratorClass
{
    return [SetCardMatchingGameHistoryItemStatusMessageGenerator class];
}

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

- (void)updateUIForCardButton:(UIButton *)cardButton withCard:(Card *)card
{

    SetCard *setCard = (SetCard *)card;
    [cardButton setAttributedTitle:[SetCardMatchingGameHistoryItemStatusMessageGenerator displayStringForCard:setCard] forState:UIControlStateNormal];

    //highlight for chosen cards
    if (card.isChosen && !card.isMatched) {
        cardButton.layer.borderColor = [[UIColor blackColor] CGColor];
        cardButton.layer.borderWidth = 1.5f;
    } else {
        cardButton.layer.borderWidth = 0.0f;
    }

    cardButton.enabled = !card.isMatched;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)performSegueToHistory:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"showSetHistory" sender:sender];
}

@end
