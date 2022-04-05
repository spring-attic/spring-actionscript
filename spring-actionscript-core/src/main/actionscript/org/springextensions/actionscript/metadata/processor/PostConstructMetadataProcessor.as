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
package org.springextensions.actionscript.metadata.processor {

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.metadata.process.impl.AbstractMetadataProcessor;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Method;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PostConstructMetadataProcessor extends AbstractMetadataProcessor {
		private static const POST_CONSTRUCT_NAME:String = "PostConstruct";

		private static const LOGGER:ILogger = getClassLogger(PostConstructMetadataProcessor);

		/**
		 * Creates a new <code>LifeCycleMetadataProcessor</code> instance.
		 */
		public function PostConstructMetadataProcessor() {
			super();
			metadataNames[metadataNames.length] = POST_CONSTRUCT_NAME;
		}

		override public function process(target:Object, metadataName:String, params:Array=null):* {
			var container:IMetadataContainer = params[0];
			if (container is Method) {
				LOGGER.debug("Executing post-construct method {0} on target instance {1}", [(container as Method).name, target]);
				(container as Method).invoke(target, []);
			}
		}
	}
}
