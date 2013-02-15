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
package org.springextensions.actionscript.ioc.factory.xml.parser.support {

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ArrayCollectionNodeParser;

	/**
	 * An extension to the XMLObjectDefinitionsParser to support flex framework
	 * specific classes like ArrayCollection.
	 *
	 * @author Christophe Herreman
	 */
	public class FlexXMLObjectDefinitionsParser extends XMLObjectDefinitionsParser {

		/**
		 * Constructs a new <code>FlexXMLObjectDefinitionsParser</code>.
		 * An optional objectFactory can be passed to store the definitions. If no
		 * container is passed then a new instance will be created of type XMLObjectFactory.
		 * <p />
		 * Will add the following node parsers:
		 * <ul>
		 *   <li>ArrayCollectionNodeParser</li>
		 * </ul>
		 *
		 * @param applicationContext the objectFactory where the object definitions will be stored
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ArrayCollectionNodeParser
		 */
		public function FlexXMLObjectDefinitionsParser(applicationContext:IApplicationContext) {
			super(applicationContext);
			addNodeParser(new ArrayCollectionNodeParser(this));
		}

	}
}
