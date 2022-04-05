/*
* Copyright 2007-2008 the original author or authors.
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

	import flash.utils.getQualifiedClassName;

	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.AbstractReferenceResolver;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class VectorReferenceResolver extends AbstractReferenceResolver {

		private static const VECTOR_CLASSNAME_PREFIX:String = "__AS3__.vec::Vector";

		/**
		 * Creates a new <code>VectorReferenceResolver</code> instance.
		 * @param factory
		 */
		public function VectorReferenceResolver(factory:IObjectFactory) {
			super(factory);
		}

		/**
		 * Checks if the object is a <code>Vector</code>.
		 * @inheritDoc
		 */
		override public function canResolve(property:Object):Boolean {
			var clsName:String = getQualifiedClassName(property);
			var idx:int = clsName.indexOf(VECTOR_CLASSNAME_PREFIX);
			return (idx > -1);
		}

		/**
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			var refs:Vector.<*> = (property as Vector.<*>);
			var cls:Class = refs.shift() as Class;
			var result:* = new cls();
			for each (var item:Object in refs) {
				if (!(item is RuntimeObjectReference)) {
					result[result.length] = factory.resolveReference(item);
				} else {
					result[result.length] = factory.getObject((item as RuntimeObjectReference).objectName);
				}
			}
			return result;
		}

	}
}
