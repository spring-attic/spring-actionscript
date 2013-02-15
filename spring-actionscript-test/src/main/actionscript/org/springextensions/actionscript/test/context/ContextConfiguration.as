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
import flash.system.ApplicationDomain;

import org.as3commons.reflect.MetaData;

/**
 * <p>
 * [ContextConfiguration] defines class-level metadata which can be used to
 * instruct client code with regard to how to load and configure an
 * IApplicationContext.
 * </p>
 *
 * @author Andrew Lewisohn
 * @see IContextLoader
 * @see org.springextensions.actionscript.context.IApplicationContext
 */
public class ContextConfiguration {

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The name of the metadata tag that defines a [ContextConfiguration].
	 */
	public static function get name():String {
		return "ContextConfiguration";
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * The underlying metadata instance. 
	 */
	private var metadata:MetaData;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param metadata The underlying metadata instance. 
	 */
	public function ContextConfiguration(metadata:MetaData) {
		this.metadata = metadata;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  inheritLocations
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the inheritLocations property.
	 */
	private var _inheritLocations:Boolean = true;
	
	private var inheritLocationsRead:Boolean = false;
	
	/**
	 * <p>
	 * Whether or not resource locations from superclasses should be 
	 * <em>inherited</em>.
	 * </p>
	 * <p>
	 * The default value is <code>true</code>, which means that an annotated
	 * class will <em>inherit</em> the resource locations defined by an
	 * annotated superclass. Specifically, the resource locations for an
	 * annotated class will be appended to the list of resource locations
	 * defined by an annotated superclass. Thus, subclasses have the option of
	 * <em>extending</em> the list of resource locations. In the following
	 * example, the IApplicationContext for <code>ExtendedTest</code> will be 
	 * loaded from "base-context.xml" <strong>and</strong>
	 * "extended-context.xml", in that order. Beans defined in
	 * "extended-context.xml" may therefore override those defined in
	 * "base-context.xml".
	 * </p>
	 *
	 * <pre class="code">
	 * [ContextConfiguration(locations="base-context.xml")]
	 * public class BaseTest {
	 *     // ...
	 * }
	 * 
	 * [ContextConfiguration(locations="extended-context.xml")]
	 * public class ExtendedTest extends BaseTest {
	 *     // ...
	 * }
	 * </pre>
	 *
	 * <p>
	 * If <code>inheritLocations</code> is set to false, the
	 * resource locations for the annotated class will <em>shadow</em> and
	 * effectively replace any resource locations defined by a superclass.
	 * </p>
	 * 
	 * @defaultValue <code>true</code>
	 */
	public function get inheritLocations():Boolean {
		if(!inheritLocationsRead) {
			if(metadata.hasArgumentWithKey("inheritLocations")) {
				_inheritLocations = metadata.getArgument("inheritLocations").value == "true";
			}
			
			inheritLocationsRead = true;
		}
		
		return _inheritLocations;
	}
	
	//----------------------------------
	//  loader
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the loader property.
	 */
	private var _loader:Class = null;
	
	private var loaderRead:Boolean = false;
	
	/**
	 * The IContextLoader to use for loading an IApplicationContext.
	 * 
	 * @defaultValue null
	 */
	public function get loader():Class {
		if(!loaderRead) {
			if(metadata.hasArgumentWithKey("loader")) {
				try {
					_loader = ApplicationDomain.currentDomain.getDefinition(metadata.getArgument("loader").value) as Class;	
				} catch(e:ReferenceError) {
					_loader = IContextLoader;
				}
			} else {
				_loader = IContextLoader;
			}
			
			loaderRead = true;
		}
		
		return _loader;
	}
	
	//----------------------------------
	//  locations
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the locations property.
	 */
	private var _locations:Array = null;
	
	/**
	 * The resource locations to use for loading an IApplicationContext.
	 * 
	 * @defaultValue empty array
	 */
	public function get locations():Array {
		if(_locations == null) {
			if(metadata.hasArgumentWithKey("locations")) {
				_locations = metadata.getArgument("locations").value.split(/\s*,\s*/g);
			} else {
				_locations = [];
			}
		}
		
		return _locations;
	}
}
}