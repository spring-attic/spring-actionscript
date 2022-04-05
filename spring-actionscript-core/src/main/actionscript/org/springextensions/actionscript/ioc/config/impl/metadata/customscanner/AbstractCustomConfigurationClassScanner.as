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
package org.springextensions.actionscript.ioc.config.impl.metadata.customscanner {

	import flash.errors.IllegalOperationError;

	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.metadata.ICustomConfigurationClassScanner;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractCustomConfigurationClassScanner implements ICustomConfigurationClassScanner {
		private var _metadataNames:Vector.<String>;

		/**
		 * Creates a new <code>AbstractCustomMetadataConfigurator</code> instance.
		 */
		public function AbstractCustomConfigurationClassScanner() {
			super();
			_metadataNames = new Vector.<String>();
		}

		public function get metadataNames():Vector.<String> {
			return _metadataNames;
		}

		public function execute(metadata:Metadata, objectName:String, objectDefinition:IObjectDefinition, objectDefinitionsRegistry:IObjectDefinitionRegistry, applicationContext:IApplicationContext):void {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}
	}
}
