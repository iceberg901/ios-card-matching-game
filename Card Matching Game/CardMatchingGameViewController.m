//
//  CardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "CardMatchingGameHistoryItemStatusMessageGenerator.h"
#import "CardView.h"
#import "Grid.h"

@interface CardMatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *grid;
@end

@implementation CardMatchingGameViewController

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
    }

    return _grid;
}

- (void)updateUI
{
    self.grid.size = self.cardContainerView.bounds.size;
    self.grid.cellAspectRatio = 40.0 / 60.0;
    self.grid.minimumNumberOfCells = self.game.numCardsOnTable;

//    [UIView animateWithDuration:2.0 animations:<#^(void)animations#>]
//    self.grid.cellSize;

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (CardMatchingGame *)createGame
{
    return [[CardMatchingGame alloc] initWithCardCount:self.maxCardsOnTable usingDeck:self.createDeck];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [self createGame];
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc] init];
    }

    return _cardViews;
}

- (IBAction)newGameButtonPressed:(UIBarButtonItem *)sender {
    self.game = [self createGame];
    [self updateUI];
}

// View Lifecycle Hooks
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];

    // Set up the button at the top of the NavigationView
    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game" style:UIBarButtonItemStylePlain target:self action:@selector(newGameButtonPressed:)];
    self.navigationItem.rightBarButtonItem = newGameButton;

    // Create the first game
    self.game = self.createGame;
    for (int i = 0; i < self.maxCardsOnTable; i++) {
        CardView *cardView = [self createCardViewForCard:[self.game cardAtIndex:i]];
        [self.cardViews addObject:cardView];
        [self.cardContainerView addSubview:cardView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateUI];
}

// ABSTRACT METHODS
- (void)setup
{
    //SHOULD I ASSERT HERE?
}

- (CardView *)createCardViewForCard:(Card *)card
{
    //SHOULD I ASSERT HERE?
    return nil;
}

- (Deck *)createDeck
{
    //SHOULD I ASSERT HERE?
    return nil;
}
@end
