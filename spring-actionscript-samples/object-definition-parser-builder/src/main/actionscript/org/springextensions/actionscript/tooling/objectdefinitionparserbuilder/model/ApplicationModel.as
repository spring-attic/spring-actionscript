package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.ClassNameInfo;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.NamespaceExportInfo;
	/**
	 * The main application model for the object definition parser builder
	 * @author Roland Zwaga
	 */
	public class ApplicationModel extends EventDispatcher {
		
		/**
		 * Creates a new <code>ApplicationModel</code> instance. 
		 */
		public function ApplicationModel(target:IEventDispatcher=null) {
			super(target);

			classNameList = new ArrayCollection();
			classNameList.sort = new Sort();
			classNameList.sort.fields = [new SortField('name',true)];
			
			classNameList.filterFunction = filterFrameworkClasses;
			 
			classImportList = new ArrayCollection();
			classImportList.sort = new Sort();
			classImportList.sort.fields = [new SortField('name',true)];
		}
		
		[Bindable]
		/**
		 * An array of <code>ClassNameInfo</code> instances 
		 */
		public var classImportList:ArrayCollection;
		
		[Bindable]
		/**
		 * An array of <code>ClassNameInfo</code> instances 
		 */
		public var classNameList:ArrayCollection;
		
		[Bindable]
		/**
		 * If true the classNameList will not show all the org.springextensions.actionscript.samples.stagewiring.classes that start with mx. or flash.
		 */
		public var filterClasses:Boolean;
		
		[Bindable]
		/**
		 * The export info for the code generator org.springextensions.actionscript.samples.stagewiring.classes
		 */
		public var namespaceExportInfo:NamespaceExportInfo;

		private function filterFrameworkClasses(item:Object):Boolean {
			if (filterClasses){
				var classNameInfo:ClassNameInfo = (item as ClassNameInfo);
				if (classNameInfo != null){
					return ((classNameInfo.fullyQualifiedName.match("^mx\.").length < 0) || (classNameInfo.fullyQualifiedName.match("^flash\.").length < 0));
				}
				else {
					return false;
				}
			}
			else
			{
				return true;
			}
		}

	}
}