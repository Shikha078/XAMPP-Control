/*
 
 XAMPP
 Copyright (C) 2009 by Apache Friends
 
 Authors of this file:
 - Christian Speich <kleinweby@apachefriends.org>
 
 This file is part of XAMPP.
 
 XAMPP is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 XAMPP is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with XAMPP.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "ProFTPDPlugin.h"
#import "ProFTPDModule.h"
#import "ProFTPDModuleViewController.h"
#import "ProFTPDSecurityCheck.h"

@implementation ProFTPDPlugin

- (BOOL) setupError:(NSError**)anError
{
	NSMutableDictionary *dict;
	NSDictionary* bundleInformations;
	ProFTPDModule *module;
	XPModuleViewController *controller;
	ProFTPDSecurityCheck* securityCheck;
	
	bundleInformations = [[NSBundle bundleForClass:[self class]] infoDictionary];
	dict = [NSMutableDictionary dictionary];
	module = [ProFTPDModule new];
	controller = [[ProFTPDModuleViewController alloc] initWithModule:module];
	securityCheck = [ProFTPDSecurityCheck new];
	
	[dict setValue:[NSArray arrayWithObject:module] forKey:XPModulesPlugInCategorie];
	
	if ([[bundleInformations objectForKey:@"RegisterControlsController"] boolValue])
		[dict setValue:[NSArray arrayWithObject:controller] forKey:XPControlsPlugInCategorie];
	
	if ([[bundleInformations objectForKey:@"RegisterSecurityCheck"] boolValue])
		[dict setValue:[NSArray arrayWithObject:securityCheck] forKey:XPSecurityChecksPlugInCategorie];

	[module setShouldRunStartTests:[[bundleInformations objectForKey:@"RunStartTests"] boolValue]];
	
	[module release];
	[securityCheck release];
	[controller release];
	
	[self setRegistryInfo:dict];
	
	return YES;
}

@end
