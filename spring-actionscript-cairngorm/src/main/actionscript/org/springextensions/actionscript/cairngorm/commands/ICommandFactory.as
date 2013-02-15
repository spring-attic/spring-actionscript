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
	
	/**
	 * Implemented by factory objects that are capable of creating <code>ICommand</code> instances.
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 */
	public interface ICommandFactory {
		
		/**
		 * Returns true if the current <code>ICommandFactory</code> is able to create the specified <code>Class</code>
		 * @param clazz The specified <code>Class</code> instance.
		 * @return True if the factory is able to create the specified <code>Class</code> instance.
		 */
		function canCreate(clazz:Class):Boolean;
		
		/**
		 * Creates a command for the passed command type
		 *
		 * @param clazz The Command Type
		 *
		 * @return The new <code>ICommand</code> instance
		 */
		function createCommand(clazz:Class):ICommand;
	}
}
