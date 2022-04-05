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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import mx.utils.UIDUtil;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ICustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.util.TypeUtils;

	[DefaultProperty("childContent")]
	/**
	 * <p>MXML representation of an <code>ObjectDefinition</code> object. This non-visual component must be declared as
	 * a child component of a <code>MXMLApplicationContext</code> component.</p>
	 * <p>Describes an object that can populate an IObjectDefinition instance with properties defined in MXML.</p>
	 * @see org.springextensions.actionscript.context.impl.mxml.MXMLApplicationContext MXMLApplicationContext
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLObjectDefinition extends EventDispatcher implements IMXMLObject, IApplicationContextAware {

		/**
		 * Prefix added to <code>ObjectDefinitions</code> without an explicit context id, this prefix is needed
		 * by the MXMLUtils serializer
		 */
		public static const ANON_OBJECT_PREFIX:String = "anonref_";

		public static const AUTO_WIRE_MODE_CHANGED_EVENT:String = "autoWireModeChanged";
		public static const CHILD_CONTEXT_ACCESS_CHANGED_EVENT:String = "childContextAccessChanged";
		public static const CLASS_NAME_CHANGED:String = "classNameChanged";
		public static const CLAZZ_CHANGED_EVENT:String = "clazzChanged";
		public static const CONSTRUCTOR_ARGUMENTS_CHANGED_EVENT:String = "constructorArgumentsChanged";
		public static const DEPENDENCY_CHECK_CHANGED_EVENT:String = "dependencyCheckChanged";
		public static const DEPENDS_ON_CHANGED_EVENT:String = "dependsOnChanged";
		public static const DEPENDS_ON_FIELD_NAME:String = "dependsOn";
		public static const DESTROY_METHOD_CHANGED_EVENT:String = "destroyMethodChanged";
		public static const FACTORY_METHOD_CHANGED_EVENT:String = "factoryMethodChanged";
		public static const FACTORY_OBJECT_CHANGED_EVENT:String = "factoryObjectChanged";
		public static const FACTORY_OBJECT_NAME_CHANGED_EVENT:String = "factoryObjectNameChanged";
		public static const ID_CHANGED_EVENT:String = "idChanged";
		public static const INIT_METHOD_CHANGED_EVENT:String = "initMethodChanged";
		public static const IS_ABSTRACT_CHANGED_EVENT:String = "isAbstractChanged";
		public static const IS_AUTO_WIRE_CANDIDATE_CHANGED_EVENT:String = "isAutoWireCandidateChanged";
		public static const IS_LAZY_INIT_CHANGED_EVENT:String = "isLazyInitChanged";
		public static const PARENT_OBJECT_CHANGED_EVENT:String = "parentObjectChanged";
		public static const PRIMARY_CHANGED_EVENT:String = "primaryChanged";
		public static const SCOPE_CHANGED_EVENT:String = "scopeChanged";
		public static const SKIP_METADATA_CHANGED_EVENT:String = "skipMetadataChanged";
		public static const SKIP_POST_PROCESSORS_CHANGED_EVENT:String = "skipPostProcessorsChanged";
		private static const AUTO_WIRE_MODE_FIELD_NAME:String = 'autoWireMode';
		private static const BOOLEAN_TYPE_ATTR_NAME:String = "boolean";
		private static const CHILD_CONTEXT_ACCESS_FIELD_NAME:String = "childContextAccess";
		private static const CLASS_NAME_FIELD_NAME:String = 'className';
		private static const CLASS_TYPE_ATTR_NAME:String = "class";
		private static const CLAZZ_FIELD_NAME:String = 'clazz';
		private static const DEPENDENCY_CHECK_FIELD_NAME:String = 'dependencyCheck';
		private static const DESTROY_METHOD_FIELD_NAME:String = 'destroyMethod';
		private static const FACTORY_METHOD_FIELD_NAME:String = 'factoryMethod';
		private static const FACTORY_OBJECT_FIELD_NAME:String = 'factoryObject';
		private static const FACTORY_OBJECT_NAME_FIELD_NAME:String = 'factoryObjectName';
		private static const INIT_METHOD_FIELD_NAME:String = 'initMethod';
		private static const IS_ABSTRACT_FIELD_NAME:String = 'isAbstract';
		private static const IS_AUTO_WIRE_CANDIDATE_FIELD_NAME:String = 'isAutoWireCandidate';
		private static const IS_LAZY_INIT_FIELD_NAME:String = 'isLazyInit';
		private static const PARENT_DOCUMENT_FIELD_NAME:String = "parentDocument";
		private static const PARENT_NAME_FIELD_NAME:String = 'parentName';
		private static const PARENT_OBJECT_FIELD_NAME:String = 'parentObject';
		private static const PRIMARY_FIELD_NAME:String = 'primary';
		private static const SCOPE_FIELD_NAME:String = 'scope';
		private static const SKIP_METADATA_FIELD_NAME:String = 'skipMetadata';
		private static const SKIP_POST_PROCESSORS_FIELD_NAME:String = 'skipPostProcessors';
		private static const TRUE_VALUE:String = "true";

		/**
		 * Creates a new <code>ObjectDefinition</code> instance
		 *
		 */
		public function MXMLObjectDefinition() {
			super();
			_objectDefinitions = {};
			_scope = ObjectDefinitionScope.SINGLETON;
			_params = new Dictionary();
			_methodDefinitions = new Dictionary();
			_defaultedProperties = new Dictionary();
			_defaultedProperties[PARENT_OBJECT_FIELD_NAME] = true;
			_defaultedProperties[CLAZZ_FIELD_NAME] = true;
			_defaultedProperties[CLASS_NAME_FIELD_NAME] = true;
			_defaultedProperties[FACTORY_OBJECT_NAME_FIELD_NAME] = true;
			_defaultedProperties[FACTORY_METHOD_FIELD_NAME] = true;
			_defaultedProperties[INIT_METHOD_FIELD_NAME] = true;
			_defaultedProperties[SCOPE_FIELD_NAME] = true;
			_defaultedProperties[IS_LAZY_INIT_FIELD_NAME] = true;
			_defaultedProperties[IS_ABSTRACT_FIELD_NAME] = false;
			_defaultedProperties[IS_AUTO_WIRE_CANDIDATE_FIELD_NAME] = true;
			_defaultedProperties[AUTO_WIRE_MODE_FIELD_NAME] = true;
			_defaultedProperties[PRIMARY_FIELD_NAME] = true;
			_defaultedProperties[SKIP_POST_PROCESSORS_FIELD_NAME] = true;
			_defaultedProperties[CHILD_CONTEXT_ACCESS_FIELD_NAME] = true;
			_defaultedProperties[SKIP_METADATA_FIELD_NAME] = true;
			_defaultedProperties[DEPENDENCY_CHECK_FIELD_NAME] = true;
			_defaultedProperties[DESTROY_METHOD_FIELD_NAME] = true;
			_explicitProperties = new Dictionary();
		}

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}
		private var _applicationDomain:ApplicationDomain;

		/**
		 * @private
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}
		private var _autoWireMode:String;

		[Bindable(event="autoWireModeChanged")]
		/**
		 * Defines the way an object will be autowired (configured). This can be the following values: no,byName,byType,constructor,autodetect
		 */
		public function get autoWireMode():String {
			return _autoWireMode;
		}

		[Inspectable(enumeration="no,byName,byType,constructor,autodetect", defaultValue="no")]
		/**
		 * @private
		 */
		public function set autoWireMode(value:String):void {
			if (_autoWireMode != value) {
				_autoWireMode = value;
				delete _defaultedProperties[AUTO_WIRE_MODE_FIELD_NAME];
				_explicitProperties[AUTO_WIRE_MODE_FIELD_NAME] = true;
				dispatchEvent(new Event(AUTO_WIRE_MODE_CHANGED_EVENT));
			}
		}
		private var _childContent:Array;

		/**
		 * Placeholder for all MXML child content of the current <code>ObjectDefinition</code>
		 */
		public function get childContent():Array {
			return _childContent;
		}

		/**
		 * @private
		 */
		public function set childContent(value:Array):void {
			_childContent = value;
		}
		private var _childContextAccess:String;

		[Bindable(event="childContextAccessChanged")]
		public function get childContextAccess():String {
			return _childContextAccess;
		}

		[Inspectable(enumeration="none,definition,singleton,full", defaultValue="full")]
		public function set childContextAccess(value:String):void {
			if (_childContextAccess != value) {
				_childContextAccess = value;
				delete _defaultedProperties[CHILD_CONTEXT_ACCESS_FIELD_NAME];
				_explicitProperties[CHILD_CONTEXT_ACCESS_FIELD_NAME] = true;
				dispatchEvent(new Event(CHILD_CONTEXT_ACCESS_CHANGED_EVENT));
			}
		}
		private var _className:String;

		[Bindable(event="classNameChanged")]
		/**
		 * The classname of the object that the current <code>ObjectDefinition</code> describes.
		 */
		public function get className():String {
			return _className;
		}

		/**
		 * @private
		 */
		public function set className(value:String):void {
			if (_className != value) {
				_className = value;
				_clazz = ClassUtils.forName(_className, Type.currentApplicationDomain);
				delete _defaultedProperties[CLASS_NAME_FIELD_NAME];
				delete _defaultedProperties[CLAZZ_FIELD_NAME];
				_explicitProperties[CLAZZ_FIELD_NAME] = true;
				_explicitProperties[CLASS_NAME_FIELD_NAME] = true;
				dispatchEvent(new Event(CLAZZ_CHANGED_EVENT));
				dispatchEvent(new Event(CLASS_NAME_CHANGED));
			}
		}
		private var _clazz:Class;

		[Bindable(event="clazzChanged")]
		/**
		 * The <code>Class</code> of the object that the current <code>ObjectDefinition</code> describes.
		 */
		public function get clazz():Class {
			return _clazz;
		}

		/**
		 * @private
		 */
		public function set clazz(value:Class):void {
			if (_clazz !== value) {
				_clazz = value;
				_className = (_clazz != null) ? ClassUtils.getFullyQualifiedName(_clazz, true) : null;
				delete _defaultedProperties[CLAZZ_FIELD_NAME];
				delete _defaultedProperties[CLASS_NAME_FIELD_NAME];
				_explicitProperties[CLAZZ_FIELD_NAME] = true;
				_explicitProperties[CLASS_NAME_FIELD_NAME] = true;
				dispatchEvent(new Event(CLASS_NAME_CHANGED));
				dispatchEvent(new Event(CLAZZ_CHANGED_EVENT));
			}
		}
		private var _defaultedProperties:Dictionary;

		/**
		 * A dictionary of property names that have not been explicitly set through MXML markup.
		 * When the current <code>ObjectDefinition</code> is configured by a <code>Template</code> or parent definition
		 * only the properties present in this dictionary will be copied from the source definition.
		 * @see org.springextensions.actionscript.context.support.mxml.Template Template
		 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition#parentObject parentObject
		 */
		public function get defaultedProperties():Dictionary {
			return _defaultedProperties;
		}
		private var _definition:IObjectDefinition;

		/**
		 * The <code>IObjectDefinition</code> that is populated by the current MXML <code>ObjectDefinition</code>
		 */
		public function get definition():IObjectDefinition {
			return _definition;
		}
		private var _dependencyCheck:String;

		[Bindable(event="dependencyCheckChanged")]
		/**
		 *
		 */
		public function get dependencyCheck():String {
			return _dependencyCheck;
		}

		[Inspectable(enumeration="none,simple,objects,all", defaultValue="none")]
		/**
		 * @private
		 */
		public function set dependencyCheck(value:String):void {
			if (_dependencyCheck !== value) {
				_dependencyCheck = value;
				delete _defaultedProperties[DEPENDENCY_CHECK_FIELD_NAME];
				_explicitProperties[DEPENDENCY_CHECK_FIELD_NAME] = true;
				dispatchEvent(new Event(DEPENDENCY_CHECK_CHANGED_EVENT));
			}
		}
		private var _dependsOn:Array = [];

		[Bindable(event="dependsOnChanged")]
		/**
		 *
		 */
		public function get dependsOn():Array {
			return _dependsOn;
		}

		/**
		 * @private
		 */
		public function set dependsOn(value:Array):void {
			if (_dependsOn !== value) {
				_dependsOn = value;
				_explicitProperties[DEPENDS_ON_FIELD_NAME] = true;
				dispatchEvent(new Event(DEPENDS_ON_CHANGED_EVENT));
			}
		}
		private var _destroyMethod:String;

		[Bindable(event="destroyMethodChanged")]
		/**
		 * The name of a method on the class defined by the <code>class</code> property that will be called when the
		 * application context is disposed. Destroy methods are used to release resources that are being kept by an object.
		 */
		public function get destroyMethod():String {
			return _destroyMethod;
		}

		/**
		 * @private
		 */
		public function set destroyMethod(value:String):void {
			if (_destroyMethod != value) {
				_destroyMethod = value;
				delete _defaultedProperties[DESTROY_METHOD_FIELD_NAME];
				_explicitProperties[DESTROY_METHOD_FIELD_NAME] = true;
				dispatchEvent(new Event(DESTROY_METHOD_CHANGED_EVENT));
			}
		}
		private var _explicitProperties:Dictionary;

		/**
		 * A dictionary of property names that have been explicitly set through MXML markup.
		 */
		public function get explicitProperties():Dictionary {
			return _explicitProperties;
		}
		private var _factoryMethod:String;

		[Bindable(event="factoryMethodChanged")]
		/**
		 * The name of method responsible for the creation of the object.
		 */
		public function get factoryMethod():String {
			return _factoryMethod;
		}

		/**
		 * @private
		 */
		public function set factoryMethod(value:String):void {
			if (_factoryMethod != value) {
				_factoryMethod = value;
				delete _defaultedProperties[FACTORY_METHOD_FIELD_NAME];
				_explicitProperties[FACTORY_METHOD_FIELD_NAME] = true;
				dispatchEvent(new Event(FACTORY_METHOD_CHANGED_EVENT));
			}
		}
		private var _factoryObject:MXMLObjectDefinition;

		[Bindable(event="factoryObjectChanged")]
		/**
		 * The ObjectDefinition for the factory object responsible for the creation of the object.
		 */
		public function get factoryObject():MXMLObjectDefinition {
			return _factoryObject;
		}

		/**
		 * @private
		 */
		public function set factoryObject(value:MXMLObjectDefinition):void {
			if (_factoryObject !== value) {
				_factoryObject = value;
				_factoryObjectName = (_factoryObject != null) ? _factoryObject.id : null;
				delete _defaultedProperties[FACTORY_OBJECT_NAME_FIELD_NAME];
				_explicitProperties[FACTORY_OBJECT_NAME_FIELD_NAME] = true;
				dispatchEvent(new Event(FACTORY_OBJECT_CHANGED_EVENT));
				dispatchEvent(new Event(FACTORY_OBJECT_NAME_CHANGED_EVENT));
			}
		}
		private var _factoryObjectName:String;

		[Bindable(event="factoryObjectNameChanged")]
		/**
		 * The name of the factory object responsible for the creation of the object.
		 */
		public function get factoryObjectName():String {
			return _factoryObjectName;
		}

		/**
		 * @private
		 */
		public function set factoryObjectName(value:String):void {
			if (_factoryObjectName != value) {
				_factoryObjectName = value;
				delete _defaultedProperties[FACTORY_OBJECT_NAME_FIELD_NAME];
				_explicitProperties[FACTORY_OBJECT_NAME_FIELD_NAME] = true;
				dispatchEvent(new Event(FACTORY_OBJECT_NAME_CHANGED_EVENT));
			}
		}
		private var _id:String;

		[Bindable(event="idChanged")]
		/**
		 * The unique id for the current <code>ObjectDefinition</code> as defined in the MXML markup. This id will
		 * also be used to register as the name of the <code>IObjectDefinition</code> instance.
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
		 */
		public function get id():String {
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void {
			if (_id != value) {
				_id = value;
				dispatchEvent(new Event(ID_CHANGED_EVENT));
			}
		}
		private var _initMethod:String;

		[Bindable(event="initMethodChanged")]
		/**
		 * The name of a method on the class defined by the className property or clazz property that will be called immediately after the object has been configured.
		 */
		public function get initMethod():String {
			return _initMethod;
		}

		/**
		 * @private
		 */
		public function set initMethod(value:String):void {
			if (_initMethod != value) {
				_initMethod = value;
				delete _defaultedProperties[INIT_METHOD_FIELD_NAME];
				_explicitProperties[INIT_METHOD_FIELD_NAME] = true;
				dispatchEvent(new Event(INIT_METHOD_CHANGED_EVENT));
			}
		}
		private var _isAbstract:Boolean;

		[Bindable(event="isAbstractChanged")]
		/**
		 * The name of a method on the class defined by the className property or clazz property that will be called immediately after the object has been configured.
		 */
		public function get isAbstract():Boolean {
			return _isAbstract;
		}

		/**
		 * @private
		 */
		public function set isAbstract(value:Boolean):void {
			delete _defaultedProperties[IS_ABSTRACT_FIELD_NAME];
			_explicitProperties[IS_ABSTRACT_FIELD_NAME] = true;
			if (_isAbstract != value) {
				_isAbstract = value;
				dispatchEvent(new Event(IS_ABSTRACT_CHANGED_EVENT));
			}
		}
		private var _isAutoWireCandidate:Boolean;

		[Bindable(event="isAutoWireCandidateChanged")]
		/**
		 * True if this object can be used as a value used by the container when it autowires an object by type.
		 */
		public function get isAutoWireCandidate():Boolean {
			return _isAutoWireCandidate;
		}

		/**
		 * @private
		 */
		public function set isAutoWireCandidate(value:Boolean):void {
			delete _defaultedProperties[IS_AUTO_WIRE_CANDIDATE_FIELD_NAME];
			_explicitProperties[IS_AUTO_WIRE_CANDIDATE_FIELD_NAME] = true;
			if (_isAutoWireCandidate != value) {
				_isAutoWireCandidate = value;
				dispatchEvent(new Event(IS_AUTO_WIRE_CANDIDATE_CHANGED_EVENT));
			}
		}

		protected var _isInitialized:Boolean = false;

		public function get isInitialized():Boolean {
			return _isInitialized;
		}
		private var _isLazyInit:Boolean;

		[Bindable(event="isLazyInitChanged")]
		/**
		 * <code>True</code> if the object does not need to be eagerly pre-instantiated by the container. I.e. the object will be created after the first call to the <code>getObject()</code> method.
		 */
		public function get isLazyInit():Boolean {
			return _isLazyInit;
		}

		/**
		 * @private
		 */
		public function set isLazyInit(value:Boolean):void {
			delete _defaultedProperties[IS_LAZY_INIT_FIELD_NAME];
			_explicitProperties[IS_LAZY_INIT_FIELD_NAME] = true;
			if (_isLazyInit != value) {
				_isLazyInit = value;
				dispatchEvent(new Event(IS_LAZY_INIT_CHANGED_EVENT));
			}
		}
		private var _methodDefinitions:Dictionary;

		/**
		 * A dictionary of <code>MethodInvocation</code> objects
		 * @see org.springextensions.actionscript.context.support.mxml.MethodInvocation MethodInvocation
		 */
		public function get methodDefinitions():Dictionary {
			return _methodDefinitions;
		}
		private var _objectDefinitions:Object;

		public function get objectDefinitions():Object {
			return _objectDefinitions;
		}
		private var _params:Dictionary;

		/**
		 * A dictionary of <code>Param</code> objects
		 * @see org.springextensions.actionscript.context.support.mxml.Param Param
		 */
		public function get params():Dictionary {
			return _params;
		}
		private var _parentObject:MXMLObjectDefinition;

		[Bindable(event="parentObjectChanged")]
		/**
		 *  If not null the specified ObjectDefinition will be used to populate the current ObjectDefinition
		 */
		public function get parentObject():MXMLObjectDefinition {
			return _parentObject;
		}

		/**
		 * @private
		 */
		public function set parentObject(value:MXMLObjectDefinition):void {
			if (_parentObject !== value) {
				_parentObject = value;
				if (value != null) {
					_parentName = value.id;
				}
				_parent = _parentObject.definition;
				delete _defaultedProperties[PARENT_OBJECT_FIELD_NAME];
				_explicitProperties[PARENT_NAME_FIELD_NAME] = true;
				dispatchEvent(new Event(PARENT_OBJECT_CHANGED_EVENT));
			}
		}
		private var _primary:Boolean;

		[Bindable(event="primaryChanged")]
		/**
		 * True if this object needs to be used as the primary autowire candidate when the container is autowiring by type. This means that if multiple objects are found of the same type, the object marked as 'primary' will become the autowire candidate.
		 */
		public function get primary():Boolean {
			return _primary;
		}

		/**
		 * @private
		 */
		public function set primary(value:Boolean):void {
			delete _defaultedProperties[PRIMARY_FIELD_NAME];
			_explicitProperties[PRIMARY_FIELD_NAME] = true;
			if (_primary != value) {
				_primary = value;
				dispatchEvent(new Event(PRIMARY_CHANGED_EVENT));
			}
		}
		private var _scope:ObjectDefinitionScope;

		[Bindable(event="scopeChanged")]
		[Inspectable(enumeration="prototype,singleton,stage,remote", defaultValue="singleton")]
		/**
		 * Defines the scope of the object, the object is either a singleton or a prototype object.
		 */
		public function get scope():String {
			return _scope.toString();
		}

		/**
		 * @private
		 */
		public function set scope(value:String):void {
			if (_scope.name != value) {
				_scope = ObjectDefinitionScope.fromName(value);
				delete _defaultedProperties[SCOPE_FIELD_NAME];
				_explicitProperties[SCOPE_FIELD_NAME] = true;
				dispatchEvent(new Event(SCOPE_CHANGED_EVENT));
			}
		}
		private var _skipMetadata:Boolean;

		[Bindable(event="skipMetadataChanged")]
		/**
		 *
		 */
		public function get skipMetadata():Boolean {
			return _skipMetadata;
		}

		/**
		 * @private
		 */
		public function set skipMetadata(value:Boolean):void {
			delete _defaultedProperties[SKIP_METADATA_FIELD_NAME];
			_explicitProperties[SKIP_METADATA_FIELD_NAME] = true;
			if (_skipMetadata != value) {
				_skipMetadata = value;
				dispatchEvent(new Event(SKIP_METADATA_CHANGED_EVENT));
			}

		}
		private var _skipPostProcessors:Boolean;

		[Bindable(event="skipPostProcessorsChanged")]
		/**
		 *
		 */
		public function get skipPostProcessors():Boolean {
			return _skipPostProcessors;
		}

		/**
		 * @private
		 */
		public function set skipPostProcessors(value:Boolean):void {
			delete _defaultedProperties[SKIP_POST_PROCESSORS_FIELD_NAME];
			_explicitProperties[SKIP_POST_PROCESSORS_FIELD_NAME] = true;
			if (_skipPostProcessors != value) {
				_skipPostProcessors = value;
				dispatchEvent(new Event(SKIP_POST_PROCESSORS_CHANGED_EVENT));
			}
		}
		private var _defaultDefinition:IBaseObjectDefinition;


		protected function get defaultDefinition():IBaseObjectDefinition {
			return _defaultDefinition;
		}
		private var _anonObjectsCount:int = 0;
		private var _constructorArguments:Array;
		private var _document:Object;
		private var _parent:IObjectDefinition;
		private var _parentName:String;

		/**
		 * Adds the specified <code>ConstructorArg</code> resolved value to the constructorArguments array.
		 * @param param The specified <code>ConstructorArg</code> instance.
		 */
		public function addConstructorArg(arg:ConstructorArg):void {
			_definition.constructorArguments ||= new Vector.<ArgumentDefinition>();
			_definition.constructorArguments[_definition.constructorArguments.length] = resolveValue(arg);
		}

		/**
		 * Adds the specified <code>MethodInvocation</code> to the methodDefinitions dictionary, then creates an <code>IObjectDefinition</code>
		 * based on the <code>MethodInvocation</code> properties, adds this to the <code>definition.methodInvocations</code> and propertyObjectDefinitions lists.
		 * @param method The specified <code>MethodInvocation</code> instance.
		 */
		public function addMethodInvocation(method:org.springextensions.actionscript.ioc.config.impl.mxml.component.MethodInvocation):void {
			var newMethod:org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation = method.toMethodInvocation(_applicationContext, _defaultDefinition);
			var len:int = (method.arguments) ? method.arguments.length : 0;
			for (var i:int = 0; i < len; ++i) {
				var arg:Arg = method.arguments[i];
				newMethod.arguments[i] = resolveValue(arg);
			}
			_definition.addMethodInvocation(newMethod);
		}

		/**
		 * Adds the specified <code>Property</code> to the properties dictionary and resolves its value by invoking <code>resolveValue()</code>.
		 * @param param The specified <code>Property</code> instance.
		 */
		public function addProperty(property:Property):void {
			var propDef:PropertyDefinition = property.toPropertyDefinition();
			propDef.valueDefinition = resolveValue(property);
			_definition.addPropertyDefinition(propDef);
		}

		/**
		 * After <code>FlexEvent.CREATION_COMPLETE</code> has been dispatched the <code>processChildContent()</code> method is invoked.
		 */
		public function initializeComponent(context:IApplicationContext, defaultObjectDefinition:IBaseObjectDefinition):void {
			if (!_isInitialized) {
				_applicationContext = context;
				_defaultDefinition = defaultObjectDefinition;
				_definition = new ObjectDefinition(_className, defaultObjectDefinition);
				for (var propertyName:String in _explicitProperties) {
					if (!this.hasOwnProperty(propertyName)) {
						if (propertyName == PARENT_NAME_FIELD_NAME) {
							_definition.parentName = _parentName;
						} else if (propertyName == PARENT_OBJECT_FIELD_NAME) {
							if (_parentObject != null) {
								_parentObject.initializeComponent(context, defaultObjectDefinition)
								_definition.parent = _parentObject.definition;
							} else {
								_definition.parent = null;
							}
						}
						continue;
					}
					if (propertyName == AUTO_WIRE_MODE_FIELD_NAME) {
						_definition.autoWireMode = AutowireMode.fromName(this.autoWireMode);
					} else if (propertyName == CHILD_CONTEXT_ACCESS_FIELD_NAME) {
						_definition.childContextAccess = ChildContextObjectDefinitionAccess.fromValue(this.childContextAccess);
					} else if (propertyName == DEPENDENCY_CHECK_FIELD_NAME) {
						_definition.dependencyCheck = DependencyCheckMode.fromName(this.dependencyCheck);
					} else if (propertyName == SCOPE_FIELD_NAME) {
						_definition.scope = _scope;
					} else if (propertyName == DEPENDS_ON_FIELD_NAME) {
						var depOn:Vector.<String>;
						for each (var item:* in _dependsOn) {
							(depOn ||= new Vector.<String>())[depOn.length] = (item is MXMLObjectDefinition) ? item.id : item as String;
						}
						_definition.dependsOn = depOn;
					} else {
						_definition[propertyName] = this[propertyName];
					}
				}
				parse();
				_isInitialized = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function initialized(document:Object, id:String):void {
			_document = document;
			_applicationDomain ||= Type.currentApplicationDomain;
			_id = (StringUtils.hasText(id)) ? id : UIDUtil.createUID();
		}

		/**
		 * Parses the MXML object definition.
		 */
		public function parse():void {
			for each (var obj:* in _childContent) {
				if (obj is Property) {
					addProperty(obj);
				} else if (obj is ConstructorArg) {
					addConstructorArg(obj);
				} else if (obj is org.springextensions.actionscript.ioc.config.impl.mxml.component.MethodInvocation) {
					addMethodInvocation(obj);
				} else if (obj is ICustomObjectDefinitionComponent) {
					var custom:ICustomObjectDefinitionComponent = obj;
					custom.execute(applicationContext, objectDefinitions, _defaultDefinition, _definition, this.id);
				} else {
					throw new Error("Illegal child object for ObjectDefinition: " + ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(obj)));
				}
			}
		}

		private function findConfigurationPropertyNameWithValue(propertyValue:*):RuntimeObjectReference {
			var type:Type = Type.forInstance(_document, _applicationDomain);
			if (type != null) {
				for each (var field:Field in type.properties) {
					if ((field.declaringType === type) && (_document.hasOwnProperty(field.name))) {
						if (_document[field.name] === propertyValue) {
							return new RuntimeObjectReference(field.name);
						}
					}
				}
			}
			return null;
		}

		/**
		 * Returns a <code>RuntimeObjectReference</code> instance if the specified <code>Arg</code> has a ref property assigned, returns a <code>Class</code> instance
		 * if the <code>Arg</code> has a type property of "class" and a string as value, returns a <code>RuntimeObjectReference</code> if the property value is a <code>ObjectDefinition</code>
		 * and adds this instance to the propertyObjectDefinitions list, in all other cases it just returns the value of the specified <code>Arg</code>.
		 * @param arg The specified <code>Arg</code>
		 * @return The actual value of the <code>Arg</code>
		 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
		 * @see org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference RuntimeObjectReference
		 */
		private function resolveValue(arg:Arg):ArgumentDefinition {
			var result:*;
			if (!arg.isInitialized) {
				arg.initializeComponent(_applicationContext, _defaultDefinition);
			}

			if (arg.ref) {
				if (arg.ref is MXMLObjectDefinition) {
					result = new RuntimeObjectReference(MXMLObjectDefinition(arg.ref).id);
				} else if (arg.ref is String) {
					result = new RuntimeObjectReference(String(arg.ref));
				} else {
					result = findConfigurationPropertyNameWithValue(arg.ref);
					if (result == null) {
						throw new IllegalOperationError("The ref type must either be MXMLObjectdefinition or a String that represents the ID of a definition or singleton");
					}
				}
			} else if (arg.type) {
				var argType:String = arg.type.toLowerCase();
				if (argType == CLASS_TYPE_ATTR_NAME) {
					result = ClassUtils.forName(String(arg.value), _applicationDomain);
				} else if (argType == BOOLEAN_TYPE_ATTR_NAME) {
					result = (String(arg.value).toLowerCase() == TRUE_VALUE);
				} else {
					result = arg.value;
				}
			} else {
				var type:Type = Type.forInstance(arg.value, _applicationDomain);
				if (!TypeUtils.isSimpleProperty(type)) {
					result = findConfigurationPropertyNameWithValue(arg.value);
					if (result == null) {
						var newId:String = ANON_OBJECT_PREFIX + (++_anonObjectsCount).toString();
						_applicationContext.cache.putInstance(newId, arg.value);
						result = new RuntimeObjectReference(newId);
					}
				} else {
					result = arg.value;
				}
			}
			return ArgumentDefinition.newInstance(result, arg.lazyPropertyResolving);
		}
	}
}
