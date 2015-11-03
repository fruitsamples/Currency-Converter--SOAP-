(* Currency Converter.applescript *)

(* This is an enhanced version of Currency Converter that utilizes SOAP services to enable getting the current exchange rate. *)


(* ==== Event Handlers ==== *)

-- The "action" event handler is called when the user choosing a country from the popup button. We will call the "getRate" event handler to use a SOAP service to get the rate.
--
on action theObject
	set contents of text field "rate" of window of theObject to getRate(title of theObject as string)
end action


-- The "clicked" event handler is called when the user clicks on the "Convert" button. This will do a simple calculatin of "rate * dollars" and put the result in the "total" field.
--
on clicked theObject
	tell window of theObject
		set theRate to contents of text field "rate" as real
		set theDollars to contents of text field "dollars" as real
		set contents of text field "total" to theRate * theDollars
	end tell
end clicked


-- The "awake from nib" event handler is called the popup button is loaded form the nib. In this example we will use this opportunity to get the rate (based on the default selection of the popup button).
--
on awake from nib theObject
	set contents of text field "rate" of window of theObject to getRate(title of theObject)
end awake from nib


(* ==== Handlers ==== *)

-- This handler is called to get the current exchange rate for the given country. It does this by using the "call soap" command to communicate with a SOAP web service.
--
on getRate(forCountry)
	-- Initialize the result to a known value
	set theRate to 1.0
	
	-- We always convert from the US	
	set fromCountry to "USA"
	
	-- Talk to the soap service
	tell application "http://services.xmethods.net:80/soap"
		-- Call the "getRate" method of the soap service returning the current rate
		set theRate to call soap {method name:"getRate", method namespace uri:"urn:xmethods-CurrencyExchange", parameters:{country1:fromCountry, country2:forCountry}, SOAPAction:""}
	end tell
	
	-- Return the result
	return theRate
end getRate

-- This is a utility handler to get the given unicode text as plain text (not styled text)
--
on getPlainText(fromUnicodeString)
	set styledText to fromUnicodeString as string
	set styledRecord to styledText as record
	return �class ktxt� of styledRecord
end getPlainText

(* � Copyright 2002 Apple Computer, Inc. All rights reserved.

IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. (�Apple�) in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this Apple software constitutes acceptance of these terms.  If you do not agree with these terms, please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Apple grants you a personal, non-exclusive license, under Apple�s copyrights in this original Apple software (the �Apple Software�), to use, reproduce, modify and redistribute the Apple Software, with or without modifications, in source and/or binary forms; provided that if you redistribute the Apple Software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the Apple Software.  Neither the name, trademarks, service marks or logos of Apple Computer, Inc. may be used to endorse or promote products derived from the Apple Software without specific prior written permission from Apple.  Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Apple herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *)
