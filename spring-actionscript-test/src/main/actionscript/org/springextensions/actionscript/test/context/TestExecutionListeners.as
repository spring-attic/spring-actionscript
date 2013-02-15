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
import org.as3commons.lang.IllegalArgumentError;
import org.as3commons.reflect.MetaData;

/**
 * TestExecutionListeners defines class-level metadata for configuring which
 * instances of ITestExecutionListener should be registeredwith a TestContextManager. 
 * Typically, [TestExecutionListeners] will be used in conjunction with 
 * [ContextConfiguration].
 *
 * @author Andrew Lewisohn
 * @see ITestExecutionListener
 * @see TestContextManager
 * @see ContextConfiguration
 */
public class TestExecutionListeners {

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The name of the metadata tag that defines a [TestExecutionListeners].
	 */
	public static function get name():String {
		return "TestExecutionListeners";
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * The underlying metadata instance. 
	 */
	private var metadata:MetaData;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param metadata The underlying metadata instance. 
	 */
	public function TestExecutionListeners(metadata:MetaData) {
		if(metadata.name != name) {
			throw new IllegalArgumentError("Metadata tag must be [" + name + "].");
		}
		
		this.metadata = metadata;	
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  inheritsListeners
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the inheritsListeners property.
	 */
	private var _inheritsListeners:Boolean = true;
	
	private var inheritsListenersRead:Boolean = false;
	
	/**
	 * <p>
	 * Whether or not <code>value</code> from superclasses should be 
	 * <em>inherited</em>.
	 * </p>
	 * <p>
	 * The default value is <code>true</code>, which means that an annotated
	 * class will <em>inherit</em> the listeners defined by an annotated
	 * superclass. Specifically, the listeners for an annotated class will be
	 * appended to the list of listeners defined by an annotated superclass.
	 * Thus, subclasses have the option of <em>extending</em> the list of
	 * listeners. In the following example, <code>AbstractBaseTest</code> will
	 * be configured with <code>DependencyInjectionTestExecutionListener</code>
	 * and <code>AnotherTestExecutionListener</code>; whereas,
	 * <code>TestClass</code> will be configured with
	 * <code>DependencyInjectionTestExecutionListener</code>,
	 * <code>AnotherTestExecutionListener</code>, and
	 * <code>YetAnotherTestExecutionListener</code>, in that order.
	 * </p>
	 *
	 * <pre class="code">
	 * [TestExecutionListeners("org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener,
	 *     org.springextensions.actionscript.test.context.support.AnotherTestExecutionListener")]
	 * public abstract class AbstractBaseTest {
	 *     // ...
	 * }
	 * 
	 * [TestExecutionListeners("org.springextensions.actionscript.test.context.support.YetAnotherTestExecutionListener")]
	 * public class TestClass extends BaseTest {
	 *     // ...
	 * }
	 * </pre>
	 *
	 * <p>
	 * If <code>inheritListeners</code> is set to false, the
	 * listeners for the annotated class will <em>shadow</em> and effectively
	 * replace any listeners defined by a superclass.
	 * </p>
	 * 
	 * @defaultValue <code>true</code>
	 */
	public function get inheritsListeners():Boolean {
		if(!inheritsListenersRead) {
			if(metadata.hasArgumentWithKey("inheritsListeners")) {
				_inheritsListeners = metadata.getArgument("inheritsListeners").value == "true";
			}
			
			inheritsListenersRead = true;
		}
		
		return _inheritsListeners;
	}

	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the value property.
	 */
	private var _value:Array = null;
	
	/**
	 * <p>
	 * The fully qualified class names of instances of ITestExecutionListener 
	 * to register with a TestContextManager.
	 * </p>
	 * <p>
	 * Any classes that are refernced must be linked into the compiled SWF/SWC 
	 * or they will not be available at runtime.
	 * </p>
	 *
	 * @defaultValue empty array
	 * @see org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener
	 */
	public function get value():Array {
		if(_value == null) {
			if(metadata.hasArgumentWithKey("")) {
				_value = metadata.getArgument("").value.split(/\s*,\s*/g);
			} else {
				_value = [];
			}
		}
		
		return _value;
	}
}
}