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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.builder.EqualsBuilder;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;

	[Event(name="instancesDependenciesUpdated", type="org.springextensions.actionscript.ioc.objectdefinition.event.ObjectDefinitionEvent")]
	/**
	 * Describes an object that can be created by an <code>ObjectFactory</code>.
	 * @author Christophe Herreman
	 * @author Damir Murat
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinition extends BaseObjectDefinition implements IObjectDefinition, IEquals, ICloneable {

		private static const COLON:String = ':';

		private static const logger:ILogger = getClassLogger(ObjectDefinition);

		/**
		 * Creates a new <code>ObjectDefinition</code> instance.
		 * @param className The fully qualified class name for the object that this definition describes.
		 * @param baseDefinition An IBaseObjectDefinition instance that defines a number of default property values.
		 */
		public function ObjectDefinition(clazzName:String=null, baseDefinition:IBaseObjectDefinition=null) {
			super();
			_eventDispatcher = new EventDispatcher();
			className = clazzName;
			if (baseDefinition == null) {
				scope = ObjectDefinitionScope.SINGLETON;
				childContextAccess = ChildContextObjectDefinitionAccess.FULL;
				dependencyCheck = DependencyCheckMode.NONE;
				autoWireMode = AutowireMode.NO;
				isLazyInit = false;
				isAutoWireCandidate = true;
			} else {
				this.autoWireMode = baseDefinition.autoWireMode = this.autoWireMode = baseDefinition.autoWireMode;
				this.childContextAccess = baseDefinition.childContextAccess;
				this.dependencyCheck = baseDefinition.dependencyCheck;
				this.destroyMethod = baseDefinition.destroyMethod;
				this.factoryMethod = baseDefinition.factoryMethod;
				this.factoryObjectName = baseDefinition.factoryObjectName;
				this.initMethod = baseDefinition.initMethod;
				this.isAutoWireCandidate = baseDefinition.isAutoWireCandidate;
				this.isLazyInit = baseDefinition.isLazyInit;
				this.parentName = baseDefinition.parentName;
				this.scope = baseDefinition.scope;
				this.skipMetadata = baseDefinition.skipMetadata;
				this.skipPostProcessors = baseDefinition.skipPostProcessors;
			}
		}

		private var _className:String;
		private var _clazz:Class;
		private var _constructorArguments:Vector.<ArgumentDefinition>;
		private var _customConfiguration:*;
		private var _dependsOn:Vector.<String>;

		private var _eventDispatcher:IEventDispatcher;
		private var _isAbstract:Boolean;
		private var _isInterface:Boolean;
		private var _methodInvocations:Vector.<MethodInvocation>;
		private var _methodNameLookup:Object;
		private var _parent:IObjectDefinition;
		private var _primary:Boolean = false;
		private var _properties:Vector.<PropertyDefinition>;
		private var _propertyNameLookup:Object;
		private var _registryId:String = "";

		/**
		 * @inheritDoc
		 */
		public function get className():String {
			return _className;
		}

		/**
		 * @private
		 */
		public function set className(value:String):void {
			_className = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get clazz():Class {
			return _clazz;
		}

		/**
		 * @private
		 */
		public function set clazz(value:Class):void {
			_clazz = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get constructorArguments():Vector.<ArgumentDefinition> {
			return _constructorArguments;
		}

		/**
		 * @private
		 */
		public function set constructorArguments(value:Vector.<ArgumentDefinition>):void {
			_constructorArguments = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get customConfiguration():* {
			return _customConfiguration;
		}

		/**
		 * @private
		 */
		public function set customConfiguration(value:*):void {
			_customConfiguration = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get dependsOn():Vector.<String> {
			return _dependsOn;
		}

		/**
		 * @private
		 */
		public function set dependsOn(value:Vector.<String>):void {
			_dependsOn = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get isAbstract():Boolean {
			return _isAbstract;
		}

		/**
		 * @private
		 */
		public function set isAbstract(value:Boolean):void {
			_isAbstract = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get isInterface():Boolean {
			return _isInterface;
		}

		/**
		 * @private
		 */
		public function set isInterface(value:Boolean):void {
			_isInterface = value;
		}


		/**
		 * @default true
		 * @inheritDoc
		 */
		public function get isSingleton():Boolean {
			return (scope == ObjectDefinitionScope.SINGLETON);
		}

		/**
		 * @inheritDoc
		 */
		public function get methodInvocations():Vector.<MethodInvocation> {
			return _methodInvocations;
		}

		/**
		 * @inheritDoc
		 */
		public function get parent():IObjectDefinition {
			return _parent;
		}

		/**
		 * @private
		 */
		public function set parent(value:IObjectDefinition):void {
			_parent = value;
		}


		/**
		 * @default false
		 * @inheritDoc
		 */
		public function get primary():Boolean {
			return _primary;
		}

		/**
		 * @private
		 */
		public function set primary(value:Boolean):void {
			_primary = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get properties():Vector.<PropertyDefinition> {
			return _properties;
		}

		/**
		 * @inheritDoc
		 */
		public function get registryId():String {
			return _registryId;
		}

		/**
		 * @private
		 */
		public function set registryId(value:String):void {
			_registryId = value;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function addMethodInvocation(methodInvocation:MethodInvocation):void {
			var name:String = (methodInvocation.namespaceURI != null) ? methodInvocation.namespaceURI + COLON + methodInvocation.methodName : methodInvocation.methodName;
			_methodNameLookup ||= {};
			//if (_methodNameLookup[name] == null) {
			_methodInvocations ||= new Vector.<MethodInvocation>();
			_methodInvocations[_methodInvocations.length] = methodInvocation;
			_methodNameLookup[name] = methodInvocation;
			logger.debug("Added method invocation: '{0}'", [methodInvocation]);
			//} else {
			//	logger.debug("Method invocation with name '{0}' and namespace '{1}' already exists", [methodInvocation.methodName, methodInvocation.namespaceURI]);
			//}
		}

		/**
		 * @inheritDoc
		 */
		public function addPropertyDefinition(propertyDefinition:PropertyDefinition):void {
			var name:String = (propertyDefinition.namespaceURI != null) ? propertyDefinition.namespaceURI + COLON + propertyDefinition.name : propertyDefinition.name;
			_propertyNameLookup ||= {};
			if (_propertyNameLookup[name] == null) {
				_properties ||= new Vector.<PropertyDefinition>();
				_properties[_properties.length] = propertyDefinition;
				_propertyNameLookup[name] = propertyDefinition;
				logger.debug("Added property definition: '{0}'", [propertyDefinition]);
			} else {
				logger.debug("Property definition with name '{0}' and namespace '{1}' already exists", [propertyDefinition.name, propertyDefinition.namespaceURI]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function clone():* {
			var result:ObjectDefinition = new ObjectDefinition(this.className);
			result.autoWireMode = this.autoWireMode;
			result.childContextAccess = this.childContextAccess;
			result.clazz = this.clazz;
			result.constructorArguments = (this.constructorArguments != null) ? this.constructorArguments.concat() : null;
			result.dependencyCheck = this.dependencyCheck;
			result.dependsOn = (dependsOn != null) ? this.dependsOn.concat.apply(this) : null;
			result.destroyMethod = this.destroyMethod;
			result.factoryMethod = this.factoryMethod;
			result.factoryObjectName = this.factoryObjectName;
			result.initMethod = this.initMethod;
			result.isAbstract = this.isAbstract;
			result.isAutoWireCandidate = this.isAutoWireCandidate;
			result.isInterface = this.isInterface;
			result.isLazyInit = this.isLazyInit;
			cloneMethodInvocations(this.methodInvocations, result);
			result.parentName = this.parentName;
			result.primary = this.primary;
			cloneProperties(this.properties, result);
			result.scope = this.scope;
			result.skipMetadata = this.skipMetadata;
			result.skipPostProcessors = this.skipPostProcessors;
			if (this.customConfiguration is ICloneable) {
				result.customConfiguration = (this.customConfiguration as ICloneable).clone();
			} else if (this.customConfiguration is Vector.<Object>) {
				var configs:Vector.<Object> = (this.customConfiguration as Vector.<Object>);
				var newConfigs:Vector.<Object> = new Vector.<Object>();
				for each (var config:Object in configs) {
					if (config is ICloneable) {
						newConfigs[newConfigs.length] = (config as ICloneable).clone();
					} else {
						newConfigs[newConfigs.length] = config;
					}
				}
				result.customConfiguration = newConfigs;
			} else if (this.customConfiguration != null) {
				result.customConfiguration = this.customConfiguration;
			}
			logger.debug("Instance was cloned");
			return result;
		}

		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}

		/**
		 *
		 */
		public function equals(object:Object):Boolean {
			if (!(object is IObjectDefinition)) {
				return false;
			}

			if (object === this) {
				return true;
			}

			var that:IObjectDefinition = IObjectDefinition(object);

			return new EqualsBuilder().append(autoWireMode, that.autoWireMode). //
				append(className, that.className). //
				append(constructorArguments, that.constructorArguments). //
				append(dependsOn, that.dependsOn). //
				append(factoryMethod, that.factoryMethod). //
				append(factoryObjectName, that.factoryObjectName). //
				append(initMethod, that.initMethod). //
				append(isAutoWireCandidate, that.isAutoWireCandidate). //
				append(isLazyInit, that.isLazyInit). //
				append(isSingleton, that.isSingleton). //
				append(isAbstract, that.isAbstract). //
				append(methodInvocations, that.methodInvocations). //
				append(skipPostProcessors, that.skipPostProcessors). //
				append(skipMetadata, that.skipMetadata). //
				append(primary, that.primary). //
				append(properties, that.properties). //
				append(scope, that.scope). //
				append(dependencyCheck, that.dependencyCheck). //
				append(parent, that.parent). //
				append(parentName, that.parentName). //
				append(isInterface, that.isInterface). //
				append(customConfiguration, that.customConfiguration). //
				append(childContextAccess, that.childContextAccess). //
				equals;
		}

		/**
		 * @inheritDoc
		 */
		public function getMethodInvocationByName(name:String, namespace:String=null):MethodInvocation {
			if (_methodNameLookup != null) {
				var methodName:String = (namespace != null) ? namespace + COLON + name : name;
				return _methodNameLookup[methodName];
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getPropertyDefinitionByName(name:String, namespace:String=null):PropertyDefinition {
			if (_propertyNameLookup != null) {
				var propertyName:String = (namespace != null) ? namespace + COLON + name : name;
				return _propertyNameLookup[propertyName] as PropertyDefinition;
			}
			return null;
		}

		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function toString():String {
			return "ObjectDefinition{autoWireMode:" + autoWireMode + ",\n\tchildContextAccess:" + childContextAccess + ",\n\tclassName:\"" + _className + "\", clazz:" + _clazz + ",\n\tconstructorArguments:[" + _constructorArguments + "], customConfiguration:" + _customConfiguration + ",\n\tdependencyCheck:" + dependencyCheck + ",\n\tdependsOn:[" + dependsOn + "], destroyMethod:\"" + destroyMethod + "\", factoryMethod:\"" + factoryMethod + "\", factoryObjectName:\"" + factoryObjectName + "\", initMethod:\"" + initMethod + "\", isAbstract:" + _isAbstract + ",\n\tisAutoWireCandidate:" + isAutoWireCandidate + ",\n\tisInterface:" + _isInterface + ",\n\tisLazyInit:" + isLazyInit + ",\n\tmethodInvocations:[" + _methodInvocations + "], parent:" + _parent + ",\n\tparentName:\"" + parentName + "\", primary:" + _primary + ",\n\tproperties:[" + _properties + "], registryId:\"" + _registryId + "\", scope:" + scope + ",\n\tskipMetadata:" + skipMetadata + ",\n\tskipPostProcessors:" + skipPostProcessors + "}";
		}

		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}

		/**
		 *
		 * @param methodInvocations
		 * @param destination
		 */
		private function cloneMethodInvocations(methodInvocations:Vector.<MethodInvocation>, destination:IObjectDefinition):void {
			for each (var mi:MethodInvocation in methodInvocations) {
				destination.addMethodInvocation(mi.clone());
			}
		}

		/**
		 *
		 * @param properties
		 * @param destination
		 */
		private function cloneProperties(properties:Vector.<PropertyDefinition>, destination:IObjectDefinition):void {
			for each (var pd:PropertyDefinition in properties) {
				destination.addPropertyDefinition(pd.clone());
			}
		}
	}
}
