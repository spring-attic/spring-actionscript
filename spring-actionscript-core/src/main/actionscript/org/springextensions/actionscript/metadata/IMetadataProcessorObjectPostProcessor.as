/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.metadata {
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 * Describes and object that acts as a registry for <code>IMetaDataProcessors</code> and is able
	 * to dispatch objects with the appropriate metadata annotations to their respective <code>process()</code> methods.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IMetadataProcessorObjectPostProcessor extends IObjectPostProcessor {
		function get beforeInitializationRegistry():IMetadataProcessorRegistry;
		function set beforeInitializationRegistry(value:IMetadataProcessorRegistry):void;
		function get afterInitializationRegistry():IMetadataProcessorRegistry;
		function set afterInitializationRegistry(value:IMetadataProcessorRegistry):void;
	}
}
