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
	import org.as3commons.lang.ClassUtils;
	
	/**
	 * 
	 * @author Roland Zwaga
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class Interface extends MXMLObjectDefinition {

		/**
		 * Creates a new <code>Interface</code> instance.
		 * 
		 */
		public function Interface() {
			super();
		}
		
		/**
		 * Loops through the MXML children and processes each <code>Property</code> and <code>MethodInvocation</code> instance.
		 * @see org.springextensions.actionscript.context.support.mxml.Property Property
		 * @see org.springextensions.actionscript.context.support.mxml.MethodInvocation MethodInvocation
		 * @throws Error When an MXML child is encountered other than <code>Property</code> or <code>MethodInvocation</code> an error is thrown
		 */
		override public function parse():void {
			if (childContent) {
				for each (var obj:* in childContent) {
					if (obj is Property) {
						addProperty(obj);
					} else if (obj is MethodInvocation) {
						//addMethodInvocation(obj);
					} else {
						throw new Error("Illegal child object for Interface: " + ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(obj)));
					}
				}
			}
			_isInitialized = true;
		}

	}
}