//
//  CCSpriteExtension.m
//  CocosLib
//
//  Created by Goffredo Marocchi on 6/2/11.
//  Copyright 2011 IGGS. All rights reserved.
//

#import "CCSpriteExtensions.h"

@implementation CCSprite (Xtensions)
+(id) spriteWithSpriteFrameNameOrFile:(NSString*)nameOrFile
{
    CCSpriteFrame* spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:nameOrFile];
    if (spriteFrame)
    {
        return [CCSprite spriteWithSpriteFrame:spriteFrame];
    }
    
    return [CCSprite spriteWithFile:nameOrFile];
}
@end