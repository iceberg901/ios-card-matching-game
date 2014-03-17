//
//  RandomUtils.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 3/12/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#ifndef Card_Matching_Game_RandomUtils_h
#define Card_Matching_Game_RandomUtils_h

extern float randomFloatBetween(float smallNumber, float bigNumber) {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

#endif
