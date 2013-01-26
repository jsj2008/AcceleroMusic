//
//  Smuse.h
//  MUSI 7100
//
//  Created by Govinda Ram Pingali on 11/27/12.
//  Copyright (c) 2012 Govinda Ram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVOSC.h"

@interface Smuse : NSObject
{
    OSCManager *manager;
    OSCOutPort *outPort;
    OSCInPort *inPort;
    OSCMessage *newMsg;
}

- (void) initSmuse;

- (void) smuse: (int)onOff;

- (void) changeTempo: (int)tempo;

- (void) mono1: (int)onOff;
- (void) mono2: (int)onOff;
- (void) mono3: (int)onOff;
- (void) mono4: (int)onOff;

- (void) global: (int)onOff;

- (void) setNetwork: (NSString*)IPAddress : (NSString*)oscPort;

@end