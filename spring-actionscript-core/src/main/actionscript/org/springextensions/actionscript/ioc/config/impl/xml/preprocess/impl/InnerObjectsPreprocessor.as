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
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.Constants;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;

	use namespace spring_actionscript_objects;

	/**
	 * This <code>IXMLObjectDefinitionsPreprocessor</code> implementation looks for inner objects, objects
	 * that are children or grandchildren of an object, and sets their lazy-init attribute to true.
	 * This way the inner objects won't be instantiated when their parent object is either lazy-init or prototype.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class InnerObjectsPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const logger:ILogger = getClassLogger(InnerObjectsPreprocessor);

		/**
		 * Creates a new <code>InnerObjectsPreprocessor</code> instance.
		 *
		 */
		public function InnerObjectsPreprocessor() {
			super();
		}

		/**
		 * Retrieves all &lt;object/&gt; element that have an ancestor &lt;object/&gt; element, checks if
		 * their scope attribute is set to singleton, and if so, set their lazy-init attribute to true.
		 * @param xml The specified <code>XML</code> object
		 * @return The processed <code>XML</code> object
		 *
		 */
		public function preprocess(xml:XML):XML {
			Assert.notNull(xml, "The xml argument must not be null");
			var innerObjectNodes:XMLList = xml.object..object.(attribute(Constants.SCOPE_ATTRIBUTE) == ObjectDefinitionScope.SINGLETON.name);

			for each (var node:XML in innerObjectNodes) {
				logger.debug("Set lazy-init to true for element <{0}>", [node.localName()]);
				node.@[Constants.LAZYINIT_ATTRIBUTE] = true;

			}
			return xml;
		}

	}
}
