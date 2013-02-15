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
package org.springextensions.actionscript.test.context.flexunit4.internals.runners.statements
{
import org.as3commons.reflect.Method;
import org.flexunit.token.AsyncTestToken;
import org.springextensions.actionscript.test.context.TestContextManager;

/**
 * The <code>SpringFlexUnit4RunAfters</code> should be run after a test has completed.
 * 
 * @author Andrew Lewisohn
 * @since 1.1
 */
public class SpringFlexUnit4RunAfters extends AbstractSpringFlexUnit4Statement {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param testInstance The current test instance.
	 * @param testMethod The current test method.
	 * @param testContextManager The test context manager.
	 */
	public function SpringFlexUnit4RunAfters(testInstance:Object, testMethod:Method, testContextManager:TestContextManager) {
		super(testInstance, testMethod, testContextManager);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Execute <code>ITestExecutionListeners</code> that have been registered for
	 * the current <code>TestContext</code>.
	 */
	override public function evaluate(parentToken:AsyncTestToken):void {
		testContextManager.afterTestMethod(testInstance, testMethod, parentToken.error);
		super.evaluate(parentToken);
	}
}
}