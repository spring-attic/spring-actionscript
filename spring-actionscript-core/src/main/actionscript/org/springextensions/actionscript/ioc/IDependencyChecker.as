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
package org.springextensions.actionscript.ioc {
	import flash.system.ApplicationDomain;

	import org.springextensions.actionscript.ioc.impl.LazyDependencyCheckResult;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IDependencyChecker {
		/**
		 *
		 * @param objectDefinition
		 * @param instance
		 * @param objectName
		 * @param applicationDomain
		 * @param throwError
		 * @return
		 */
		function checkDependenciesSatisfied(objectDefinition:IObjectDefinition, instance:*, objectName:String, applicationDomain:ApplicationDomain, throwError:Boolean=true):LazyDependencyCheckResult;
		/**
		 *
		 * @param objectDefinition
		 * @param instance
		 * @param objectName
		 * @param applicationDomain
		 * @return
		 */
		function checkLazyDependencies(objectDefinition:IObjectDefinition, instance:*, applicationDomain:ApplicationDomain):Boolean;
	}
}
