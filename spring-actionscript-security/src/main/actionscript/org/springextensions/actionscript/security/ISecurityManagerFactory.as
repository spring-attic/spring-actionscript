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

	/**
	 * Describes an object that can manage a list of membership data and based on that
	 * can create <code>ISecurityManager</code> instances for arbitrary objects.
	 * @author Roland Zwaga
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public interface ISecurityManagerFactory {
		/**
		 * Creates a new <code>ISecurityManager</code> for the specified object when possible,
		 * returns the newly created instance or null.
		 * @param object The specified object for which an <code>ISecurityManager</code> might be created.
		 * @return A new <code>ISecurityManager</code> instance or null.
		 */
		function createInstance(object:Object):ISecurityManager;
		
		/**
		 * <p><code>IMembershipOwner</code> instance that will be monitored and whose changes will be used to
		 * let the <code>ISecurityManagers</code> evaluate access to the objects they manage.</p>
		 * <p>Typically an <code>ISecurityManagerFactory</code> will call the <code>checkMembership()</code> method
		 * on each <code>ISecurityManager</code> it created when this property changes.</p>
		 * @see org.springextensions.actionscript.security.ISecurityManager#checkMembership() ISecurityManager.checkMembership()
		 */
		function get membershipOwner():IMembershipOwner;
		/**
		 * @private
		 */
		function set membershipOwner(value:IMembershipOwner):void;
		
		/**
		 * Returns <code>true</code> if the current <code>membershipOwner</code> has access to the object with the specifed id.
		 * @param id The id of the object.
		 * @return <code>true</code> if the current <code>membershipOwner</code> has access.
		 */
		function hasAccess(objectId:String):Boolean;
	}
}