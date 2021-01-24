//
//  main.m
//  touchbar-tablet
//
//  Created by Никита Исаенко on 24.01.2021.
//

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,  CGEventRef event, void *refcon) {
    if (type == NSEventTypeGesture)
    {
        NSEvent* ev = [NSEvent eventWithCGEvent:event];
        NSSet *touches = [ev allTouches];
        for (NSTouch *touch in touches) {
            NSPoint fraction = { touch.normalizedPosition.x, 1.0f - touch.normalizedPosition.y };
            NSRect e = [[NSScreen mainScreen] frame];
            CGWarpMouseCursorPosition(CGPointMake(e.size.width * fraction.x, e.size.height * fraction.y));
        }
    }
    
    return event;
}

int main(int argc, const char * argv[]) {
    
    CFMachPortRef eventTap;
    CFRunLoopSourceRef runLoopSource;

    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, kCGEventMaskForAllEvents, myCGEventCallback, NULL);
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    CFRunLoopRun();
    
    return 0;
}
