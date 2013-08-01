/*
 * Copyright 2013 Michael Stringer
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "DocumentInteraction.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface DocumentInteraction(private)
- (NSString *) detectFileUTI:(NSString *)filePath;
- (NSString *) convertMimeToUTI:(NSString *)mime;
@end

@implementation DocumentInteraction

- (void) previewDocument:(CDVInvokedUrlCommand *)command {
    NSString *filename = [command argumentAtIndex:0];
    NSString *fileMime = [command argumentAtIndex:1];
    NSString *title = [command argumentAtIndex:2];

    NSString *fileUTI;
    if (fileMime == nil) {
        // try to auto-detect file type
        fileUTI = [self detectFileUTI:filename];
    } else {
        // convert mime into UTI
        fileUTI = [self convertMimeToUTI:fileMime];
    }

    NSURL *fileUrl = [NSURL fileURLWithPath:filename];

    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];

    interactionController.delegate = self;
    interactionController.UTI = fileUTI;
    if (title != nil) {
        interactionController.name = title;
    }

    [interactionController presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods

- (UIViewController *) documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.viewController;
}

#pragma mark - Private Methods

- (NSString *) detectFileUTI:(NSString *)filePath {
#if __has_feature(objc_arc)
    CFStringRef pathExtension = (__bridge_retained CFStringRef) [filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);

    if (type == NULL) {
        return (NSString *) kUTTypeContent;
    }

    return CFBridgingRelease(type);
#else
    CFStringRef pathExtension = (CFStringRef) [filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);

    if (type == NULL) {
        return (NSString *) CFRetain(kUTTypeContent);
    }

    return CFBridgingRelease(type);
#endif
}

- (NSString *) convertMimeToUTI:(NSString *)mime {
#if __has_feature(objc_arc)
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mime), NULL);

    if (type == NULL) {
        return (NSString *) kUTTypeContent;
    }

    return CFBridgingRelease(type);
#else
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (CFStringRef)(mime), NULL);

    if (type == NULL) {
        return (NSString *) CFRetain(kUTTypeContent);
    }

    return CFBridgingRelease(type);
#endif
}

@end
