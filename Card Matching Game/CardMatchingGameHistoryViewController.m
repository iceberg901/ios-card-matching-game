//
//  CardMatchingGameHistoryViewController.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameHistoryViewController.h"
#import "CardMatchingGameHistoryItem.h"

@interface CardMatchingGameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation CardMatchingGameHistoryViewController

- (void)updateUI
{
    NSMutableAttributedString *historyReport;

    if ([self.game.history count]) {

        historyReport = [[NSMutableAttributedString alloc] init];

        for (CardMatchingGameHistoryItem *item in self.game.history) {
            NSAttributedString *statusMessage = [self statusMessageForHistoryItem:item];
            if ([statusMessage length]) {
                [historyReport appendAttributedString:statusMessage];
                [historyReport appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
        }
    } else {
        historyReport = [[NSMutableAttributedString alloc] initWithString:@"No history yet"];
    }

    self.historyTextView.attributedText = historyReport;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

// Abstract Methods
- (NSAttributedString *)statusMessageForHistoryItem:(CardMatchingGameHistoryItem *)item
{
    return [self.messageGeneratorClass statusMessageForHistoryItem:item];
}

@end
