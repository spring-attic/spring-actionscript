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

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.AbstractReferenceResolver;

	/**
	 * Resolves the references in an array-collection.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 * @productionversion SpringActionscript 2.0
	 */
	public class ArrayCollectionReferenceResolver extends AbstractReferenceResolver {

		private static const MXCOLLECTIONS_ARRAY_COLLECTION_CLASSNAME:String = "mx.collections.ArrayCollection";
		private static var _arrayCollectionClass:Class;

		/**
		 * Constructs <code>ArrayCollectionReferenceResolver</code>.
		 *
		 * @param factory    The factory that uses this reference resolver
		 */
		public function ArrayCollectionReferenceResolver(factory:IObjectFactory) {
			super(factory);
		}

		/**
		 * Checks if the object is an <code>ArrayCollection</code>.
		 * <p />
		 * @inheritDoc
		 */
		override public function canResolve(property:Object):Boolean {
			return (property is _arrayCollectionClass);
		}

		/**
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			for (var c:* = property.createCursor(); !c.afterLast; c.moveNext()) {
				c.insert(factory.resolveReference(c.current));
				c.remove();
				c.movePrevious();
			}
			return property;
		}

		/**
		 * Return <code>true</code> if the <code>ArrayCollectionReferenceResolver</code> is able to be instantiated. This method determines this
		 * by trying to retrieve the <code>Class</code> object for the <code>mx.collections.ArrayCollection</code> class name.
		 * @param applicationDomain
		 * @return
		 */
		public static function canCreate(applicationDomain:ApplicationDomain):Boolean {
			if (_arrayCollectionClass == null) {
				try {
					_arrayCollectionClass = ClassUtils.forName(MXCOLLECTIONS_ARRAY_COLLECTION_CLASSNAME, applicationDomain);
				} catch (e:Error) {
					return false;
				}
				return true;
			} else {
				return true;
			}
		}
	}
}
