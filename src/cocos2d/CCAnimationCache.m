/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 *
 * Copyright (c) 2011 John Wordsworth
 *
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCAnimationCache.h"
#import "ccMacros.h"
#import "CCSpriteFrameCache.h"
#import "CCAnimation.h"
#import "CCSprite.h"
#import "Support/CCFileUtils.h"


@implementation CCAnimationCache

#pragma mark CCAnimationCache - Alloc, Init & Dealloc

static CCAnimationCache *sharedAnimationCache_=nil;

+ (CCAnimationCache *)sharedAnimationCache
{
	if (!sharedAnimationCache_)
		sharedAnimationCache_ = [[CCAnimationCache alloc] init];

	return sharedAnimationCache_;
}

+(id)alloc
{
	NSAssert(sharedAnimationCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+(void)purgeSharedAnimationCache
{
	[sharedAnimationCache_ release];
	sharedAnimationCache_ = nil;
}

-(id) init
{
	if( (self=[super init]) ) {
		animations_ = [[NSMutableDictionary alloc] initWithCapacity: 20];
	}

	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | num of animations =  %i>", [self class], self, [animations_ count]];
}

-(void) dealloc
{
	CCLOGINFO(@"cocos2d: deallocing %@", self);

	[animations_ release];
	[super dealloc];
}

#pragma mark CCAnimationCache - load/get/del

-(void) addAnimation:(CCAnimation*)animation name:(NSString*)name
{
	[animations_ setObject:animation forKey:name];
}

-(void) removeAnimationByName:(NSString*)name
{
	if( ! name )
		return;

	[animations_ removeObjectForKey:name];
}

-(CCAnimation*) animationByName:(NSString*)name
{
	return [animations_ objectForKey:name];
}

#pragma mark CCAnimationCache - from file

-(void)addAnimationsWithDictionary:(NSDictionary *)dictionary
{
	NSDictionary *animations = [dictionary objectForKey:@"animations"];

	if ( animations == nil ) {
		CCLOG(@"cocos2d: CCAnimationCache: No animations were found in provided dictionary.");
		return;
	}

	NSArray* animationNames = [animations allKeys];

	CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

	for( NSString *name in animationNames ) {
		NSDictionary* animationDict = [animations objectForKey:name];
		NSArray *frameNames = [animationDict objectForKey:@"frames"];
		NSNumber *delay = [animationDict objectForKey:@"delay"];
		CCAnimation* animation = nil;

		if ( frameNames == nil ) {
			CCLOG(@"cocos2d: CCAnimationCache: Animation '%@' found in dictionary without any frames - cannot add to animation cache.", name);
			continue;
		}

		NSMutableArray *frames = [NSMutableArray arrayWithCapacity:[frameNames count]];

		for( NSString *frameName in frameNames ) {
			CCSpriteFrame *frame = [frameCache spriteFrameByName:frameName];

			if ( frame )
				[frames addObject:frame];
			else
				CCLOG(@"cocos2d: CCAnimationCache: Animation '%@' refers to frame '%@' which is not currently in the CCSpriteFrameCache. This frame will not be added to the animation.", name, frameName);
		}

		if ( [frames count] == 0 ) {
			CCLOG(@"cocos2d: CCAnimationCache: None of the frames for animation '%@' were found in the CCSpriteFrameCache. Animation is not being added to the Animation Cache.", name);
			continue;
		} else if ( [frames count] != [frameNames count] ) {
			CCLOG(@"cocos2d: CCAnimationCache: An animation in your dictionary refers to a frame which is not in the CCSpriteFrameCache. Some or all of the frames for the animation '%@' may be missing.", name);
		}

		if ( delay != nil )
			animation = [CCAnimation animationWithFrames:frames delay:[delay floatValue]];
		else
			animation = [CCAnimation animationWithFrames:frames];

		[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];
	}
}


/** Read an NSDictionary from a plist file and parse it automatically for animations */
-(void)addAnimationsWithFile:(NSString *)plist
{
	NSAssert( plist, @"Invalid texture file name");

    NSString *path = [CCFileUtils fullPathFromRelativePath:plist];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

	NSAssert1( dict, @"CCAnimationCache: File could not be found: %@", plist);


	[self addAnimationsWithDictionary:dict];
}

@end
