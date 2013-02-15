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
package org.springextensions.actionscript.context.support.mxml {
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.utils.ApplicationUtils;
	
	[DefaultProperty("content")]
	/**
	 * MXML representation of a <code>Template</code> object. This non-visual component must be declared as
	 * a child component of a <code>MXMLApplicationContext</code> component.
	 * @see org.springextensions.actionscript.context.support.MXMLApplicationContext MXMLApplicationContext
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 * @author Roland Zwaga
	 */
	public class Template extends AbstractMXMLObject {
		
		/**
		 * Creates a new <code>Template</code>
		 */
		public function Template() {
			super(this);
		}
		
		private var _objectDefinition:MXMLObjectDefinition;
		
		/**
		 * The <code>ObjectDefinition</code> whose properties will be used to configure a different <code>ObjectDefinition</code> which
		 * defines the current <code>Template</code> as its template property.
		 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition#template template
		 */
		public function get objectDefinition():MXMLObjectDefinition {
			return _objectDefinition;
		}
		
		private var _content:Array = [];
		
		/**
		 * Placeholder for the MXML child components
		 */
		public function get content():Array {
			return _content;
		}
		
		/**
		 * @private
		 */
		public function set content(value:Array):void {
			_content = value;
		}
		
		/**
		 * Adds an eventlistener for the <code>FlexEvent.CREATION_COMPLETE</code> event to execute <code>complete_handler()</code> method
		 * when it fires.
		 * @inheritDoc
		 */
		override public function initialized(document:Object, id:String):void {
			super.initialized(document, id);
		}
		
		/**
		 * Checks if the current <code>Template</code> only has one chid component if this component is of type <code>ObjectDefinition</code>.
		 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
		 */
		override public function initializeComponent():void {
			Assert.notNull(_content, "content value must not be null");
			
			if (_content.length == 0) {
				throw new Error("Template needs a child ObjectDefinition");
			}
			
			if (_content.length > 1) {
				throw new Error("Template can only have one child");
			}
			
			if ((_content[0] as MXMLObjectDefinition) == null) {
				throw new Error("Template child must be of type org.springextensions.actionscript.context.support.mxml.ObjectDefinition");
			}
			_objectDefinition = (_content[0] as MXMLObjectDefinition);
			
			_isInitialized = true;
		}
	}
}