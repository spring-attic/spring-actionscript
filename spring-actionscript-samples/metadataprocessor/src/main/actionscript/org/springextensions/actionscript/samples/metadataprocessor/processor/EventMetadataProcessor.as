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
package org.springextensions.actionscript.samples.metadataprocessor.processor {
	import org.as3commons.reflect.IMetaDataContainer;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;
	import org.springextensions.actionscript.samples.metadataprocessor.model.ApplicationModel;

	public class EventMetadataProcessor extends AbstractMetadataProcessor {

		private static const EVENT_METADATA_NAME:String = "Event";

		public var applicationModel:ApplicationModel;

		public function EventMetadataProcessor() {
			super(true, [EVENT_METADATA_NAME]);
		}

		override public function process(instance:Object, container:IMetaDataContainer, name:String, objectName:String):void {
			applicationModel.classNames.addItem(Object(instance).constructor);
		}

	}
}