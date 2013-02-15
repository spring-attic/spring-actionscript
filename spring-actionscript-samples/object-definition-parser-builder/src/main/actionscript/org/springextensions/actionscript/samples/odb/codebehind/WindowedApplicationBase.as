package org.springextensions.actionscript.samples.odb.codebehind {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;
	import org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.ClassExportInfo;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.ClassNameInfo;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.GeneratorResult;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.NamespaceClassGenerator;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.NamespaceHandlerClassGenerator;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.ObjectDefinitionParserClassGenerator;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.SWCExtractor;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.SchemaGenerator;
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.model.ApplicationModel;
	/**
	 * The certificate for the AIR release compilation is found in the project root and is called 'springas.p12'.
	 * The password for the certificate is 'springactionscript'.
	 * @author Roland Zwaga
	 */
	public class WindowedApplicationBase extends WindowedApplication {

		public function WindowedApplicationBase() {
			super();
		}

		//Component declarations:
		[Bindable]
		public var availableClasses:List;
		[Bindable]
		public var btnAdd:Button;
		[Bindable]
		public var btnRemove:Button;
		[Bindable]
		public var mainStack:ViewStack;
		[Bindable]
		public var parsercode:TabNavigator;
		[Bindable]
		public var selectedClasses:List;
		[Bindable]
		public var taNameSpaceHandler:TextArea;
		[Bindable]
		public var taNamespace:TextArea;
		[Bindable]
		public var taSchema:TextArea;
		[Bindable]
		public var tiClassNameSpace:TextInput;
		[Bindable]
		public var tiNamespaceName:TextInput;
		[Bindable]
		public var tiSchemaURL:TextInput;

		protected var applicationContext:FlexXMLApplicationContext;

		[Bindable]
		protected var applicationModel:ApplicationModel;
		
		private var _file:File;

		/**
		 * Adds a tab to the parsercode <code>TabNavigator</code> instance with the source of the generated ObjectDefinitionParser class displayed in a <code>TextArea</code>
		 */
		protected function addTab(tabName:String, generatorResult:GeneratorResult):void	{
			var textArea:TextArea=null;
			for (var i:int=0; i < parsercode.numChildren; i++)
			{
				var vb:VBox=parsercode.getChildAt(i) as VBox;
				if (vb.id == tabName)
				{
					textArea=vb.getChildAt(0) as TextArea;
					break;
				}
			}
			if (textArea == null)
			{
				textArea=new TextArea();
				textArea.percentHeight=100;
				textArea.percentWidth=100;
				textArea.name=generatorResult.fileName;
				var vbox:VBox=new VBox();
				vbox.percentHeight=100;
				vbox.percentWidth=100;
				vbox.label=tabName;
				vbox.id=tabName;
				vbox.addChild(textArea);
				parsercode.addChild(vbox);
			}
			textArea.text=generatorResult.fileContents;
		}

		/**
		 * Retrieves the various code generator org.springextensions.actionscript.samples.stagewiring.classes from the <code>applicationContext</code> and execute them one-by-one, the result are
		 * displayed in the UI.
		 */
		protected function btnGenerate_clickHandler(event:MouseEvent):void {
			applicationModel.namespaceExportInfo.classExportInfoList.forEach(function(item:ClassExportInfo, index:int, arr:Array):void
				{
					generateParser(item);
				});

			var nshGenerator:NamespaceHandlerClassGenerator=applicationContext.getObject('namespaceHandlerClassGenerator') as NamespaceHandlerClassGenerator;
			nshGenerator.namespaceExportInfo=applicationModel.namespaceExportInfo;
			var result:GeneratorResult=nshGenerator.execute();
			taNameSpaceHandler.text=result.fileContents;
			taNameSpaceHandler.name=result.fileName;
			applicationModel.namespaceExportInfo.generatorResults.push(result);

			var nsGenerator:NamespaceClassGenerator=applicationContext.getObject('namespaceClassGenerator') as NamespaceClassGenerator;
			result=nsGenerator.execute();
			taNamespace.text=result.fileContents;
			taNamespace.name=result.fileName;
			applicationModel.namespaceExportInfo.generatorResults.push(result);

			var sGenerator:SchemaGenerator=applicationContext.getObject('schemaGenerator') as SchemaGenerator;
			result=sGenerator.execute();
			taSchema.text=result.fileContents;
			taSchema.name=result.fileName;
		}

		/**
		 * Shows a file browser to select a .SWC file to load
		 */
		protected function btnLoadSWC_clickHandler(event:MouseEvent):void {
			_file=new File();
			var fileTypes:FileFilter=new FileFilter(".swc files", "*.swc");
			_file.browseForOpen("Open", [fileTypes]);
			_file.addEventListener(Event.SELECT, onOpenDialogComplete);
			_file.addEventListener(Event.CANCEL, clearFileListeners);
		}

		/**
		 * Loops through the items of the selectedClasses <code>List</code> control and creates a <code>ClassExportInfo</code> instance for
		 * each item. The <code>ClassExportInfo</code> instances are added to the <code>applicationModel.namespaceExportInfo</code> instance.
		 */
		protected function btnReflectClass_clickHandler(event:MouseEvent):void {
			(selectedClasses.dataProvider as ArrayCollection).source.forEach(function(item:ClassNameInfo, index:int, arr:Array):void
				{
					var type:Type=Type.forName(item.fullyQualifiedName);
					if (type != null)
					{
						if (applicationModel.namespaceExportInfo.hasClassExportInfo(type) == false)
						{
							var classExportInfo:ClassExportInfo=applicationContext.getObject('classExportInfo', [type, getCandidateProperties(type)]) as ClassExportInfo;

							applicationModel.namespaceExportInfo.classExportInfoList.push(classExportInfo);

							this.status="Imported " + item.fullyQualifiedName + " reflection info, choose the new class from the combobox to edit its export properties";
						}
					}
				});
			(selectedClasses.dataProvider as ArrayCollection).removeAll();
		}

		/**
		 * Saves all the generated source code to the file system. Files are saved to the user directory in a directory with the same name
		 * as the generated namespace (defined in the 'Namespace title' <code>TextInput</code>). 
		 */
		protected function btnSaveAllFiles_clickHandler(event:MouseEvent):void {
			var directoryName:String=applicationModel.namespaceExportInfo.namespaceTitle;
			saveFile(directoryName + File.separator + taNameSpaceHandler.name, taNameSpaceHandler.text);
			saveFile(directoryName + File.separator + taSchema.name, taSchema.text);
			saveFile(directoryName + File.separator + taNamespace.name, taNamespace.text);
			for (var i:int=0; i < parsercode.numChildren; i++)
			{
				var ta:TextArea=(parsercode.getChildAt(i) as VBox).getChildAt(0) as TextArea;
				saveFile(File.userDirectory.resolvePath(directoryName).nativePath + File.separator + ta.name, ta.text);
			}

			this.status="Files saved in directory: " + File.userDirectory.resolvePath(directoryName).nativePath;
		}

		/**
		 * Returns <code>true</code> if a <code>ClassNameInfo</code> instance has already been created for the specified fully qualified class name.
		 */		
		protected function classIsListed(fullyQualifiedName:String):Boolean {
			return applicationModel.classNameList.source.some(function(item:ClassNameInfo, index:int, arr:Array):Boolean
				{
					return (item.fullyQualifiedName == fullyQualifiedName);
				});
		}

		/**
		 * Inserts the selected items from the specified source <code>List</code> instance into the specified destination <code>List</code> instance
		 * and deletes the selected items from the specified source <code>List</code> instance.
		 */
		protected function exchangeItems(source:List, destination:List):void {
			var sourceList:ArrayCollection=(source.dataProvider as ArrayCollection);
			var destinationList:ArrayCollection=(destination.dataProvider as ArrayCollection);
			source.selectedIndices.forEach(function(indice:int, index:int, arr:Array):void
				{
					var cInfo:ClassNameInfo=sourceList.getItemAt(indice) as ClassNameInfo;
					destinationList.addItem(cInfo);
					sourceList.removeItemAt(indice);
				});
			sourceList.refresh();
			destinationList.refresh();
		}

		/**
		 * Retrieves an <code>ObjectDefinitionParserClassGenerator</code> instance from the <code>applicationContext</code> and executes it with the specified
		 * <code>ClassExportInfo</code> instance.
		 */
		protected function generateParser(classExportInfo:ClassExportInfo):void	{
			var defGenerator:ObjectDefinitionParserClassGenerator=applicationContext.getObject('objectDefinitionParserGenerator') as ObjectDefinitionParserClassGenerator;
			defGenerator.classExportInfo=classExportInfo;
			var result:GeneratorResult=defGenerator.execute();
			applicationModel.namespaceExportInfo.generatorResults.push(result);
			addTab(classExportInfo.className, result);
		}

		/**
		 * Adds or removes org.springextensions.actionscript.samples.stagewiring.classes to be analyzed
		 */
		protected function generic_add_remove_clickHandler(event:Event):void {
			switch (event.target)
			{
				case btnAdd:
					exchangeItems(availableClasses, selectedClasses);
					break;
				case btnRemove:
					exchangeItems(selectedClasses, availableClasses);
					break;
				default:
					break;
			}
		}

		/**
		 * Tests the <code>event.target</code> an updates the <code>applicationModel.namespaceExportInfo.targetClassNamespace</code>,
		 * <code>applicationModel.namespaceExportInfo.schemaURL</code> or <code>applicationModel.namespaceExportInfo.namespaceTitle</code>
		 * accordingly given the <code>event.target</code> text property.
		 */
		protected function generic_commithandler(event:Event):void {
			switch (event.target)
			{
				case tiClassNameSpace:
					applicationModel.namespaceExportInfo.targetClassNamespace=tiClassNameSpace.text;
					break;
				case tiSchemaURL:
					applicationModel.namespaceExportInfo.schemaURL=tiSchemaURL.text;
					break;
				case tiNamespaceName:
					applicationModel.namespaceExportInfo.namespaceTitle=tiNamespaceName.text;
				default:
					break;
			}
		}

		/**
		 * Retrieves an array of <code>FieldExportInfo</code> instances for the the specified <code>Type</code>, only
		 * non-static variables and non-static/write-only or read-write accessors are used. 
		 */
		protected function getCandidateProperties(type:Type):Array {
			var result:Array=[];
			var i:int;
			var variable:Variable;

			for (i=0; i < type.variables.length; i++)
			{
				variable=type.variables[i];

				if (variable.isStatic == false)
				{
					result.push(applicationContext.getObject('fieldExportInfo', [variable]));
				}
			}

			var accessor:Accessor;

			for (i=0; i < type.accessors.length; i++)
			{
				accessor=type.accessors[i];

				if ((accessor.access == AccessorAccess.WRITE_ONLY || accessor.access == AccessorAccess.READ_WRITE) && (accessor.isStatic == false))
				{
					result.push(applicationContext.getObject('fieldExportInfo', [accessor]));
				}
			}
			return result;

		}

		/**
		 * Retrieves an <code>XMLList</code> of &lt;def/&gt; elements from the specified <code>XML</code> object, loops through them
		 * and uses its id attribute to create a <code>ClassNameInfo</code> instance. 
		 */
		protected function importClassList(input:XML):void {
			var ns:Namespace=input.namespaceDeclarations()[0] as Namespace;
			var defs:XMLList=input..ns::def;
			for (var i:int=0; i < defs.length(); i++)
			{
				var fullName:String=String(defs[i].@id);
				var name:String=(fullName.indexOf(':') > -1) ? String(fullName.split(':')[1]) : fullName;
				fullName=fullName.replace(':', '::');
				if (classIsListed(fullName) == false)
				{
					applicationModel.classNameList.addItem(new ClassNameInfo(name, fullName));
				}
			}
		}

		/**
		 * Loads a .swc file from the filesystem, unzips it, retrives the catalog.xml which is used to import a list
		 * of <code>ClassNameInfo</code> instances, retrieves the library.swf file and loads it into the application domain.  
		 */
		protected function loadSWC(file:File):void {
			var context:LoaderContext=new LoaderContext();
			context.applicationDomain=ApplicationDomain.currentDomain;
			context.securityDomain=null;
			context["allowLoadBytesCodeExecution"]=true;

			var zStream:FileStream=new FileStream();
			var loader:Loader=new Loader();
			try
			{
				zStream.open(file, FileMode.READ);
				zStream.endian=Endian.LITTLE_ENDIAN;

				var bt:ByteArray=new ByteArray();
				bt.endian=zStream.endian;
				zStream.readBytes(bt);

				var swcZIP:SWCExtractor=new SWCExtractor(bt);

				importClassList(swcZIP.getCatalog());

				try
				{
					loader.loadBytes(swcZIP.getSWF(), context);
				}
				catch (e:*)
				{
					//eat load errors, we're only interested in reflection info anyways
				}
			}
			finally
			{
				zStream.close();
			}
		}

		/**
		 * Loops through the swc directory and one-by-one loads the .swc files found in there.
		 */
		protected function loadSWCS():void {
			var swcDirectory:File=new File(File.applicationDirectory.nativePath + File.separator + 'swc');
			if (swcDirectory.exists)
			{
				var files:Array=swcDirectory.getDirectoryListing();
				files.forEach(function(item:File, index:int, arr:Array):void
					{
						if (item.extension == "swc")
						{
							loadSWC(item);
						}
					});
				applicationModel.classNameList.refresh();
			}
			else {
				this.status = File.applicationDirectory.nativePath + File.separator + 'swc' + ", this directory does not exist.";
			}
		}

		/**
		 * Sets the status message with some informative text...
		 */
		protected function updateStatus():void {
			this.status="Use the checkboxes and inputs to change the export properties";
		}

		/**
		 * Creates the <code>FlexXMLApplicationContext</code> instance, set a <code>Event.COMPLETE</code> handler on it
		 * and loads the specified confiugration file.
		 */
		protected function windowedapplicationbase1_creationCompleteHandler(event:FlexEvent):void {
			applicationContext=new FlexXMLApplicationContext('context/application-context.xml');
			applicationContext.addEventListener(Event.COMPLETE, handleComplete);
			applicationContext.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			applicationContext.load();
		}

		/**
		 * Removes all event listeners on the <code>File</code> instance. 
		 */
		private function clearFileListeners(event:Event=null):void {
			_file.removeEventListener(Event.SELECT, onOpenDialogComplete);
			_file.removeEventListener(Event.CANCEL, clearFileListeners);
		}
		
		private function handleError(event:IOErrorEvent):void {
			removeContextHandlers();
			Alert.show(event.text);
		}
		
		private function removeContextHandlers():void {
			applicationContext.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			applicationContext.removeEventListener(Event.COMPLETE, handleComplete);
		}

		/**
		 * Sets the applicationModel property and loads the swc files in the swc directory. 
		 */
		private function handleComplete(event:Event):void {
			removeContextHandlers();
			applicationModel=applicationContext.getObject('applicationModel') as ApplicationModel;
			loadSWCS();
			mainStack.selectedIndex=1;
		}

		/**
		 * Loads the specified SWC file. 
		 */
		private function onOpenDialogComplete(event:Event):void	{
			clearFileListeners();
			loadSWC(_file);
		}

		/**
		 * Saves a file with the specified file path and with the specified contents 
		 */
		private function saveFile(filePath:String, contents:String):void {
			var file:File=File.userDirectory.resolvePath(filePath);
			var stream:FileStream=new FileStream();
			try
			{
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(contents);
			}
			finally
			{
				stream.close();
			}
		}
		//Static code block to force class compilation
		{
			FieldRetrievingFactoryObject
		}
	}
}