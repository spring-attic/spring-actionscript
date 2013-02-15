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
import flash.utils.describeType;

import org.as3commons.lang.Assert;
import org.as3commons.lang.ClassUtils;
import org.as3commons.lang.IllegalStateError;
import org.as3commons.lang.builder.ToStringBuilder;
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.MetadataUtils;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Type;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.core.AttributeAccessorSupport;
import org.springextensions.actionscript.test.context.support.GenericXMLContextLoader;
import org.springextensions.actionscript.utils.ObjectUtils;

/**
 * TestContext encapsulates the context in which a test is executed, agnostic of
 * the actual testing framework in use.
 *
 * @author Andrew Lewisohn
 * @since 1.1
 */
public class TestContext extends AttributeAccessorSupport {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(TestContext);
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var DEFAULT_CONTEXT_LOADER_CLASS:Class = org.springextensions.actionscript.test.context.support.GenericXMLContextLoader;
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Stores the reflection information for the test class.
	 */
	private var testClassType:Type;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Construct a new test context for the supplied test class and context cache
	 * and parses the corresponding [ContextConfiguration] metadata, if present.
	 * 
	 * @param testClass the Class object corresponding to the test class
	 * for which the test context should be constructed (must not be <code>null</code>)
	 * @param contextCache the context cache from which the constructed test context
	 * should retrieve application contexts (must not be <code>null</code>)
	 */
	public function TestContext(testClass:Class, contextCache:ContextCache) {
		Assert.notNull(testClass, "Test class must not be null.");
		Assert.notNull(contextCache, "ContextCache must not be null.");
		
		testClassType = Type.forInstance(testClass);
		
		var contextConfigurationMetadata:MetaData = MetadataUtils.findClassMetadata(testClass, ContextConfiguration.name);
		var locations:Array = null;
		var contextLoader:IContextLoader = null;
		
		if(contextConfigurationMetadata == null) {
			if(LOGGER.infoEnabled) {
				LOGGER.info("[ContextConfiguration] not found for class [" + testClass + "]");
			}
		} else {
			var contextConfiguration:ContextConfiguration = new ContextConfiguration(contextConfigurationMetadata);
			var contextLoaderClass:Class = contextConfiguration.loader;
			
			if(contextLoaderClass == IContextLoader) {
				try {
					contextLoaderClass = DEFAULT_CONTEXT_LOADER_CLASS;
				} catch(e:Error) {
					throw new IllegalStateError("Could not load default ContextLoader class ["
						+ DEFAULT_CONTEXT_LOADER_CLASS + "]. Specify [ContextConfiguration]'s 'loader' "
						+ "attribute or make the default loader class available.");
				}
			}
			
			contextLoader = new contextLoaderClass();
			locations = retrieveContextLocations(contextLoader, testClass);
		}
		
		_testClass = testClass;
		_contextCache = contextCache;
		_contextLoader = contextLoader;
		_locations = locations;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  contextCache
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the contextCache property.
	 */
	private var _contextCache:ContextCache;
	
	/**
	 * Get the context cache for this test context.
	 * 
	 * @return the context cache (never <code>null</code>)
	 */
	internal function get contextCache():ContextCache {
		return _contextCache;
	}
	
	//----------------------------------
	//  contextLoader
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the contextLoader property.
	 */
	private var _contextLoader:IContextLoader;
	
	/**
	 * Get the IContextLoader to use for loading the IApplicationContext
	 * for this test context.
	 * 
	 * @return the context loader. May be <code>null</code> if the current
	 * test context is not configured to use an application context.
	 */
	internal function get contextLoader():IContextLoader {
		return _contextLoader;
	}
	
	//----------------------------------
	//  locations
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the locations property.
	 */
	private var _locations:Array = [];
	
	/**
	 * Get the resource locations to use for loading the
	 * IApplicationContext for this test context.
	 * 
	 * @return the application context resource locations.
	 * May be <code>null</code> if the current test context is
	 * not configured to use an application context.
	 */
	internal function get locations():Array {
		return _locations;
	}	
	
	//----------------------------------
	//  testClass
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testClass property.
	 */
	private var _testClass:Class;
	
	/**
	 * Get the test class for this test context.
	 * 
	 * @return the test class (never <code>null</code>)
	 */
	public final function get testClass():Class {
		return _testClass;
	}
	
	//----------------------------------
	//  testException
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testException property.
	 */
	private var _testException:Error;
	
	/**
	 * Gets the exception that was thrown during execution of
	 * the test method.
	 * 
	 * <p>Note: this is a mutable property.</p>
	 * 
	 * @return the exception that was thrown, or <code>null</code> 
	 * if no exception was thrown
	 * @see #updateState()
	 */
	public final function get testException():Error {
		return _testException;	
	}
	
	//----------------------------------
	//  testInstance
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testInstance property.
	 */
	private var _testInstance:Object;
	
	/**
	 * Gets the current test instance for this test context.
	 * <p>Note: this is a mutable property.</p>
	 * 
	 * @return the current test instance (may be <code>null</code>)
	 * @see #updateState()
	 */
	public final function get testInstance():Object {
		return _testInstance;
	}
	
	//----------------------------------
	//  testMethod
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testMethod property.
	 */
	private var _testMethod:Method;
	
	/**
	 * Gets the current test method for this test context.
	 * <p>Note: this is a mutable property.</p>
	 * 
	 * @return the current test method (may be <code>null</code>)
	 * @see #updateState()
	 */
	public final function get testMethod():Method {
		return _testMethod;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Convert the supplied context <code>key</code> to a String
	 * representation for use in caching, logging, etc.
	 * 
	 * @param key the context key to convert to a String
	 */
	private function contextKeyString(key:Array):String {
		return ObjectUtils.nullSafeToString(key);
	}
	
	/**
	 * Get the application context for this test context, possibly cached.
	 * 
	 * @return the application context; may be <code>null</code> if the
	 * current test context is not configured to use an application context
	 * @throws IllegalStateError if an error occurs while retrieving the application context
	 */
	public function getApplicationContext():IApplicationContext {
		var context:IApplicationContext = null;
		var cache:ContextCache = contextCache;
		var contextKey:String = contextKeyString(locations);
		
		if((context = cache.get(contextKey)) == null) {
			try {
				context = loadApplicationContext();
				cache.put(contextKey, context);
			} catch(e:Error) {
				throw new IllegalStateError("Failed to load IApplicationContext");
			}
		}
		
		return context;
	}
	
	/**
	 * Build an IApplicationContext for this test context using the
	 * configured IContextLoader and resource locations.
	 * 
	 * @throws Error if an error occurs while building the application context
	 */
	private function loadApplicationContext():IApplicationContext {
		Assert.notNull(contextLoader, "Cannot build an IApplicationContext with a NULL 'contextLoader.' Consider annotating your test class with [ContextConfiguration].");
		Assert.notNull(locations, "Cannot build an IApplicationContext with a NULL 'locations.' Consider annotating your test class with [ContextConfiguration].");
		
		return contextLoader.loadContext(locations);
	}
	
	/**
	 * Call this method to signal that the application context associated 
	 * with this test context is <em>dirty</em> and should be reloaded. Do 
	 * this if a test has modified the context (for example, by replacing 
	 * a bean definition).
	 */
	public function markApplicationContextDirty():void {
		contextCache.setDirty(contextKeyString(locations));
	}
	
	/**
	 * @private
	 * Retrieve IApplicationContext resource locations for the supplied
	 * class, using the supplied IContextLoader to process the
	 * locations.
	 * 
	 * <p>Note that the inheritLocations flag of [ContextConfiguration] 
	 * will be taken into consideration. Specifically, if the 
	 * <code>inheritLocations</code> flag is set to <code>true</code>, 
	 * locations defined in the annotated class will be appended to the 
	 * locations defined in superclasses.
	 * </p>
	 * 
	 * @param contextLoader the IContextLoader to use for processing the locations
	 * (must not be <code>null</code>)
	 * @param clazz the class for which to retrieve the resource locations
	 * (must not be <code>null</code>)
	 * @return the list of IApplicationContext resource locations for the specified
	 * class, including locations from superclasses if appropriate
	 * @throws IllegalArgumentException if [ContextConfiguration]
	 * is not <em>present</em> on the supplied class
	 */
	private function retrieveContextLocations(contextLoader:IContextLoader, clazz:Class):Array {
		Assert.notNull(contextLoader, "ContextLoader must not be null.");
		Assert.notNull(clazz, "Class must not be null.");
		
		var locationsList:Array = []; 
		var metadataName:String = ContextConfiguration.name;
		var declaringClass:Class = MetadataUtils.findMetadataDeclaringClass(metadataName, clazz);
		Assert.notNull(declaringClass, "Could not find an 'metadata declaring class' for metadata type [" +
			metadataName + "] and class [" + clazz + "]");
		
		while(declaringClass != null) {
			var type:XML = describeType(declaringClass);
			var declaringClassType:Type = Type.forClass(declaringClass);
			var contextConfiguration:ContextConfiguration = new ContextConfiguration(declaringClassType.getMetaData(metadataName)[0]);
			var locations:Array = contextLoader.processLocations(declaringClass, contextConfiguration.locations);
			locationsList = locations.concat(locationsList);
			declaringClass = contextConfiguration.inheritLocations
				? MetadataUtils.findMetadataDeclaringClass(metadataName, ClassUtils.getSuperClass(declaringClass))
				: null;
		}
		
		return locationsList;
	}
	
	/**
	 * Updates this test context to reflect the state of the currently executing test.
	 * 
	 * @param testInstance the current test instance (may be <code>null</code>)
	 * @param testMethod the current test method (may be <code>null</code>)
	 * @param testException the exception that was thrown in the test method,
	 * or <code>null</code> if no exception was thrown
	 */
	public function updateState(testInstance:Object, testMethod:Method, testException:Error):void {
		_testInstance = testInstance;
		_testMethod = testMethod;
		_testException = testException;
	}
	
	/**
	 * Provides a string representation of this test context
	 * @see #getTestClass() test class
	 * @see #getLocations() application context resource locations
	 * @see #getTestInstance() test instance
	 * @see #getTestMethod() test method
	 * @see #getTestException() test exception.
	 */
	public function toString():String {
		return new ToStringBuilder(this)
			.append(_testClass, "testClass")
			.append(locations, "locations")
			.append(_testInstance, "testInstance")
			.append(_testMethod, "testMethod")
			.append(_testException, "testException")
			.toString();
	}
}
}