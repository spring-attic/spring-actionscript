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
package org.springextensions.actionscript.ioc.objectdefinition {
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IBaseObjectDefinition {

		/**
		 * Determines the way an object will be autowired (configured).
		 */
		function get autoWireMode():AutowireMode;

		function set autoWireMode(value:AutowireMode):void;

		/**
		 * Determines if the current <code>IObjectDefinition</code> will be injected into child contexts.
		 */
		function get childContextAccess():ChildContextObjectDefinitionAccess;

		function set childContextAccess(value:ChildContextObjectDefinitionAccess):void;

		/**
		 * Determines if and how the object properties dependencies should be checked.
		 */
		function get dependencyCheck():DependencyCheckMode;

		function set dependencyCheck(value:DependencyCheckMode):void;

		/**
		 * The name of a method on the class defined by the <code>className</code> property that will be called when the
		 * application context is disposed. Destroy methods are used to release resources that are being kept by an object.
		 */
		function get destroyMethod():String;

		function set destroyMethod(value:String):void;

		/**
		 * The name of method responsible for the creation of the object. This is either a static method of class defined
		 * by the <code>className</code> property or the name of a method on the object defined by the <code>factoryObjectName</code> property.
		 */
		function get factoryMethod():String;

		function set factoryMethod(value:String):void;

		/**
		 * The name of the factory object responsible for the creation of the object.
		 */
		function get factoryObjectName():String;

		function set factoryObjectName(value:String):void;

		/**
		 * The name of a method on the class defined by the <code>className</code> property that will be called immediately after the
		 * object has been configured.
		 */
		function get initMethod():String;

		function set initMethod(value:String):void;

		/**
		 * True if this object can be used as a value used by the container when it autowires an object by type.
		 */
		function get isAutoWireCandidate():Boolean;

		function set isAutoWireCandidate(value:Boolean):void;

		/**
		 *  True if the object does not need to be eagerly pre-instantiated by the container. I.e. the object will be created
		 *  after the first call to the <code>getObject()</code> method.
		 *  @see org.springextensions.actionscript.ioc.factory.IObjectFactory#getObject() IObjectFactory.getObject()
		 */
		function get isLazyInit():Boolean;

		function set isLazyInit(value:Boolean):void;

		/**
		 * The name of an <code>IObjectDefinition</code> whose properties will be inherited by the current <code>IObjectDefinition</code>.
		 */
		function get parentName():String;

		function set parentName(value:String):void;

		/**
		 * Defines the scope of the object, the object is either a singleton or a prototype.
		 */
		function get scope():ObjectDefinitionScope;

		function set scope(value:ObjectDefinitionScope):void;

		/**
		 * Determines whether the autowire processor will examine the class metadata.
		 */
		function get skipMetadata():Boolean;

		function set skipMetadata(value:Boolean):void;

		/**
		 * Determines whether the object factory will send the created object through its list of <code>IObjectProcessors</code>.
		 */
		function get skipPostProcessors():Boolean;

		function set skipPostProcessors(value:Boolean):void;

	}
}
