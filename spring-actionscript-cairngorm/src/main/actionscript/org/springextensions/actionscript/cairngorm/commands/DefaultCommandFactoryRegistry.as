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
	
	import org.as3commons.lang.Assert;
	
	/**
	 * <p>Default implementation of the <code>ICommandFactoryRegistry</code> interface.
	 * @inheritDoc
	 */
	public class DefaultCommandFactoryRegistry implements ICommandFactoryRegistry {
		
		private var _commandFactories:Array = [];
		
		/**
		 * Creates a new <code>DefaultCommandFactoryRegistry</code> instance.
		 */
		public function DefaultCommandFactoryRegistry()	{
		}

		/**
		 * @inheritDoc
		 */
		public function addCommandFactory(factory:ICommandFactory):void {
			Assert.notNull(factory, "The command factory cannot be null");
			_commandFactories.unshift(factory);
		}
		
		/**
		 * @inheritDoc
		 */
		public function createCommand(commandClass:Class):ICommand {
			Assert.notNull(commandClass, "The commandClass cannot be null");
			var result:ICommand;
			
			for (var i:int = 0; i < _commandFactories.length; i++) {
				var factory:ICommandFactory = _commandFactories[i] as ICommandFactory;
				
				if (factory.canCreate(commandClass)) {
					result = factory.createCommand(commandClass);
					break;
				}
			}
			
			return result;
		}
		
	}
}