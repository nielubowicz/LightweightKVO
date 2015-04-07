//
//  Observer.m
//  LightweightKVO
//
//  Created by chris nielubowicz on 4/7/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "Observer.h"

@interface Observer ()

@property (nonatomic, strong) ObserverActionBlock actionBlock;
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString* keyPath;

@end

@implementation Observer

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector
{
    __weak typeof(target) weakTarget = target;
    ObserverActionBlock block = ^void(id value) {
        __strong typeof(target)strongTarget = weakTarget;
        if ([strongTarget respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:selector withObject:value];
#pragma clang diagnostic pop
        }
    };
    
    return [[Observer alloc] initWithObject:object keyPath:keyPath actionBlock:block];
}

+ (instancetype)observerWithObject:(id)object keyPath:(NSString *)keyPath actionBlock:(ObserverActionBlock)action
{
    return [[Observer alloc] initWithObject:object keyPath:keyPath actionBlock:action];
}

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        actionBlock:(ObserverActionBlock)action
{
    if (self = [super init]) {
        self.observedObject = object;
        self.keyPath = keyPath;
        self.actionBlock = action;
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
        self.actionBlock(change[@"new"]);
    }
}

@end
