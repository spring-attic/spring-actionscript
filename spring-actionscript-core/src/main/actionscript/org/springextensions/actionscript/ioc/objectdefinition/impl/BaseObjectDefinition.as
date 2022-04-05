/*
* Copyright 2007-2012 the original author or authors.
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
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class BaseObjectDefinition implements IBaseObjectDefinition {

		private var _autoWireMode:AutowireMode;
		private var _childContextAccess:ChildContextObjectDefinitionAccess;
		private var _dependencyCheck:DependencyCheckMode;
		private var _destroyMethod:String;
		private var _factoryMethod:String;
		private var _factoryObjectName:String;
		private var _initMethod:String;
		private var _isAutoWireCandidate:Boolean = true;
		private var _isLazyInit:Boolean;
		private var _parentName:String;
		private var _scope:ObjectDefinitionScope;
		private var _skipMetadata:Boolean = false;
		private var _skipPostProcessors:Boolean = false;

		/**
		 * Creates a new <code>BaseObjectDefinition</code> instance.
		 */
		public function BaseObjectDefinition() {
			super();
			_childContextAccess = ChildContextObjectDefinitionAccess.FULL;
			_autoWireMode = AutowireMode.NO;
			_dependencyCheck = DependencyCheckMode.NONE;
			_scope = ObjectDefinitionScope.SINGLETON;
		}

		/**
		 * @default <code>AutowireMode.NO</code>
		 * @inheritDoc
		 */
		public function get autoWireMode():AutowireMode {
			return _autoWireMode;
		}

		/**
		 * @private
		 */
		public function set autoWireMode(value:AutowireMode):void {
			_autoWireMode = (value) ? value : AutowireMode.NO;
		}

		/**
		 * @default <code>ChildContextObjectDefinitionAccess.FULL</code>
		 * @inheritDoc
		 */
		public function get childContextAccess():ChildContextObjectDefinitionAccess {
			return _childContextAccess;
		}

		/**
		 * @private
		 */
		public function set childContextAccess(value:ChildContextObjectDefinitionAccess):void {
			_childContextAccess = value ||= ChildContextObjectDefinitionAccess.FULL;
		}

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
			_dependencyCheck = value ||= DependencyCheckMode.NONE;
		}

		/**
		 * @inheritDoc
		 */
		public function get destroyMethod():String {
			return _destroyMethod;
		}

		/**
		 * @private
		 */
		public function set destroyMethod(value:String):void {
			_destroyMethod = value;
		}

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
			_isAutoWireCandidate = value;
		}

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

		/**
		 * @inheritDoc
		 */
		public function get parentName():String {
			return _parentName;
		}

		/**
		 * @private
		 */
		public function set parentName(value:String):void {
			_parentName = value;
		}

		/**
		 * @default <code>ObjectDefinitionScope.SINGLETON</code>
		 * @inheritDoc
		 */
		public function get scope():ObjectDefinitionScope {
			return _scope;
		}

		/**
		 * @private
		 */
		public function set scope(value:ObjectDefinitionScope):void {
			_scope = value ||= ObjectDefinitionScope.SINGLETON;
		}

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
	}
}
