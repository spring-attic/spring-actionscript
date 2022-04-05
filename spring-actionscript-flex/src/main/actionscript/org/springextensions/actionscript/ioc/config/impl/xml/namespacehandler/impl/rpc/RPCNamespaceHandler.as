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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.rpc {

	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.rpc.nodeparser.RemoteObjectNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.rpc.nodeparser.WebServiceNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_rpc;

	/**
	 * RPC namespace handler.
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class RPCNamespaceHandler extends AbstractNamespaceHandler {

		/**
		 * Creates a new <code>RPCNamespaceHandler</code> instance.
		 */
		public function RPCNamespaceHandler() {
			super(spring_actionscript_rpc);
			registerObjectDefinitionParser("remote-object", new RemoteObjectNodeParser());
			registerObjectDefinitionParser("web-service", new WebServiceNodeParser());
		}
	}
}
