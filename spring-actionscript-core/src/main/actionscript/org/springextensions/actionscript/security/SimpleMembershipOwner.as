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
package org.springextensions.actionscript.security {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Basic implementation of the <code>IMembershipOwner</code> interface.
	 * @author Roland Zwaga
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public class SimpleMembershipOwner extends EventDispatcher implements IMembershipOwner {
		
		public static const ROLES_CHANGED:String = "rolesChanged";
		
		public static const RIGHTS_CHANGED:String = "rightsChanged"

		/**
		 * Creates a new <code>SimpleMembershipOwner</code> instance
		 */
		public function SimpleMembershipOwner(target:IEventDispatcher = null) {
			super(target);
			_roles = [];
			_rights = [];
		}

		private var _roles:Array;
		/**
		 * @inheritDoc
		 */		
		public function get roles():Array {
			return _roles;
		}
		[Bindable(event="rolesChanged")]
		/**
		 * @private
		 */		
		public function set roles(value:Array):void {
			if (value !== _roles) {
				_roles = value;
				dispatchEvent(new Event(ROLES_CHANGED));
			}
		}

		private var _rights:Array;
		/**
		 * @inheritDoc
		 */		
		public function get rights():Array {
			return _rights;
		}
		[Bindable(event="rightsChanged")]
		/**
		 * @private
		 */		
		public function set rights(value:Array):void {
			if (value !== _rights){
				_rights = value;
				dispatchEvent(new Event(RIGHTS_CHANGED));
			}
		}

	}
}