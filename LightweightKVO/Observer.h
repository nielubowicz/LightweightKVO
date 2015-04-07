//
//  Observer.h
//  LightweightKVO
//
//  Created by chris nielubowicz on 4/7/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Observer : NSObject

typedef void (^ObserverActionBlock)(id value);

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector;

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                       actionBlock:(ObserverActionBlock)action;

@end
