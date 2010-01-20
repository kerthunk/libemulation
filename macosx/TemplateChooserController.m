
/**
 * OpenEmulator
 * Mac OS X Template Chooser Controller
 * (C) 2009 by Marc S. Ressl (mressl@umich.edu)
 * Released under the GPL
 *
 * Controls the template chooser window.
 */

#import "TemplateChooserController.h"

@implementation TemplateChooserController

- (id) init
{
	self = [super initWithWindowNibName:@"TemplateChooser"];
	
	if (self)
	{
		templateChooserViewController = [[TemplateChooserViewController alloc] init];
		[templateChooserViewController setDelegate:self];
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
	
	[templateChooserViewController release];
}

- (void) updateTemplateChooser
{
	[templateChooserViewController updateUserTemplates];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *itemPath = [userDefaults stringForKey:@"OELastTemplate"];
	[templateChooserViewController selectItemWithPath:itemPath];
	
	[[self window] center];
	
	[fChooseButton setEnabled:([templateChooserViewController selectedItemPath]
							   != nil)];
}

- (void) windowDidLoad
{
	[super windowDidLoad];
	
	[self setWindowFrameAutosaveName:@"TemplateChooser"];
	
	NSView *view = [templateChooserViewController view];
	[fTemplateChooserView addSubview:view];
	[view setFrameSize:[fTemplateChooserView frame].size];
	
	[self updateTemplateChooser];
}

- (void) showWindow:(id) sender
{
	[super showWindow:sender];
	
	[self updateTemplateChooser];
}

- (void) chooserWasDoubleClicked:(id) sender
{
	[self chooseTemplate:sender];
}

- (IBAction) chooseTemplate:(id) sender
{
	NSString *templatePath = [templateChooserViewController selectedItemPath];
	NSURL *url = nil;
	if (templatePath)
	{
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:templatePath
						 forKey:@"OELastTemplate"];
		url = [NSURL fileURLWithPath:templatePath];
	}
	
	[[self window] orderOut:self];
	
	if (url)
	{
		NSError *error;
		if (![fDocumentController openUntitledDocumentWithTemplateURL:url
															  display:YES
																error:&error])
			[[NSAlert alertWithError:error] runModal];
	}
}

@end