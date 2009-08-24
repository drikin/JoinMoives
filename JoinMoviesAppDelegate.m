//
//  JoinMoviesAppDelegate.m
//  JoinMovies
//
//  Created by Kohichi Aoki on 8/23/09.
//  Copyright 2009 drikin.com. All rights reserved.
//

#import "JoinMoviesAppDelegate.h"

#define EXPORT_FILENAME @"export.mov"

@implementation JoinMoviesAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (QTMovie*)addMovieTo:(QTMovie*)movie fromPath:(NSString*)path;
{
  QTMovie *srcMovie = [QTMovie movieWithFile:path error:nil];
  [movie insertSegmentOfMovie:srcMovie timeRange:QTMakeTimeRange(QTZeroTime, [srcMovie duration]) atTime:[movie duration]];
  return movie;
}

- (void)exportMovie:(QTMovie*)movie to:(NSString*)path;
{
  NSDictionary *exportAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], QTMovieFlatten, nil];
  
  [movie writeToFile:path withAttributes:exportAttributes];
}

- (void)joinMovieFromPaths:(NSArray*)paths;
{
  [loadingView setHidden:NO];
  [spinningView startAnimation:self];
  [window display];
  QTMovie *exportMovie;
  BOOL    isFirst = YES;
  for( NSString *path in paths ){
    NSLog(@"%@", path);
    if( isFirst ) {
      exportMovie = [QTMovie movieWithFile:path error:nil];
      [exportMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
      isFirst = NO;      
    } else {
      exportMovie = [self addMovieTo:exportMovie fromPath:path];
    }
  }
  
  NSString *exportPath = [NSString stringWithFormat:@"%@/Desktop/%@", NSHomeDirectory(), EXPORT_FILENAME];
  [self exportMovie:exportMovie to:exportPath];
  [loadingView setHidden:YES];
  [spinningView stopAnimation:self];
  [window display];
  
  [[NSWorkspace sharedWorkspace] openFile:exportPath];
}

@end
