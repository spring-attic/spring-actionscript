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
package org.springextensions.actionscript.test.context.flexunit4.internals.runners.statements {
import org.as3commons.lang.Assert;
import org.as3commons.reflect.Method;
import org.flexunit.internals.runners.statements.StatementSequencer;
import org.springextensions.actionscript.test.context.TestContextManager;

/**
 * Provides an abstract implementation for Spring Flex Unit 4 statements.
 * 
 * @author Andrew Lewisohn
 * @since 1.1
 */
public class AbstractSpringFlexUnit4Statement extends StatementSequencer {
	
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
	public function AbstractSpringFlexUnit4Statement(testInstance:Object, testMethod:Method, testContextManager:TestContextManager) {
		Assert.notNull(testInstance, "'testInstance' cannot be null.");
		Assert.notNull(testMethod, "'testMethod' cannot be null.");
		Assert.notNull(testContextManager, "'testContextManager' cannot be null.");		
		
		_testContextManager = testContextManager;
		_testInstance = testInstance;
		_testMethod = testMethod;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  testContextManager
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the testContextManager property.
	 */
	private var _testContextManager:TestContextManager;

	/**
	 * The test context manager.
	 */
	protected function get testContextManager():TestContextManager {
		return _testContextManager;
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
	 * The current test instance.
	 */
	protected function get testInstance():Object {
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
	 * The current test method.
	 */
	protected function get testMethod():Method {
		return _testMethod;
	}	
}
}