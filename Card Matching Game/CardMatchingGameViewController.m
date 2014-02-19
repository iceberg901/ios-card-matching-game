//
//  CardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardMatchingGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardsToMatchSegment;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation CardMatchingGameViewController

- (IBAction)touchCardButton:(UIButton *)sender {
    NSLog(@"Are we doing this a million times?");
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    // if we flipped a card over, we should no longer be able to switch
    // the card matching mode
    self.cardsToMatchSegment.enabled = NO;
}

- (void)updateUI
{
    for (int i = 0; i < [self.cardButtons count]; i++) {
        Card *card = [self.game cardAtIndex:i];
        UIButton *cardButton = self.cardButtons[i];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.text = [self statusMessage];
}

- (NSString *)titleForCard:(Card *) card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

- (NSString *)statusMessage
{
    if (self.game.lastResult != CardMatchingGameResultOther) {
        return [NSString stringWithFormat:@"%@ %@", [self statusMessageForChosenCards], [self statusMesageForScoreDelta]];
    } else {
        return self.statusMessageForChosenCards;
    }
}

- (NSString *)statusMessageForChosenCards
{
    NSString *message = @"";

    NSLog(@"Constructing: %@", [self.game getLastConsideredCards]);

    for (Card *card in [self.game getLastConsideredCards]) {
        message = [message stringByAppendingString:card.contents];
    }

    return message;
}

- (NSString *)statusMesageForScoreDelta
{
    NSInteger lastScoreDelta = self.game.lastScoreDelta;
    if (lastScoreDelta > 0) {
        return [NSString stringWithFormat:@"matched for %d points", lastScoreDelta];
    } else if (lastScoreDelta < 0) {
        return [NSString stringWithFormat:@"don't match! %d point penalty!", -lastScoreDelta];
    } else {
        return @"";
    }
}

- (IBAction)newGameButton:(id)sender {
    self.game = [self createGame];
    // in case they don't touch the card match count segment control at all,
    // update the game's cardsToMatch value to whatever the control has selected
    // now
    [self updateCardsToMatchSegment:nil];
    // re enable the card match count segment control until the user starts playing the
    // new game
    self.cardsToMatchSegment.enabled = YES;
    [self updateUI];
}

static NSUInteger SEGMENT_VALUES[2] = {2,3};

- (IBAction)updateCardsToMatchSegment:(UISegmentedControl *)sender {
    NSUInteger segmentValue = SEGMENT_VALUES[[self.cardsToMatchSegment selectedSegmentIndex]];
    self.game.cardsToMatch = segmentValue;
    NSLog(@"Game's cardsToMatch set to %u", self.game.cardsToMatch);
}

- (CardMatchingGame *)createGame
{
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:self.createDeck];
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [self createGame];
    return _game;
}

@end
