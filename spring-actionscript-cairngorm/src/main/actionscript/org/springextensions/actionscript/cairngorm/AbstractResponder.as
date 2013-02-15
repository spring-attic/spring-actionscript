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
package org.springextensions.actionscript.cairngorm {
	
	import com.adobe.cairngorm.commands.ICommand;
	
	import flash.errors.IllegalOperationError;
	
	import mx.rpc.IResponder;
	
	/**
	 * Abstract responder base class.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractResponder implements IResponder {
		
		/**
		 * Creates an AbstractResponder instance.
		 * Abstract class should never be instantiated directly.
		 * AbstractResponder implementations should pass themselves to the AbstractResponder's constructor.
		 * @param self A reference to the <code>AbstractResponder</code> itself.
		 * @throws flash.errors.IllegalOperationError when the <code>self</code> constructor argument is not equal to the current <code>AbstractResponder</code>.
		 */
		public function AbstractResponder(self:AbstractResponder) {
			if (self != this) {
				throw new IllegalOperationError("AbstractResponder is abstract");
			}
		}
		
		/**
		 * Invokes the <code>unregister()</code> method.
		 */
		public function result(data:Object):void {
			unregister();
		}
		
		/**
		 * Invokes the <code>unregister()</code> method.
		 */
		public function fault(info:Object):void {
			unregister();
		}
		
		/**
		 * Checks if the current <code>AbstractResponder</code> implements the <code>ICommand</code> interface and, if so,
		 * invokes the <code>unregister()</code> method on the <code>PendingCommandRegistry</code> singleton.
		 * @see org.springextensions.actionscript.cairngorm.PendingCommandRegistry PendingCommandRegistry
		 */
		protected function unregister():void {
			if (this is ICommand) {
				PendingCommandRegistry.getInstance().unregister(this as ICommand);
			}
		}
	}
}
