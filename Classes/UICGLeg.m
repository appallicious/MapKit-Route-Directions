#import "UICGLeg.h"

@interface UICGLeg ()

@property (nonatomic, retain) NSArray *steps;
@property (nonatomic, retain) NSDictionary *duration;
@property (nonatomic, retain) NSDictionary *distance;
@property (nonatomic, retain) NSDictionary *startLocation;
@property (nonatomic, retain) NSDictionary *endLocation;
@property (nonatomic, retain) NSString *startAddress;
@property (nonatomic, retain) NSString *endAddress;
@property (nonatomic, retain) NSArray *viaWaypoint;
@property (nonatomic) NSInteger numerOfSteps;

@end


@implementation UICGLeg

@synthesize steps, duration, distance, startLocation, endLocation;
@synthesize startAddress, endAddress, viaWaypoint, numerOfSteps;

+ (UICGLeg *)legWithDictionaryRepresentation:(NSDictionary *)dictionary {
	UICGLeg *leg = [[UICGLeg alloc] initWithDictionaryRepresentation:dictionary];
	return [leg autorelease];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	self = [super init];
	if (self != nil) {
		
		self.duration = [dictionary valueForKey:@"duration"];
		self.distance = [dictionary valueForKey:@"distance"];
		NSDictionary *startLocationDict = [dictionary valueForKeyPath:@"bounds.southwest"];
		CLLocationDegrees longitudeS = [[startLocationDict objectForKey:@"lat"] doubleValue];
		CLLocationDegrees latitudeS  = [[startLocationDict objectForKey:@"lng"] doubleValue];							 
		self.startLocation = [[[CLLocation alloc] initWithLatitude:latitudeS longitude:longitudeS]autorelease];
		NSDictionary *endLocationDict = [dictionary valueForKeyPath:@"bounds.northeast"];
		CLLocationDegrees longitudeE = [[endLocationDict objectForKey:@"lat"] doubleValue];
		CLLocationDegrees latitudeE  = [[endLocationDict objectForKey:@"lng"] doubleValue];							 
		self.endLocation = [[[CLLocation alloc] initWithLatitude:latitudeE longitude:longitudeE]autorelease];
		self.startAddress = [dictionary valueForKey:@"start_address"];
		self.endAddress = [dictionary valueForKey:@"end_address"];
		self.viaWaypoint = [dictionary valueForKey:@"via_waypoint"];
		
		NSArray *stepsDict = [dictionary valueForKey:@"steps"];
		self.steps = [NSMutableArray arrayWithCapacity:[stepsDict count]];
		for (NSDictionary *stepDict in stepsDict) {
			[(NSMutableArray *)self.steps addObject:[UICGStep stepWithDictionaryRepresentation:stepDict]];
		}
		self.numerOfSteps = self.steps.count;
	}
	return self;
}

- (UICGStep *)stepAtIndex:(NSInteger)index
{
	if (index >= self.steps.count) {
		return nil;
	}
	
	return [self.steps objectAtIndex:index];
}

- (void)dealloc
{
	[steps release];
	[duration release];
	[distance release];
	[startLocation release];
	[endLocation release];
	[startAddress release];
	[endAddress release];
	[viaWaypoint release];
	
	[super dealloc];
}

@end