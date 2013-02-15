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
	
	import flash.utils.Dictionary;
	
	import org.springextensions.actionscript.cairngorm.business.IBusinessDelegateFactory;
	
	/**
	 * @inheritDoc
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 */
	public class ResponderCommandFactory extends CommandFactory implements IResponderCommandFactory {
		
		private var _businessDelegateFactories:Dictionary = new Dictionary();
		
		/**
		 * Creates a new <code>ResponderCommandFactory</code> instance.
		 */
		public function ResponderCommandFactory() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function addBusinessDelegateFactory(factory:IBusinessDelegateFactory, commandClasses:Array):void {
			for (var i:int = 0; i < commandClasses.length; i++) {
				_businessDelegateFactories[commandClasses[i]] = factory;
			}
		}
		
		/**
		 * Returns true if the current <code>ResponderCommandFactory</code> contains a <code>IBusinessDelegateFactory</code>
		 * that is able to configure the specified <code>Class</code>.
		 */
		override public function canCreate(clazz:Class):Boolean {
			return (lookupBusinessDelegateFactory(clazz) != null);
		}
		
		/**
		 * Creates an instance of the specified <code>Class</code> and assigns it an appropriate business delegate.
		 */
		override public function createCommand(clazz:Class):ICommand {
			var result:AbstractResponderCommand = super.createCommand(clazz) as AbstractResponderCommand;
			var delegateFactory:IBusinessDelegateFactory = lookupBusinessDelegateFactory(clazz);
			delegateFactory.responder = result;
			result.businessDelegate = delegateFactory.createBusinessDelegate();
			return result;
		}
		
		/**
		 * Returns null or a valid <code>IBusinessDelegateFactory</code> instance if the current <code>ResponderCommandFactory</code> contains a <code>IBusinessDelegateFactory</code>
		 * that is able to configure the specified <code>Class</code>.
		 * @param commandClass The specified command <code>Class</code>
		 * @return null or a valid <code>IBusinessDelegateFactory</code> instance.
		 */
		protected function lookupBusinessDelegateFactory(commandClass:Class):IBusinessDelegateFactory {
			return _businessDelegateFactories[commandClass];
		}
	}
}
