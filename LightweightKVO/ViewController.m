//
//  ViewController.m
//  LightweightKVO
//
//  Created by chris nielubowicz on 4/7/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "ViewController.h"
#import "Observer.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tapsLabel;
@property (strong, nonatomic) IBOutlet UILabel *longPressLabel;

@property (strong, nonatomic) Observer *tapsObserver;
@property (assign, nonatomic) NSInteger taps;

@property (strong, nonatomic) Observer *longPressObserver;
@property (assign, nonatomic) NSInteger longPressDuration;

@property (strong, nonatomic) NSTimer *longPressUpdate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.taps = 0;
    self.longPressDuration = 0;
    
    self.tapsObserver = [Observer observerWithObject:self keyPath:NSStringFromSelector(@selector(taps)) target:self selector:@selector(tapsUpdated:)];

    __weak typeof(self) weakSelf = self;
    self.longPressObserver = [Observer observerWithObject:self
                                                  keyPath:NSStringFromSelector(@selector(longPressDuration))
                                              actionBlock:^(id value) {
                                                  __strong typeof(self)strongSelf = weakSelf;
                                                  strongSelf.longPressLabel.text = [NSString stringWithFormat:@"%@", value];
                                              }];
}

- (IBAction)tapGestureAction:(id)sender
{
    self.taps++;
}

- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        self.longPressDuration = 0;
        self.longPressUpdate = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(longPress) userInfo:nil repeats:YES];
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded || longPressGesture.state == UIGestureRecognizerStateCancelled) {
        [self.longPressUpdate invalidate];
    }
}

- (void)longPress
{
    self.longPressDuration++;
}

- (void)tapsUpdated:(id)value {
    self.tapsLabel.text = [NSString stringWithFormat:@"%@", value];
}

@end
