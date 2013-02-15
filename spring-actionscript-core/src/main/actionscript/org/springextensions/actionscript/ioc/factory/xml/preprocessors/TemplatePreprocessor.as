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

	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;

	use namespace spring_actionscript_objects;

	/**
	 * The <code>TemplatePreprocessor</code> is used to apply all templates
	 * to the xml context. The parser nor the container should be aware of
	 * templates.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @docref container-documentation.html#object_definition_inheritance
	 */
	public class TemplatePreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const TEMPLATE_BEGIN:String = "${";
		private static const TEMPLATE_END:String = "}";

		/**
		 * Creates a new <code>TemplatePreprocessor</code>
		 */
		public function TemplatePreprocessor() {
		}

		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			// the nodes that use a template
			var nodes:XMLList = xml..*.(attribute("template") != undefined);

			// loop through each node that uses a template and apply the template
			for each(var node:XML in nodes) {
				var template:XML = xml.template.(attribute("id") == node.@template)[0];
				var templateText:String = template.children()[0].toXMLString();

				// replace all parameters
				for each(var param:XML in node.param) {
					var key:String = TEMPLATE_BEGIN + param.@name + TEMPLATE_END;
					// replace the key with the value of the parameter
					templateText = templateText.split(key).join(param.value.toString());
					// remove the param node from the main node
					delete node.param[0];
				}

				// fill the object with the result of the template
				// if the node is an object node, we fill it
				// if the node is a property node, we append it
				var newNodeXML:XML = new XML(templateText);
				var nodeName:QName = node.name()as QName;

				if (nodeName.localName == "object") {
					node.@["class"] = newNodeXML.attribute("class").toString();
					for each(var n:XML in newNodeXML.children()) {
						node.appendChild(n);
					}
				} else {
					node.text()[0] = newNodeXML;
				}

				// remove the template attribute
				delete node.@template;
			}

			return xml;
		}
	}
}
