/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.metadata {

	import org.as3commons.reflect.IMetadataContainer;

	/**
	 * Describes an object that can process an instance that is annotated with specific metadata.
	 * @author Roland Zwaga
	 * @docref annotations.html
	 * @sampleref metadataprocessor
	 */
	public interface IMetadataProcessor {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The names of the metadata annotations that the current <code>IMetadataProcessor</code> processes.
		 */
		function get metadataNames():Array;

		/**
		 * If <code>true</code> the <code>IMetadataProcessor</code> instance will be able to process the annotated
		 * instance before it has been initialized by the container.
		 */
		function get processBeforeInitialization():Boolean;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Processes the specified <code>Object</code>. The <code>IMetaDataContainer</code> instance can be any of these
		 * <code>MetaDataContainer</code> subclasses:
		 * <ul>
		 *   <li>Type</li>
		 *   <li>Method</li>
		 *   <li>Accessor</li>
		 *   <li>Constant</li>
		 *   <li>Variable</li>
		 * </ul>
		 * @param instance The specified <code>Object</code>.
		 * @param container The associated <code>IMetaDataContainer</code>
		 * @param metadataName The metadata name that triggered this invocation.
		 * @param objectName The name of the object definition in the Spring Actionscript container.
		 */
		function process(instance:Object, container:IMetadataContainer, metadataName:String, objectName:String):void;
	}
}