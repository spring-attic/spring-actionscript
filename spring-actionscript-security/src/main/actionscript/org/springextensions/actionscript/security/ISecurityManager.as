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
 	import flash.utils.Dictionary;
 	

	/**
	 * <p>Describes an object that can restrict the access to a list of objects based on a list of role and right names
	 * contained in a given <code>IMembershipOwner</code> instance.</p>
	 * <p>This interface extends the <code>IMembershipOwner</code> that way the roles and rights that are applicable to the
	 * objects that are being managed can be stored in the <code>ISecurityManager</code>.</p>
	 * @author Roland Zwaga
	 * @sampleref security 
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public interface ISecurityManager extends IMembershipOwner {

		/**
		 * A Dictionary of objects whose access is restricted by the current <code>ISecurityManager</code>.
		 */
		function get objects():Dictionary;
		/**
		 * @private
		 */
		function set objects(value:Dictionary):void;

		/**
		 * Determines whether the specified <code>IMembershipOwner</code> instance has access to the list of objects that
		 * the current <code>ISecurityManager</code> manages.
		 */
		function checkMembership(owner:IMembershipOwner):Boolean;		
	}
}