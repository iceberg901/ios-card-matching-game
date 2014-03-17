//
//  CardMatchingGameViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameViewController.h"
#import "CardView.h"
#import "Grid.h"
#import "RandomUtils.h"

@interface CardMatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreCardsButton;
@property (strong, nonatomic) UIDynamicAnimator *stackUpAnimator;
@property (nonatomic) CGPoint stackUpAnchorPoint;
@property (nonatomic) BOOL cardsStacked;
@property (strong, nonatomic) NSArray *attachmentBehaviors;
@property (strong, nonatomic) UIPanGestureRecognizer *cardPanGestureRecognizer;
@end

@implementation CardMatchingGameViewController

#pragma mark - Getters and setters

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
    }

    return _grid;
}

- (UIDynamicAnimator *)stackUpAnimator
{
    if (!_stackUpAnimator) {
        _stackUpAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardContainerView];
    }
    return _stackUpAnimator;
}

- (NSArray *)attachmentBehaviors
{
    if (!_attachmentBehaviors) {
        _attachmentBehaviors = [[NSArray alloc] init];
    }
    return _attachmentBehaviors;
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

- (UIPanGestureRecognizer *)cardPanGestureRecognizer
{
    if (!_cardPanGestureRecognizer){
        _cardPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCardViewPanned:)];
    }

    return _cardPanGestureRecognizer;
}

#pragma mark - Card game model management
- (CardMatchingGame *)createGame
{
    return [[CardMatchingGame alloc] initWithCardCount:self.maxCardsOnTable usingDeck:self.createDeck];
}

#pragma mark - UI Updates

- (void)updateAllUI
{
    NSLog(@"Update ALL UI Happening");
    [self updateCardViewContentsThenUpdateOtherUI:YES];
}

- (void)updateOtherUI
{
    NSLog(@"Updating other UI");
    [self updateCardLayout];
    [self updateScoreLabel];
    self.moreCardsButton.enabled = (self.game.numCardsInDeck > 0);
}

- (void)updateScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateCardLayout
{
    [self updateCardLayout:NO];
}

