//
//  PPDataControllerError.h
//  Dentist
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _PPDataControllerErrorType
{
    PPURLErrorUnknown = NSURLErrorUnknown,
    PPURLErrorCancelled = NSURLErrorCancelled,
    PPURLErrorBadURL = NSURLErrorBadURL,
    PPRequestTimedOutErrorType = NSURLErrorTimedOut,
    PPURLErrorUnsupportedURL = NSURLErrorUnsupportedURL,
    PPURLErrorCannotFindHost = NSURLErrorCannotFindHost,
    PPURLErrorCannotConnectToHost = NSURLErrorCannotConnectToHost,
    PPURLErrorNetworkConnectionLost = NSURLErrorNetworkConnectionLost,
    PPURLErrorDNSLookupFailed = NSURLErrorDNSLookupFailed,
    PPURLErrorHTTPTooManyRedirects = NSURLErrorHTTPTooManyRedirects,
    PPURLErrorResourceUnavailable = NSURLErrorResourceUnavailable,
    PPURLErrorNotConnectedToInternet = NSURLErrorNotConnectedToInternet,
    PPURLErrorRedirectToNonExistentLocation = NSURLErrorRedirectToNonExistentLocation,
    PPURLErrorBadServerResponse = NSURLErrorBadServerResponse,
    PPURLErrorUserCancelledAuthentication = NSURLErrorUserCancelledAuthentication,
    PPURLErrorUserAuthenticationRequired = NSURLErrorUserAuthenticationRequired,
    PPURLErrorZeroByteResource = NSURLErrorZeroByteResource,
    PPURLErrorCannotDecodeRawData = NSURLErrorCannotDecodeRawData,
    PPURLErrorCannotDecodeContentData = NSURLErrorCannotDecodeContentData,
    PPURLErrorCannotParseResponse = NSURLErrorCannotParseResponse,
    PPURLErrorFileDoesNotExist = NSURLErrorFileDoesNotExist,
    PPURLErrorFileIsDirectory = NSURLErrorFileIsDirectory,
    PPURLErrorNoPermissionsToReadFile = NSURLErrorNoPermissionsToReadFile,
    PPURLErrorDataLengthExceedsMaximum = NSURLErrorDataLengthExceedsMaximum,
    
    // SSL errors
    PPURLErrorSecureConnectionFailed = NSURLErrorSecureConnectionFailed,
    PPURLErrorServerCertificateHasBadDate = NSURLErrorServerCertificateHasBadDate,
    PPURLErrorServerCertificateUntrusted = NSURLErrorServerCertificateUntrusted,
    PPURLErrorServerCertificateHasUnknownRoot = NSURLErrorServerCertificateHasUnknownRoot,
    PPURLErrorServerCertificateNotYetValid = NSURLErrorServerCertificateNotYetValid,
    PPURLErrorClientCertificateRejected = NSURLErrorClientCertificateRejected,
    PPURLErrorClientCertificateRequired = NSURLErrorClientCertificateRequired,
    PPURLErrorCannotLoadFromNetwork = NSURLErrorCannotLoadFromNetwork,
    
    // Download and file I/O errors
    PPURLErrorCannotCreateFile = NSURLErrorCannotCreateFile,
    PPURLErrorCannotOpenFile = NSURLErrorCannotOpenFile,
    PPURLErrorCannotCloseFile = NSURLErrorCannotCloseFile,
    PPURLErrorCannotWriteToFile = NSURLErrorCannotWriteToFile,
    PPURLErrorCannotRemoveFile = NSURLErrorCannotRemoveFile,
    PPURLErrorCannotMoveFile = NSURLErrorCannotMoveFile,
    PPURLErrorDownloadDecodingFailedMidStream = NSURLErrorDownloadDecodingFailedMidStream,
    PPURLErrorDownloadDecodingFailedToComplete = NSURLErrorDownloadDecodingFailedToComplete,
    
    PPURLErrorInternationalRoamingOff = NSURLErrorInternationalRoamingOff,
    PPURLErrorCallIsActive = NSURLErrorCallIsActive,
    PPURLErrorDataNotAllowed = NSURLErrorDataNotAllowed,
    PPURLErrorRequestBodyStreamExhausted = NSURLErrorRequestBodyStreamExhausted,
    
    // Custom errors
    PPDataParseError = 100,
    PPDataStatusCodeError = 101,
    PPServerError = 102
}PPDataControllerErrorType;
