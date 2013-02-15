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
import org.springextensions.actionscript.test.context.TestContext;
import org.springextensions.actionscript.test.context.ITestExecutionListener;

/**
 * Abstract implementation of the <code>ITestExecutionListener</code> interface 
 * which provides empty method stubs. Subclasses can extend this class and 
 * override only those methods suitable for the task at hand.
 *
 * @author Andrew Lewisohn
 * @see org.springextensions.actionscript.test.context.ITestExecutionListener
 */
public class AbstractTestExecutionListener implements ITestExecutionListener {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AbstractTestExecutionListener() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The default implementation is <em>empty</em>. Can be overridden by
	 * subclasses as necessary.
	 */
	public function afterTestMethod(testContext:TestContext):void {
		/* no-op */	
	}
	
	/**
	 * The default implementation is <em>empty</em>. Can be overridden by
	 * subclasses as necessary.
	 */
	public function beforeTestMethod(testContext:TestContext):void {
		/* no-op */	
	}
	
	/**
	 * The default implementation is <em>empty</em>. Can be overridden by
	 * subclasses as necessary.
	 */
	public function prepareTestInstance(testContext:TestContext):void {
		/* no-op */	
	}
}
}