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
package org.springextensions.actionscript.core.task.command {
	import flash.events.EventDispatcher;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.command.ICommand;
	import org.springextensions.actionscript.core.task.ITaskFlowControl;
	import org.springextensions.actionscript.core.task.TaskFlowControlKind;
	import org.springextensions.actionscript.core.task.event.TaskFlowControlEvent;

	/**
	 * 
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#tasks
	 */
	public class TaskFlowControlCommand extends EventDispatcher implements ICommand, ITaskFlowControl {
		private var _kind:TaskFlowControlKind;

		/**
		 * Creates a new <code>TaskFlowControlCommand</code> instance.
		 * @param kind
		 */
		public function TaskFlowControlCommand(kind:TaskFlowControlKind) {
			Assert.notNull(kind, "The kind argument must not be null");
			super();
			_kind = kind;
		}

		public function execute():* {
			dispatchEvent(new TaskFlowControlEvent(this.kind));
			return this.kind;
		}

		public function get kind():TaskFlowControlKind {
			return _kind;
		}

	}
}