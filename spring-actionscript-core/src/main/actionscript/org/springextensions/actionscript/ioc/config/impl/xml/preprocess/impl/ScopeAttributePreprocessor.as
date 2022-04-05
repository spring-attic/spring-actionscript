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
package org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.Constants;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;

	use namespace spring_actionscript_objects;

	/**
	 * <p>The ScopeAttributePreprocessor makes sure that all object definitions
	 * have a valid scope attribute.</p>
	 *
	 * <p>If no scope attribute is found, a default scope="singleton" will be added.
	 * If a singleton attribute is found, it will be converted to the
	 * corresponding scope attribute.</p>
	 *
	 * @author Christophe Herreman
	 * @see org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope
	 */
	public class ScopeAttributePreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const logger:ILogger = getClassLogger(ScopeAttributePreprocessor);

		/**
		 * Creates a new <code>ScopeAttributePreprocessor</code>.
		 */
		public function ScopeAttributePreprocessor() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			// nodes without scope attribute
			var nodes:XMLList = xml..object.(attribute(Constants.SCOPE_ATTRIBUTE) == undefined);

			for each (var node:XML in nodes) {
				// no singleton attribute
				if (node.@[Constants.SINGLETON_ATTRIBUTE] == undefined) {
					node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON.name;
					logger.debug("Defaulted scope to singleton for element:\n{0}", [node]);
				} else if (node.@[Constants.SINGLETON_ATTRIBUTE] == false) {
					node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.PROTOTYPE.name;
					logger.debug("Defaulted scope to prototype because deprecated attribute 'singleton=false' for element:\n{0}", [node]);
				} else {
					node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON.name;
					logger.debug("Defaulted scope to singleton because deprecated attribute 'singleton=true' for element:\n{0}", [node]);
				}

				// remove the singleton attribute
				delete node.@[Constants.SINGLETON_ATTRIBUTE];
			}

			return xml;
		}
	}
}
