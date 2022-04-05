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
	import flash.utils.Dictionary;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.security.IMembershipOwner;
	import org.springextensions.actionscript.security.ISecurityManager;
	import org.springextensions.actionscript.security.ISecurityManagerFactory;
	import org.springextensions.actionscript.security.MembershipAccessData;


	/**
	 * <code>ISecurityManagerFactory</code> that holds the roles and rights data for a specified list of <code>Objects</code>
	 * in a dictionary with a <code>Object</code> id as its key and an <code>IMembershipOwner</code> as its value.
	 * <p>When a <code>UIComponent</code> is passed to its <code>createInstance()</code> the component's id is looked up in this
	 * dictionary, and if a valid <code>IMembershipOwner</code> is found an <code>ISecurityManager</code> is created for the <code>UIComponent</code>
	 * and added to the <code>managersList</code>.</p>
	 * @author Roland Zwaga
	 */
	public class SimpleSecurityManagerFactory implements ISecurityManagerFactory {

		private static const LOGGER:ILogger = getLogger(SimpleSecurityManagerFactory);

		/**
		 * A Dictionary instance used to keep track of the stage components that have already been
		 * processed by the current <code>SimpleSecurityManagerFactory</code>. This Dictionary
		 * instance is created with the <code>weakKeys</code> constructor argument set to <code>true</code>
		 * and will therefore not cause any memory leaks should any of the stage components be removed
		 * from the permanently.
		 */
		protected var componentCache:Dictionary;

		private var _managersList:Vector.<ISecurityManager>;

		/**
		 * An Vector of <code>ISecurityManagers</code> that have been created by the current <code>SimpleSecurityManagerFactory</code>
		 */
		public function get managersList():Vector.<ISecurityManager> {
			return _managersList;
		}

		/**
		 * Creates a new <code>SimpleSecurityManagerFactory</code> instance.
		 */
		public function SimpleSecurityManagerFactory() {
			super();
			initSimpleSecurityManagerFactory();
		}

		protected function initSimpleSecurityManagerFactory():void {
			_managersList = new Vector.<ISecurityManager>();
			_membershipData = new Dictionary();
			componentCache = new Dictionary(true);
		}

		private var _membershipData:Dictionary;

		/**
		 * A <code>Dictionary</code> containing membershipData, the key should be the id of
		 * an UIComponent on the stage, the value is <code>MembershipAccessData</code> instance
		 * whose roles and rights arrays and <code>AcccessStrategy</code> will be assigned to the <code>ISecurityManager</code>
		 * that is created for the stage component.
		 */
		public function get membershipData():Dictionary {
			return _membershipData;
		}

		/**
		 * @private
		 */
		public function set membershipData(value:Dictionary):void {
			if (value !== _membershipData) {
				LOGGER.debug("Received new membershipData");
				_managersList = new Vector.<ISecurityManager>();
				_membershipData = value;
				if (_membershipData != null) {
					for (var c:* in componentCache) {
						createSecurityManager(c);
					}
				}
			}
		}

		/**
		 *
		 * @inheritDoc
		 */
		public function createInstance(object:Object):ISecurityManager {
			if (componentCache[object] == null) {
				componentCache[object] = true;
				LOGGER.debug("Added object {0} to the componentCache", [object]);
				return createSecurityManager(object);
			}
			return null;
		}

		/**
		 * If an <code>IMembershipOwner</code> exists in the <code>membershipData</code> Dictionary
		 * for the id of the specified <code>UIComponent</code> a new <code>ISecurityManager</code>
		 * instance is created for the specified <code>UIComponent</code> using the <code>IMembershipOwner</code> instance.
		 * @param component The specified <code>UIComponent</code>
		 * @return A new <code>ISecurityManager</code> instance or null if a valid <code>IMembershipOwner</code> wasn't found
		 *
		 */
		protected function createSecurityManager(component:Object):ISecurityManager {
			var accessData:MembershipAccessData = _membershipData[component.id] as MembershipAccessData;
			if (accessData != null) {
				LOGGER.debug("Created SimpleStageSecurityManager for component {0} with id {1}", [component, component.id]);
				var securityManager:SimpleStageSecurityManager = new SimpleStageSecurityManager(accessData);
				securityManager.objects[component] = true;
				_managersList.push(securityManager);
				securityManager.checkMembership(membershipOwner);
				return securityManager;
			}
			return null;
		}

		private var _membershipOwner:IMembershipOwner;

		/**
		 * @inheritDoc
		 */
		public function get membershipOwner():IMembershipOwner {
			return _membershipOwner;
		}

		/**
		 * @private
		 */
		public function set membershipOwner(value:IMembershipOwner):void {
			if (value !== _membershipOwner) {
				unbindMembershipOwner();
				_membershipOwner = value;
				bindMembershipOwner();
				membershipOwnerChange_handler();
			}
		}

		public function hasAccess(objectId:String):Boolean {
			return false;
		}

		/**
		 * Adds event listeners for the <code>rolesChanged</code> and <code>rightsChanged</code> events on the
		 * <code>membershipOwner</code> when its not null.
		 */
		protected function bindMembershipOwner():void {
			if (_membershipOwner != null) {
				_membershipOwner.addEventListener(SimpleMembershipOwner.ROLES_CHANGED, membershipOwnerChange_handler, false, 0, true);
				_membershipOwner.addEventListener(SimpleMembershipOwner.RIGHTS_CHANGED, membershipOwnerChange_handler, false, 0, true);
				LOGGER.debug("{0} is attached to {1}", [this, _membershipOwner]);
			}
		}

		/**
		 * Removes event listeners for the <code>rolesChanged</code> and <code>rightsChanged</code> events from the
		 * <code>membershipOwner</code> when its not null.
		 */
		protected function unbindMembershipOwner():void {
			if (_membershipOwner != null) {
				_membershipOwner.removeEventListener(SimpleMembershipOwner.ROLES_CHANGED, membershipOwnerChange_handler);
				_membershipOwner.removeEventListener(SimpleMembershipOwner.RIGHTS_CHANGED, membershipOwnerChange_handler);
				LOGGER.debug("{0} is detached from {1}", [this, _membershipOwner]);
			}
		}

		/**
		 * Calls the <code>checkMembership()</code> method on all the <code>ISecurityManager</code> instances that
		 * the current <code>SimpleSecurityManager</code> has created.
		 * @see org.springextensions.actionscript.security.ISecurityManager#checkMembership() ISecurityManager.checkMembership()
		 */
		protected function membershipOwnerChange_handler(event:Event=null):void {
			_managersList.forEach(function(item:ISecurityManager, index:int, arr:Array):void {
				LOGGER.debug("{0} is checking membership for object(s): {1}", [item, item.objects]);
				item.checkMembership(_membershipOwner);
			});
		}

	}
}
