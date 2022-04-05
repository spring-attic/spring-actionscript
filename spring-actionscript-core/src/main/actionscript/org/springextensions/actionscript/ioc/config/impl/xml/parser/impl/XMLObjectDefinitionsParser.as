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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl {
	import flash.errors.IllegalOperationError;
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.XMLUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.INamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.INodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ArrayCollectionNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ArrayNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.DictionaryNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.KeyValueNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.NanNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.NullNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ObjectNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.RefNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.UndefinedNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.VectorNodeParser;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.BaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	use namespace spring_actionscript_objects;

	public class XMLObjectDefinitionsParser implements IXMLObjectDefinitionsParser, IDisposable {

		public static const ABSTRACT_ATTRIBUTE:String = "abstract";
		public static const ARRAY_COLLECTION_ELEMENT:String = "array-collection";
		public static const ARRAY_ELEMENT:String = "array";
		public static const AUTOWIRE_CANDIDATE_ATTRIBUTE:String = "autowire-candidate";
		public static const CHILD_CONTEXT_ACCESS:String = "child-context-access";
		public static const AUTOWIRE_MODE_ATTRIBUTE:String = "autowire";
		public static const AUTOWIRE_PRIMARY_CANDIDATE_ATTRIBUTE:String = "primary";
		public static const CLASS_ATTRIBUTE:String = "class";
		public static const CONSTRUCTOR_ARG_ELEMENT:String = "constructor-arg";
		public static const DEPENDENCY_CHECK_ATTRIBUTE:String = "dependency-check";
		public static const DEPENDS_ON_ATTRIBUTE:String = "depends-on";
		public static const DESTROY_METHOD_ATTRIBUTE:String = "destroy-method";
		public static const DICTIONARY_ELEMENT:String = "dictionary";
		public static const ENTRY_ELEMENENT:String = "entry";
		public static const FACTORY_METHOD_ATTRIBUTE:String = "factory-method";
		public static const FACTORY_OBJECT_ATTRIBUTE:String = "factory-object";
		public static const ID_ATTRIBUTE:String = "id";
		public static const INIT_METHOD_ATTRIBUTE:String = "init-method";
		public static const KEY_ATTRIBUTE:String = "key";
		public static const KEY_ELEMENT:String = "key";
		public static const LAZY_INIT_ATTRIBUTE:String = "lazy-init";
		public static const LIST_ELEMENT:String = "list";
		public static const MAP_ELEMENT:String = "map";
		public static const METHOD_INVOCATION:String = "method-invocation";
		public static const NAMESPACE_ATTRIBUTE:String = "namespace";
		public static const NAN_ELEMENT:String = "not-a-number";
		public static const NULL_ELEMENT:String = "null";
		public static const OBJECT_ELEMENT:String = "object";
		public static const OBJECT_NAME_DELIMITERS:String = ",; ";
		public static const PARENT_ATTRIBUTE:String = "parent";
		public static const PROPERTY_ELEMENT:String = "property";
		public static const REF_ATTRIBUTE:String = "ref";
		public static const REF_ELEMENT:String = "ref";
		public static const SCOPE_ATTRIBUTE:String = "scope";
		public static const SKIP_METADATA:String = "skip-metadata";
		public static const SKIP_POSTPROCESSORS:String = "skip-postprocessors";
		public static const STATIC_ATTRIBUTE:String = "static";
		public static const UNDEFINED_ELEMENT:String = "undefined";
		public static const VALUE_ATTRIBUTE:String = "value";
		public static const VALUE_ELEMENT:String = "value";
		public static const VECTOR_ELEMENT:String = "vector";
		private static const HASH_CHAR:String = "#";
		private static const TRUE_VALUE:String = "true";
		private static const LAZY_ATTRIBUTE:String = "lazy";
		private static const LAZY_PROPERTY_RESOLVING_ATTRIBUTE:String = "lazy-property-resolving";
		private static const logger:ILogger = getClassLogger(XMLObjectDefinitionsParser);

		/**
		 * Creates a new <code>XmlObjectDefinitionsParser</code> instance.
		 * @param applicationContext   the applicationContext where the object definitions will be stored
		 */
		public function XMLObjectDefinitionsParser(applicationContext:IApplicationContext) {
			Assert.notNull(applicationContext, "applicationContext argument must not be null");
			super();
			_applicationContext = applicationContext;
			addNodeParser(new ObjectNodeParser(this));
			addNodeParser(new KeyValueNodeParser(this, _applicationContext.applicationDomain));
			addNodeParser(new ArrayNodeParser(this));
			addNodeParser(new RefNodeParser(this));
			addNodeParser(new DictionaryNodeParser(this));
			addNodeParser(new NullNodeParser(this));
			addNodeParser(new NanNodeParser(this));
			addNodeParser(new UndefinedNodeParser(this));
			addNodeParser(new VectorNodeParser(this, _applicationContext.applicationDomain));
			if (ArrayCollectionNodeParser.canCreate(_applicationContext.applicationDomain)) {
				addNodeParser(new ArrayCollectionNodeParser(this));
			}
		}

		private var _applicationContext:IApplicationContext;
		private var _definitions:Object;
		private var _generatedObjectNames:Object = {};
		private var _isDisposed:Boolean;
		private var _namespaceHandlers:Object = {};
		private var _nodeParsers:Vector.<INodeParser> = new Vector.<INodeParser>();
		private var _defaultObjectDefinition:IBaseObjectDefinition;

		/**
		 * The current <code>IApplicationContext</code>
		 * @default an instance of XMLObjectFactory
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @private
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * Returns all registered implementations of <code>INodeParser</code>. Node parsers can
		 * be added using the addNodeParser method.
		 *
		 * @see #addNodeParser()
		 */
		public function get nodeParsers():Vector.<INodeParser> {
			return _nodeParsers;
		}

		/**
		 * Adds a namespace handler.
		 */
		public function addNamespaceHandler(handler:INamespaceHandler):void {
			var uri:String = handler.getNamespace().uri;
			_namespaceHandlers[uri] = handler;
			logger.debug("Added namespace handler {0} for namespace {1}", [handler, uri]);
		}

		/**
		 *
		 * @param handlers
		 */
		public function addNamespaceHandlers(handlers:Vector.<INamespaceHandler>):void {
			for each (var handler:INamespaceHandler in handlers) {
				addNamespaceHandler(handler);
			}
		}

		/**
		 * Adds a NodeParser to the parser.
		 * @param parser    The implementation of INodeParser that will be added
		 */
		public function addNodeParser(parser:INodeParser):void {
			_nodeParsers.push(parser);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				_applicationContext = null;
				_definitions = null;
				_generatedObjectNames = null;
				if (_namespaceHandlers != null) {
					for each (var handler:INamespaceHandler in _namespaceHandlers) {
						ContextUtils.disposeInstance(handler);
					}
					_namespaceHandlers = null;
				}
				if (_nodeParsers != null) {
					for each (var nodeParser:INodeParser in _nodeParsers) {
						ContextUtils.disposeInstance(nodeParser);
					}
					_nodeParsers = null;
				}
				_isDisposed = true;
				logger.debug("Instance {0} is disposed...", [this]);
			}
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

			result += HASH_CHAR + (counter + 1);

			_generatedObjectNames[definition.className]++;
			logger.debug("Generated object name: '{0}'", [result]);
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
		public function parse(xml:XML, defaultObjectDefinition:IBaseObjectDefinition=null):Object {
			_definitions = {};
			_defaultObjectDefinition = parseDefaultObjectDefinition(xml, defaultObjectDefinition);
			parseObjectDefinitions(xml);
			return _definitions;
		}

		private function parseDefaultObjectDefinition(xml:XML, defaultObjectDefinition:IBaseObjectDefinition):IBaseObjectDefinition {
			defaultObjectDefinition ||= new BaseObjectDefinition();
			defaultObjectDefinition.autoWireMode = AutowireMode.fromName(xml.attribute(AUTOWIRE_MODE_ATTRIBUTE).toString());
			defaultObjectDefinition.childContextAccess = ChildContextObjectDefinitionAccess.fromValue(xml.attribute(CHILD_CONTEXT_ACCESS).toString());
			defaultObjectDefinition.dependencyCheck = DependencyCheckMode.fromName(xml.attribute(DEPENDENCY_CHECK_ATTRIBUTE).toString());
			defaultObjectDefinition.destroyMethod = (xml.attribute(DESTROY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(DESTROY_METHOD_ATTRIBUTE);
			defaultObjectDefinition.factoryMethod = (xml.attribute(FACTORY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_METHOD_ATTRIBUTE);
			defaultObjectDefinition.factoryObjectName = (xml.attribute(FACTORY_OBJECT_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_OBJECT_ATTRIBUTE);
			defaultObjectDefinition.initMethod = (xml.attribute(INIT_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(INIT_METHOD_ATTRIBUTE);
			defaultObjectDefinition.isAutoWireCandidate = (xml.attribute(AUTOWIRE_CANDIDATE_ATTRIBUTE) != "false");
			defaultObjectDefinition.isLazyInit = (xml.attribute(LAZY_INIT_ATTRIBUTE) == TRUE_VALUE);
			defaultObjectDefinition.parentName = (xml.attribute(PARENT_ATTRIBUTE).length() > 0) ? String(xml.attribute(PARENT_ATTRIBUTE)) : null;
			defaultObjectDefinition.scope = ObjectDefinitionScope.fromName(xml.attribute(SCOPE_ATTRIBUTE).toString());
			defaultObjectDefinition.skipMetadata = xml.attribute(SKIP_METADATA) == TRUE_VALUE;
			defaultObjectDefinition.skipPostProcessors = xml.attribute(SKIP_POSTPROCESSORS) == TRUE_VALUE;
			return defaultObjectDefinition;
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
			logger.debug("Parsing and registering definition '{0}'", [id]);
			var objectDefinition:IObjectDefinition = parseObjectDefinition(node);

			registerObjectDefinition(id, objectDefinition);
			logger.debug("Parsed and registered definition: {0}", [objectDefinition]);

			return id;
		}

		/**
		 * Parses the attributes of an object node into an object definition.
		 */
		public function parseAttributes(objectDefinition:IObjectDefinition, xml:XML):void {
			objectDefinition.factoryMethod = (xml.attribute(FACTORY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_METHOD_ATTRIBUTE);
			objectDefinition.factoryObjectName = (xml.attribute(FACTORY_OBJECT_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_OBJECT_ATTRIBUTE);
			objectDefinition.initMethod = (xml.attribute(INIT_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(INIT_METHOD_ATTRIBUTE);
			objectDefinition.destroyMethod = (xml.attribute(DESTROY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(DESTROY_METHOD_ATTRIBUTE);
			objectDefinition.isLazyInit = (xml.attribute(LAZY_INIT_ATTRIBUTE) == TRUE_VALUE);
			objectDefinition.scope = ObjectDefinitionScope.fromName(xml.attribute(SCOPE_ATTRIBUTE).toString());
			objectDefinition.autoWireMode = AutowireMode.fromName(xml.attribute(AUTOWIRE_MODE_ATTRIBUTE).toString());
			objectDefinition.isAutoWireCandidate = (xml.attribute(AUTOWIRE_CANDIDATE_ATTRIBUTE) != "false");
			objectDefinition.primary = xml.attribute(AUTOWIRE_PRIMARY_CANDIDATE_ATTRIBUTE) == TRUE_VALUE;
			objectDefinition.skipPostProcessors = xml.attribute(SKIP_POSTPROCESSORS) == TRUE_VALUE;
			objectDefinition.skipMetadata = xml.attribute(SKIP_METADATA) == TRUE_VALUE;
			objectDefinition.dependencyCheck = DependencyCheckMode.fromName(xml.attribute(DEPENDENCY_CHECK_ATTRIBUTE).toString());
			objectDefinition.parentName = (xml.attribute(PARENT_ATTRIBUTE).length() > 0) ? String(xml.attribute(PARENT_ATTRIBUTE)) : null;
			objectDefinition.childContextAccess = ChildContextObjectDefinitionAccess.fromValue(xml.attribute(CHILD_CONTEXT_ACCESS).toString());

			var dependsOnAttributes:XMLList = xml.attribute(DEPENDS_ON_ATTRIBUTE);

			if (dependsOnAttributes.length() > 0) {
				var dependsOnAttribute:XML = dependsOnAttributes[0];
				objectDefinition.dependsOn = StringUtils.tokenizeToVector(dependsOnAttribute.toString(), OBJECT_NAME_DELIMITERS);
			}
		}

		/**
		 * Will retrieve the constructor arguments and parses them as if they were property nodes.
		 *
		 * @param xml The xml to check for nodes
		 *
		 * @see #parseProperty()
		 */
		public function parseConstructorArguments(objectDefinition:IObjectDefinition, xml:XML):void {
			var result:Vector.<ArgumentDefinition>;

			for each (var node:XML in xml.children().(name().localName == CONSTRUCTOR_ARG_ELEMENT)) {
				result ||= new Vector.<ArgumentDefinition>()
				var lazyPropertyResolving:Boolean = (node.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE).length() > 0) ? (String(node.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE)) == TRUE_VALUE) : false;
				result[result.length] = ArgumentDefinition.newInstance(parseProperty(node), lazyPropertyResolving);
				logger.debug("Parsed constructor-arg element:\n{0}", [node]);
			}

			objectDefinition.constructorArguments = result;
		}

		/**
		 * Parses the method invocations of the given definition.
		 */
		public function parseMethodInvocations(objectDefinition:IObjectDefinition, xml:XML):void {
			for each (var node:XML in xml.children().(name().localName == METHOD_INVOCATION)) {
				objectDefinition.addMethodInvocation(parseMethodInvocation(node));
			}
		}

		/**
		 *
		 * @param node
		 */
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
		 * Parses the given object definition node into an implementation of IObjectDefinition.
		 *
		 * @param xml  The object definition node
		 * @return an implementation of IObjectDefinition
		 */
		public function parseObjectDefinition(xml:XML, objectDefinition:IObjectDefinition=null):IObjectDefinition {
			var result:IObjectDefinition = createObjectDefinitionResult(objectDefinition, xml);

			parseAttributes(result, xml);
			parseConstructorArguments(result, xml);
			parseProperties(result, xml);
			parseMethodInvocations(result, xml);

			return result;
		}

		/**
		 * Parses the properties of the given definition.
		 *
		 * @param xml
		 */
		public function parseProperties(objectDefinition:IObjectDefinition, xml:XML):void {
			var propertyNodes:XMLList = xml.property;

			for each (var node:XML in propertyNodes) {
				var isStatic:Boolean = (node.attribute(STATIC_ATTRIBUTE).length() > 0) ? (String(node.attribute(STATIC_ATTRIBUTE)) == TRUE_VALUE) : false;
				var isLazy:Boolean = (node.attribute(LAZY_ATTRIBUTE).length() > 0) ? (String(node.attribute(LAZY_ATTRIBUTE)) == TRUE_VALUE) : false;
				var lazyPropertyResolving:Boolean = (node.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE).length() > 0) ? (String(node.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE)) == TRUE_VALUE) : false;
				var ns:String = (node.attribute(NAMESPACE_ATTRIBUTE).length() > 0) ? String(node.attribute(NAMESPACE_ATTRIBUTE)) : null;
				var propDef:PropertyDefinition = new PropertyDefinition(node.@name.toString(), parseProperty(node), ns, isStatic, isLazy, lazyPropertyResolving);
				objectDefinition.addPropertyDefinition(propDef);
				logger.debug("Parsed property defintion: {0}", [propDef]);
			}
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
		public function parseProperty(node:XML):* {
			var result:*;

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
		 * Will parse the given property value using the node parsers.<br/>
		 *
		 * Will loop through the node parsers in the order that they have
		 * been added. The first parser able to parse the node is used to
		 * retrieve the value.
		 *
		 * @param node    The property value node to be parsed
		 *
		 * @return the value of the node after parsing
		 */
		public function parsePropertyValue(node:XML):* {
			var result:*;
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
		 * Registers in a temporary object which will be returned by the parse() method.
		 *
		 * @param objectName the name of the object
		 * @param objectDefinition the object definition
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void {
			(_definitions ||= {})[objectName] = objectDefinition;
		}

		private function createObjectDefinitionResult(objectDefinition:IObjectDefinition, xml:XML):IObjectDefinition {
			var result:IObjectDefinition;

			if (objectDefinition) {
				result = objectDefinition;
			} else if (!XMLUtils.hasAttribute(xml, CLASS_ATTRIBUTE)) {
				result = new ObjectDefinition(null, _defaultObjectDefinition);
			} else {
				result = new ObjectDefinition(xml.attribute(CLASS_ATTRIBUTE)[0], _defaultObjectDefinition);
			}

			return result;
		}

		private function isDefaultNamespace(qname:QName):Boolean {
			return ((qname.uri == "") || (qname.uri == Namespace(spring_actionscript_objects).uri));
		}

		private function parseCustomNode(node:XML):void {
			var qname:QName = QName(node.name());
			var namespaceHandler:INamespaceHandler = _namespaceHandlers[qname.uri];

			if (!namespaceHandler) {
				throw new Error("No namespace handler found for node '" + node + "' with URI '" + qname.uri + "'");
			}

			namespaceHandler.parse(node, this);
		}

		private function parseDefaultNode(node:XML):void {
			var qname:QName = QName(node.name());
			var isObjectNode:Boolean = (qname.localName == OBJECT_ELEMENT);
			var isAbstract:Boolean = (node.attribute(ABSTRACT_ATTRIBUTE).length() > 0);

			if (isObjectNode) {
				processObjectDefinition(node, isAbstract);
			}
		}

		private function parseMethodInvocation(node:XML):MethodInvocation {
			var methodName:String = node.@name;
			var namespaceURI:String = null;
			if (node.attribute(NAMESPACE_ATTRIBUTE).length() > 0) {
				namespaceURI = String(node.attribute(NAMESPACE_ATTRIBUTE)[0]);
			}
			var args:Vector.<ArgumentDefinition>;

			for each (var argXML:XML in node.arg) {
				args ||= new Vector.<ArgumentDefinition>();
				var lazyPropertyResolving:Boolean = (argXML.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE).length() > 0) ? (String(argXML.attribute(LAZY_PROPERTY_RESOLVING_ATTRIBUTE)) == TRUE_VALUE) : false;
				args[args.length] = ArgumentDefinition.newInstance(parseProperty(argXML), lazyPropertyResolving);
			}

			return new MethodInvocation(methodName, args, namespaceURI);
		}

		private function parseObjectDefinitions(xml:XML):void {
			for each (var node:XML in xml.children()) {
				parseNode(node);
			}
		}

		private function processObjectDefinition(node:XML, isAbstract:Boolean=false):void {
			var definition:IObjectDefinition = parseObjectDefinition(node);
			definition.isAbstract = isAbstract;
			registerObjectDefinition(node.@id, definition);
		}
	}
}
