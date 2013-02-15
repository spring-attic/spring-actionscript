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
package org.springextensions.actionscript.ioc.factory.xml {
	
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util.ConstantNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util.InvokeNodeParser;
	
	/**
	 * Util namespace handler.
	 * xml-schema-based-configuration.html#the_util_schema
	 * @author Christophe Herreman
	 */
	public class UtilNamespaceHandler extends NamespaceHandlerSupport {
		
		public static const CONSTANT:String = "constant";
		
		public static const INVOKE:String = "invoke";
		/**
		 * Creates a new <code>UtilNamespaceHandler</code> instance.
		 */
		public function UtilNamespaceHandler() {
			super(spring_actionscript_util);
			registerObjectDefinitionParser(CONSTANT, new ConstantNodeParser());
			registerObjectDefinitionParser(INVOKE, new InvokeNodeParser());
		}
	}
}