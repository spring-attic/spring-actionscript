////////////////////////////////////////////////////////////////////////////////
//
//  Uitgeverij Deviant - Studiemeter
//  Copyright 2010 Uitgeverij Deviant
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util {

	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.config.MethodInvokingFactoryObject;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;

	public class InvokeNodeParser extends AbstractObjectDefinitionParser {
		
		public static const TARGET_CLASS:String = "target-class";
		public static const TARGET_OBJECT:String = "target-object";
		public static const TARGET_METHOD:String = "target-method";
		
		/**
		 * Creates a new <code>InvokeNodeParser</code> instance.
		 */
		public function InvokeNodeParser() {
			super();
		}
		
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(MethodInvokingFactoryObject);
			var objectDefinitionParser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			
			setNamespace(node, node.namespace());
			
			ParsingUtils.mapProperties(builder.objectDefinition, node, TARGET_CLASS);
			ParsingUtils.mapProperties(builder.objectDefinition, node, TARGET_OBJECT);
			ParsingUtils.mapProperties(builder.objectDefinition, node, TARGET_METHOD);
			
			var args:Array = [];
			
			var argNodes:XMLList = node.children();
			for each (var argXML:XML in argNodes) {
				args.push(objectDefinitionParser.parseProperty(argXML));
			}
			
			builder.addPropertyValue("arguments",args);
			
			return builder.objectDefinition
		}
		
		protected function setNamespace(node:XML, ns:Namespace):void {
			for each(var desc:XML in node.descendants()) {
				desc.setNamespace(ns);
				setNamespace(desc,ns);
			}
		}

	}
}