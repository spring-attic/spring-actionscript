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

import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
import org.springextensions.actionscript.ioc.util.Constants;

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
 *
 * @see org.springextensions.actionscript.ioc.ObjectDefinitionScope ObjectDefinitionScope
 */
public class ScopeAttributePreprocessor implements IXMLObjectDefinitionsPreprocessor {

	/**
	 * Creates a new <code>ScopeAttributePreprocessor</code>.
	 */
	public function ScopeAttributePreprocessor() {
		// nothing
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
				node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON_NAME;
			} else if (node.@[Constants.SINGLETON_ATTRIBUTE] == false) {
				node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.PROTOTYPE_NAME;
			} else {
				node.@[Constants.SCOPE_ATTRIBUTE] = ObjectDefinitionScope.SINGLETON_NAME;
			}

			// remove the singleton attribute
			delete node.@[Constants.SINGLETON_ATTRIBUTE];
		}

		return xml;
	}
}
}
