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
package org.springextensions.actionscript.test.context.flexunit4
{
import flash.utils.setTimeout;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Type;
import org.flexunit.internals.AssumptionViolatedException;
import org.flexunit.internals.runners.InitializationError;
import org.flexunit.internals.runners.model.EachTestNotifier;
import org.flexunit.internals.runners.statements.Fail;
import org.flexunit.internals.runners.statements.IAsyncStatement;
import org.flexunit.internals.runners.statements.StatementSequencer;
import org.flexunit.runner.IDescription;
import org.flexunit.runner.notification.IRunNotifier;
import org.flexunit.runners.BlockFlexUnit4ClassRunner;
import org.flexunit.runners.ParentRunner;
import org.flexunit.runners.model.FrameworkMethod;
import org.flexunit.token.AsyncTestToken;
import org.flexunit.token.ChildResult;
import org.flexunit.utils.ClassNameUtil;
import org.springextensions.actionscript.test.context.TestContextManager;
import org.springextensions.actionscript.test.context.flexunit4.internals.runners.statements.SpringFlexUnit4RunAfters;
import org.springextensions.actionscript.test.context.flexunit4.internals.runners.statements.SpringFlexUnit4RunBefores;

/**
 * SpringFlexUnit4ClassRunner is a custom extension of BlockFlexUnit4ClassRunner
 * which provides functionality of the <em>Spring TestContext Framework</em>
 * to standard FlexUnit 4.0+ tests by means of the TestContextManager and
 * associated support classes and metadata.
 * 
 * @author Andrew Lewisohn
 * @see TestContextManager
 */
public class SpringFlexUnit4ClassRunner extends BlockFlexUnit4ClassRunner {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(SpringFlexUnit4ClassRunner);
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructs a new <code>SpringFlexUnit4ClassRunner</code> and initializes 
	 * a <code>TestContextManager</code> to provide Spring testing functionality 
	 * to standard FlexUnit tests.
	 * 
	 * @param clazz the Class object corresponding to the test class to be run
	 * @see #createTestContextManager()
	 * @throws org.flexunit.internals.runners.InitializationError
	 */
	public function SpringFlexUnit4ClassRunner(klass:Class) {
		super(klass);
		
		if(LOGGER.debugEnabled) {
			LOGGER.debug("SpringFlexUnit4ClassRunner constructor called with " + klass + ".");
		}
		
		_testContextManager = createTestContextManager(klass);
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
	 * Get the TestContextManager associated with this runner.
	 */
	protected final function get testContextManager():TestContextManager {
		return _testContextManager;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Delegates to <code>BlockFlexUnit4ClassRunner#createTest()</code> to create 
	 * the test instance and then to a TestContextManager to prepare the test
	 * instance for Spring testing functionality.
	 * 
	 * @see org.flexunit.runners.BlockFlexUnit4ClassRunner#createTest()
	 * @see TestContextManager#prepareTestInstance()
	 */
	override protected function createTest():Object {
		var testInstance:Object = super.createTest();
		try {
			_testContextManager.prepareTestInstance(testInstance);
		} catch(e:Error) {
			throw new InitializationError(e.message);
		}
		return testInstance;
	}
	
	/**
	 * @private
	 */
	override protected function methodBlock(frameworkMethod:FrameworkMethod):IAsyncStatement {
		var c:Class;
		
		var test:Object;
		var method:Method;
		
		//might need to be reflective at some point
		try {
			test = createTest();
			method = Type.forInstance(test).getMethod(frameworkMethod.name);
		} catch (e:Error) {
			trace(e.getStackTrace());
			return new Fail(e);
		}
		
		var sequencer:StatementSequencer = new StatementSequencer();
		
		sequencer.addStep(new SpringFlexUnit4RunBefores(test, method, _testContextManager));
		sequencer.addStep(withBefores(frameworkMethod, test));
		sequencer.addStep(withDecoration(frameworkMethod, test));
		sequencer.addStep(withAfters(frameworkMethod, test));
		sequencer.addStep(new SpringFlexUnit4RunAfters(test, method, _testContextManager));
		
		return sequencer;
	}
	
	/**
	 * @private
	 */
	override protected function runChild(child:*, notifier:IRunNotifier, childRunnerToken:AsyncTestToken):void {
		var method:FrameworkMethod = FrameworkMethod(child); 
		var eachNotifier:EachTestNotifier = makeNotifier(method, notifier);
				
		//Determine if the method should be ignored and not run
		if(method.hasMetaData("Ignore")) {
			eachNotifier.fireTestIgnored();
			childRunnerToken.sendResult();
			return;
		}
		
		var token:AsyncTestToken = new AsyncTestToken(ClassNameUtil.getLoggerFriendlyClassName(this));
		token.parentToken = childRunnerToken;
		token.addNotificationMethod(handleBlockComplete);
		token[ParentRunner.EACH_NOTIFIER] = eachNotifier;
		
		runChildAfterContextLoaded(methodBlock(method), eachNotifier, token, childRunnerToken);
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new TestContextManager. Can be overridden by subclasses.
	 * @param clazz the Class object corresponding to the test class to be managed
	 */
	protected function createTestContextManager(klass:Class):TestContextManager {
		return new TestContextManager(klass);
	}
	
	/**
	 * Handles the result of the test method that has run and alerts the <code>IRunNotifier</code>
	 * about the results of the test.
	 * 
	 * @param result The <code>ChildResult</code> of the test method that has run.
	 */
	private function handleBlockComplete( result:ChildResult ):void {
		var error:Error = result.error;
		var token:AsyncTestToken = result.token;
		var eachNotifier:EachTestNotifier = result.token[EACH_NOTIFIER];
		
		//Determine if an assumption failed, if it did, ignore the test; otherwise, report the error
		if (error is AssumptionViolatedException) {
			eachNotifier.fireTestIgnored();
		} else if (error) {
			eachNotifier.addFailure(error);
		}
		
		eachNotifier.fireTestFinished();
		
		token.parentToken.sendResult();
	}
	
	/**
	 * Creates an <code>EachTestNotifier</code> based on the the description of the method and a notifer.
	 * 
	 * @param method The <code>FrameworkMethod</code> that is to be described.
	 * @param notifier The notifier to notify about the execution of the method.
	 * 
	 * @return an <code>EachTestNotifier</code>.
	 */
	private function makeNotifier( method:FrameworkMethod, notifier:IRunNotifier ):EachTestNotifier {
		var description:IDescription = describeChild(method);
		return new EachTestNotifier(notifier, description);
	}
	
	/**
	 * Responsible for preventing test execution until the IApplicationContext has been loaded.
	 * 
	 * @param block The <code>IAsyncStatement</code> to be executed.
	 * @param eachNotifier The <code>EachTestNotifier</code> that notifies the parent context.
	 * @param token An <code>AsyncTestToken</code>
	 * @param childRunnerToken An <code>AsyncTestToken</code> 
	 */
	private function runChildAfterContextLoaded(block:IAsyncStatement, eachNotifier:EachTestNotifier, token:AsyncTestToken, childRunnerToken:AsyncTestToken):void {
		if(_testContextManager.couldNotLoadApplicationContext) {
			throw new InitializationError("An application context could not be loaded.");
		}
		
		if(_testContextManager.applicationContextLoaded) {
			var error:Error;
			
			eachNotifier.fireTestStarted();
			try {
				block.evaluate(token);				
			} catch (e:AssumptionViolatedException) {
				error = e;
				eachNotifier.addFailedAssumption(e);
			} catch (e:Error) {
				error = e;
				eachNotifier.addFailure(e);
			} 
			
			if(error) {
				eachNotifier.fireTestFinished();
				childRunnerToken.sendResult();
			}
		} else {
			setTimeout(runChildAfterContextLoaded, 10, block, eachNotifier, token, childRunnerToken); 
		}		
	}
}
}