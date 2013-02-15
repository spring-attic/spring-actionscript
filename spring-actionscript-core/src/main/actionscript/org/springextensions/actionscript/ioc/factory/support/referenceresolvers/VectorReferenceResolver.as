/*
* Copyright 2007-2008 the original author or authors.
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

	import flash.utils.getQualifiedClassName;

	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.AbstractReferenceResolver;

	/**
	 * 
	 * @author Roland Zwaga
	 */
	public class VectorReferenceResolver extends AbstractReferenceResolver {
		
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
			var idx:int = clsName.indexOf("__AS3__.vec::Vector");
			return (idx > -1);
		}

		/**
		 * @inheritDoc
		 */
		override public function resolve(property:Object):Object {
			var refs:Array = (property as Array);
			var cls:Class = refs.shift() as Class;
			var result:* = new cls();
			for each(var item:Object in refs) {
				result.push(factory.resolveReference(item));
			}
			return result;
		}

	}
}