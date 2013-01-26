//
//  MUSI_7100ViewController.h
//  MUSI 7100
//
//  Created by Govinda Ram Pingali on 11/15/12.
//  Copyright (c) 2012 Govinda Ram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Smuse.h"


@interface MUSI_7100ViewController : UIViewController <UIAccelerometerDelegate, UITextFieldDelegate>
{
    Smuse *smuseObject;
    
    UIAccelerometer *accelerometer;
    
    //Gyroscoope
    CMMotionManager *motionManager;
    NSTimer *timer;
}



//Start/Stop Switch
@property (nonatomic, retain) IBOutlet UISwitch *toggleSwitch;
- (IBAction)start:(UISwitch *)sender;

//Status Text
@property (nonatomic, retain) IBOutlet UILabel *status;


//Tempo Slider
- (IBAction)changeTempo:(UISlider *)sender;
@property (nonatomic, retain) IBOutlet UISlider *tempoSlider;


//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *oscTextField;
- (IBAction)ipChangeText:(UITextField *)sender;
- (IBAction)oscChangeText:(UITextField *)sender;

@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, copy) NSString *oscPort;


//Accelerometer
@property (nonatomic, retain) UIAccelerometer *accelerometer;

@property (nonatomic, retain) IBOutlet UISwitch *toggleAccelerometer;
- (IBAction)acceleratorOn:(UISwitch *)sender;



//Mono Instrument Switches
- (IBAction)actionMono1:(UISwitch *)sender;
@property (nonatomic, retain) IBOutlet UISwitch *toggleMono1;

- (IBAction)actionMono2:(UISwitch *)sender;
@property (nonatomic, retain) IBOutlet UISwitch *toggleMono2;

- (IBAction)actionMono3:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *toggleMono3;

- (IBAction)actionMono4:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *toggleMono4;


@end
