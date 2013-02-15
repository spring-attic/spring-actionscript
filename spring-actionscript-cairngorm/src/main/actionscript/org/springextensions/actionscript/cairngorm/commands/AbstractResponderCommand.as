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
package org.springextensions.actionscript.cairngorm.commands {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.errors.IllegalOperationError;
	
	import mx.rpc.IResponder;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.cairngorm.business.IBusinessDelegate;
	import org.springextensions.actionscript.cairngorm.business.IBusinessDelegateAware;
	
	/**
	 * Base class for command classes that can act as a responder for their assigned business delegate.
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 * @inheritDoc
	 */
	public class AbstractResponderCommand implements ICommand, IBusinessDelegateAware, IResponder {
		
		private var _businessDelegate:IBusinessDelegate;
		
		/**
		 * Creates a new <code>AbstractResponderCommand</code> instance.
		 */
		public function AbstractResponderCommand() {
		}
		
		/**
		 * A <code>IBusinessDelegate</code> used by the current <code>AbstractResponderCommand</code>, the current instance
		 * will set itself as the responder to this <code>IBusinessDelegate</code> instance.
		 */
		public function get businessDelegate():IBusinessDelegate {
			return _businessDelegate;
		}
		/**
		 * @private
		 */		
		public function set businessDelegate(value:IBusinessDelegate):void {
			_businessDelegate = value;
		}
		
		/**
		 * Executes the current <code>AbstractResponderCommand</code>, this is where the <code>IBusinessDelegate</code> will need to be invoked.
		 * @see org.springextensions.actionscript.cairngorm.business.IBusinessDelegate IBusinessDelegate
		 */
		public function execute(event:CairngormEvent):void {
			Assert.state(businessDelegate != null, "The business delegate cannot be null");
		}
		
		/**
		 * Method used ot handle the <code>IBusinessDelegate</code> result. 
		 * @see org.springextensions.actionscript.cairngorm.business.IBusinessDelegate IBusinessDelegate
		 */
		public function result(data:Object):void {
			throw new IllegalOperationError("result must be implemented");
		}
		
		/**
		 * Method used ot handle the <code>IBusinessDelegate</code> fault. 
		 * @see org.springextensions.actionscript.cairngorm.business.IBusinessDelegate IBusinessDelegate
		 */
		public function fault(info:Object):void {
			throw new IllegalOperationError("fault must be implemented");
		}
	}
}
