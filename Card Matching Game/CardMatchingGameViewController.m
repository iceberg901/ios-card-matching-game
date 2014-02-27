//
//  CardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "CardMatchingGameHistoryItemStatusMessageGenerator.h"
#import "CardMatchingGameHistoryViewController.h"

@interface CardMatchingGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation CardMatchingGameViewController

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (int i = 0; i < [self.cardButtons count]; i++) {
        [self updateUIForCardButton:self.cardButtons[i] withCard:[self.game cardAtIndex:i]];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.attributedText = [self statusMessageForHistoryItem:[self.game.history lastObject]];
}

- (NSAttributedString *)statusMessageForHistoryItem:(CardMatchingGameHistoryItem *)item
{
    return [[self messageGenerator] statusMessageForHistoryItem:item];
}

- (CardMatchingGame *)createGame
{
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:self.createDeck];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [self createGame];
    return _game;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPlayingCardHistory"] || [segue.identifier isEqualToString:@"showSetHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[CardMatchingGameHistoryViewController class]]) {
            CardMatchingGameHistoryViewController *vc = (CardMatchingGameHistoryViewController *)segue.destinationViewController;
            vc.game = self.game;
            vc.messageGenerator = [self messageGenerator];
        }
    }
}

- (IBAction)newGameButtonPressed:(UIBarButtonItem *)sender {
    self.game = [self createGame];
    [self updateUI];
}

- (IBAction)historyButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueToHistory:sender];
}

// View Lifecycle Hooks
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set up the buttons at the top of the NavigationView
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(historyButtonPressed:)];
    self.navigationItem.rightBarButtonItem = historyButton;

    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game" style:UIBarButtonItemStylePlain target:self action:@selector(newGameButtonPressed:)];
    self.navigationItem.leftBarButtonItem = newGameButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateUI];
}

// ABSTRACT METHODS
- (void)updateUIForCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    //SHOULD I ASSERT HERE?
}

- (CardMatchingGameHistoryItemStatusMessageGenerator *)messageGenerator{
    //SHOULD I ASSERT HERE?
    return nil;
}

- (void)performSegueToHistory:(UIBarButtonItem *)sender
{
    //SHOULD I ASSERT HERE?
}

- (Deck *)createDeck
{
    return nil;
}
@end
