//
//  Smuse.m
//  MUSI 7100
//
//  Created by Govinda Ram Pingali on 11/27/12.
//  Copyright (c) 2012 Govinda Ram. All rights reserved.
//

#import "Smuse.h"

@implementation Smuse


- (void) mono1:(int)onOff
{
    newMsg = [OSCMessage createWithAddress:@"/mono1/start"];
    [newMsg addInt:onOff];
    [outPort sendThisMessage:newMsg];
}

- (void) mono2:(int)onOff
{
    newMsg = [OSCMessage createWithAddress:@"/mono2/start"];
    [newMsg addInt:onOff];
    [outPort sendThisMessage:newMsg];
}

- (void) mono3:(int)onOff
{
    newMsg = [OSCMessage createWithAddress:@"/mono3/start"];
    [newMsg addInt:onOff];
    [outPort sendThisMessage:newMsg];
}


- (void) mono4:(int)onOff
{
    newMsg = [OSCMessage createWithAddress:@"/mono4/start"];
    [newMsg addInt:onOff];
    [outPort sendThisMessage:newMsg];
}


- (void) global:(int)onOff
{
    newMsg = [OSCMessage createWithAddress:@"/global/start"];
    [newMsg addInt:onOff];
    [outPort sendThisMessage:newMsg];
}


- (void) setNetwork:(NSString *)IPAddress :(NSString *)oscPort
{
    int port = [oscPort intValue];
    outPort = [manager createNewOutputToAddress:IPAddress atPort:port];
}



- (void) smuse:(int)onOff
{
    [self global:onOff];
    
    [self mono1:onOff];
    [self mono2:onOff];
    [self mono3:onOff];
    [self mono4:onOff];
}




- (void) initSmuse
{
    // creating OSCManager- set myself up as its delegate
    manager = [[OSCManager alloc] init];
    [manager setDelegate:self];
    // create an input port for receiving OSC data
    [manager createNewInputForPort:1235];
    // create an output to send OSC data
    [self setNetwork:@"128.61.25.197" : @"1234"];
    
    //Mono*, Global: Stop
    [self smuse:0];
    
    
    //Mono 1 MIDI Setup
    newMsg = [OSCMessage createWithAddress:@"/mono1/midi/channel"];
    [newMsg addInt:1];
    [outPort sendThisMessage:newMsg];
    
    //Mono 2 MIDI Setup
    newMsg = [OSCMessage createWithAddress:@"/mono2/midi/channel"];
    [newMsg addInt:2];
    [outPort sendThisMessage:newMsg];
    
    //Mono 3 MIDI Setup
    newMsg = [OSCMessage createWithAddress:@"/mono3/midi/channel"];
    [newMsg addInt:3];
    [outPort sendThisMessage:newMsg];
    
    //Mono 4 MIDI Setup
    newMsg = [OSCMessage createWithAddress:@"/mono4/midi/channel"];
    [newMsg addInt:4];
    [outPort sendThisMessage:newMsg];
    
    
    //Mono 3 Set Register
    newMsg = [OSCMessage createWithAddress:@"/mono3/register/pattern"];
    [newMsg addInt:3];
    [outPort sendThisMessage:newMsg];
    
    //Mono 4 Set Register
    newMsg = [OSCMessage createWithAddress:@"/mono4/register/pattern"];
    [newMsg addInt:3];
    [outPort sendThisMessage:newMsg];
    
    
    //Smuse Message - Mono 1 Set Pitches - Bass
    newMsg = [OSCMessage createWithAddress:@"/mono1/pitch/pattern"];
    [newMsg addInt:0]; [newMsg addInt:0]; [newMsg addInt:0]; [newMsg addInt:0];
    [newMsg addInt:0]; [newMsg addInt:0]; [newMsg addInt:0]; [newMsg addInt:0];
    [newMsg addInt:3]; [newMsg addInt:3]; [newMsg addInt:3]; [newMsg addInt:3];
    [newMsg addInt:8]; [newMsg addInt:8]; [newMsg addInt:8]; [newMsg addInt:8];
    [outPort sendThisMessage:newMsg];
    
    //Smuse Message - Mono 2 Set Pitches - Lead
    newMsg = [OSCMessage createWithAddress:@"/mono2/pitch/pattern"];
    [newMsg addInt:0]; [newMsg addInt:10]; [newMsg addInt:12]; [newMsg addInt:0];
    [newMsg addInt:8]; [newMsg addInt:10]; [newMsg addInt:0];  [newMsg addInt:7];
    [newMsg addInt:8]; [newMsg addInt:0];  [newMsg addInt:5];  [newMsg addInt:7];
    [newMsg addInt:0]; [newMsg addInt:3];  [newMsg addInt:2];  [newMsg addInt:0];
    [outPort sendThisMessage:newMsg];
    
    //Smuse Message - Mono 3 Set Pitches - Kick/Snare
    newMsg = [OSCMessage createWithAddress:@"/mono3/pitch/pattern"];
    [newMsg addInt:0];  [newMsg addInt:-1]; [newMsg addInt:2];   [newMsg addInt:-1];
    [newMsg addInt:0];  [newMsg addInt:0];  [newMsg addInt:2];  [newMsg addInt:-1];
    [outPort sendThisMessage:newMsg];
    
    //Smuse Message - Mono 4 Set Pitches - Hats
    newMsg = [OSCMessage createWithAddress:@"/mono4/pitch/pattern"];
    [newMsg addInt:15];
    [outPort sendThisMessage:newMsg];
    
}




- (void) changeTempo: (int)tempo
{
    //Tempo Change Message
    newMsg = [OSCMessage createWithAddress:@"/global/tempo"];
    
    // add a bunch arguments to the message
    [newMsg addInt:tempo];
    /*[newMsg addFloat:12.34];
     [newMsg addBOOL:YES];
     [newMsg addString:@"Hello World!"];*/

    [outPort sendThisMessage:newMsg];
}

@end
