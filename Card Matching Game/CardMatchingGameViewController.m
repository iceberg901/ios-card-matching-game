//
//  CardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardMatchingGameViewController


- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flip Count: %d", self.flipCount];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([[sender currentTitle] length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        Card *nextCard = [self.deck drawRandomCard];
        if (nextCard) {
            // if there's still another card to show, show it
            [sender setBackgroundImage:[UIImage imageNamed:@"cardFront"]
                              forState:UIControlStateNormal];
            [sender setTitle:nextCard.contents forState:UIControlStateNormal];
        } else {
            // otherwise, do nothing and return immediately so the flip count doesn't change
            return;
        }
    }
    
    self.flipCount++;
}

- (Deck *)deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

@end