- (void)updateCardLayout:(BOOL)withoutAnimation
{
    void (^animations)(void) = ^{
        if (self.cardsStacked) {
            // if the card stack anchor point has wandered outside the bounds of its parent view, move it back inside
            [self ensureStackAnchorPointInsideCardContentsView];
            // if the cards have been stacked, they should all be located on top of
            // a specified anchor point
            for (NSUInteger cardIndex = 0; cardIndex < self.game.numCardsOnTable; cardIndex++) {
                Card *card = [self.game cardAtIndex:cardIndex];
                CardView *cardView = self.cardViews[cardIndex];
                if (!card.isMatched) {
                    cardView.frame = CGRectMake(cardView.frame.origin.x, cardView.frame.origin.y, self.grid.cellSize.width, self.grid.cellSize.height);
                    cardView.center = self.stackUpAnchorPoint;
                }
            }
        } else {
            // if the cards aren't stacked, place them in a grid that uses up as much
            // space on the screen as possible while still being able to fit all the cards
            NSUInteger cardIndex = 0;
            for (NSUInteger row = 0; row < self.grid.rowCount; row++) {
                for (NSUInteger col = 0; col < self.grid.columnCount; col++) {
                    Card *card;
                    CardView *cardView;
                    do {
                        card = [self.game cardAtIndex:cardIndex];
                        cardView = self.cardViews[cardIndex];
                        cardIndex++;
                    } while ((!card || card.isMatched) && cardIndex <= [self.cardViews count] - 1);
                    if (card.isMatched) {
                        NSLog(@"Uh oh, modifying a matched card!");
                    }
                    cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                    if (cardIndex > [self.cardViews count] - 1) {
                        goto loop_finished;
                    }
                }
            }
        loop_finished:;
        }
    };

    if (!withoutAnimation) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];
    } else {
        animations();
    }
}
- (void)ensureStackAnchorPointInsideCardContentsView
{
    BOOL hadToSnapBack = NO;

    CGFloat xMinDiff = self.stackUpAnchorPoint.x - (self.grid.cellSize.width / 2.0);
    if (xMinDiff < 0.0) {
        self.stackUpAnchorPoint = CGPointMake(self.stackUpAnchorPoint.x - xMinDiff, self.stackUpAnchorPoint.y);
        hadToSnapBack = YES;
    } else {
        CGFloat xMaxDiff = (self.stackUpAnchorPoint.x + (self.grid.cellSize.width / 2.0)) - CGRectGetWidth(self.cardContainerView.bounds);
        if (xMaxDiff > 0.0) {
            self.stackUpAnchorPoint = CGPointMake(self.stackUpAnchorPoint.x - xMaxDiff, self.stackUpAnchorPoint.y);
            hadToSnapBack = YES;
        }
    }

    CGFloat yMinDiff = self.stackUpAnchorPoint.y - (self.grid.cellSize.height / 2.0);
    if (yMinDiff < 0.0) {
        self.stackUpAnchorPoint = CGPointMake(self.stackUpAnchorPoint.x, self.stackUpAnchorPoint.y - yMinDiff);
        hadToSnapBack = YES;
    } else {
        CGFloat yMaxDiff = (self.stackUpAnchorPoint.y + (self.grid.cellSize.height / 2.0)) - CGRectGetHeight(self.cardContainerView.bounds);
        if (yMaxDiff > 0.0) {
                    self.stackUpAnchorPoint = CGPointMake(self.stackUpAnchorPoint.x, self.stackUpAnchorPoint.y - yMaxDiff);
            hadToSnapBack = YES;
        }
    }

    // if we had to snap back to the edge of the contents view, cancel
    // the any current pan gesture so that the user has to reestablish the pan
    // to keep moving the card
    if (hadToSnapBack) {
        self.cardPanGestureRecognizer.enabled = NO;
        self.cardPanGestureRecognizer.enabled = YES;
    }
}

- (void)updateCardViewContentsThenUpdateOtherUI:(BOOL)doUpdateOtherUI
{
    NSLog(@"Updating card view contents");
    NSTimeInterval timeUntilCustomActionsComplete = 0.0;

    for (NSUInteger cardIndex = 0; cardIndex < self.game.numCardsOnTable; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        CardView *cardView = self.cardViews[cardIndex];
        NSTimeInterval waitTime = [self performCustomActionsOnCardView:cardView forCard:card];
        // if the card was matched a result of the update, then animate it off the screen
        if (card.isMatched && CGRectContainsRect([self.cardContainerView bounds], [cardView frame]))
        {
            [self animateCardViewOffTable:cardView delay:waitTime];
        }
        if (waitTime > timeUntilCustomActionsComplete) {
            timeUntilCustomActionsComplete = waitTime;
        }
    }

    if (doUpdateOtherUI) {
        [self performSelector:@selector(updateOtherUI) withObject:nil afterDelay:timeUntilCustomActionsComplete];
    }
}

- (void)updateGridInputs
{
    self.grid.size = self.cardContainerView.bounds.size;
    self.grid.cellAspectRatio = 40.0 / 60.0;
    self.grid.minimumNumberOfCells = self.game.numCardsOnTable;
}

# pragma mark - Card view management

- (void)rebuildCardViewsArray
{
    for (CardView *cardView in self.cardViews) {
        [cardView removeFromSuperview];
    }
    [self.cardViews removeAllObjects];
    for (int i = 0; i < self.maxCardsOnTable; i++) {
        [self createCardViewAndAddToCardContainer];
    }
}

