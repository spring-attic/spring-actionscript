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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {

	import org.springextensions.actionscript.utils.Environment;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;

	use namespace spring_actionscript_objects;

	/**
	 * XML Preprocessor for the "import" element that imports external properties files. These nodes are
	 * preprocessed to PropertyPlaceholderConfigurer objects.
	 *
	 * @author Christophe Herreman
	 */
	public class PropertyImportPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private var _configurerClassName:String;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function PropertyImportPreprocessor() {
			super();
			propertyImportPreprocessorInit();
		}
		
		protected function propertyImportPreprocessorInit():void {
			if (Environment.isFlash) {
				_configurerClassName = "org.springextensions.actionscript.ioc.factory.config.PropertyPlaceholderConfigurer";
			} else {
				_configurerClassName = "org.springextensions.actionscript.ioc.factory.config.flex.FlexPropertyPlaceholderConfigurer";
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IXMLObjectDefinitionsPreprocessor: Methods
		//
		// --------------------------------------------------------------------

		public function preprocess(xml:XML):XML {
			var propertyNodes:XMLList = xml.property;

			for each (var propertyNode:XML in propertyNodes) {
				if (propertyNode.attribute('file').length() > 0) {
					var node:XML = <object class={_configurerClassName}>
										<property name="location" value={propertyNode.attribute('file')[0]}/>
									</object>;

					// "required" attribute
					if (propertyNode.attribute('required').length() > 0) {
						var notRequired:Boolean = (propertyNode.attribute('required')[0] == "false");
						if (notRequired) {
							node.appendChild(<property name="ignoreResourceNotFound" value="true"/>);
						}
					}

					xml.appendChild(node);
					delete xml.property[0];
				}

			}

			return xml;
		}
	}
}