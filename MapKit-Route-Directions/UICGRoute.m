//
//  UICGRoute.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "UICGRoute.h"

@implementation UICGRoute

@synthesize dictionaryRepresentation;
@synthesize numerOfSteps;
@synthesize steps;
@synthesize distance;
@synthesize duration;
@synthesize summaryHtml;
@synthesize startGeocode;
@synthesize endGeocode;
@synthesize endLocation;
@synthesize polylineEndIndex;

+ (UICGRoute *)routeWithDictionaryRepresentation:(NSDictionary *)dictionary {
	UICGRoute *route = [[UICGRoute alloc] initWithDictionaryRepresentation:dictionary];
	return [route autorelease];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	self = [super init];
	if (self != nil) {
		dictionaryRepresentation = [dictionary retain];
        NSSet * setOfKeys = [dictionaryRepresentation keysOfEntriesPassingTest:^(id key, id obj, BOOL * stop){
            if ([obj isKindOfClass:[NSDictionary class]]) {
                for (NSString *keyString in [obj allKeys]) {
                    if ([keyString isEqualToString:@"Steps"]) {
                        *stop=YES;
                        return YES;
                    }
                }
            }
            return NO;
        }];
        NSDictionary * k = [dictionaryRepresentation objectForKey:[setOfKeys anyObject]];
        NSArray * stepDics = [k objectForKey:@"Steps"];
        numerOfSteps = [stepDics count];
		steps = [[NSMutableArray alloc] initWithCapacity:numerOfSteps];
		for (NSDictionary *stepDic in stepDics) {
			[(NSMutableArray *)steps addObject:[UICGStep stepWithDictionaryRepresentation:stepDic]];
		}
		
		endGeocode = [dictionaryRepresentation objectForKey:@"MJ"];
		startGeocode = [dictionaryRepresentation objectForKey:@"dT"];
		
		distance = [[k objectForKey:@"Distance"] copy];
		duration = [[k objectForKey:@"Duration"] copy];
		NSDictionary *endLocationDic = [[k objectForKey:@"End"] copy];
		NSArray *coordinates = [[endLocationDic objectForKey:@"coordinates"] copy];
		CLLocationDegrees longitude = [[coordinates objectAtIndex:0] doubleValue];
		CLLocationDegrees latitude  = [[coordinates objectAtIndex:1] doubleValue];
		endLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		summaryHtml = [[k objectForKey:@"summaryHtml"] copy];
		polylineEndIndex = [[k objectForKey:@"polylineEndIndex"] integerValue];
	}
	return self;
}

- (void)dealloc {
	[dictionaryRepresentation release];
	[steps release];
	[distance release];
	[duration release];
	[summaryHtml release];
	[startGeocode release];
	[endGeocode release];
	[endLocation release];
	[super dealloc];
}

- (UICGStep *)stepAtIndex:(NSInteger)index {
	return [steps objectAtIndex:index];;
}

@end
