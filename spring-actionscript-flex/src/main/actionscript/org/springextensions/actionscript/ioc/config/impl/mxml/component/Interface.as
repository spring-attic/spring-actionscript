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
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ICustomObjectDefinitionComponent;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
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
			definition.isInterface = true;
			if (childContent) {
				for each (var obj:* in childContent) {
					if (obj is Property) {
						addProperty(obj);
					} else if (obj is MethodInvocation) {
						addMethodInvocation(obj);
					} else if (obj is ICustomObjectDefinitionComponent) {
						var custom:ICustomObjectDefinitionComponent = obj;
						custom.execute(applicationContext, objectDefinitions, defaultDefinition, definition, this.id);
					} else {
						throw new Error("Illegal child object for Interface: " + ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(obj)));
					}
				}
			}
			_isInitialized = true;
		}

	}
}
