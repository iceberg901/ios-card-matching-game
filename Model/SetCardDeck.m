//
//  SetCardDeck.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];

    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (uint i = 1; i <= [SetCard maxCount]; i++) {
                for (SetCardColor color = 0; color < SetCardColorAllColors; color++) {
                    for (SetCardShading shading = 0; shading < SetCardShadingAllShadings; shading++) {
                        SetCard *card = [SetCard new];
                        card.shape = shape;
                        card.count = i;
                        card.color = color;
                        card.shading = shading;

                        [self addCard:card];
                    }
                }
            }
        }
    }

    return self;
}

@end
