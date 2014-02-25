//
//  SetCardMatchingGameHistoryItemStatusMessageGenerator.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "SetCardMatchingGameHistoryItemStatusMessageGenerator.h"

@implementation SetCardMatchingGameHistoryItemStatusMessageGenerator
+ (NSAttributedString *)statusMessageForChosenCards:(NSArray *)cards
{
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@""];

    for (SetCard *card in cards) {
        [message appendAttributedString:[SetCardMatchingGameHistoryItemStatusMessageGenerator displayStringForCard:card]];
        [message appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }

    return message;
}

+ (NSAttributedString *)displayStringForCard:(SetCard *)card
{
    NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] init];
    //Prepare the card color
    attributesDictionary[NSForegroundColorAttributeName] = [self getUIColorForSetCardColor:card.color];

    //Prepare the card shading (which is shading only in Set game terms, it's stroke in real iOS display terms)
    [self setCardContentsStrokeAttributes:attributesDictionary forCard:card];

    //Prepare the card's shape and number (ie shape repeated n times)
    NSString *cardContents = [@"" stringByPaddingToLength:card.count withString:card.shape startingAtIndex:0];

    //Set the font for displaying the contents on the card
    UIFont *cardFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    attributesDictionary[NSFontAttributeName] = [cardFont fontWithSize:8.0];

    //Finalize the card's contents with string and attributes we just built
    return [[NSAttributedString alloc] initWithString:cardContents attributes:attributesDictionary];
}

+ (void)setCardContentsStrokeAttributes:(NSMutableDictionary *)attributesDictionary forCard:(SetCard *)card
{
    //If we're going to be setting a stroke width on the card contents, we want it to be in the card's color
    attributesDictionary[NSStrokeColorAttributeName] = [self getUIColorForSetCardColor:card.color];

    //For "striped" look, we need to lighten the interior of the card contents
    if (card.shading == SetCardShadingStriped) {
        UIColor *cardColor = attributesDictionary[NSForegroundColorAttributeName];
        attributesDictionary[NSForegroundColorAttributeName] = [cardColor colorWithAlphaComponent:0.25];
    }

    //Finally set the card's stroke width to tie everything together
    switch (card.shading) {
        case SetCardShadingOpen:
            attributesDictionary[NSStrokeWidthAttributeName] = @5;
            break;

        case SetCardShadingSolid:
        case SetCardShadingAllShadings:
            //No stroke
            break;

        case SetCardShadingStriped:
            attributesDictionary[NSStrokeWidthAttributeName] = @-5;
            break;
    }
}

+ (UIColor *)getUIColorForSetCardColor:(SetCardColor)color
{
    switch (color) {
        case SetCardColorGreen:
            return [UIColor greenColor];

        case SetCardColorRed:
            return [UIColor redColor];
            break;

        case SetCardColorPurple:
            return [UIColor purpleColor];
            break;

        case SetCardColorAllColors:
            return [UIColor blackColor];
            break;
    }
    
}

@end
