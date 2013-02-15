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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.util.Constants;
	
	use namespace spring_actionscript_objects;

	/**
	 * This <code>IXMLObjectDefinitionsPreprocessor</code> implementation looks for inner objects, objects
	 * that are children or grandchildren of an object, and sets their lazy-init attribute to true.
	 * This way the inner objects won't be instantiated when their parent object is either lazy-init or prototype.
	 * @author Roland Zwaga
	 */
	public class InnerObjectsPreprocessor implements IXMLObjectDefinitionsPreprocessor {

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
		 * @return The prcoessed <code>XML</code> object
		 * 
		 */
		public function preprocess(xml:XML):XML {
			Assert.notNull(xml, "The xml argument must not be null");
			var innerObjectNodes:XMLList = xml.object..object.(attribute(Constants.SCOPE_ATTRIBUTE) == ObjectDefinitionScope.SINGLETON_NAME);
			var isSingleton:Boolean;

			for each (var node:XML in innerObjectNodes) {
				
				node.@[Constants.LAZYINIT_ATTRIBUTE] = true; 

			}
			return xml;
		}

	}
}