- (void)createCardViewAndAddToCardContainer
{
    CardView *cardView = [self createCardView];
    cardView.frame = CGRectMake(0.0, 0.0, self.grid.cellSize.width, self.grid.cellSize.height);
    cardView.center = [self generateRandomCenterPointOutsideRect:[self.cardContainerView frame] ForRect:[cardView frame]];
    [self.cardViews addObject:cardView];
    [self.cardContainerView addSubview:cardView];
    [cardView addTarget:self action:@selector(cardTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createCardViewsAndUpdateAllUI
{
    [self rebuildCardViewsArray];
    [self updateAllUI];
}

#pragma mark - Static card animations

- (NSTimeInterval)animateCardViewOffTable:(CardView *)cardView delay:(NSTimeInterval)waitTime
{
    NSTimeInterval animationDuration = 2.0;

    [UIView animateWithDuration:animationDuration delay:waitTime options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint newCenter = [self generateRandomCenterPointOutsideRect:[self.cardContainerView frame] ForRect:[cardView frame]];
                         cardView.center = newCenter;
                     }
                     completion:^(BOOL finished){
                         [cardView removeFromSuperview];
                     }
     ];

    return animationDuration + waitTime;
}

- (CGPoint)generateRandomCenterPointOutsideRect:(CGRect)boundaryRect ForRect:(CGRect)innerRect
{
    CGFloat destinationX = 0.0;
    CGFloat destinationY = 0.0;
    NSUInteger direction = arc4random() % 4;

    CGRect cardContainerBounds = [self.cardContainerView bounds];
    switch (direction) {
        case 0:
            destinationX = randomFloatBetween(innerRect.size.width / 2.0, cardContainerBounds.size.width - (innerRect.size.width / 2.0));
            destinationY = -(innerRect.size.height / 2.0);
            break;

        case 1:
            destinationX = boundaryRect.size.width + (innerRect.size.width / 2.0);
            destinationY = randomFloatBetween(innerRect.size.height / 2.0, cardContainerBounds.size.height - (innerRect.size.height / 2.0));
            break;

        case 2:
            destinationX = randomFloatBetween(innerRect.size.width / 2.0, cardContainerBounds.size.width - (innerRect.size.width / 2.0));
            destinationY = boundaryRect.size.height + (innerRect.size.height / 2.0);
            break;

        case 3:
            destinationX = -(innerRect.size.width / 2.0);
            destinationY = randomFloatBetween(innerRect.size.height / 2.0, cardContainerBounds.size.height - (innerRect.size.height / 2.0));
            break;

        default:
            NSLog(@"A direction case we hadn't thought of");
            break;
    }

    return CGPointMake(destinationX, destinationY);
}

#pragma mark - Actions

- (IBAction)newGameButtonTapped:(UIBarButtonItem *)sender {
    NSLog(@"Updating because new game button preseed");
    NSTimeInterval waitTime = 0.0;
    for (NSUInteger cardIndex = 0; cardIndex < self.game.numCardsOnTable; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        CardView *cardView = self.cardViews[cardIndex];
        if (!card.isMatched) {
            NSTimeInterval timeTillCompletion = [self animateCardViewOffTable:cardView delay:0.0];
            if (timeTillCompletion > waitTime) {
                waitTime = timeTillCompletion;
            }
        }
    }
    self.game = [self createGame];
    [self updateGridInputs];
    self.cardsStacked = NO;
    [self performSelector:@selector(createCardViewsAndUpdateAllUI) withObject:nil afterDelay:waitTime];
}

- (IBAction)moreCardsButtonTapped:(UIBarButtonItem *)sender {

    NSArray *newCards = [self.game drawCards:3];
    for (NSUInteger i = 0; i < [newCards count]; i++) {
        [self createCardViewAndAddToCardContainer];
    }
    [self updateGridInputs];
    self.cardsStacked = NO;
    [self updateAllUI];
}

- (IBAction)cardTouched:(CardView *)sender
{
    if (self.cardsStacked) {
        //if the cards are stacked, just unstack them so we can get back to playing the game
        self.cardsStacked = NO;
        // they're not pannable anymore so remove the pan gesture recognizer
        [[[self.cardContainerView subviews] lastObject] removeGestureRecognizer:self.cardPanGestureRecognizer];
        [self updateCardLayout];
    } else {
        //otherwise, choose the card that was tapped
        NSUInteger cardIndex = [self.cardViews indexOfObject:sender];
        [self.game chooseCardAtIndex:cardIndex];
        NSLog(@"Updating because of card touch");
        [self updateAllUI];
    }
}

#pragma mark - View lifecycle

// View Lifecycle Hooks
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"Updating because view did layout subviews");
    [self updateGridInputs];
    [self updateCardLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"Updating because view will appear");
    [self updateAllUI];
}

