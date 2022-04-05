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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.security.AccessStrategy;
	import org.springextensions.actionscript.security.IMembershipOwner;
	import org.springextensions.actionscript.security.ISecurityManager;
	import org.springextensions.actionscript.security.MembershipAccessData;

	/**
	 * An <code>ISecurityManager</code> that restricts the access to a list of <code>Objects</code>, the way this restriction works is determined by
	 * an instance of the <code>AccessStrategy</code> enum.
	 * @author Roland Zwaga
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public class SimpleStageSecurityManager extends EventDispatcher implements ISecurityManager {
		private static const INCLUDE_IN_LAYOUT_FIELD_NAME:String = "includeInLayout";
		private static const LOGGER:ILogger = getLogger(SimpleStageSecurityManager);
		private static const VISIBLE_FIELD_NAME:String = "visible";

		/**
		 * Creates a new <code>SimpleStageSecurityManager</code> instance.
		 * @param membershipOwner a <code>IMembershipOwner</code> instance whose roles and rights are applicable to the list of <code>Objects</code>
		 * that the current <code>SimpleStageSecurityManager</code> manages.
		 */
		public function SimpleStageSecurityManager(membershipOwner:IMembershipOwner=null) {
			super(membershipOwner);
			_membershipOwner = (membershipOwner == null) ? new SimpleMembershipOwner() : membershipOwner;
			_accessStrategy = (membershipOwner is MembershipAccessData) ? (membershipOwner as MembershipAccessData).accessStrategy : AccessStrategy.ENABLED;
			_objects = new Dictionary(true);
		}

		private var _accessStrategy:AccessStrategy;
		private var _membershipOwner:IMembershipOwner;
		private var _objects:Dictionary;

		/**
		 * The <code>AccessStrategy</code> that determines which property on the list of managed <code>Objects</code> will be used
		 * to restrict access.
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

		/**
		 * A Vector of <code>Objects</code> whose access is restricted by the current <code>SimpleStageSecurityManager</code>.
		 * @see org.springextensions.actionscript.security.SimpleStageSecurityManager#checkObjectArray() SimpleStageSecurityManager.checkObjectArray()
		 */
		public function get objects():Dictionary {
			return _objects;
		}

		/**
		 * @private
		 */
		public function set objects(value:Dictionary):void {
			Assert.notNull(value, "objects property must not be null");
			_objects = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rights():Vector.<String> {
			return _membershipOwner.rights;
		}

		/**
		 * @private
		 */
		public function set rights(value:Vector.<String>):void {
			_membershipOwner.rights = value ||= new Vector.<String>();
		}

		/**
		 * @inheritDoc
		 */
		public function get roles():Vector.<String> {
			return _membershipOwner.roles;
		}

		/**
		 * @private
		 */
		public function set roles(value:Vector.<String>):void {
			_membershipOwner.roles = value ||= new Vector.<String>();
		}

		/**
		 * Checks the specified <code>IMembershipOwner</code> against the roles and rights
		 * of the current <code>SimpleStageSecurityManager</code>. Roles take precendence in this,
		 * so if the roles list of the <code>SimpleStageSecurityManager</code> is not empty and the
		 * specified <code>IMembershipOwner</code> shares one or more roles <code>true</code> is returned,
		 * if not the same check is done for the rights.
		 */
		public function checkMembership(owner:IMembershipOwner):Boolean {
			var result:Boolean = false;

			if (owner != null) {
				if (_membershipOwner.roles.length > 0) {
					result = isInRoles(owner);
				}
				if ((!result) && (_membershipOwner.rights.length > 0)) {
					result = isInRights(owner);
				}
			}

			setAccess(result);

			LOGGER.debug("Membership check result: {0}", [result]);

			return result;
		}

		/**
		 * Returns <code>true</code> if one of the items in the <code>checkedArray</code> exists in the <code>sourceArray</code>.
		 * @param sourceArray The array of which one or more items need to be contained in the <code>checkedArray</code>.
		 * @param checkedArray The array that needs to contain one or more items of the <code>sourceArray</code>.
		 * @return <code>true</code> if one of the items in the <code>checkedArray</code> exists in the <code>sourceArray</code>.
		 */
		protected function isInVector(sourceArray:Vector.<String>, checkedArray:Vector.<String>):Boolean {
			return checkedArray.some(function(item:Object, index:int, arr:Vector.<String>):Boolean {
				return (sourceArray.indexOf(item) > -1);
			});
		}

		/**
		 * Returns <code>true</code> if the specified <code>IMembershipOwner</code> has any rights equal to the current <code>SimpleStageSecurityManager</code> rights.
		 */
		protected function isInRights(owner:IMembershipOwner):Boolean {
			return isInVector(_membershipOwner.rights, owner.rights);
		}

		/**
		 * Returns <code>true</code> if the specified <code>IMembershipOwner</code> has any roles equal to the current <code>SimpleStageSecurityManager</code> roles.
		 */
		protected function isInRoles(owner:IMembershipOwner):Boolean {
			return isInVector(_membershipOwner.roles, owner.roles);
		}

		/**
		 * Sets a property whose name is specified by the <code>AccessStrategy</code> on the <code>UIComponent</code> to the value
		 * of the <code>state</code> argument.
		 * @param component The specified <code>UIComponent</code>
		 * @param strategy The specified <code>AccessStrategy</code> which determines which property will be set on the <code>UIComponent</code>
		 * @param state The value of the property that will be set
		 */
		protected function restrictAccess(component:Object, strategy:AccessStrategy, state:Boolean):void {
			switch (strategy) {
				case AccessStrategy.HIDE:
					if (component.hasOwnProperty(VISIBLE_FIELD_NAME)) {
						component[VISIBLE_FIELD_NAME] = state;
					}
					if (component.hasOwnProperty(INCLUDE_IN_LAYOUT_FIELD_NAME)) {
						component[INCLUDE_IN_LAYOUT_FIELD_NAME] = state;
					}
					break;
				default:
					if (component.hasOwnProperty(_accessStrategy.name)) {
						component[_accessStrategy.name] = state;
					}
					break;
			}
		}

		/**
		 * Sets a property determined by the <code>accessStrategy</code> to true or false (based on the <code>state</code> value) on all
		 * the <code>Objects</code> that the current <code>SimpleStageSecurityManager</code> manages by invoking the <code>restrictAccess()</code>
		 * for each <code>UIComponents</code>
		 */
		protected function setAccess(state:Boolean):void {
			for (var c:* in objects) {
				restrictAccess(c as Object, _accessStrategy, state);
			}
		}
	}
}
