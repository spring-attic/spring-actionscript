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
package org.springextensions.actionscript.ioc.factory.impl.referenceresolver {

	import flash.errors.IllegalOperationError;

	import org.as3commons.lang.ObjectUtils;
	import org.springextensions.actionscript.ioc.config.IObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.AbstractReferenceResolver;

	/**
	 * Resolves IObjectReference references.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectReferenceResolver extends AbstractReferenceResolver {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static const GENERATED_NAME_REGEXP:RegExp = new RegExp("#\\d+");
		private static const PARENT_HOST_PART:String = "parent";

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
			var isCompoundName:Boolean = (objectName.indexOf(ObjectUtils.DOT) > -1);
			var isGeneratedName:Boolean = GENERATED_NAME_REGEXP.test(objectName);

			if (isCompoundName && !isGeneratedName) {
				return resolveSubReference(objectName);
			}

			return factory.getObject(objectName);
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function resolveSubReference(objectName:String):Object {
			var nameParts:Array = objectName.split(ObjectUtils.DOT);
			var hostName:String = nameParts.shift();
			if (hostName != PARENT_HOST_PART) {
				return ObjectUtils.resolvePropertyChain(nameParts.join(ObjectUtils.DOT), factory.getObject(hostName));
			} else {
				if (factory.parent != null) {
					return factory.parent.resolveReference(nameParts.join(ObjectUtils.DOT));
				} else {
					throw new IllegalOperationError("Current object factory doesn't have a valid parent property, cannot resolve " + nameParts.join(ObjectUtils.DOT));
				}
			}
		}
	}
}
