//
//  PlayingCardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "PlayingCardMatchingGameHistoryItemStatusMessageGenerator.h"

@interface PlayingCardMatchingGameViewController ()

@end

@implementation PlayingCardMatchingGameViewController


- (Class)statusMessageGeneratorClass
{
    return [PlayingCardMatchingGameHistoryItemStatusMessageGenerator class];
}

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

// Implement Abstract Methods
- (void)updateUIForCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)performSegueToHistory:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"showPlayingCardHistory" sender:sender];
}


@end
