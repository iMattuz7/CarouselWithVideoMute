
#import "PBJViewController.h"
#import "PBJVideoPlayerController.h"

static NSString * const PBJRemoteVideoURLString = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
static NSString * const PBJViewControllerVideoPath = @"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11719145_918467924880620_816495633_n.mp4";
static NSString * const texturl = @"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4";

static NSString * const URL1 = @"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11719145_918467924880620_816495633_n.mp4";
//static NSString * const URL1 = @"http://wwwstatic.batanga.bz/vixvideos/1272647426078959.mp4";
static NSString * const URL2 = @"http://wwwstatic.batanga.bz/vixvideos/1272647426078959.mp4";
static NSString * const URL3 = @"http://wwwstatic.batanga.bz/vixvideos/1272264992783869.mp4";
static NSString * const URL4 = @"http://wwwstatic.batanga.bz/vixvideos/1272265462783822.mp4";
static NSString * const URL5 = @"http://wwwstatic.batanga.bz/vixvideos/1272280576115644.mp4";

static int VIDEO_COUNT = 5;

@interface PBJViewController () <
PBJVideoPlayerControllerDelegate>
{
    PBJVideoPlayerController *_videoPlayerController;
    UIButton *_playButton;
    NSMutableArray *videoPlayerViewControllers;
    NSMutableArray *videoURLs;
}

@end

@implementation PBJViewController

@synthesize carousel = _carousel;

#pragma mark - UIViewController status bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    videoPlayerViewControllers = [NSMutableArray new];
    videoURLs = [NSMutableArray new];
    [self loadVideos];
    //configure carousel
    self.carousel.type = iCarouselTypeLinear;
    
    //Start carousel
    [self.carousel scrollToItemAtIndex:0 animated:NO];
    [self.carousel setCenterItemWhenSelected:YES];
    [self.carousel setScrollSpeed:0.5];
    
}

-(void)loadVideos{
    PBJVideoPlayerController * currentVideoViewController;
    for (int i = 0; i<5; i++) {
        currentVideoViewController = [PBJVideoPlayerController new];
        [videoPlayerViewControllers addObject:currentVideoViewController];
        //Agrego el array de video
    }
    [videoURLs addObject:URL1];
    [videoURLs addObject:URL2];
    [videoURLs addObject:URL3];
    [videoURLs addObject:URL4];
    [videoURLs addObject:URL5];
    
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return VIDEO_COUNT;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250.0f, 250.0f)];
    view.backgroundColor = [UIColor clearColor];
    NSUInteger idx = (NSUInteger)index;
    PBJVideoPlayerController * currentVideoViewController = [videoPlayerViewControllers objectAtIndex:idx];
    
    
    currentVideoViewController.delegate = self;
    currentVideoViewController.view.frame = view.bounds;
    [videoPlayerViewControllers addObject:currentVideoViewController];
    
    NSLog(@"video player controller frame: %@",NSStringFromCGRect(currentVideoViewController.view.frame));
    
    
    [view addSubview:currentVideoViewController.view];
    
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _playButton.center = view.center;
    [view addSubview:_playButton];
    [view bringSubviewToFront:_playButton];
    
    //agrego un label

    
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateHighlighted];
    //    [_playButton addTarget:self
    //                    action:@selector(playTouched)
    //          forControlEvents:UIControlEventTouchUpInside];
    
    ///////_videoPlayerController.videoPath = PBJViewControllerVideoPath;
    //UN TIPO DE URL
    //NSURL *bipbopUrl = [[NSURL alloc] initWithString:PBJRemoteVideoURLString];
    //URL MP4
    //NSURL *bipbopUrl = [[NSURL alloc] initWithString:texturl];
    
    //LEVANTO URL DEL Array
    NSString *urlToUse = [videoURLs objectAtIndex:idx];
    NSURL *bipbopUrl = [[NSURL alloc] initWithString:urlToUse];
    currentVideoViewController.asset = [[AVURLAsset alloc] initWithURL:bipbopUrl options:nil];
    
    NSLog(@"current view frame: %@",NSStringFromCGRect(view.frame));
    
    return view;
}



- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
    NSLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    NSLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"Carousel did end scrolling");
            for (PBJVideoPlayerController *currentController in videoPlayerViewControllers) {
                if(currentController!=nil)
                    [currentController stop];
            }
    
    PBJVideoPlayerController *currentVideoController = videoPlayerViewControllers[(NSUInteger)
                                                                                  _carousel.currentItemIndex];
    
    
    [currentVideoController setMuted:true];
    [currentVideoController playFromBeginning];
}


#pragma mark - PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    //    _playButton.alpha = 1.0f;
    //    _playButton.hidden = NO;
    //
    //    [UIView animateWithDuration:0.1f animations:^{
    //        _playButton.alpha = 0.0f;
    //    } completion:^(BOOL finished) {
    //        _playButton.hidden = YES;
    //    }];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    //    _playButton.hidden = NO;
    //
    //    [UIView animateWithDuration:0.1f animations:^{
    //        _playButton.alpha = 1.0f;
    //    } completion:^(BOOL finished) {
    //    }];
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    
}

- (void)videoPlayer:(PBJVideoPlayerController *)videoPlayer didUpdatePlayBackProgress:(CGFloat)progress {
}

//- (CMTime)videoPlayerTimeIntervalForPlaybackProgress:(PBJVideoPlayerController *)videoPlayer {
//    //return CMTimeMake(5, 25);
//    return NULL;
//}


#pragma mark - end carrousel delegate

-(void) playTouched
{
    [_videoPlayerController playFromBeginning];
    
    [_playButton removeTarget:self action:@selector(playTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [_playButton addTarget:self
                    action:@selector(pauseTouched)
          forControlEvents:UIControlEventTouchUpInside];
}

-(void) pauseTouched
{
    [_videoPlayerController pause];
    
    [_playButton removeTarget:self action:@selector(pauseTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [_playButton addTarget:self
                    action:@selector(playTouched)
          forControlEvents:UIControlEventTouchUpInside];
    
}


@end
