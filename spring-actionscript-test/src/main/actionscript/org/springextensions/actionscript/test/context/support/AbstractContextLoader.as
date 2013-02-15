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
package org.springextensions.actionscript.test.context.support {
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;

import org.as3commons.lang.Assert;
import org.as3commons.lang.ClassUtils;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.test.context.IContextLoader;

/**
 * <p>
 * Abstract application context loader, which provides a basis for all concrete
 * implementations of the <code>IContextLoader</code> strategy. Provides a
 * <em>Template</em> Method based approach for
 * <code>processLocations()</code> processing locations.
 * </p>
 *
 * @author Andrew Lewisohn
 * @see #generateDefaultLocations()
 * @see #modifyLocations()
 */
public class AbstractContextLoader extends EventDispatcher implements IContextLoader {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AbstractContextLoader() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  contextLoaded
	//----------------------------------
	
	/**
	 * If <code>true</code>, an <code>IApplicationContext</code> has been loaded.
	 */
	public function get contextLoaded():Boolean {
		throw new IllegalOperationError("Abstract method must be overridden in subclass.");
	}
	
	//----------------------------------
	//  couldNotLoadContext
	//----------------------------------
	
	/**
	 * If <code>true</code>, the application context could not be loaded.
	 */
	public function get couldNotLoadContext():Boolean {
		throw new IllegalOperationError("Abstract method must be overridden in subclass.");
	}
	
	//----------------------------------
	//  enerateDefaultLocations
	//----------------------------------
	
	/**
	 * <p>
	 * Determines whether or not <em>default</em> resource locations should be
	 * generated if the <code>locations</code> provided to <code>processLocations()</code> 
	 * are <code>null</code> or empty.
	 * </p>
	 * <p>
	 * Can be overridden by subclasses to change the default behavior.
	 * </p>
	 *
	 * @return always <code>true</code> by default
	 */
	public function get generateDefaultLocations():Boolean {
		return true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * <p>
	 * Gets the suffix to append to <code>IApplicationContext</code> resource
	 * locations when generating default locations.
	 * </p>
	 * <p>
	 * Must be implemented by subclasses.
	 * </p>
	 *
	 * @return the resource suffix; should not be <code>null</code> or empty.
	 * @see #generateDefaultLocations()
	 */
	protected function getResourceSuffix():String {
		throw new IllegalOperationError("Abstract method must be overridden in subclass.");
	}
	
	/**
	 * <p>
	 * Generates the default classpath resource locations array based on the
	 * supplied class.
	 * </p>
	 * <p>
	 * For example, if the supplied class is <code>com.example.MyTest</code>,
	 * the generated locations will contain a single string with a value of
	 * "/com/example/MyTest<code>&lt;suffix&gt;</code>",
	 * where <code>&lt;suffix&gt;</code> is the value of the resource suffix string.
	 * </p>
	 * <p>
	 * Subclasses can override this method to implement a different
	 * <em>default</em> location generation strategy.
	 * </p>
	 *
	 * @param clazz the class for which the default locations are to be generated
	 * @return an array of default application context resource locations
	 * @see #getResourceSuffix()
	 */
	protected function getDefaultLocations(clazz:Class):Array {
		Assert.notNull(clazz, "clazz cannot be null.");
		Assert.hasText(getResourceSuffix(), "resourceSuffix cannot be empty.");
		
		var className:String = ClassUtils.getFullyQualifiedName(clazz, true);
		var resourceUrl:String = className.replace(/\./g, "/") + getResourceSuffix(); 
			
		return [resourceUrl];
	}

	/**
	 * @inheritDoc
	 */
	public function loadContext(locations:Array):IApplicationContext {
		throw new IllegalOperationError("Abstract method must be overridden in subclass.");
	}
	
	/**
	 * <p>
	 * Generates a modified version of the supplied locations array and returns
	 * it.
	 * </p>
	 * <p>
	 * A plain path, e.g. "context.xml", will be treated as a
	 * classpath resource from the same package in which the specified class is
	 * defined. A path starting with a slash is treated as a fully qualified
	 * class path location, e.g.:
	 * "/org/springframework/whatever/foo.xml".
	 * </p>
	 * <p>
	 * Subclasses can override this method to implement a different
	 * <em>location</em> modification strategy.
	 * </p>
	 *
	 * @param clazz the class with which the locations are associated
	 * @param locations the resource locations to be modified
	 * @return an array of modified application context resource locations
	 */
	protected function modifyLocations(clazz:Class, locations:Array):Array {
		return locations;
	}
	
	/**
	 * <p>
	 * If the supplied <code>locations</code> are null or
	 * <em>empty</em> and <code>isGenerateDefaultLocations()</code> is
	 * <code>true</code>, default locations will be generated for the specified
	 * class and the configured resource suffix otherwise, the supplied
	 * <code>locations</code> will be modified if necessary and returned.
	 * </p>
	 *
	 * @param clazz the class with which the locations are associated: to be
	 * used when generating default locations.
	 * @param locations the unmodified locations to use for loading the
	 * application context; can be <code>null</code> or empty.
	 * @return an array of application context resource locations
	 * @see #generateDefaultLocations()
	 * @see #modifyLocations()
	 * @see org.springextensions.actionscript.test.context.IContextLoader#processLocations()
	 */
	public function processLocations(clazz:Class, locations:Array):Array {
		return (locations.length == 0 && generateDefaultLocations)
			? getDefaultLocations(clazz)
			: modifyLocations(clazz, locations);
	}
}
}