- (void)setup
{
    self.game = self.createGame;

    [self updateGridInputs];

    // Set up the button at the top of the NavigationView
    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game" style:UIBarButtonItemStylePlain target:self action:@selector(newGameButtonTapped:)];
    self.navigationItem.rightBarButtonItem = newGameButton;

    // Put a pinch gesture recognizer on the card container
    UIGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onCardContainerPinch:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];

    //create all the card views we need to show the cards in the game
    [self rebuildCardViewsArray];
}

#pragma mark - Gestures

- (void)onCardContainerPinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.stackUpAnchorPoint = [pinchGestureRecognizer locationInView:self.cardContainerView];
        // attach all unmatched cards to the anchor point
        NSMutableArray *attachmentBehaviors = [[NSMutableArray alloc] init];
        for (NSUInteger cardIndex = 0; cardIndex < self.game.numCardsOnTable; cardIndex++) {
            Card *card = [self.game cardAtIndex:cardIndex];
            if (!card.isMatched) {
                CardView *cardView = self.cardViews[cardIndex];
                UIAttachmentBehavior *cardAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:self.stackUpAnchorPoint];
                [self.stackUpAnimator addBehavior:cardAttachmentBehavior];
                [attachmentBehaviors addObject:cardAttachmentBehavior];
            }
        }
        self.attachmentBehaviors = attachmentBehaviors;
    } else if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged ||
        pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        for (UIAttachmentBehavior *behavior in self.attachmentBehaviors) {
            behavior.length = behavior.length * pinchGestureRecognizer.scale;
        }
        pinchGestureRecognizer.scale = 1.0;
    } else if (pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled || pinchGestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self removeAllAttachmentBehaviors];
        [self updateCardLayout];
    }

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.cardsStacked = YES;
        [self removeAllAttachmentBehaviors];
        // add a pan gesture recognizer to the top of the card stack so that it can be moved
        // around by the user
        [[[self.cardContainerView subviews] lastObject] addGestureRecognizer:self.cardPanGestureRecognizer];
        [self updateCardLayout];
    }
};

- (void)removeAllAttachmentBehaviors
{
    for (UIAttachmentBehavior *behavior in self.attachmentBehaviors) {
        [self.stackUpAnimator removeBehavior:behavior];
    }
    self.attachmentBehaviors = nil;
    [self updateCardLayout];
}

- (void)onCardViewPanned:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
        panGestureRecognizer.state == UIGestureRecognizerStateChanged ||
        panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panGestureRecognizer translationInView:self.cardContainerView];
        [panGestureRecognizer setTranslation:CGPointMake(0.0, 0.0) inView:self.cardContainerView];
        self.stackUpAnchorPoint = CGPointMake(self.stackUpAnchorPoint.x + translation.x, self.stackUpAnchorPoint.y + translation.y);
        [self updateCardLayout:YES];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateFailed ||
               panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self updateCardLayout:YES];
    }
}

#pragma mark - Abstract methods

- (CardView *)createCardView
{
    //SHOULD I ASSERT HERE?
    return nil;
}

- (NSTimeInterval)performCustomActionsOnCardView:(CardView *)cardView forCard:(Card *)card
{
    //SHOULD I ASSERT HERE
    return 0.0;
}

- (Deck *)createDeck
{
    //SHOULD I ASSERT HERE?
    return nil;
}
@end
