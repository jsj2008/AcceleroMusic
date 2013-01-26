//
//  MUSI_7100ViewController.m
//  MUSI 7100
//
//  Created by Govinda Ram Pingali on 11/15/12.
//  Copyright (c) 2012 Govinda Ram. All rights reserved.
//

#import "MUSI_7100ViewController.h"

@interface MUSI_7100ViewController ()

@end

@implementation MUSI_7100ViewController

@synthesize status;
@synthesize toggleSwitch;
@synthesize tempoSlider;
@synthesize accelerometer;

@synthesize ipTextField;
@synthesize oscTextField;
@synthesize ipAddress;
@synthesize oscPort;

@synthesize toggleMono1;
@synthesize toggleMono2;
@synthesize toggleMono3;
@synthesize toggleMono4;

@synthesize toggleAccelerometer;

#define degrees(x) (180 * x / M_PI)

float flX = 0;
float fhX = 0;
float flTempo = 0;

bool counterPosToggle = false;
bool counterNegToggle = false;
bool acceleratorToggleVariable = false;

double timeStamp;
int tempo;

float zRotation;

NSDate *startTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    //*** Smuse ***//
    smuseObject = [[Smuse alloc] init];
    [smuseObject initSmuse];
    
    ipTextField.delegate = self;
    oscTextField.delegate = self;
    
    //*** Accelerometer ***//
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .01;
    self.accelerometer.delegate = self;
    startTime = [NSDate date];


    //*** Timer ***//
    //timer = [NSTimer scheduledTimerWithTimeInterval:(1/60) target:self selector:@selector(readGyroscope) userInfo:nil repeats:YES];
    
    
    //*** Gyroscope ***//
    motionManager = [[CMMotionManager alloc] init];
    /*  UIAlertView *alertNoGyro = [[UIAlertView alloc]initWithTitle:@"No Gyro!" message:@"Use Device with Gyro" delegate:self cancelButtonTitle:@"DONE" otherButtonTitles:nil];
        [alertNoGyro show];*/

}




