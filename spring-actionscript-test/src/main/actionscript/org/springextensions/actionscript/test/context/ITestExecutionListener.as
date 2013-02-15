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
/**
 * <p>
 * <code>ITestExecutionListener</code> defines a listener API for
 * reacting to test execution events published by the TestContextManager
 * with which the listener is registered.
 * </p>
 * <p>
 * Concrete implementations must provide a <code>public</code> no-args
 * constructor, so that listeners can be instantiated transparently by tools and
 * configuration mechanisms.
 * </p>
 * <p>
 * Spring provides the following out-of-the-box implementations:
 * </p>
 * <ul>
 * <li>org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener</li>
 * </ul>
 *
 * @author Andrew Lewisohn
 * @since 1.1
 * @see TestContextManager
 * @see org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener
 */
public interface ITestExecutionListener {

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Post-processes a test just <em>after</em> execution of the test method in
	 * the supplied test context, for example for tearing down test fixtures.
	 * 
	 * @param testContext the test context in which the test method was
	 * 	executed (never <code>null</code>)
	 * @throws Error allows any exception to propagate
	 */
	function afterTestMethod(testContext:TestContext):void;
	
	/**
	 * Pre-processes a test just <em>before</em> execution of the test method in 
	 * the supplied test context, for example for setting up test fixtures.
	 * 
	 * @param testContext the test context in which the test method will be
	 * 	executed (never <code>null</code>)
	 * @throws Error allows any exception to propagate
	 */
	function beforeTestMethod(testContext:TestContext):void;
	
	/**
	 * Prepares the test instance of the supplied test context. For example,
	 * by injecting dependencies.
	 * 
	 * <p>This method should be called immediately after instantiation but prior to
	 * any framework-specific lifecycle callbacks.</p>
	 * 
	 * @param testContext the test context for the test (never <code>null</code>)
	 * @throws Error allows any exception to propagate
	 */
	function prepareTestInstance(testContext:TestContext):void;
}
}