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
package org.springextensions.actionscript.ioc.factory.config {
	
	import mx.logging.ILoggingTarget;
	import mx.logging.targets.LineFormattedTarget;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.ioc.factory.IInitializingObject;
	
	/**
	 * Creates a new <code>LoggingTargetFactoryObject</code>.
	 *
	 * <p>The logging target this factory creates will automatically be added to
	 * the Log manager class.</p>
	 *
	 * @example
	 *
	 * <pre>
	 * &lt;object id="traceTarget" class="org.springextensions.actionscript.ioc.factory.config.LoggingTargetFactoryObject"&gt;
	 *  &lt;property name="loggingTargetClass" value="mx.logging.targets.TraceTarget"/&gt;
	 *  &lt;property name="includeCategory" value="true"/&gt;
	 *   &lt;property name="includeDate" value="true"/&gt;
	 *  &lt;property name="includeLevel" value="true"/&gt;
	 *  &lt;property name="includeTime" value="true"/&gt;
	 *   &lt;property name="level" value="2"/&gt;
	 *   &lt;property name="filters"&gt;
	 *   &lt;array&gt;
	 *    &lt;value&gt;com.domain.model.&#42;&lt;/value&gt;
	 *    &lt;value&gt;com.domain.view.&#42;&lt;/value&gt;
	 *   &lt;/array&gt;
	 *  &lt;/property&gt;
	 * &lt;/object&gt;
	 * </pre>
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @docref container-documentation.html#logging_target_factory
	 */
	public class LoggingTargetFactoryObject extends AbstractFactoryObject implements IInitializingObject {
		
		private var _loggingTarget:ILoggingTarget;
		
		private var _loggingTargetClass:Class;
		
		private var _includeCategory:Boolean = true;
		
		private var _includeDate:Boolean = true;
		
		private var _includeLevel:Boolean = true;
		
		private var _includeTime:Boolean = true;
		
		private var _level:uint = 0;
		
		private var _filters:Array = [];
		
		/**
		 * Constructs a new LoggingTargetFactoryObject instance
		 */
		public function LoggingTargetFactoryObject() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getObject():* {
			return _loggingTarget;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getObjectType():Class {
			return loggingTargetClass;
		}
		
		/**
		 * Create the logging target after all properties have been set.
		 */
		public function afterPropertiesSet():void {
			_loggingTarget = new loggingTargetClass();
			
			if (_loggingTarget is LineFormattedTarget) {
				var lft:LineFormattedTarget = _loggingTarget as LineFormattedTarget;
				lft.includeCategory = includeCategory;
				lft.includeDate = includeDate;
				lft.includeLevel = includeLevel;
				lft.includeTime = includeTime;
			}
			_loggingTarget.filters = filters;
			// setting the level will add the logging target to the Log manager
			_loggingTarget.level = level;
		}
		
		/**
		 * @return
		 */
		public function get loggingTargetClass():Class {
			return _loggingTargetClass;
		}
		
		/**
		 * @private
		 */
		public function set loggingTargetClass(value:Class):void {
			Assert.notNull(value, "The loggingTargetClass must not be null");
			_loggingTargetClass = value;
		}
		
		public function get includeCategory():Boolean {
			return _includeCategory;
		}
		
		public function set includeCategory(value:Boolean):void {
			_includeCategory = value;
		}
		
		public function get includeDate():Boolean {
			return _includeDate;
		}
		
		public function set includeDate(value:Boolean):void {
			_includeDate = value;
		}
		
		public function get includeLevel():Boolean {
			return _includeLevel;
		}
		
		public function set includeLevel(value:Boolean):void {
			_includeLevel = value;
		}
		
		public function get includeTime():Boolean {
			return _includeTime;
		}
		
		public function set includeTime(value:Boolean):void {
			_includeTime = value;
		}
		
		public function get level():uint {
			return _level;
		}
		
		public function set level(value:uint):void {
			_level = value;
		}
		
		public function get filters():Array {
			return _filters;
		}
		
		public function set filters(value:Array):void {
			_filters = value;
		}
	}
}
