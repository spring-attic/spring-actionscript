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

	/**
	 * Subinterface of IObjectPostProcessor that adds a hook to the destruction phase of an object managed by the
	 * container.
	 *
	 * @author Christophe Herreman
	 */
	public interface IDestructionAwareObjectPostProcessor extends IObjectPostProcessor {

		/**
		 * Applied to the given object right before it is destructed.
		 *
		 * @param object The instance that is being configured by the object factory
     	 * @param objectName The name of the object definition as found in the <code>IObjectFactory's</code> configuration
		 */
		function postProcessBeforeDestruction(object:Object, objectName:String):void;

	}
}