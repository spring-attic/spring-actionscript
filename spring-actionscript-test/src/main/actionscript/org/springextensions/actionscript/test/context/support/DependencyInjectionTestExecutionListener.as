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
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.springextensions.actionscript.context.IApplicationContextAware;
import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
import org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory;
import org.springextensions.actionscript.test.context.TestContext;
import org.springextensions.actionscript.utils.NameUtils;

/**
 * <code>ITestExecutionListener</code> which provides support for dependency
 * injection and initialization of test instances.
 *
 * @author Andrew Lewisohn
 */
public class DependencyInjectionTestExecutionListener extends AbstractTestExecutionListener {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(DependencyInjectionTestExecutionListener);
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Attribute name for a TestContext attribute that indicates whether or not 
	 * the dependencies of a test instance should be <em>reinjected</em> in
	 * beforeTestMethod(). Note that dependencies will be injected in 
	 * prepareTestInstance() in any case.
	 * 
	 * <p>
	 * Clients of a TestContext (e.g., other TestExecutionListeners) may therefore 
	 * choose to set this attribute to signal that dependencies should be 
	 * reinjected <em>between</em> execution of individual test methods.
	 * </p>
	 * 
	 * <p>
	 * Permissible values include <code>true</code> and <code>false</code>.
	 * </p>
	 */
	public static const REINJECT_DEPENDENCIES_ATTRIBUTE:String = NameUtils.getQualifiedAttributeName(
		DependencyInjectionTestExecutionListener, "reinjectDependencies");
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DependencyInjectionTestExecutionListener() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * If the REINJECT_DEPENDENCIES_ATTRIBUTE in the supplied test context has a 
	 * value of <code>true</code> this method will have the same effect as
	 * <code>prepareTestInstance()</code> otherwise, this method will have no 
	 * effect.
	 */
	override public function beforeTestMethod(testContext:TestContext):void {
		if(testContext.getAttribute(REINJECT_DEPENDENCIES_ATTRIBUTE)) {
			if(LOGGER.debugEnabled) {
				LOGGER.debug("Reinjecting dependencies for test context " + testContext + ".");
			}
			injectDependencies(testContext);
		}
	}
	
	/**
	 * Performs dependency injection on the test instance of the supplied
	 * test context by initializing the test instance via its own application 
	 * context (without checking dependencies).
	 */
	override public function prepareTestInstance(testContext:TestContext):void {
		if(LOGGER.debugEnabled) {
			LOGGER.debug("Performing dependency injection for test context " + testContext + ".");
		}		
		injectDependencies(testContext);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Performs dependency injection and object initialization for the supplied
	 * as described in <code>prepareTestInstance()</code>.
	 * 
	 * @param testContext the test context for which dependency injection should
	 * 	be performed (never <code>null</code>)
	 * @throws Error allows any error to propagate
	 * @see #prepareTestInstance()
	 */
	protected function injectDependencies(testContext:TestContext):void {
		var object:Object = testContext.testInstance;
		if(object is IApplicationContextAware) {
			IApplicationContextAware(object).applicationContext = testContext.getApplicationContext();
		}
		
		try {
			var beanFactory:IAutowireProcessor = AbstractObjectFactory(testContext.getApplicationContext()).autowireProcessor;
			beanFactory.autoWire(object);
		} catch(e:Error) {
			LOGGER.warn(e.message);
		}
	}
}
}