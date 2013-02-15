/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.stage {
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.module.IOwnerModuleAware;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	public class FlexStageProcessorFactoryPostProcessor extends StageProcessorFactoryPostprocessor {

		public function FlexStageProcessorFactoryPostProcessor() {
			super();
		}

		/**
		 * Checks if the specified <code>IConfigurableListableObjectFactory</code> implements <code>IOwnerModuleAware</code>, if so
		 * it checks if the <code>ownerModule</code> property is not null and return its value.
		 * <p>Otherwise a reference to the current <code>Application</code> instance is returned.</p>
		 * @param objectFactory
		 * @return Either a reference to a <code>Module</code> or to the current <code>Application</code> instance.
		 */
		override protected function findCurrentDocument(objectFactory:IConfigurableListableObjectFactory):Object {
			var ownerModuleAware:IOwnerModuleAware = (objectFactory as IOwnerModuleAware);
			if ((ownerModuleAware != null) && (ownerModuleAware.ownerModule != null)) {
				return ownerModuleAware.ownerModule;
			} else {
				return ApplicationUtils.application;
			}
		}

	}
}