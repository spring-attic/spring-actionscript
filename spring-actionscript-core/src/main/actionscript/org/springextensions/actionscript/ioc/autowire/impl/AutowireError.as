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
package org.springextensions.actionscript.ioc.autowire.impl {
	import flash.utils.Dictionary;

	import org.as3commons.lang.StringUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AutowireError extends Error {

		/**
		 *
		 */
		public static const AUTOWIRE_BINDING_ERROR:String = "autowireBindingError";
		/**
		 *
		 */
		public static const AUTOWIRE_ERROR:String = "autowireError";
		/**
		 *
		 */
		public static const MULTIPLE_PRIMARY_CANIDATES:String = "multiplePrimaryCandidates";
		/**
		 *
		 */
		public static const MULTIPLE_EXPLICIT_SINGLETON_CANIDATES:String = "multipleExplicitSingletonCandidates";
		/**
		 *
		 */
		private static const AUTOWIRING_ERROR:String = "An error occured while autowiring '{0}.{1}' with '{2}'. Caused by: {3}. {4}";
		/**
		 *
		 */
		private static const MULTIPLE_PRIMARY_CANIDATES_ERROR:String = "More than one 'primary' object found among candidates: {0}";
		/**
		 *
		 */
		private static const MULTIPLE_EXPLICIT_SINGLETON_CANIDATES_ERROR:String = "More than one explicit singleton object found for autowiring candidate: {0}";
		/**
		 *
		 */
		private static const AUTOWIRE_BINDING_ERROR_MESSAGE:String = "Autowiring tried to bind field '{0}.{1}' with '{2}.{3}', but failed. Original exception was: {4}";
		/**
		 *
		 */
		private static const TYPES:Object = {};
		//
		{
			TYPES[AUTOWIRE_ERROR] = AUTOWIRING_ERROR;
			TYPES[MULTIPLE_PRIMARY_CANIDATES] = MULTIPLE_PRIMARY_CANIDATES_ERROR;
			TYPES[MULTIPLE_EXPLICIT_SINGLETON_CANIDATES] = MULTIPLE_EXPLICIT_SINGLETON_CANIDATES_ERROR;
			TYPES[AUTOWIRE_BINDING_ERROR] = AUTOWIRE_BINDING_ERROR_MESSAGE;
		}

		private var _kind:String;

		/**
		 * Creates a new <code>AutowireError</code> instance.
		 */
		public function AutowireError(kind:String, message:String) {
			super(message);
			_kind = kind;
		}


		public function get kind():String {
			return _kind;
		}

		public static function createNew(kind:String, ... params):AutowireError {
			var message:String = StringUtils.substitute(TYPES[kind], params);
			return new AutowireError(kind, message);
		}
	}
}
