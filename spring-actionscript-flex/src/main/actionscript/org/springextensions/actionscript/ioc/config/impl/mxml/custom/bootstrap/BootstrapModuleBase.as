/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.bootstrap {
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class BootstrapModuleBase extends BootstrapItemBase {

		public static const APPLICATIONDOMAIN_CHANGED_EVENT:String = "applicationDomainChanged";
		public static const SECURITYDOMAIN_CHANGED_EVENT:String = "securityDomainChanged";

		private var _applicationDomain:ApplicationDomain;
		private var _securityDomain:SecurityDomain;

		/**
		 * Creates a new <code>BootstrapModuleBase</code> instance.
		 */
		public function BootstrapModuleBase() {
			super();
		}

		[Bindable(event="applicationDomainChanged")]
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
			if (_applicationDomain !== value) {
				_applicationDomain = value;
				dispatchEvent(new Event(APPLICATIONDOMAIN_CHANGED_EVENT));
			}
		}

		[Bindable(event="securityDomainChanged")]
		public function get securityDomain():SecurityDomain {
			return _securityDomain;
		}

		public function set securityDomain(value:SecurityDomain):void {
			if (_securityDomain !== value) {
				_securityDomain = value;
				dispatchEvent(new Event(SECURITYDOMAIN_CHANGED_EVENT));
			}
		}

	}
}
