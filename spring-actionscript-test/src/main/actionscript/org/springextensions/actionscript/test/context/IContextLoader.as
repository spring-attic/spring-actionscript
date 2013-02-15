/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.test.context {
import org.springextensions.actionscript.context.IApplicationContext;

/**
 * <p>
 * Strategy interface for loading an application context.
 * </p>
 * <p>
 * Clients of an IContextLoader should call processLocations() prior to
 * calling loadContext() in case the IContextLoader provides custom 
 * support for modifying or generating locations. The results of 
 * processLocations() should then be supplied to loadContext().
 * </p>
 * <p>
 * Concrete implementations must provide a <code>public</code> no-args
 * constructor.
 * </p>
 * <p>
 * Spring provides the following out-of-the-box implementations:
 * </p>
 * <ul>
 * <li>org.springextensions.actionscript.test.context.support.GenericXMLContextLoader</li>
 * </ul>
 *
 * @author Andrew Lewisohn
 * @see org.springextensions.actionscript.test.context.support.GenericXMLContextLoader
 */
public interface IContextLoader {

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  contextLoaded
	//----------------------------------
	
	/**
	 * If <code>true</code>, the application context has been loaded. 
	 */
	function get contextLoaded():Boolean;
	
	//----------------------------------
	//  couldNotLoadContext
	//----------------------------------
	
	/**
	 * If <code>true</code>, the application context could not be loaded.
	 */
	function get couldNotLoadContext():Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * <p>
	 * Loads a new context based on the supplied <code>locations</code>, configures 
	 * the context, and finally returns the context.
	 * </p>
	 * <p>
	 * Configuration locations are generally considered to be system path
	 * resources by default.
	 * </p>
	 *
	 * @param locations the resource locations to use to load the application context
	 * @return a new application context
	 * @throws Exception if context loading failed
	 */
	function loadContext(locations:Array):IApplicationContext;
	
	/**
	 * <p>
	 * Processes application context resource locations for a specified class.
	 * </p>
	 * <p>
	 * Concrete implementations may choose to modify the supplied locations,
	 * generate new locations, or simply return the supplied locations unchanged.
	 * </p>
	 *
	 * @param clazz the class with which the locations are associated: used to
	 * determine how to process the supplied locations.
	 * @param locations the unmodified locations to use for loading the
	 * application context; can be <code>null</code> or empty.
	 * @return an array of application context resource locations
	 */
	function processLocations(clazz:Class, locations:Array):Array;
}
}