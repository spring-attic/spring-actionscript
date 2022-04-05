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

	import flash.events.Event;

	import mx.core.IMXMLObject;
	import mx.core.UIComponent;

	import org.as3commons.lang.IDisposable;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.BaseObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class SASObjects extends UIComponent implements IDisposable {

		private static const PARENT_NAME_CHANGED_EVENT:String = "parentNameChanged";
		private var _defaultObjectDefinition:IBaseObjectDefinition;
		private var _isDisposed:Boolean;

		public function SASObjects() {
			super();
		}

		protected function get internalDefinition():IBaseObjectDefinition {
			return _defaultObjectDefinition ||= new BaseObjectDefinition();
		}

		public function getDefaultDefinition():IBaseObjectDefinition {
			return _defaultObjectDefinition;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		public function dispose():void {
			if (!isDisposed) {
				_isDisposed = true;
				_defaultObjectDefinition = null;
			}
		}

		[Bindable("autoWireModeChanged")]
		public function get autoWireMode():AutowireMode {
			return internalDefinition.autoWireMode;
		}

		public function set autoWireMode(value:AutowireMode):void {
			if ((internalDefinition.autoWireMode)) {
				internalDefinition.autoWireMode = value;
				dispatchEvent(new Event(MXMLObjectDefinition.AUTO_WIRE_MODE_CHANGED_EVENT));
			}
		}

		[Bindable("childContextAccessChanged")]
		public function get childContextAccess():ChildContextObjectDefinitionAccess {
			return internalDefinition.childContextAccess;
		}

		public function set childContextAccess(value:ChildContextObjectDefinitionAccess):void {
			if (value !== internalDefinition.childContextAccess) {
				internalDefinition.childContextAccess = value;
				dispatchEvent(new Event(MXMLObjectDefinition.CHILD_CONTEXT_ACCESS_CHANGED_EVENT));
			}
		}

		[Bindable("dependencyCheckChanged")]
		public function get dependencyCheck():DependencyCheckMode {
			return internalDefinition.dependencyCheck;
		}

		public function set dependencyCheck(value:DependencyCheckMode):void {
			if (internalDefinition.dependencyCheck !== value) {
				internalDefinition.dependencyCheck = value;
				dispatchEvent(new Event(MXMLObjectDefinition.DEPENDENCY_CHECK_CHANGED_EVENT));
			}
		}

		[Bindable("destroyMethodChanged")]
		public function get destroyMethod():String {
			return _defaultObjectDefinition.destroyMethod;
		}

		public function set destroyMethod(value:String):void {
			if (internalDefinition.destroyMethod != value) {
				internalDefinition.destroyMethod = value;
				dispatchEvent(new Event(MXMLObjectDefinition.DESTROY_METHOD_CHANGED_EVENT));
			}
		}

		[Bindable("factoryMethodChanged")]
		public function get factoryMethod():String {
			return internalDefinition.factoryMethod;
		}

		public function set factoryMethod(value:String):void {
			if (internalDefinition.factoryMethod != value) {
				internalDefinition.factoryMethod = value;
				dispatchEvent(new Event(MXMLObjectDefinition.FACTORY_METHOD_CHANGED_EVENT));
			}
		}

		[Bindable("factoryObjectNameChanged")]
		public function get factoryObjectName():String {
			return internalDefinition.factoryObjectName;
		}

		public function set factoryObjectName(value:String):void {
			if (internalDefinition.factoryObjectName != value) {
				internalDefinition.factoryObjectName = value;
				dispatchEvent(new Event(MXMLObjectDefinition.FACTORY_OBJECT_NAME_CHANGED_EVENT));
			}
		}

		[Bindable("factoryObjectNameChanged")]
		public function get initMethod():String {
			return internalDefinition.initMethod;
		}

		public function set initMethod(value:String):void {
			if (internalDefinition.initMethod != value) {
				internalDefinition.initMethod = value;
				dispatchEvent(new Event(MXMLObjectDefinition.INIT_METHOD_CHANGED_EVENT));
			}
		}

		[Bindable("isAutoWireCandidateChanged")]
		public function get isAutoWireCandidate():Boolean {
			return internalDefinition.isAutoWireCandidate;
		}

		public function set isAutoWireCandidate(value:Boolean):void {
			if (internalDefinition.isAutoWireCandidate != value) {
				internalDefinition.isAutoWireCandidate = value;
				dispatchEvent(new Event(MXMLObjectDefinition.IS_AUTO_WIRE_CANDIDATE_CHANGED_EVENT));
			}
		}

		[Bindable("isLazyInitChanged")]
		public function get isLazyInit():Boolean {
			return internalDefinition.isLazyInit;
		}

		public function set isLazyInit(value:Boolean):void {
			if (internalDefinition.isLazyInit != value) {
				internalDefinition.isLazyInit = value;
				dispatchEvent(new Event(MXMLObjectDefinition.IS_LAZY_INIT_CHANGED_EVENT));
			}
		}

		[Bindable("parentNameChanged")]
		public function get parentName():String {
			return internalDefinition.parentName;
		}

		public function set parentName(value:String):void {
			if (internalDefinition.parentName != value) {
				internalDefinition.parentName = value;
				dispatchEvent(new Event(PARENT_NAME_CHANGED_EVENT));
			}
		}

		[Bindable("scopeChanged")]
		public function get scope():ObjectDefinitionScope {
			return internalDefinition.scope;
		}

		public function set scope(value:ObjectDefinitionScope):void {
			if (internalDefinition.scope !== value) {
				internalDefinition.scope = value;
				dispatchEvent(new Event(MXMLObjectDefinition.SCOPE_CHANGED_EVENT));
			}
		}

		[Bindable("skipMetadataChanged")]
		public function get skipMetadata():Boolean {
			return internalDefinition.skipMetadata;
		}

		public function set skipMetadata(value:Boolean):void {
			if (internalDefinition.skipMetadata != value) {
				internalDefinition.skipMetadata = value;
				dispatchEvent(new Event(MXMLObjectDefinition.SKIP_METADATA_CHANGED_EVENT));
			}
		}

		[Bindable("skipPostProcessorsChanged")]
		public function get skipPostProcessors():Boolean {
			return internalDefinition.skipPostProcessors;
		}

		public function set skipPostProcessors(value:Boolean):void {
			if (internalDefinition.skipPostProcessors != value) {
				internalDefinition.skipPostProcessors = value;
				dispatchEvent(new Event(MXMLObjectDefinition.SKIP_POST_PROCESSORS_CHANGED_EVENT));
			}
		}

	}
}
