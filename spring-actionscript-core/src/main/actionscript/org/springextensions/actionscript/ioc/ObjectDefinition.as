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
package org.springextensions.actionscript.ioc {

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.builder.EqualsBuilder;

	/**
	 * Describes an object that can be created by an <code>ObjectFactory</code>.
	 * @author Christophe Herreman, Damir Murat
	 * @docref container-documentation.html#the_objects
	 */
	public class ObjectDefinition implements IObjectDefinition, IEquals {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>ObjectDefinition</code> instance.
		 * @param className The fully qualified class name for the object that this definition describes
		 */
		public function ObjectDefinition(className:String = null) {
			initObjectDefinition(className);
		}

		protected function initObjectDefinition(className:String):void {
			this.className = className;
			this.constructorArguments = [];
			this.properties = {};
			this.scope = ObjectDefinitionScope.SINGLETON;
			this.isLazyInit = false;
			this.dependsOn = [];
			this.autoWireMode = AutowireMode.NO;
			this.isAutoWireCandidate = true;
			this.primary = false;
			this.methodInvocations = [];
			this.dependencyCheck = DependencyCheckMode.NONE;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// className
		// ----------------------------

		private var _className:String;

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

		// ----------------------------
		// factoryObjectName
		// ----------------------------

		private var _factoryObjectName:String;

		/**
		 * @inheritDoc
		 */
		public function get factoryObjectName():String {
			return _factoryObjectName;
		}

		/**
		 * @private
		 */
		public function set factoryObjectName(value:String):void {
			_factoryObjectName = value;
		}

		// ----------------------------
		// factoryMethod
		// ----------------------------

		private var _factoryMethod:String;

		/**
		 * @inheritDoc
		 */
		public function get factoryMethod():String {
			return _factoryMethod;
		}

		/**
		 * @private
		 */
		public function set factoryMethod(value:String):void {
			_factoryMethod = value;
		}

		// ----------------------------
		// initMethod
		// ----------------------------

		private var _initMethod:String;

		/**
		 * @inheritDoc
		 */
		public function get initMethod():String {
			return _initMethod;
		}

		/**
		 * @private
		 */
		public function set initMethod(value:String):void {
			_initMethod = value;
		}

		// ----------------------------
		// destroyMethod
		// ----------------------------

		private var _destroyMethod:String;

		public function get destroyMethod():String {
			return _destroyMethod;
		}

		/**
		 * @private
		 */
		public function set destroyMethod(value:String):void {
			_destroyMethod = value;
		}

		// ----------------------------
		// constructorArguments
		// ----------------------------

		private var _constructorArguments:Array;

		/**
		 * @inheritDoc
		 */
		public function get constructorArguments():Array {
			return _constructorArguments;
		}

		/**
		 * @private
		 */
		public function set constructorArguments(value:Array):void {
			_constructorArguments = value;
		}

		// ----------------------------
		// properties
		// ----------------------------

		private var _properties:Object;

		/**
		 * @inheritDoc
		 */
		public function get properties():Object {
			return _properties;
		}

		/**
		 * @private
		 */
		public function set properties(value:Object):void {
			_properties = value;
		}

		// ----------------------------
		// isSingleton
		// ----------------------------

		private var _scope:ObjectDefinitionScope;

		/**
		 * @default true
		 * @inheritDoc
		 */
		public function get isSingleton():Boolean {
			return (scope == ObjectDefinitionScope.SINGLETON);
		}

		/**
		 * @private
		 */
		public function set isSingleton(value:Boolean):void {
			scope = (value) ? ObjectDefinitionScope.SINGLETON : ObjectDefinitionScope.PROTOTYPE;
		}

		// ----------------------------
		// scope
		// ----------------------------

		/**
		 * @default ObjectDefinitionScope.SINGLETON
		 * @inheritDoc
		 */
		public function get scope():ObjectDefinitionScope {
			return _scope;
		}

		/**
		 * @private
		 */
		public function set scope(value:ObjectDefinitionScope):void {
			Assert.notNull(value, "The scope cannot be null");
			_scope = value;
		}

		// ----------------------------
		// isLazyInit
		// ----------------------------

		private var _isLazyInit:Boolean;

		/**
		 * @default false
		 * @inheritDoc
		 */
		public function get isLazyInit():Boolean {
			return _isLazyInit;
		}

		/**
		 * @private
		 */
		public function set isLazyInit(value:Boolean):void {
			_isLazyInit = value;
		}

		// ----------------------------
		// dependsOn
		// ----------------------------

		private var _dependsOn:Array;

		/**
		 * @inheritDoc
		 */
		public function get dependsOn():Array {
			return _dependsOn;
		}

		/**
		 * @private
		 */
		public function set dependsOn(value:Array):void {
			_dependsOn = value;
		}

		// ----------------------------
		// isAutoWireCandidate
		// ----------------------------

		private var _isAutoWireCandidate:Boolean;

		/**
		 * @default true
		 * @inheritDoc
		 */
		public function get isAutoWireCandidate():Boolean {
			return _isAutoWireCandidate;
		}

		/**
		 * @private
		 */
		public function set isAutoWireCandidate(value:Boolean):void {
			this._isAutoWireCandidate = value;
		}

		// ----------------------------
		// autoWireMode
		// ----------------------------

		private var _autoWireMode:AutowireMode;

		/**
		 * @default AutowireMode.NO
		 * @inheritDoc
		 */
		public function get autoWireMode():AutowireMode {
			return this._autoWireMode;
		}

		/**
		 * @private
		 */
		public function set autoWireMode(value:AutowireMode):void {
			this._autoWireMode = (value) ? value : AutowireMode.NO;
		}

		// ----------------------------
		// primary
		// ----------------------------

		private var _primary:Boolean;

		/**
		 * @default false
		 * @inheritDoc
		 */
		public function get primary():Boolean {
			return this._primary;
		}

		/**
		 * @private
		 */
		public function set primary(value:Boolean):void {
			this._primary = value;
		}

		// ----------------------------
		// methodInvocations
		// ----------------------------

		private var _methodInvocations:Array;

		/**
		 * @inheritDoc
		 */
		public function get methodInvocations():Array {
			return _methodInvocations;
		}

		/**
		 * @private
		 */
		public function set methodInvocations(value:Array):void {
			_methodInvocations = value;
		}

		// ----------------------------
		// skipPostProcessors
		// ----------------------------

		private var _skipPostProcessors:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get skipPostProcessors():Boolean {
			return _skipPostProcessors;
		}

		/**
		 * @default false
		 * @inheritDoc
		 */
		public function set skipPostProcessors(value:Boolean):void {
			_skipPostProcessors = value;
		}

		// ----------------------------
		// skipMetadata
		// ----------------------------

		private var _skipMetadata:Boolean = false;

		/**
		 * @default false
		 * @inheritDoc
		 */
		public function get skipMetadata():Boolean {
			return _skipMetadata;
		}

		/**
		 * @inheritDoc
		 */
		public function set skipMetadata(value:Boolean):void {
			_skipMetadata = value;
		}

		// ----------------------------
		// dependencyCheck
		// ----------------------------

		private var _dependencyCheck:DependencyCheckMode = DependencyCheckMode.NONE;

		/**
		 * @default <code>ObjectDefinitionDependencyCheck.NONE</code>
		 * @inheritDoc
		 */
		public function get dependencyCheck():DependencyCheckMode {
			return _dependencyCheck;
		}

		/**
		 * @inheritDoc
		 */
		public function set dependencyCheck(value:DependencyCheckMode):void {
			_dependencyCheck = (value) ? value : DependencyCheckMode.NONE;
		}


		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

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

			return new EqualsBuilder().append(autoWireMode, that.autoWireMode).append(className, that.className).append(constructorArguments, that.constructorArguments).append(dependsOn, that.dependsOn).append(factoryMethod, that.factoryMethod).append(factoryObjectName, that.factoryObjectName).append(initMethod, that.initMethod).append(isAutoWireCandidate, that.isAutoWireCandidate).append(isLazyInit, that.isLazyInit).append(isSingleton, that.isSingleton).append(methodInvocations, that.methodInvocations).append(skipPostProcessors, that.skipPostProcessors).append(skipMetadata, that.skipMetadata).append(primary, that.primary).append(properties, that.properties).append(scope, that.scope).append(dependencyCheck, that.dependencyCheck).equals;
		}

		/**
		 *
		 */
		public function toString():String {
			return "[ObjectDefinition('" + className + "', factoryMethod: " + factoryMethod + ", constructorArguments: '" + constructorArguments + "', properties: " + properties + ")]";
		}

	}
}
