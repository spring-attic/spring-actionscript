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

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;

	use namespace spring_actionscript_objects;

	/**
	 * <code>IXMLObjectDefinitionsPreprocessor</code> implementation that retrieves all the &lt;configproperty/&gt; elements
	 * from the specified <code>XML</code> object, converts them into a <code>Properties</code> instance and adds
	 * them to the <code>loadedProperties</code> collection of the specified <code>IXMLObjectFactory</code> instance.
	 * @author Roland Zwaga
	 */
	public class PropertyElementsPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private var _objectFactory:IObjectFactory;

		/**
		 * Creates a new <code>ConfigPropertyElementsPreprocessor</code> instance.
		 */
		public function PropertyElementsPreprocessor(objectFactory:IObjectFactory) {
			Assert.notNull(objectFactory, "The objectFactory argument must not be null");
			super();
			_objectFactory = objectFactory;
		}

		/**
		 * Retrieves all &lt;configproperty/&gt; elements from the specified <code>XML</code> object, converts them into a <code>Properties</code> instance and adds
		 * them to the <code>loadedProperties</code> collection of the specified <code>IXMLObjectFactory</code> instance.
		 * @param xml The specified <code>XML</code> object.
		 * @return The processed <code>XML</code> object, all &lt;configproperty/&gt; elements will have been removed.
		 */
		public function preprocess(xml:XML):XML {
			var propertyElements:XMLList = xml.property.(attribute("file") == undefined);
			var properties:Properties = new Properties();

			for each (var child:XML in propertyElements) {
				properties.setProperty(child.attribute("name")[0], child.attribute("value")[0]);
			}

			_objectFactory.properties.merge(properties);

			return xml;
		}

	}
}