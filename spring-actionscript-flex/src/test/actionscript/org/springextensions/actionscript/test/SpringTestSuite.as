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
package org.springextensions.actionscript.test {
	import org.springextensions.actionscript.context.impl.mxml.MXMLApplicationContextTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.MXMLObjectDefinitionsProviderTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.InterfaceTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinitionTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MethodInvocationTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.PropertyTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus.EventHandlerTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus.EventInterceptorTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus.EventListenerInterceptorTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus.EventRouterTest;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.stage.StageAutowireProcessorTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public final class SpringTestSuite {
		//Unit tests
		public var t1:MXMLObjectDefinitionsProviderTest;
		public var t2:MXMLObjectDefinitionTest;
		public var t3:InterfaceTest;
		public var t4:MethodInvocationTest;
		public var t5:PropertyTest;
		public var t6:MXMLApplicationContextTest;
		public var t7:EventHandlerTest;
		public var t8:EventInterceptorTest;
		public var t9:EventListenerInterceptorTest;
		public var t10:EventRouterTest;
		public var t11:StageAutowireProcessorTest;
	}
}
