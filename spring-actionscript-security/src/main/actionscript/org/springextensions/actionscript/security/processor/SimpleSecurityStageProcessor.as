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
package org.springextensions.actionscript.security.processor {

	import flash.display.DisplayObject;

	import org.as3commons.lang.Assert;
	import org.as3commons.stageprocessing.impl.AbstractStageObjectProcessor;
	import org.springextensions.actionscript.security.ISecurityManagerFactory;
	import org.springextensions.actionscript.security.impl.SimpleSecurityManagerFactory;

	/**
	 * <p>An <code>IStageProcessor</code> implementation that uses an <code>ISecurityManagerFactory</code> instance to
	 * create <code>ISecurityManager</code> instances for the stage components passed to its <code>process()</code> method.</p>
	 * <p>This <code>IStageProcessor</code> creates a <code>PropertyValueBasedObjectSelector</code> by default.</p>
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.stage.selectors.PropertyValueBasedObjectSelector PropertyValueBasedObjectSelector
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public class SimpleSecurityStageProcessor extends AbstractStageObjectProcessor {

		/**
		 * Creates a new <code>SimpleSecurityStageProcessor</code>
		 *
		 */
		public function SimpleSecurityStageProcessor() {
			super(this);
			_securityManagerFactory = new SimpleSecurityManagerFactory();
		}

		private var _securityManagerFactory:ISecurityManagerFactory;

		/**
		 * The <code>ISecurityManagerFactory</code> implementation responsible for creating <code>ISecurityManager</code>
		 * instances for the stage components passed to the current <code>SimpleSecurityStageProcessor</code>
		 * @default a SimpleSecurityManagerFactory instance
		 * @see org.springextensions.actionscript.security.SimpleSecurityManagerFactory SimpleSecurityManagerFactory
		 */
		public function get securityManagerFactory():ISecurityManagerFactory {
			return _securityManagerFactory;
		}

		/**
		 * @private
		 */
		public function set securityManagerFactory(value:ISecurityManagerFactory):void {
			Assert.notNull(value, "securityManagerFactory property must not be null");
			_securityManagerFactory = value;
		}

		/**
		 * Invokes the <code>createInstance()</code> method on the <code>securityManagerFactory</code> instance with
		 * the specified <code>object</code>.
		 * @see org.springextensions.actionscript.security.ISecurityManagerFactory#createInstance() ISecurityManagerFactory.createInstance()
		 */
		override public function process(object:DisplayObject):DisplayObject {
			_securityManagerFactory.createInstance(object);
			return object;
		}

	}
}
