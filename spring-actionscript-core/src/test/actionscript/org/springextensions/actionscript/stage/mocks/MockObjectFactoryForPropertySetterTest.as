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
package org.springextensions.actionscript.stage.mocks {
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.impl.EventBus;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
	import org.springextensions.actionscript.objects.IPropertyEditor;
	import org.springextensions.actionscript.objects.ITypeConverter;
	import org.springextensions.actionscript.objects.testclasses.PropertySetterTestClass;

	public class MockObjectFactoryForPropertySetterTest implements IApplicationContext {

		private var _eventBus:IEventBus;

		public function get eventBus():IEventBus {
			return _eventBus;
		}

		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}


		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MockObjectFactoryForPropertySetterTest() {
			super();
			_eventBus = new EventBus();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		private var _parent:IObjectFactory;

		public function get parent():IObjectFactory {
			return _parent;
		}

		public function set parent(value:IObjectFactory):void {
			if (value !== this) {
				_parent = value;
			}
		}

		public function get parentContext():IApplicationContext {
			return (parent as IApplicationContext);
		}

		public function wire(object:*, objectDefinition:IObjectDefinition = null, objectName:String = null):void {
			(object as PropertySetterTestClass).testProperty = "Test value";
		}

		public function get properties():Properties {
			return null;
		}

		public function get numObjectDefinitions():uint {
			return 0;
		}

		public function preInstantiateSingletons():void {
		}

		public function get objectDefinitionNames():Array {
			return [];
		}

		public function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void {
		}

		public function removeObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void {
		}

		public function get objectDefinitions():Object {
			return {};
		}

		public function getObjectPostProcessors(objectPostProcessorClass:Class):Array {
			return [];
		}

		public function getObjectDefinition(objectName:String):IObjectDefinition {
			return null;
		}

		public function get numObjectPostProcessors():int {
			return 0;
		}

		public function getObjectNamesForType(type:Class):Array {
			return [];
		}

		public function isFactoryObject(objectName:String):Boolean {
			return false;
		}

		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
		}

		public function getObjectsOfType(type:Class):Object {
			return {};
		}

		public function get typeConverter():ITypeConverter {
			return null;
		}

		public function set typeConverter(value:ITypeConverter):void {
		}

		public function getObject(name:String, constructorArguments:Array = null):* {
			return null;
		}

		public function createInstance(clazz:Class, constructorArguments:Array = null):* {
			return null;
		}

		public function containsObject(objectName:String):Boolean {
			return false;
		}

		public function canCreate(objectName:String):Boolean {
			return false;
		}

		public function isSingleton(objectName:String):Boolean {
			return false;
		}

		public function isPrototype(objectName:String):Boolean {
			return false;
		}

		public function getType(objectName:String):Class {
			return null;
		}

		public function clearObjectFromInternalCache(name:String):Object {
			return null;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
		}

		public function resolveReference(property:Object):Object {
			return null;
		}

		public function addReferenceResolver(referenceResolver:IReferenceResolver):void {
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
		}

		public function dispatchEvent(event:Event):Boolean {
			return false;
		}

		public function hasEventListener(type:String):Boolean {
			return false;
		}

		public function willTrigger(type:String):Boolean {
			return false;
		}

		public function getClassForName(className:String):Class {
			return null;
		}

		public function getClassForInstance(object:Object):Class {
			return null;
		}

		public function get id():String {
			return null;
		}

		public function get displayName():String {
			return null;
		}

		public function registerObjectDefinition(objectName:String, obectDefinition:IObjectDefinition):void {
		}

		public function removeObjectDefinition(objectName:String):void {
		}

		public function getObjectDefinitionsOfType(type:Class):Array {
			return [];
		}

		public function containsObjectDefinition(objectName:String):Boolean {
			return false;
		}

		public function get explicitSingletonNames():Array {
			return null;
		}

		public function get applicationDomain():ApplicationDomain {
			return null;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
		}

		public function registerSingleton(name:String, object:Object):void {
		}

		public function getUsedTypes():Array {
			return [];
		}

		public function get objectPostProcessors():Array {
			return [];
		}

		public function get isReady():Boolean {
			return true;
		}
	}
}