- (void)readGyroscope
{
    CMAttitude *attitude;
    CMDeviceMotion *motion;
    attitude = motion.attitude;
    
    NSString *yaw = [NSString stringWithFormat:@"Yaw: %f", degrees(attitude.yaw)];
    NSLog(@"%@",yaw);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//*** Start SMUSE ***//
- (IBAction)start:(UISwitch *)sender
{
    if(toggleSwitch.on) {
        status.text = @"Start";
        [smuseObject smuse:1];
    } else {
        status.text = @"Stop";
        [smuseObject smuse:0];
    }
}




//*** If Tempo Slider Changed ***//
- (IBAction)changeTempo:(UISlider *)sender
{
    tempo = (int)sender.value;
    status.text = [NSString stringWithFormat:@"%i",tempo];
    [smuseObject changeTempo:tempo];
}




//*** Motion Sensors On/Off ***//
- (IBAction)acceleratorOn:(UISwitch *)sender
{
    if(toggleAccelerometer.on)
    {
        //Start Accelerometer
        acceleratorToggleVariable = true;
        status.text = @"Accelerometer On";
        
        
        //Start Gyroscope
        [motionManager startGyroUpdates];
		timer = [NSTimer scheduledTimerWithTimeInterval:1/30.0 target:self selector:@selector(doGyroUpdate) userInfo:nil repeats:YES];
    }
    
    else
    {
        //Stop Accelerometer
        acceleratorToggleVariable = false;
        status.text = @"Accelerometer Off";
        
        
        //Stop Gyroscope
        [motionManager stopGyroUpdates];
		[timer invalidate];
    }
}




//*** Gyroscope ***//
-(void)doGyroUpdate
{
	float zRate;
    int zGyroRotate;
    
    zRate = motionManager.gyroData.rotationRate.x;
	if (fabs(zRate) > .1)
    {
		float zDirection = zRate > 0 ? 1 : -1;
		zRotation += zDirection * M_PI/90.0;
        zGyroRotate = (int) (zRotation * 100);
		//NSLog(@"Rotation: %d",zGyroRotate);
	}
}





//*** Accelerometer ***//
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    float kHighpass = 0.99;
    float kLowpass = 0.925;
    float kTempoFilter = 0.2;
    
    int filterTempo, finalTempo, newTempo;
    double elapsedTime;

    double speedX = 1000 * (acceleration.x);
    double speedY = 1000 * (acceleration.y);
    double speedZ = 1000 * (acceleration.z);
    
    
    
    int finalAcceleration = (int) (sqrt(pow(speedX, 2) + pow(speedY, 2) + pow(speedZ, 2)) - 1000);
    
    
    //Lowpass Filter
    flX = kLowpass * flX + (1 - kLowpass) * finalAcceleration;
    int filterLowPass = (int)flX;
    
    
    //High Pass Filter
    fhX = (kHighpass * filterLowPass) + (fhX * (1 - kHighpass));
    int filterHighPass = (int) (filterLowPass - fhX);
    
    
    
    if(filterHighPass >= 1)
    {
        counterPosToggle = true;
    }
    
    else if(filterHighPass <= -1)
    {
        counterNegToggle = true;
    }
    
    else
    {
        if((counterPosToggle == true) && (counterNegToggle == true))
        {
            counterPosToggle = false;
            counterNegToggle = false;
            
            timeStamp = [NSDate timeIntervalSinceReferenceDate] - timeStamp;
            elapsedTime = [startTime timeIntervalSinceNow] * -1000;
            newTempo = (int) (60000/elapsedTime);
            
            flTempo = kTempoFilter * flTempo + (1 - kTempoFilter) * newTempo;
            filterTempo = (int)flTempo;
            startTime = [NSDate date];
            
            
            //Set Tempo
            if(filterTempo<=75)
            {
                finalTempo = 60;
            }
            
            else if((filterTempo>75) && (filterTempo<=105))
            {
                finalTempo = 90;
            }
            
            else if((filterTempo>105) && (filterTempo<=135))
            {
                finalTempo = 120;
            }
            
            else if((filterTempo>135) && (filterTempo<=165))
            {
                finalTempo = 150;
            }
            
            else if((filterTempo>165) && (filterTempo<=195))
            {
                finalTempo = 180;
            }
            
            else if((filterTempo>195) && (filterTempo<=225))
            {
                finalTempo = 210;
            }
            
            else if(filterTempo>225)
            {
                finalTempo = 240;
            }
            
            
            if(acceleratorToggleVariable == true)
            {
                status.text = [NSString stringWithFormat:@"%d", filterTempo];
                
                //Tempo Change OSC Message
                [smuseObject changeTempo:filterTempo];
            }
            
            
        //End Counter if Statement
        }
    //End Else Statement
    }
//End Function
}





- (IBAction)actionMono1:(UISwitch *)sender
{
    if(toggleMono1.on) {
        status.text = @"Mono1 On";
        [smuseObject mono1:1];
    } else {
        status.text = @"Mono1 Off";
        [smuseObject mono1:0];
    }
}



- (IBAction)actionMono2:(UISwitch *)sender
{
    if(toggleMono2.on) {
        status.text = @"Mono2 On";
        [smuseObject mono2:1];
    } else {
        status.text = @"Mono2 Off";
        [smuseObject mono2:0];
    }
}



- (IBAction)actionMono3:(UISwitch *)sender
{
    if(toggleMono3.on) {
        status.text = @"Mono3 On";
        [smuseObject mono3:1];
    } else {
        status.text = @"Mono3 Off";
        [smuseObject mono3:0];
    }

}


- (IBAction)actionMono4:(UISwitch *)sender
{
    if(toggleMono4.on) {
        status.text = @"Mono4 On";
        [smuseObject mono2:1];
    } else {
        status.text = @"Mono4 Off";
        [smuseObject mono2:0];
    }

}


- (IBAction)ipChangeText:(UITextField *)sender
{
    ipAddress = self.ipTextField.text;
    
    if([oscTextField.text length] != 0){
        [smuseObject setNetwork: ipAddress :oscPort];
    }
}


- (IBAction)oscChangeText:(UITextField *)sender
{
   oscPort = self.oscTextField.text;
    
    if([ipTextField.text length] != 0) {
        [smuseObject setNetwork: ipAddress :oscPort];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [ipTextField resignFirstResponder];
    [oscTextField resignFirstResponder];
    return NO;
}


@end

