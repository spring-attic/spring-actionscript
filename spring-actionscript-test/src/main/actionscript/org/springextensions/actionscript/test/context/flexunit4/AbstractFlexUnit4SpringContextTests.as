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
package org.springextensions.actionscript.test.context.flexunit4 {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.context.IApplicationContextAware;

[RunWith("org.springextensions.actionscript.test.context.flexunit4.SpringFlexUnit4ClassRunner")]
[TestExecutionListeners("org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener,org.springextensions.actionscript.test.context.support.DirtiesContextTestExecutionListener")]
public class AbstractFlexUnit4SpringContextTests implements IApplicationContextAware {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	protected const LOGGER:ILogger = LoggerFactory.getClassLogger(getDefinitionByName(getQualifiedClassName(this)) as Class);
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Force compile time inclusion of the test runner.
	 */
	private var runner:SpringFlexUnit4ClassRunner;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AbstractFlexUnit4SpringContextTests() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  applicationContext
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the applicationContext property.
	 */
	protected var _applicationContext:IApplicationContext;

	/**
	 * Set the <code>IApplicationContext</code> to be used by this test instance.
	 */
	public function get applicationContext():IApplicationContext {
		return _applicationContext;
	}
	
	/**
	 * @private
	 */
	public function set applicationContext(value:IApplicationContext):void {
		_applicationContext = value;
	}	
}
}