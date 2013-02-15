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
package org.springextensions.actionscript.stage {

	import flash.display.DisplayObject;
	import flash.display.Stage;

	import org.springextensions.actionscript.context.IApplicationContext;

	/**
	 * Describes an object that manages a collection of <code>IStageProcessor</code> instances.
	 * @author Roland Zwaga
	 * @docref container-documentation.html#the_istageprocessor_interface
	 * @sampleref stagewiring
	 */
	public interface IStageProcessorRegistry {

		function get stage():Stage;

		/**
		 * Determines if the current <code>IStageProcessorRegistry</code> is enabled.
		 */
		function get enabled():Boolean;

		/**
		 * @private
		 */
		function set enabled(value:Boolean):void;

		/**
		 * True if the current <code>IStageProcessorRegistry</code> has been initialized.
		 */
		function get initialized():Boolean;

		/**
		 * The number of <code>IObjectSelector</code> registrations.
		 */
		function get numRegistrations():uint;

		/**
		 * Performs initialization of the <code>IStageProcessorRegistry</code>.
		 */
		function initialize():void;

		/**
		 * Clears the all processor and context registrations in the current <code>IStageProcessorRegistry</code>
		 */
		function clear():void;

		/**
		 * Adds the specified <code>IStageProcessor</code> instance to the collection.
		 * @param name The name of the <code>IStageProcessor</code>, if an instance by that name and with the same document property already exists in the collection it will be replaced.
		 * @param stageProcessor The specified <code>IStageProcessor</code> instance.
		 */
		function registerStageProcessor(name:String, stageProcessor:IStageProcessor, objectSelector:IObjectSelector):void;

		/**
		 * Removes the <code>IStageProcessor</code> with the specified name.
		 * @param name The name of the <code>IStageProcessor</code> that will be removed
		 */
		function unregisterStageProcessor(name:String, document:Object):void;

		/**
		 * Retrieves a list of all the <code>IObjectSelectors</code> that have been registered with the current <code>IStageProcessorRegistry</code>.
		 * @return An <code>Array</code> of <code>IObjectSelectors</code>.
		 * @see org.springextensions.actionscript.stage.IObjectSelector IObjectSelector
		 */
		function getAllObjectSelectors():Array;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> that have been registered with the current <code>IStageProcessorRegistry</code>.
		 * @return An <code>Array</code> of <code>IStageProcessors</code>.
		 * @see org.springextensions.actionscript.stage.IStageProcessor IStageProcessor
		 */
		function getAllStageProcessors():Array;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> of the specified <code>Class</code>.
		 * @param type the specified <code>Class</code>.
		 * @return An <code>Array</code> of <code>IStageProcessors</code>.
		 */
		function getStageProcessorsByType(type:Class):Array;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> with the specified name.
		 * @param name The specified name
		 * @return An <code>Array</code> of <code>IStageProcessors</code>, or null if none was found.
		 *
		 */
		function getStageProcessorByName(name:String):Array;

		/**
		 * Retrieves the <code>IObjectSelector</code> instance that is associated with the specified <code>IStageProcessor</code> instance.
		 * @param stageProcessor The specified <code>IStageProcessor</code>.
		 * @return The <code>IObjectSelector</code> instance that is associated with the specified <code>IStageProcessor</code>, or null if none was found.
		 */
		function getObjectSelectorForStageProcessor(stageProcessor:IStageProcessor):IObjectSelector;

		/**
		 * Recursively loops through the stage displaylist and processes every object therein.
		 * @param startComponent Optionally a start component can be specified that will be used as the root for recursion.
		 */
		function processStage(startComponent:DisplayObject = null):void;

		/**
		 * Registers the specified <code>IApplicationContext</code> with the current <code>IStageProcessorRegistry</code> by associating
		 * it with the specified <code>parentDocument</code>.
		 * @param parentDocument The specified <code>parentDocument</code>, if this is not a <code>Module</code> the specified <code>IApplicationContext</code> will be associated with the current <code>Application</code>.
		 * @param applicationContext The specified <code>IApplicationContext</code>.
		 */
		function registerContext(parentDocument:Object, applicationContext:IApplicationContext):void;

		/**
		 * Unregisters the specified <code>IApplicationContext</code> with the current <code>IStageProcessorRegistry</code> by removing its association
		 * it with the specified <code>parentDocument</code>.
		 * @param parentDocument The specified <code>parentDocument</code>.
		 * @param applicationContext The specified <code>IApplicationContext</code>.
		 */
		function unregisterContext(parentDocument:Object, applicationContext:IApplicationContext):void;

	}
}