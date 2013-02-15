# Author: Christophe Herreman
# Version: $Revision: 468 $, $Date: 2009-07-04 23:22:51 +0200 (za, 04 jul 2009) $, $Author: martino.piccinato $
# Since: 0.1

SPRING ACTIONSCRIPT README
==========================


Installation Instructions
-------------------------

To use Spring ActionScript, simple put the spring-actionscript.swc file in your actionscript classpath. If you downloaded
the zipped distribution, you can find the swc file in the dist/swc folder.

The framework is built against Flex SDK 3.2.0


Checking Out Source From SVN
----------------------------

Check out the sources from SVN if you want to work on the sources or build the framework yourself.
The SVN repository can be found at:

  https://src.springframework.org/svn/se-springactionscript-as/spring-actionscript/trunk


Source Usage Instructions
-------------------------

If you prefer to use the sources instead of the compiled swc file of the framework, create a new Flex Library Project
in Flex Builder with the following properties:

  * name: springactionscript
  * location: uncheck "Use default location" and enter "[ROOT]\core\src\main\actionscript" where
              [ROOT] is replaced by the folder where you checked out Spring ActionScript
  * main source folder: leave empty

You will also have to add as3reflect and flexunit to the build path. These libraries are available in the "lib/as3" folder.
To add them to the build path, go to the properties of the Flex Library project you created, select Flex Library Build Path
from the left and then the Library path tab. Add them using the Add SWC button and browse for the needed libraries.


Build Instructions
------------------


  Building with Ant
  -----------------

  Make sure java is in your path.

  Next, make sure the FLEX_HOME property in ant\build.properties points to your Flex SDK.

    e.g. FLEX_HOME=C:/Program Files/Adobe/Flex Builder 3 Plug-in/sdks/3.2.0

  To build the framework, run the build.bat file in the "ant" folder and specify "release" as a target

    > build.bat release

  Now check the antbuild directory on the root of the folder where you checked out the framework. The swc is located in

    antbuild\compile\main\swc\spring-actionscript.swc


  Building with Maven
  -------------------

  Run "mvn install" in the "core" folder. You'll have to manually install the as3reflect library since it is currently
  not hosted in a Maven repository. You can download as3reflect at http://code.google.com/p/as3reflect/

  To manually install the as3reflect library, run the following command:

  > mvn install:install-file -DgroupId=com.google.code -DartifactId=as3reflect -Dversion=1.0RC2 -Dpackaging=swc -Dfile=/path/to/file
 
  Replace /path/to/file with the path to the as3reflect.swc file. If you are installing a version other than 1.0RC2, you will have
  to update the version property as well.