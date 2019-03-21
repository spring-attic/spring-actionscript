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
package org.springextensions.actionscript.ioc.factory {

	/**
	 * <p>Interface to be implemented by objects that are factories for other
	 * objects. When this object is requested from the container, it will not
	 * be returned itself, but the object it creates will be returned.</p>
	 * <p>If a reference to the <code>IFactoryObject</code> instance itself is desired then
	 * invoke the <code>getObject()</code> method with an <strong>'&amp;'</strong> prefix in front of the object name.</p>
	 * @example
	 * <code>
	 * applicationContext.getObject('&amp;myFactoryObject');
	 * </code>
	 *
	 * <p>Factory objects are ideal for extending the core IoC container with
	 * custom initialization objects.</p>
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IFactoryObject {

		/**
		 * Returns an instance of the object managed by this factory.
		 */
		function getObject():*;

		/**
		 * Returns the type of the object this factory manages or null if the type is unknown.
		 */
		function getObjectType():Class;

		/**
		 * Returns if this factory object is a singleton or not. If it is
		 * a singleton, it will return a new instance of the object it
		 * creates on each getObject() call. Else, the same object will be
		 * returned.
		 */
		function get isSingleton():Boolean;
	}
}
