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
package org.springextensions.actionscript.security.impl {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.springextensions.actionscript.security.IMembershipOwner;

	/**
	 * Basic implementation of the <code>IMembershipOwner</code> interface.
	 * @author Roland Zwaga
	 */
	public class SimpleMembershipOwner extends EventDispatcher implements IMembershipOwner {
		public static const RIGHTS_CHANGED:String = "rightsChanged"
		public static const ROLES_CHANGED:String = "rolesChanged";

		/**
		 * Creates a new <code>SimpleMembershipOwner</code> instance
		 */
		public function SimpleMembershipOwner(target:IEventDispatcher=null) {
			super(target);
			initSimpleMembershipOwner();
		}

		private var _rights:Vector.<String>;
		private var _roles:Vector.<String>;

		/**
		 * @inheritDoc
		 */
		public function get rights():Vector.<String> {
			return _rights;
		}

		/**
		 * @private
		 */
		public function set rights(value:Vector.<String>):void {
			if (value !== _rights) {
				_rights = value;
				dispatchEvent(new Event(RIGHTS_CHANGED));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get roles():Vector.<String> {
			return _roles;
		}

		/**
		 * @private
		 */
		public function set roles(value:Vector.<String>):void {
			if (value !== _roles) {
				_roles = value;
				dispatchEvent(new Event(ROLES_CHANGED));
			}
		}

		protected function initSimpleMembershipOwner():void {
			_roles = new Vector.<String>();
			_rights = new Vector.<String>();
		}
	}
}
