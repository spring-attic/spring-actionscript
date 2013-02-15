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
package org.springextensions.actionscript.ioc.factory.support.referenceresolvers {

	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.AbstractReferenceResolver;
	import org.springextensions.actionscript.utils.Property;

	/**
	 * Resolves IObjectReference references.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectReferenceResolver extends AbstractReferenceResolver {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static const generatedNameRegExp:RegExp = new RegExp("#\\d+");

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Constructs <code>ObjectReferenceResolver</code>.
		 *
		 * @param factory    The factory that uses this reference resolver
		 */
		public function ObjectReferenceResolver(factory:IObjectFactory) {
			super(factory);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Checks if the object is a IObjectReference
		 * <p />
		 * @inheritDoc
		 *
		 * @see org.springextensions.actionscript.ioc.factory.config.IObjectReference
		 */
		override public function canResolve(property:Object):Boolean {
			return (property is IObjectReference);
		}

		/**
		 * <p>If the specified objectName is "this" the object factory will be returned.</p>
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			var objectName:String = property.objectName;
			var isCompoundName:Boolean = (objectName.indexOf(".") > -1);
			var isGeneratedName:Boolean = generatedNameRegExp.test(objectName);

			if (isCompoundName && !isGeneratedName) {
				return resolveSubReference(objectName);
			}

			return factory.getObject(objectName);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function resolveSubReference(objectName:String):Object {
			var nameParts:Array = objectName.split(".");
			var hostName:String = nameParts.shift();
			var host:Object = factory.getObject(hostName);
			var property:Property = new Property(host);
			property.chain = nameParts;
			return property.getValue();
		}
	}
}
