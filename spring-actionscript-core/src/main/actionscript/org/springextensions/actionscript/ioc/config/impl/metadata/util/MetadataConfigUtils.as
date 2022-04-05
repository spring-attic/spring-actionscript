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
package org.springextensions.actionscript.ioc.config.impl.metadata.util {
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public final class MetadataConfigUtils {

		/** The "args" attribute. */
		public static const ARGS_ATTR:String = "args";

		/** The "autowire" attribute. */
		public static const AUTOWIRE_ATTR:String = "autowire";

		/** The "autowireCandidate" attribute. */
		public static const AUTOWIRE_CANDIDATE_ATTR:String = "autowireCandidate";

		/** The "childContextAccess" attribute. */
		public static const CHILD_CONTEXT_ACCESS_ATTR:String = "childContextAccess";

		/** The Configuration metadata. */
		public static const CONFIGURATION_METADATA:String = "Configuration";

		/** The Component metadata. */
		public static const COMPONENT_METADATA:String = "Component";

		/** The Constructor metadata. */
		public static const CONSTRUCTOR_METADATA:String = "Constructor";

		/** The "dependencyCheck" attribute. */
		public static const DEPENDENCY_CHECK_ATTR:String = "dependencyCheck";

		/** The "dependsOn" attribute. */
		public static const DEPENDS_ON_ATTR:String = "dependsOn";

		/** The "destroyMethod" attribute. */
		public static const DESTROY_METHOD_ATTR:String = "destroyMethod";

		/** The Configuration metadata. */
		public static const EXTERNAL_PROPERTIES_METADATA:String = "ExternalProperties";

		/** The "factoryMethod" attribute. */
		public static const FACTORY_METHOD_ATTR:String = "factoryMethod";

		/** The "factoryObject" attribute. */
		public static const FACTORY_OBJECT_NAME_ATTR:String = "factoryObjectName";

		/** The "id" attribute. */
		public static const ID_ATTR:String = "id";

		/** The "initMethod" attribute. */
		public static const INIT_METHOD_ATTR:String = "initMethod";

		/** The Invoke metadata. */
		public static const INVOKE_METADATA:String = "Invoke";

		/** The "isAbstract" attribute. */
		public static const IS_ABSTRACT_ATTR:String = "isAbstract";

		/** The "lazyInit" attribute. */
		public static const LAZY_INIT_ATTR:String = "lazyInit";

		/** The "location" attribute. */
		public static const LOCATION_ATTR:String = "location";

		/** The "parentName" attribute. */
		public static const PARENT_NAME_ATTR:String = "parentName";

		/** The "preventCache" attribute. */
		public static const PREVENTCACHE_ATTR:String = "preventCache";

		/** The "primary" attribute. */
		public static const PRIMARY_ATTR:String = "primary";

		/** The SetProperty metadata. */
		public static const PROPERTY_METADATA:String = "Property";

		/** The "ref" attribute. */
		public static const REF_ATTR:String = "ref";

		/** The "required" attribute. */
		public static const REQUIRED_ATTR:String = "required";

		/** The prefix used when generating object definition names. */
		public static const SCANNED_COMPONENT_NAME_PREFIX:String = "scannedComponent#";

		/** The "scope" attribute. */
		public static const SCOPE_ATTR:String = "scope";

		/** The "skipMetaData" attribute. */
		public static const SKIP_METADATA_ATTR:String = "skipMetaData";

		/** The "skipPostProcessors" attribute. */
		public static const SKIP_POSTPROCESSORS_ATTR:String = "skipPostProcessors";

		/** The "value" attribute. */
		public static const VALUE_ATTR:String = "value";

		public static const EQUALS:String = '=';
		public static const TRUE_VALUE:String = "true";
		public static const COMMA:String = ',';
		public static const EMPTY:String = '';
		public static const SPACE:String = ' ';
		public static const UNKNOWN_METADATA_ARGUMENT_ERROR:String = "Unknown metadata argument '{0}' encountered on class {1}.";

		private static const LOGGER:ILogger = getClassLogger(MetadataConfigUtils);

		/**
		 *
		 * @param componentMetaData
		 * @param definition
		 * @param className
		 */
		public function resolveDefinitionProperties(componentMetaData:Metadata, definition:IObjectDefinition, className:String):void {
			for each (var arg:MetadataArgument in componentMetaData.arguments) {

				switch (arg.key) {
					case SCOPE_ATTR:
						definition.scope = ObjectDefinitionScope.fromName(arg.value);
						break;
					case LAZY_INIT_ATTR:
						definition.isLazyInit = (arg.value == TRUE_VALUE);
						break;
					case PRIMARY_ATTR:
						definition.primary = (arg.value == TRUE_VALUE);
						break;
					case AUTOWIRE_CANDIDATE_ATTR:
						definition.isAutoWireCandidate = (arg.value == TRUE_VALUE);
						break;
					case SKIP_METADATA_ATTR:
						definition.skipMetadata = (arg.value == TRUE_VALUE);
						break;
					case SKIP_POSTPROCESSORS_ATTR:
						definition.skipPostProcessors = (arg.value == TRUE_VALUE);
						break;
					case FACTORY_METHOD_ATTR:
						definition.factoryMethod = arg.value;
						break;
					case FACTORY_OBJECT_NAME_ATTR:
						definition.factoryObjectName = arg.value;
						break;
					case INIT_METHOD_ATTR:
						definition.initMethod = arg.value;
						break;
					case DESTROY_METHOD_ATTR:
						definition.destroyMethod = arg.value;
					case AUTOWIRE_ATTR:
						definition.autoWireMode = AutowireMode.fromName(arg.value);
						break;
					case DEPENDENCY_CHECK_ATTR:
						definition.dependencyCheck = DependencyCheckMode.fromName(arg.value);
					case DEPENDS_ON_ATTR:
						var depends:Array = arg.value.split(SPACE).join(EMPTY).split(COMMA);
						definition.dependsOn = new Vector.<String>();
						for each (var name:String in depends) {
							definition.dependsOn[definition.dependsOn.length] = name;
						}
						break;
					case CHILD_CONTEXT_ACCESS_ATTR:
						definition.childContextAccess = ChildContextObjectDefinitionAccess.fromValue(arg.key.toLowerCase());
						break;
					case PARENT_NAME_ATTR:
						definition.parentName = arg.value;
						break;
					case IS_ABSTRACT_ATTR:
						definition.isAbstract = (arg.value == TRUE_VALUE);
					case ID_ATTR:
						break;
					default:
						LOGGER.warn(UNKNOWN_METADATA_ARGUMENT_ERROR, [arg.key, className]);
				}
			}
		}

		/**
		 *
		 * @param metadata
		 * @return
		 */
		public function resolveArguments(metadata:Metadata):Vector.<ArgumentDefinition> {
			var result:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();

			if (metadata.hasArgumentWithKey(MetadataConfigUtils.ARGS_ATTR)) {
				var arg:String = metadata.getArgument(MetadataConfigUtils.ARGS_ATTR).value;
				if (arg.length > 0) {
					var args:Array = arg.split(MetadataConfigUtils.COMMA);
					var keyvalue:Array;
					for each (var val:String in args) {
						val = StringUtils.trim(val);
						keyvalue = val.split(EQUALS);
						if (StringUtils.trim(keyvalue[0]) == MetadataConfigUtils.REF_ATTR) {
							result[result.length] = new ArgumentDefinition(null, new RuntimeObjectReference(StringUtils.trim(keyvalue[1])));
						} else if (StringUtils.trim(keyvalue[0]) == VALUE_ATTR) {
							result[result.length] = new ArgumentDefinition(StringUtils.trim(keyvalue[1]));
						}
					}
				}
			}

			return (result.length > 0) ? result : null;
		}

	}
}
