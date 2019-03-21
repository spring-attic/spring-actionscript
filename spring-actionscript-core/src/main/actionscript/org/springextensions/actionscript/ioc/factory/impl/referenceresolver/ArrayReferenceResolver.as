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

	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.AbstractReferenceResolver;

	/**
	 * Resolves the references in an array.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 * @productionversion SpringActionscript 2.0
	 */
	public class ArrayReferenceResolver extends AbstractReferenceResolver {

		/**
		 * Constructs <code>ArrayReferenceResolver</code>.
		 *
		 * @param factory    The factory that uses this reference resolver
		 */
		public function ArrayReferenceResolver(factory:IObjectFactory) {
			super(factory);
		}

		/**
		 * Checks if the object is an Array
		 * <p />
		 * @inheritDoc
		 */
		override public function canResolve(property:Object):Boolean {
			return (property is Array);
		}

		/**
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			var len:int = property.length;
			for (var i:int = 0; i < len; ++i) {
				property[i] = factory.resolveReference(property[i]);
			}
			return property;
		}
	}
}
