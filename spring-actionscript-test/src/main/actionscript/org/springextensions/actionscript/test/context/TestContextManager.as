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
import flash.events.Event;
import flash.system.ApplicationDomain;

import org.as3commons.lang.Assert;
import org.as3commons.lang.ClassUtils;
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.reflect.MetadataUtils;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Type;
import org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener;
import org.springextensions.actionscript.test.context.support.DirtiesContextTestExecutionListener;

/**
 * <p>
 * <code>TestContextManager</code> is the main entry point into the
 * <em>Spring TestContext Framework</em>, which provides support for loading
 * and accessing application contexts, dependency injection of test instances,
 * execution of test methods, etc.
 * </p>
 * <p>
 * Specifically, a <code>TestContextManager</code> is responsible for managing
 * a single <code>TestContext</code> and signaling events to all registered
 * <code>TestExecutionListeners</code> at well defined test execution points:
 * </p>
 * <ul>
 * <li>prepareTestInstance() for test instance preparation
 * immediately following instantiation of the test instance</li>
 * </ul>
 *
 * @author Andrew Lewisohn
 * @see TestContext
 */
public class TestContextManager {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(TestContextManager);
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var DEFAULT_TEST_EXECUTION_LISTENER_CLASSES:Array = [
		org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener,
		org.springextensions.actionscript.test.context.support.DirtiesContextTestExecutionListener
	];
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Storage for the contextCache property.
	 */
	private static var _contextCache:ContextCache = new ContextCache();
	
