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
package org.springextensions.actionscript.context.impl {
	import flash.display.DisplayObject;
	
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.eventbus.process.EventBusAwareObjectPostProcessor;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultInstanceCache;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ArrayCollectionReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ArrayReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.DictionaryReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ObjectReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ThisReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.VectorReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.FactoryObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.ObjectDefinitionFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.RegisterObjectFactoryPostProcessorsFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.RegisterObjectPostProcessorsFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ApplicationContextAwareObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ApplicationDomainAwarePostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ObjectDefinitionRegistryAwareObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ObjectFactoryAwarePostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistryAware;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.DefaultObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.metadata.MetadataProcessorObjectFactoryPostProcessor;
	import org.springextensions.actionscript.metadata.processor.PostConstructMetadataProcessor;
	import org.springextensions.actionscript.metadata.processor.PreDestroyMetadataProcessor;
	import org.springextensions.actionscript.stage.StageProcessorFactoryPostprocessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultApplicationContext extends ApplicationContext {

		/**
		 * Creates a new <code>ApplicationContext</code> instance.
		 * @param parent
		 * @param objFactory
		 */
		public function DefaultApplicationContext(parent:IApplicationContext=null, rootViews:Vector.<DisplayObject>=null, objFactory:IObjectFactory=null) {
			objFactory ||= createDefaultObjectFactory(parent);
			super(rootViews, objFactory);
			addObjectFactoryPostProcessor(new RegisterObjectPostProcessorsFactoryPostProcessor(-100));
			addObjectFactoryPostProcessor(new RegisterObjectFactoryPostProcessorsFactoryPostProcessor(-99));
			addObjectFactoryPostProcessor(new ObjectDefinitionFactoryPostProcessor(1000));
			addObjectFactoryPostProcessor(new StageProcessorFactoryPostprocessor());
			addObjectFactoryPostProcessor(new MetadataProcessorObjectFactoryPostProcessor());
			addObjectFactoryPostProcessor(new FactoryObjectFactoryPostProcessor());

			if (objectFactory.objectDefinitionRegistry != null) {
				var definition:IObjectDefinition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(PostConstructMetadataProcessor, true));
				objectFactory.objectDefinitionRegistry.registerObjectDefinition("springactionscript_postConstructProcessor", definition);
				definition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(PreDestroyMetadataProcessor, true));
				objectFactory.objectDefinitionRegistry.registerObjectDefinition("springactionscript_preDestroyProcessor", definition);
			}

			//objectFactory.addObjectPostProcessor(new ApplicationContextAwareObjectPostProcessor(this));
			//objectFactory.addObjectPostProcessor(new ApplicationDomainAwarePostProcessor(this));
			//objectFactory.addObjectPostProcessor(new ObjectFactoryAwarePostProcessor(this));
			//objectFactory.addObjectPostProcessor(new EventBusAwareObjectPostProcessor(this));
			//objectFactory.addObjectPostProcessor(new ObjectDefinitionRegistryAwareObjectPostProcessor(this.objectDefinitionRegistry));

			addInterfaceDefinition(IApplicationContextAware, "applicationContext", "this");
			addInterfaceDefinition(IApplicationDomainAware, "applicationDomain", "this.applicationDomain");
			addInterfaceDefinition(IObjectFactoryAware, "objectFactory", "this");
			addInterfaceDefinition(IEventBusAware, "eventBus", "this.eventBus");
			addInterfaceDefinition(IEventBusUserRegistryAware, "eventBusUserRegistry", "this.eventBusUserRegistry");
			addInterfaceDefinition(IObjectDefinitionRegistryAware, "objectDefinitionRegistry", "this.objectDefinitionRegistry");

			objectFactory.addReferenceResolver(new ThisReferenceResolver(this));
			objectFactory.addReferenceResolver(new ObjectReferenceResolver(this));
			objectFactory.addReferenceResolver(new ArrayReferenceResolver(this));
			objectFactory.addReferenceResolver(new DictionaryReferenceResolver(this));
			objectFactory.addReferenceResolver(new VectorReferenceResolver(this));
			if (ArrayCollectionReferenceResolver.canCreate(applicationDomain)) {
				objectFactory.addReferenceResolver(new ArrayCollectionReferenceResolver(this));
			}
		}

		private function addInterfaceDefinition(interfaze:Class, propertyName:String, reference:String):void {
			var className:String = ClassUtils.getFullyQualifiedName(interfaze, true);
			var parts:Array = className.split('.');
			var name:String = parts[parts.length - 1];
			var definition:IObjectDefinition = new ObjectDefinition(className);
			definition.isInterface = true;
			var propertyDef:PropertyDefinition = new PropertyDefinition(propertyName, new RuntimeObjectReference(reference));
			definition.addPropertyDefinition(propertyDef);
			objectFactory.objectDefinitionRegistry.registerObjectDefinition("springactionscript_" + name, definition);
		}

		private function createDefaultObjectFactory(parent:IApplicationContext):IObjectFactory {
			var defaultObjectFactory:DefaultObjectFactory = new DefaultObjectFactory(parent);
			defaultObjectFactory.objectDefinitionRegistry = new DefaultObjectDefinitionRegistry();
			defaultObjectFactory.cache = new DefaultInstanceCache();
			return defaultObjectFactory;
		}

	}
}
