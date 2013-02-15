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
import org.as3commons.lang.Assert;
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.reflect.Method;
import org.springextensions.actionscript.test.context.TestContext;

/**
 * <code>ITestExecutionListener<code> which processes test methods configured
 * with the [DirtiesContext] metadata.
 *
 * @author Andrew Lewisohn
 * @since 1.1
 */
public class DirtiesContextTestExecutionListener extends AbstractTestExecutionListener {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(DirtiesContextTestExecutionListener);
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DirtiesContextTestExecutionListener() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * If the current test method of the supplied test context has been annotated 
	 * with [DirtiesContext] metadata, the application context of the test 
	 * context will be marked as dirty, and the 
	 * DependencyInjectionTestExecutionListener#REINJECT_DEPENDENCIES_ATTRIBUTE
	 * will be set to <code>true</code> in the test context.
	 */
	override public function afterTestMethod(testContext:TestContext):void {
		var testMethod:Method = testContext.testMethod;
		Assert.notNull(testMethod, "The test method of the supplied TestContext must not be null.");
		
		var dirtiesContext:Boolean = testMethod.hasMetaData("DirtiesContext");
		
		if(LOGGER.debugEnabled) {
			LOGGER.debug("After test method: context [" + testContext + "], dirtiesContext [" + dirtiesContext + "]."); 
		}
		
		if(dirtiesContext) {
			testContext.markApplicationContextDirty();
			testContext.setAttribute(DependencyInjectionTestExecutionListener.REINJECT_DEPENDENCIES_ATTRIBUTE, true);
		}
	}
}
}