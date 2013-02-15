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
	
	import org.springextensions.actionscript.cairngorm.business.IBusinessDelegateFactory;
	
	/**
	 * Implemented by objects that can create <code>ICommand</code> instances and configure them
	 * with the <code>IBusinessDelegateFactory</code> instances added with the <code>addBusinessDelegateFactory</code> method.
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 */
	public interface IResponderCommandFactory extends ICommandFactory {
		
		/**
		 * Adds a <code>IBusinessDelegateFactory</code> that will be used to inject business delegates in the created <code>ICommand</code> instances.
		 */
		function addBusinessDelegateFactory(businessDelegateFactory:IBusinessDelegateFactory, commandClasses:Array):void;
	
	}
}
