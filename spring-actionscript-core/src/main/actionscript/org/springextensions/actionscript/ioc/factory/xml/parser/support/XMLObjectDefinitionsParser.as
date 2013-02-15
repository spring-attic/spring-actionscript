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

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.ioc.AutowireMode;
	import org.springextensions.actionscript.ioc.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.xml.INamespaceHandler;
	import org.springextensions.actionscript.ioc.factory.xml.parser.INodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ArrayNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.DictionaryNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.KeyValueNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.NullNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ObjectNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.RefNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.VectorNodeParser;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.AttributeToElementPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.IdAttributePreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.InnerObjectsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.InterfacePreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.ParentAttributePreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.PropertyElementsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.PropertyImportPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.ScopeAttributePreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.SpringNamesPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.TemplatePreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;

	use namespace spring_actionscript_objects;

	/**
	 * Xml parser for object definitions.
	 *
	 * @author Christophe Herreman
	 * @author Damir Murat
	 */
	public class XMLObjectDefinitionsParser {

		public static const ABSTRACT_ATTRIBUTE:String = "abstract";

		public static const ID_ATTRIBUTE:String = "id";

		public static const CLASS_ATTRIBUTE:String = "class";

		public static const DEPENDS_ON_ATTRIBUTE:String = "depends-on";

		public static const FACTORY_METHOD_ATTRIBUTE:String = "factory-method";

		public static const FACTORY_OBJECT_ATTRIBUTE:String = "factory-object";

		public static const INIT_METHOD_ATTRIBUTE:String = "init-method";

		public static const DESTROY_METHOD_ATTRIBUTE:String = "destroy-method";

		public static const LAZY_INIT_ATTRIBUTE:String = "lazy-init";

		public static const SCOPE_ATTRIBUTE:String = "scope";

		public static const VALUE_ATTRIBUTE:String = "value";

		public static const KEY_ATTRIBUTE:String = "key";

		public static const REF_ATTRIBUTE:String = "ref";

		public static const AUTOWIRE_MODE_ATTRIBUTE:String = "autowire";

		public static const AUTOWIRE_CANDIDATE_ATTRIBUTE:String = "autowire-candidate";

		public static const AUTOWIRE_PRIMARY_CANDIDATE_ATTRIBUTE:String = "primary";

		public static const DEPENDENCY_CHECK_ATTRIBUTE:String = "dependency-check";

		/** Constant value 'object' */
		public static const OBJECT_ELEMENT:String = "object";

		/** Constant value 'vector' */
		public static const VECTOR_ELEMENT:String = "vector";

		/** Constant value 'value' */
		public static const VALUE_ELEMENT:String = "value";

		/** Constant value 'key' */
		public static const KEY_ELEMENT:String = "key";

		/** Constant value 'ref' */
		public static const REF_ELEMENT:String = "ref";

		/** Constant value 'property' */
		public static const PROPERTY_ELEMENT:String = "property";

		/** Constant value 'constructor-arg' */
		public static const CONSTRUCTOR_ARG_ELEMENT:String = "constructor-arg";

		/** Constant value 'method-invocation' */
		public static const METHOD_INVOCATION:String = "method-invocation";

		/** Constant value 'skip-postprocessors' */
		public static const SKIP_POSTPROCESSORS:String = "skip-postprocessors";

		/** Constant value 'method-invocation' */
		public static const SKIP_METADATA:String = "skip-metadata";

		/** Constant value 'template' */
		public static const TEMPLATE_ELEMENT:String = "template";

		/** Constant value 'array' */
		public static const ARRAY_ELEMENT:String = "array";

		/** Constant value 'array-collection' */
		public static const ARRAY_COLLECTION_ELEMENT:String = "array-collection";

		/** Constant value 'dictionary' */
		public static const DICTIONARY_ELEMENT:String = "dictionary";

		/** Constant value 'list' */
		public static const LIST_ELEMENT:String = "list";

		/** Constant value 'map' */
		public static const MAP_ELEMENT:String = "map";

		/** Constant value 'entry' */
		public static const ENTRY_ELEMENENT:String = "entry";

		/** Constant value 'null' */
		public static const NULL_ELEMENT:String = "null";

		public static const OBJECT_NAME_DELIMITERS:String = ",; ";

		private var _preprocessorsInitialized:Boolean = false;

		private var _nodeParsers:Array /*<INodeParser>*/ = [];

		private var _preprocessors:Array /*<IXMLObjectDefinitionsPreprocessor>*/ = [];

		private var _namespaceHandlers:Object = {};

		private var _generatedObjectNames:Object = {};

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Constructs a new <code>XmlObjectDefinitionsParser</code>.
		 * An optional objectFactory can be passed to store the definitions. If no
		 * container is passed then a new instance will be created of type XMLObjectFactory.
		 *
		 * @param applicationContext   the objectFactory where the object definitions will be stored
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.XMLObjectFactory XMLObjectFactory
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ObjectNodeParser ObjectNodeParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.KeyValueNodeParser KeyValueNodeParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ArrayNodeParser ArrayNodeParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.RefNodeParser RefNodeParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.DictionaryNodeParser DictionaryNodeParser
		 */
		public function XMLObjectDefinitionsParser(applicationContext:IApplicationContext = null) {
			this.applicationContext = (applicationContext ? applicationContext : new AbstractApplicationContext());

			addNodeParser(new ObjectNodeParser(this));
			addNodeParser(new KeyValueNodeParser(this));
			addNodeParser(new ArrayNodeParser(this));
			addNodeParser(new RefNodeParser(this));
			addNodeParser(new DictionaryNodeParser(this));
			addNodeParser(new NullNodeParser(this));
			addNodeParser(new VectorNodeParser(this));
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		private var _applicationContext:IApplicationContext;

		/**
		 * The objectFactory currently in use
		 *
		 * @default an instance of XMLObjectFactory
		 *
		 * @see org.springextensions.actionscript.ioc.factory.xml.XMLObjectFactory
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		/**
		 * Adds a preprocessor to the parser.
		 *
		 * @param preprocessor    The implementation of IXMLObjectDefinitionsPreprocessor that will be added
		 */
		public function addPreprocessor(preprocessor:IXMLObjectDefinitionsPreprocessor):void {
			Assert.notNull(preprocessor, "The preprocessor argument must not be null");
			_preprocessors.push(preprocessor);
		}

		/**
		 * Adds a NodeParser to the parser.
		 *
		 * @param parser    The implementation of INodeParser that will be added
		 */
		public function addNodeParser(parser:INodeParser):void {
			_nodeParsers.push(parser);
		}

		/**
		 * Adds a namespace handler.
		 */
		public function addNamespaceHandler(handler:INamespaceHandler):void {
			_namespaceHandlers[handler.getNamespace().uri] = handler;
		}

		/**
		 * Generates an object name for the given object definition.
		 */
		public function generateObjectName(definition:IObjectDefinition):String {
			var result:String = definition.className;
			var counter:uint = _generatedObjectNames[definition.className];

			if (counter == 0) {
				_generatedObjectNames[definition.className] = 0;
			}

			result += "#" + (counter + 1);

			_generatedObjectNames[definition.className]++;

			return result;
		}

		/**
		 * Parses all object definitions and returns the objectFactory that contains
		 * the parsed results.
		 *
		 * @param xml       the xml object with the object definitions
		 *
		 * @return the objectFactory with the parsed object definitions
		 */
		public function parse(xml:XML):IApplicationContext {
			// pre process the xml
			preProcessXML(xml);

			// parse the object definitions
			parseObjectDefinitions(xml);

			return applicationContext;
		}

		/**
		 * Pre process the xml data before parsing.
		 */
		protected function preProcessXML(xml:XML):void {
			// initialize the preprocessors
			// do this here because the properties preprocessor needs the properties
			if (!_preprocessorsInitialized) {
				_preprocessorsInitialized = true;

				addPreprocessor(new PropertyImportPreprocessor());
				addPreprocessor(new PropertyElementsPreprocessor(applicationContext));
				addPreprocessor(new IdAttributePreprocessor());
				addPreprocessor(new AttributeToElementPreprocessor());
				addPreprocessor(new SpringNamesPreprocessor());
				addPreprocessor(new TemplatePreprocessor());
				addPreprocessor(new ScopeAttributePreprocessor());
				addPreprocessor(new ParentAttributePreprocessor());
				addPreprocessor(new InnerObjectsPreprocessor());
				addPreprocessor(new InterfacePreprocessor(applicationContext.applicationDomain));
			}

			for each (var preprocessor:IXMLObjectDefinitionsPreprocessor in _preprocessors) {
				xml = preprocessor.preprocess(xml);
			}
		}

		/**
		 *
		 */
		protected function parseObjectDefinitions(xml:XML):void {
			// parse all top level nodes on the xml definition
			for each (var node:XML in xml.children()) {
				// only parse object nodes that are not part of a template
				if (node.parent().name() != TEMPLATE_ELEMENT) {
					parseNode(node);
				}
			}
		}

		public function parseNode(node:XML):void {
			if (node.name() is QName) {
				var qname:QName = QName(node.name());

				if (isDefaultNamespace(qname)) {
					parseDefaultNode(node);
				} else {
					parseCustomNode(node);
				}
			}
		}

		/**
		 *
		 */
		protected function isDefaultNamespace(qname:QName):Boolean {
			return ((qname.uri == "") || (qname.uri == Namespace(spring_actionscript_objects).uri));
		}

		/**
		 *
		 */
		protected function parseDefaultNode(node:XML):void {
			var qname:QName = QName(node.name());
			var isObjectNode:Boolean = (qname.localName == OBJECT_ELEMENT);
			var isAbstract:Boolean = (node.attribute(ABSTRACT_ATTRIBUTE).length() > 0);

			if (isObjectNode && !isAbstract) {
				processObjectDefinition(node);
			}
		}

		/**
		 *
		 */
		protected function parseCustomNode(node:XML):void {
			var qname:QName = QName(node.name());
			var namespaceHandler:INamespaceHandler = _namespaceHandlers[qname.uri];

			if (!namespaceHandler) {
				throw new Error("No namespace handler found for node '" + node + "' with URI '" + qname.uri + "'");
			}

			namespaceHandler.parse(node, this);
		}

		/**
		 * Process the given node as an object definition.
		 */
		protected function processObjectDefinition(node:XML):void {
			var definition:IObjectDefinition = parseObjectDefinition(node);
			var id:String = node.@id.toString();

			applicationContext.registerObjectDefinition(id, definition);
		}

		/**
		 * Registers an object definition in the internal object factory.
		 *
		 * @param objectName the name of the object
		 * @param objectDefinition the object definition
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void {
			applicationContext.registerObjectDefinition(objectName, objectDefinition);
		}

		/**
		 * Parses and registers an object definition.
		 *
		 * @param node     The xml node to create an object definition from.
		 *
		 * @returns     the id of the object definition
		 */
		public function parseAndRegisterObjectDefinition(node:XML):String {
			var id:String = node.@id.toString();
			var objectDefinition:IObjectDefinition = parseObjectDefinition(node);

			applicationContext.registerObjectDefinition(id, objectDefinition);

			return id;
		}

		/**
		 * Parses the given object definition node into an implementation of IObjectDefinition.
		 *
		 * @param xml  The object definition node
		 *
		 * @return an implementation of IObjectDefinition
		 */
		public function parseObjectDefinition(xml:XML, objectDefinition:IObjectDefinition = null):IObjectDefinition {
			var result:IObjectDefinition;

			if (objectDefinition != null) {
				result = objectDefinition;
			} else if (xml.attribute(CLASS_ATTRIBUTE).length() == 0) {
				result = new ObjectDefinition();
			} else {
				result = new ObjectDefinition(xml.attribute(CLASS_ATTRIBUTE)[0]);
			}

			parseAttributes(result, xml);
			parseConstructorArguments(result, xml);
			parseProperties(result, xml);
			parseMethodInvocations(result, xml);

			return result;
		}

		/**
		 * Parses the attributes of an object node into an object definition.
		 */
		protected function parseAttributes(objectDefinition:IObjectDefinition, xml:XML):void {
			objectDefinition.factoryMethod = (xml.attribute(FACTORY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_METHOD_ATTRIBUTE);
			objectDefinition.factoryObjectName = (xml.attribute(FACTORY_OBJECT_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_OBJECT_ATTRIBUTE);
			objectDefinition.initMethod = (xml.attribute(INIT_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(INIT_METHOD_ATTRIBUTE);
			objectDefinition.destroyMethod = (xml.attribute(DESTROY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(DESTROY_METHOD_ATTRIBUTE);
			objectDefinition.isLazyInit = (xml.attribute(LAZY_INIT_ATTRIBUTE) == "true");
			objectDefinition.scope = ObjectDefinitionScope.fromName(xml.attribute(SCOPE_ATTRIBUTE).toString());
			objectDefinition.autoWireMode = AutowireMode.fromName(xml.attribute(AUTOWIRE_MODE_ATTRIBUTE).toString());
			objectDefinition.isAutoWireCandidate = (xml.attribute(AUTOWIRE_CANDIDATE_ATTRIBUTE) != "false");
			objectDefinition.primary = xml.attribute(AUTOWIRE_PRIMARY_CANDIDATE_ATTRIBUTE) == "true";
			objectDefinition.skipPostProcessors = xml.attribute(SKIP_POSTPROCESSORS) == "true";
			objectDefinition.skipMetadata = xml.attribute(SKIP_METADATA) == "true";
			objectDefinition.dependencyCheck = DependencyCheckMode.fromName(xml.attribute(DEPENDENCY_CHECK_ATTRIBUTE).toString());

			var dependsOnAttributes:XMLList = xml.attribute(DEPENDS_ON_ATTRIBUTE);

			if (dependsOnAttributes.length() > 0) {
				var dependsOnAttribute:XML = dependsOnAttributes[0];
				objectDefinition.dependsOn = StringUtils.tokenizeToArray(dependsOnAttribute.toString(), OBJECT_NAME_DELIMITERS);
			}
		}

		/**
		 * Will retrieve the constructor arguments and parses them as if they were property nodes.
		 *
		 * @param xml The xml to check for nodes
		 *
		 * @see #parseProperty()
		 */
		protected function parseConstructorArguments(objectDefinition:IObjectDefinition, xml:XML):void {
			var result:Array = [];

			for each (var node:XML in xml.children().(name().localName == CONSTRUCTOR_ARG_ELEMENT)) {
				result.push(parseProperty(node));
			}

			objectDefinition.constructorArguments = result;
		}

		/**
		 * Parses the properties of the given definition.
		 *
		 * @param xml
		 */
		protected function parseProperties(objectDefinition:IObjectDefinition, xml:XML):void {
			var result:Object = {};
			var propertyNodes:XMLList = xml.property;

			for each (var node:XML in propertyNodes) {
				result[node.@name.toString()] = parseProperty(node);
			}

			objectDefinition.properties = result;
		}

		/**
		 * Parses the method invocations of the given definition.
		 */
		protected function parseMethodInvocations(objectDefinition:IObjectDefinition, xml:XML):void {
			var result:Array = [];

			for each (var node:XML in xml.children().(name().localName == METHOD_INVOCATION)) {
				result.push(parseMethodInvocation(node));
			}

			objectDefinition.methodInvocations = result;
		}

		/**
		 *
		 */
		protected function parseMethodInvocation(node:XML):MethodInvocation {
			var methodName:String = node.@name;
			var args:Array = [];

			for each (var argXML:XML in node.arg) {
				args.push(parseProperty(argXML));
			}

			return new MethodInvocation(methodName, args);
		}

		/**
		 * Will parse the given property node. If the given property does not contain
		 * a value attribute, the first childNode will be used as value else the value
		 * of the property will be parsed and returned using the parsePropertyValue
		 * method.
		 *
		 * @param node    The property node to be parsed
		 *
		 * @return the value of the parsed node
		 *
		 * @see #parsePropertyValue()
		 */
		public function parseProperty(node:XML):Object {
			var result:Object;

			// move the "value" attribute to the a "value" node
			if (node.@value != undefined) {
				node.value = new String(node.@value);
				delete node.@value;
			}

			if (node.value == undefined) {
				var subNodes:XMLList = node.children();
				var propertyNode:XML = subNodes[0];
				result = parsePropertyValue(propertyNode);
			} else {
				if (node.@type != undefined) {
					// move the "type" attribute to the value node
					node.value.@type = node.@type.toString();
					delete node.@type;
				}
				result = parsePropertyValue(node.value[0]);
			}

			return result;
		}

		/**
		 * Will parse the given property value using the node parsers.
		 * <p />
		 * Will loop through the node parsers in the order that they have
		 * been added. The first parser able to parse the node is used to
		 * retrieve the value.
		 *
		 * @param node    The property value node to be parsed
		 *
		 * @return the value of the node after parsing
		 */
		public function parsePropertyValue(node:XML):Object {
			var result:Object;
			var numNodeParsers:int = _nodeParsers.length;

			for (var i:int = 0; i < numNodeParsers; i++) {
				var nodeParser:INodeParser = _nodeParsers[i];

				if (nodeParser.canParse(node)) {
					result = nodeParser.parse(node);
					break;
				}
			}

			// we still don't have a result, try to parse a custom node
			if (!result) {
				var qname:QName = QName(node.name());

				if (!isDefaultNamespace(qname)) {
					parseCustomNode(node);
					result = new RuntimeObjectReference(node.@id.toString());
				}
			}

			return result;
		}

		/**
		 * Returns all registered implementations of <code>INodeParser</code>. Node parsers can
		 * be added using the addNodeParser method.
		 *
		 * @see #addNodeParser()
		 */
		public function get nodeParsers():Array {
			return _nodeParsers;
		}


	}
}
