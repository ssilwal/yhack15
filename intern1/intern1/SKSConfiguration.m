//
//  SKSConfiguration.m
//  intern1
//
//  SKSConfiguration.mm
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SKSConfiguration.h"

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".
unsigned char SKSAppKey[] = {0x40, 0x2b, 0x8d, 0x9f, 0x56, 0x5b, 0x4c, 0x43, 0xa4, 0xc0, 0x75, 0x34, 0x84, 0xee, 0x89, 0xa1, 0xdf, 0x84, 0x02, 0x63, 0xb1, 0x4a, 0xbf, 0xca, 0xf5, 0x28, 0x45, 0x42, 0xf5, 0x66, 0xc9, 0x35, 0x92, 0x56, 0xd4, 0xe8, 0xb1, 0x20, 0x2b, 0x55, 0xe0, 0xa1, 0x89, 0x64, 0x8f, 0x12, 0x06, 0x6e, 0x96, 0x08, 0xd2, 0x47, 0x52, 0x91, 0x12, 0x48, 0xb9, 0x57, 0x8a, 0xae, 0xbe, 0x53, 0xe3, 0x50};
NSString* SKSAppId = @"NMDPTRIAL_ss4547_columbia_edu20151106232211";
NSString* SKSServerHost = @"nmsp.dev.nuance.com";
NSString* SKSServerPort = @"443";


//NSString* SKSServerUrl = [NSString stringWithFormat:@"nmsp://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort];

// Only needed if using NLU/Bolt
NSString* SKSNLUContextTag = @"V1_Project876_App423";


