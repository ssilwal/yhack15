/*
*  NMT_IRecognitionInterpreter.h
*
*           Nuance Mobile Toolkit - nmt_recognition
*
*   \section Legal_Notice Legal Notice
*
*   Copyright 2013, Nuance Communications Inc. All rights reserved.
*
*   Nuance Communications, Inc. provides this document without representation
*   or warranty of any kind. The information in this document is subject to
*   change without notice and does not represent a commitment by Nuance
*   Communications, Inc. The software and/or databases described in this
*   document are furnished under a license agreement and may be used or
*   copied only in accordance with the terms of such license agreement.
*   Without limiting the rights under copyright reserved herein, and except
*   as permitted by such license agreement, no part of this document may be
*   reproduced or transmitted in any form or by any means, including, without
*   limitation, electronic, mechanical, photocopying, recording, or otherwise,
*   or transferred to information storage and retrieval systems, without the
*   prior written permission of Nuance Communications, Inc.
*
*   Nuance, the Nuance logo, Nuance Recognizer, and Nuance Vocalizer are
*   trademarks or registered trademarks of Nuance Communications, Inc. or its
*   affiliates in the United States and/or other countries. All other
*   trademarks referenced herein are the property of their respective owners.
*/

#import <Foundation/Foundation.h>

#import <nmt_recognition/NMT_IInterpretedRecognition.h>
#import <nmt_recognition/NMT_IRecognitionResult.h>

@protocol NMT_IRecognitionInterpreter <NSObject>
/**
 * Get an interpreted result from the recognition.
 * @param recognitionResult The raw recognition result.
 * @return An interpreted recognition result--never null.
 TODO(LXU)
 * @throws InterpretException Thrown if there was an error interpreting the result.
 */
-(id<NMT_IInterpretedRecognition>) getInterpretedResult:(id<NMT_IRecognitionResult>) pRecognitionResult;

/**
 * Get the network parameters to be sent to the other recognizer(s) after a
 * recognition.
 * @param recognitionResult
 * @param params Empty list of parameters, to be filled in by this method.
 * @return true if cloud processing is required.
 */
-(BOOL) processForCloud:(id<NMT_IRecognitionResult>)pRecognitionResult params:(NSArray *)params;

/**
 * After a recognition, get a list of the names of any WordSlots that were flagged as
 * requiring an update on the server.  This can be necessary if the state of the IWordList
 * on the server does not match the state on the client, for example if a user cleared the
 * application data on the phone.
 * @param recognitionResult The raw recognition result.
 * @return A list of WordSlot names that require an update on the server.
 */
-(NSArray *) getUpdateRequiredList:(id<NMT_IRecognitionResult>)pRecognitionResult;

@end