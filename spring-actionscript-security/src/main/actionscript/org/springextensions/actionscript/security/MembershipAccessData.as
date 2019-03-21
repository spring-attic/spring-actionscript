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
package org.springextensions.actionscript.security {
	import flash.events.IEventDispatcher;

	import org.springextensions.actionscript.security.impl.SimpleMembershipOwner;

	/**
	 * Subclass of <code>SimpleMembershipOwner</code> that also holds an instance of <code>AccessStrategy</code> to determine
	 * the type of access restriction to be used on a <code>UIComponent</code> instance.
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.security.SimpleSecurityManagerFactory SimpleSecurityManagerFactory
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public class MembershipAccessData extends SimpleMembershipOwner {

		/**
		 * Creates a new <code>MembershipAccessData</code> instance.
		 */
		public function MembershipAccessData(target:IEventDispatcher=null) {
			super(target);
			_accessStrategy = AccessStrategy.ENABLED;
		}

		private var _accessStrategy:AccessStrategy;

		/**
		 * Determines the way access is restricted on the <code>UIComponents</code> that a <code>SimpleStageSecurityManager</code> manages.
		 */
		public function get accessStrategy():AccessStrategy {
			return _accessStrategy;
		}

		/**
		 * @private
		 */
		public function set accessStrategy(value:AccessStrategy):void {
			_accessStrategy = value;
		}

	}
}