	/**
	 * Cache of Spring application contexts. This needs to be static, as tests
	 * may be destroyed and recreated between running individual test methods,
	 * for example with FlexUnit.
	 */
	internal static function get contextCache():ContextCache {
		return _contextCache;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructs a new <code>TestContextManager</code> for the specified
	 * test class and automatically registers the test execution listeners configured 
	 * for the test class via the annotation.
	 * @param testClass the Class object corresponding to the test class to be managed
	 * @see #registerTestExecutionListeners()
	 * @see #retrieveTestExecutionListeners()
	 */
	public function TestContextManager(testClass:Class) {
		_testContext = new TestContext(testClass, _contextCache);
		registerTestExecutionListeners(retrieveTestExecutionListeners(testClass));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  applicationContextLoaded
	//----------------------------------
	
	/**
	 * If <code>true</code>, an application context has been loaded.
	 */
	public final function get applicationContextLoaded():Boolean {
		return _testContext.contextLoader.contextLoaded;	
	}
	
	//----------------------------------
	//  couldNotLoadApplicationContext
	//----------------------------------
	
	/**
	 * If <code>true</code>, the application context could not be loaded.
	 */
	public final function get couldNotLoadApplicationContext():Boolean {
		return _testContext.contextLoader.couldNotLoadContext;
	}
	
	//----------------------------------
	//  testContext
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testContext property.
	 */
	private var _testContext:TestContext;
	
	/**
	 * Returns the TestContext managed by this <code>TestContextManager</code>.
	 */
	protected final function get testContext():TestContext {
		return _testContext;
	}
	
	//----------------------------------
	//  testExecutionListeners
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testExecutionListeners property.
	 */
	private var _testExecutionListeners:Array = [];
	
	/**
	 * Gets a copy of the [TestExecutionListeners] registered for
	 * this <code>TestContextManager</code>.
	 */
	public final function get testExecutionListeners():Array {
		return _testExecutionListeners.concat();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Hook for post-processing a test <em>after</em> execution of the supplied 
	 * test method, for example for tearing down test fixtures, etc. Should be 
	 * called after any framework-specific <em>after</em> methods (e.g., methods 
	 * annotated with FlexUnit's [After] metadata).
	 * 
	 * <p>
	 * The managed TestContext will be updated with the supplied
	 * <code>testInstance</code>, <code>testMethod</code>, and
	 * <code>exception</code>.
	 * </p>
	 * 
	 * <p>
	 * Each registered ITestExecutionListener will be given a chance to
	 * post-process the test method execution. If a listener throws an
	 * exception, the remaining registered listeners will still be called, but
	 * the first exception thrown will be tracked and rethrown after all
	 * listeners have executed. Note that registered listeners will be executed
	 * in the opposite order in which they were registered.
	 * </p>
	 * 
	 * @param testInstance the current test instance (never <code>null</code>)
	 * @param testMethod the test method which has just been executed on the
	 * 	test instance
	 * @param exception the exception that was thrown during execution of the
	 * 	test method or by a ITestExecutionListener, or <code>null</code>
	 * 	if none was thrown
	 * @throws Error if a registered ITestExecutionListener throws an exception
	 * @see #testExecutionListeners
	 */
	public function afterTestMethod(testInstance:Object, testMethod:Method, exception:Error):void {
		Assert.notNull(testInstance, "'testInstance' cannot be null.");
		if(LOGGER.debugEnabled) {
			LOGGER.debug("afterTestMethod(): instance [{0}], method [{1}], exception [{2}]", testInstance, testMethod, exception);
		}
		_testContext.updateState(testInstance, testMethod, exception);
		
		var testListenersReversed:Array = testExecutionListeners;
		testListenersReversed.reverse();
		
		var afterTestMethodError:Error = null;
		for each(var testExecutionListener:ITestExecutionListener in testListenersReversed) {
			try {
				testExecutionListener.afterTestMethod(_testContext);
			} catch(e:Error) {
				LOGGER.warn("Caught exception while allowing ITestExecutionListener [{0}]" +
					" to process 'after' execution of test: method [{1}], instance [{2}]," +
					" exception [{3}]", testExecutionListener, testMethod, testInstance, exception);
				if(afterTestMethodError == null) {
					afterTestMethodError = e;
				}
			}
		}
		
		if(afterTestMethodError != null) {
			throw afterTestMethodError;
		}
	}
	
	/**
	 * Hook for pre-processing a test <em>before</em> execution of the
	 * supplied test method, for example for setting up test fixtures, etc. 
	 * Should be called prior to any framework-specific <em>before</em> methods 
	 * (e.g., methods annotated with FlexUnit's [Before] metadata).
	 * 
	 * <p>
	 * The managed TestContext will be updated with the supplied
	 * <code>testInstance</code> and <code>testMethod</code>.
	 * </p>
	 * 
	 * <p>
	 * An attempt will be made to give each registered ITestExecutionListener
	 *  a chance to pre-process the test method execution. If a listener throws 
	 * an exception, however, the remaining registered listeners will 
	 * <strong>not</strong> be called.
	 * </p>
	 * 
	 * @param testInstance the current test instance (never <code>null</code>)
	 * @param testMethod the test method which is about to be executed on the
	 * 	test instance
	 * @throws Error if a registered ITestExecutionListener throws an exception
	 * @see #testExecutionListeners
	 */
	public function beforeTestMethod(testInstance:Object, testMethod:Method):void {
		Assert.notNull(testInstance, "'testInstance' cannot be null.");
		if(LOGGER.debugEnabled) {
			LOGGER.debug("beforeTestMethod(): instance [{0}], method [{1}]", testInstance, testMethod);
		}
		
		_testContext.updateState(testInstance, testMethod, null);
		
		for each(var testExecutionListener:ITestExecutionListener in testExecutionListeners) {
			try {
				testExecutionListener.beforeTestMethod(_testContext);
			} catch(e:Error) {
				LOGGER.warn("Caught exception while allowing ITestExecutionListener [{0}]" +
					" to process 'before' execution of test method [{1}] for test " +
					" instance [{2}]", testExecutionListener, testMethod, testInstance);
			}
		}
	}
	
	/**
	 * Determine the default ITestExecutionListener classes.
	 */
	protected function getDefaultTestExecutionListenerClassses():Array {
		return DEFAULT_TEST_EXECUTION_LISTENER_CLASSES;
	}
	
	/**
	 * Hook for preparing a test instance prior to execution of any individual
	 * test methods, for example for injecting dependencies, etc. Should be
	 * called immediately after instantiation of the test instance.
	 * 
	 * <p>
	 * The managed TestContext will be updated with the supplied
	 * <code>testInstance</code>.
	 * </p>
	 * 
	 * <p>An attempt will be made to give each registered ITestExecutionListener
	 * a chance to prepare the test instance. If a listener throws an exception, 
	 * however, the remaining registered listeners will <strong>not</strong> be 
	 * called.</p>
	 * 
	 * @param testInstance the test instance to prepare (if <code>null</code>, the 
	 * 	testInstance will be retrieved from the current testContext)
	 * @throws Exception if a registered ITestExecutionListener throws an exception
	 * 	or an application context could not be loaded.
	 * @see #getTestExecutionListeners()
	 */
	public function prepareTestInstance(testInstance:Object):void {
		Assert.notNull(testInstance, "testInstance must not be null.");
		
		if(couldNotLoadApplicationContext) {
			throw new Error("Application context could not be loaded.");	
		}
		
		function prepTestInstance():void {
			for each(var testExecutionListener:ITestExecutionListener in _testExecutionListeners) {
				try {
					testExecutionListener.prepareTestInstance(_testContext);
				} catch(e:Error) {
					LOGGER.error("Caught exception while allowing ITestExecutionListener " + testExecutionListener + " to prepare test instance " + testInstance + ".");
					throw e;
				}
			}
		}
		
		function complete(event:Event):void {
			_testContext.getApplicationContext().removeEventListener(Event.COMPLETE, complete);
			
			if(_testContext.contextLoader.couldNotLoadContext) {
				LOGGER.error("There was an error preparing the test instance.");
				throw new Error("Error preparing test instance.");
			}
			
			prepTestInstance();
		}
		
		_testContext.updateState(testInstance, null, null);	
		
		if(applicationContextLoaded) {
			prepTestInstance();
		} else {
			_testContext.getApplicationContext().addEventListener(Event.COMPLETE, complete);	
		}
	}
	
	/**
	 * Register the supplied [TestExecutionListeners] by appending them to
	 * the set of listeners used by this <code>TestContextManager</code>.
	 */
	public function registerTestExecutionListeners(testExecutionListeners:Array):void {
		for each(var listener:ITestExecutionListener in testExecutionListeners) {
			_testExecutionListeners.push(listener);
		}
	}
	
	/**
	 * Retrieves an array of newly instantiated [TestExecutionListeners] for 
	 * the specified class. If [TestExecutionListeners] is not
	 * <em>present</em> on the supplied class, the default listeners will be
	 * returned.
	 * <p>Note that the inheritListeners flag of [TestExecutionListeners] will 
	 * be taken into consideration. Specifically, if the 
	 * <code>inheritListeners</code> flag is set to <code>true</code>, listeners 
	 * defined in the annotated class will be appended to the listeners defined i
	 * n superclasses.
	 * 
	 * @param clazz the Class object corresponding to the test class for which
	 * the listeners should be retrieved
	 * @return an array of <code>ITestExecutionListener</code>s for the specified class
	 */
	private function retrieveTestExecutionListeners(clazz:Class):Array {
		Assert.notNull(clazz, "Class must not be null.");
		
		var metadataName:String = TestExecutionListeners.name;
		var classesList:Array = [];
		var declaringClass:Class = MetadataUtils.findMetadataDeclaringClass(metadataName, clazz);
		var defaultListeners:Boolean = false;
				
		if(declaringClass == null) {
			if(LOGGER.infoEnabled) {
				LOGGER.info("[TestExecutionListeners] is not present for class " + clazz + " using defaults.");
			}
			
			classesList = getDefaultTestExecutionListenerClassses();
			defaultListeners = true;			
		} else {
			while(declaringClass != null) {
				var declaringClassType:Type = Type.forClass(declaringClass);
				var testExecutionListeners:TestExecutionListeners = new TestExecutionListeners(declaringClassType.getMetaData(metadataName)[0]);
				var classes:Array = testExecutionListeners.value;
				if(classes != null) {
					classesList = classes.concat(classesList)
				}
				declaringClass = testExecutionListeners.inheritsListeners
					? MetadataUtils.findMetadataDeclaringClass(metadataName, ClassUtils.getSuperClass(declaringClass))
					: null;
			}
		}
		
		var listeners:Array = [];
		
		for each(var listener:* in classesList) {
			if(listener is Class) {
				listeners.push(new listener());
			} else {
				try {
					var listenerClass:Class = ApplicationDomain.currentDomain.getDefinition(listener) as Class;
					listeners.push(new listenerClass());
				} catch(e:ReferenceError) {
					if(defaultListeners) {
						if(LOGGER.debugEnabled)  {
							LOGGER.debug("Could not instantiate default TestExecutionListener class [" + listener
								+ "]. Specify custom listener classes or make the default listener classes available.");
						}
					} else  {
						throw e;
					}
				}
			}
		}
		
		return listeners;
	}
}
}