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
	
	import org.as3commons.lang.ClassUtils;
	
	/**
	 * <code>ICommandFactory</code> implementation that is capable of creating commands that implements the <code>ICommand</code> interface.
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 */
	public class CommandFactory implements ICommandFactory {
		
		/**
		 * Creates a new <code>CommandFactory</code> instance.
		 */
		public function CommandFactory() {
		}
		
		/**
		 * Returns true if the specified <code>Class</code> implements the <code>ICommand</code> interface
		 */
		public function canCreate(clazz:Class):Boolean {
			return ClassUtils.isImplementationOf(clazz, ICommand);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function createCommand(clazz:Class):ICommand {
			var result:ICommand = new clazz();
			return result;
		}
	}
}
