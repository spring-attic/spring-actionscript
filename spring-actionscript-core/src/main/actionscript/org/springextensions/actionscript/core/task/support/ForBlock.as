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
package org.springextensions.actionscript.core.task.support {
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.command.ICommand;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.OperationEvent;
	import org.springextensions.actionscript.core.task.ICountProvider;
	import org.springextensions.actionscript.core.task.IForBlock;
	import org.springextensions.actionscript.core.task.ITaskFlowControl;
	import org.springextensions.actionscript.core.task.event.TaskEvent;
	import org.springextensions.actionscript.core.task.event.TaskFlowControlEvent;

	/**
	 * @inheritDoc
	 */
	public class ForBlock extends AbstractTaskBlock implements IForBlock {

		/**
		 * Creates a new <code>ForBlock</code> instance.
		 * @param countProvider an <code>ICountProvider</code> that will determine whether the current <code>ForBlock</code>'s logic will be executed or not.
		 */
		public function ForBlock(countProvider:ICountProvider) {
			Assert.notNull(countProvider,"countProvider argument must not be null");
			super();
			_countProvider = countProvider;
		}

		private var _countProvider:ICountProvider;
		public function get countProvider():ICountProvider {
			return _countProvider;
		}

		public function set countProvider(value:ICountProvider):void {
			_countProvider = value;
		}
		
		override public function execute():* {
			finishedCommandList = [];
			var async:IOperation = _countProvider as IOperation;
			if (async != null) {
				if (async.result == null){
					addCountListeners(async);
				}
				if (_countProvider is ICommand){
					ICommand(_countProvider).execute();
				} else {
					startExecution();
				}
			} else {
				startExecution();
			}
		}
		
		protected function startExecution():void {
			_count = _countProvider.getCount();
			executeBlock();
		}
		
		private var _count:uint;
		protected function executeBlock():void {
			if (_count > 0) {
				finishedCommandList = [];
				executeNextCommand();
			} else {
				completeExecution();
			}
		}
		
		override protected function executeCommand(command:ICommand):void {
			currentCommand = command;
			if (command) {
				if (doFlowControlCheck(command as ITaskFlowControl)){
					var async:IOperation = command as IOperation;
					addCommandListeners(async);
					dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
					command.execute();
					if (async == null) {
						dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
						executeNextCommand();
					}
				}
			} else {
				restartExecution();
			}
		}
		
		override protected function restartExecution():void {
			resetCommandList();
			_count--;
			executeBlock();
		}
		
		protected function onCountResult(event:OperationEvent):void {
			removeCountListeners(event.target as IOperation);
			startExecution();
		}

		protected function onCountFault(event:OperationEvent):void {
			removeCountListeners(event.target as IOperation);
			dispatchErrorEvent(event.target as IOperation);
		}
		
		protected function addCountListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.addCompleteListener(onCountResult);
				asyncCommand.addErrorListener(onCountFault);
			}
		}

		protected function removeCountListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.removeCompleteListener(onCountResult);
				asyncCommand.removeErrorListener(onCountFault);
			}
		}
		
		override protected function TaskFlowControlEvent_handler(event:TaskFlowControlEvent):void {
			switch(event.type){
				case TaskFlowControlEvent.BREAK:
					resetCommandList();
					completeExecution();
					break;
				case TaskFlowControlEvent.CONTINUE:
					restartExecution();
					break;
				case TaskFlowControlEvent.EXIT:
					exitExecution();
					break;
				default:
					break;
			}
		}

	}
}