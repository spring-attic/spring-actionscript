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
 package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.stageinterception {
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.stage.GenericStageProcessor;

	/**
	 * genericstageprocessor node parser
	 * @author Roland Zwaga
	 * @docref xml-schema-based-configuration.html#the_stage_interception_schema
	 */
	public class GenericStageProcessorNodeParser extends AbstractObjectDefinitionParser {

		/** The target-object attribute */
		public static const TARGET_OBJECT_ATTR:String = "target-object";

		/** The target-property attribute */
		public static const TARGET_PROPERTY_ATTR:String = "target-property";

		/** The target-method attribute */
		public static const TARGET_METHOD_ATTR:String = "target-method";

		/** The object-selector attribute */
		public static const OBJECT_SELECTOR_ATTR:String = "object-selector";

		/**
		 * Creates a new <code>StageProcessorNodeParser</code> instance.
		 */
		public function GenericStageProcessorNodeParser() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(GenericStageProcessor);

			ParsingUtils.mapProperties(result.objectDefinition, node, TARGET_PROPERTY_ATTR, TARGET_METHOD_ATTR);
			ParsingUtils.mapReferences(result.objectDefinition, node, OBJECT_SELECTOR_ATTR, TARGET_OBJECT_ATTR);

			return result.objectDefinition;
		}

	}
}