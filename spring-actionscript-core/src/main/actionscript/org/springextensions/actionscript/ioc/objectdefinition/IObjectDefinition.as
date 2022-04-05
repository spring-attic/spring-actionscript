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
package org.springextensions.actionscript.ioc.objectdefinition {
	import flash.events.IEventDispatcher;
	
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	[Event(name="instancesDependenciesUpdated", type="org.springextensions.actionscript.ioc.objectdefinition.event.ObjectDefinitionEvent")]
	/**
	 * Describes an object that maintains the configuration for an object's instantiation.
	 *
	 * @author Christophe Herreman
	 * @author Damir Murat
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IObjectDefinition extends IBaseObjectDefinition, IEventDispatcher {
		
		/**
		 * The fully qualified classname of the object that the current <code>IObjectDefinition</code> describes.
		 */
		function get className():String;
		/**
		 * @private
		 */
		function set className(value:String):void;

		/**
		 * The <code>Class</code> of the object that the current <code>IObjectDefinition</code> describes.
		 */
		function get clazz():Class;
		/**
		 * @private
		 */
		function set clazz(value:Class):void;

		/**
		 * An array of arguments that will be passed to the constructor of the object.
		 */
		function get constructorArguments():Vector.<ArgumentDefinition>;
		/**
		 * @private
		 */
		function set constructorArguments(value:Vector.<ArgumentDefinition>):void;

		/**
		 * Optional extra data that can be used by other processing logic. May also be an instance of <code>ICustomConfigurator</code> or an instance of <code>Vector.&lt;ICustomConfigurator&gt;</code>
		 */
		function get customConfiguration():*;
		/**
		 * @private
		 */
		function set customConfiguration(value:*):void;

		/**
		 * Returns the object names that this object depends on.
		 */
		function get dependsOn():Vector.<String>;
		/**
		 * @private
		 */
		function set dependsOn(value:Vector.<String>):void;

		/**
		 *
		 */
		function get isAbstract():Boolean;

		/**
		 * @private
		 */
		function set isAbstract(value:Boolean):void;

		/**
		 * Determines if the class whose configuration is described by the current <code>IObjectDefinition</code> is an interface;
		 */
		function get isInterface():Boolean;

		/**
		 * @private
		 */
		function set isInterface(value:Boolean):void;

		/**
		 * True if only one instance of this object needs to be created by the container, i.e. every subsequent call to the <code>getObject()</code>
		 * method will return the same instance.
		 * @see org.springextensions.actionscript.ioc.factory.IObjectFactory#getObject() IObjectFactory.getObject()
		 */
		function get isSingleton():Boolean;

		/**
		 * Defines the method invocations executed after an object from this definition is created.
		 */
		function get methodInvocations():Vector.<MethodInvocation>;

		/**
		 * An <code>IObjectDefinition</code> whose properties will be inherited by the current <code>IObjectDefinition</code>.
		 */
		function get parent():IObjectDefinition;
		/**
		 * @private
		 */
		function set parent(value:IObjectDefinition):void;

		/**
		 * True if this object needs to be used as the primary autowire candidate when the container is autowiring by type.
		 * This means that if multiple objects are found of the same type, the object marked as 'primary' will become the
		 * autowire candidate.
		 */
		function get primary():Boolean;
		/**
		 * @private
		 */
		function set primary(value:Boolean):void;

		/**
		 * An anonymous object whose property values will be injected into the created object, the property names
		 * on this object are the same as on the created object.
		 */
		function get properties():Vector.<PropertyDefinition>;

		/**
		 * The id of the <code>IObjectDefinitionRegistry</code> that the current <code>IObjectDefinition</code> was first registered with.
		 */
		function get registryId():String;
		/**
		 * @private
		 */
		function set registryId(value:String):void;

		/**
		 *
		 * @param methodInvocation
		 */
		function addMethodInvocation(methodInvocation:MethodInvocation):void;

		/**
		 *
		 * @param propertyDefinition
		 */
		function addPropertyDefinition(propertyDefinition:PropertyDefinition):void;

		/**
		 *
		 * @param name
		 * @param namespace
		 * @return
		 *
		 */
		function getMethodInvocationByName(name:String, namespace:String=null):MethodInvocation;

		/**
		 *
		 * @param name
		 * @param namespace
		 * @return
		 */
		function getPropertyDefinitionByName(name:String, namespace:String=null):PropertyDefinition;
	}
}
