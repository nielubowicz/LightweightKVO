//
//  Observer.m
//  LightweightKVO
//
//  Created by chris nielubowicz on 4/7/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "Observer.h"

@interface Observer ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString* keyPath;

@end

@implementation Observer

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector
{
    return [[Observer alloc] initWithObject:object keyPath:keyPath target:target selector:selector];
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        target:(id)target
                      selector:(SEL)selector
{
    if (self = [super init]) {
        self.observedObject = object;
        self.keyPath = keyPath;
        self.target = target;
        self.selector = selector;
        [self.observedObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
    }
    
    return self;
}

- (void)dealloc
{
    id strongObservedObject = self.observedObject;
    if (strongObservedObject) {
        [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self == (__bridge Observer *)(context)) {
        id strongTarget = self.target;
        if ([strongTarget respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:self.selector withObject:change[@"new"]];
#pragma clang diagnostic pop
        }
    }
}

@end
