# Author: Christophe Herreman
# Version: $Revision: 1511 $, $Date: 2010-12-13 08:59:06 +0100 (ma, 13 dec 2010) $, $Author: mechhead $
# Since: 0.1

SPRING ACTIONSCRIPT README
==========================


Installation Instructions
-------------------------

To use Spring ActionScript, simple put the spring-actionscript.swc file in your actionscript classpath. If you downloaded
the zipped distribution, you can find the swc file in the dist/swc folder.

The framework is built against Flex SDK 3.5.0.12683


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



  Building with Maven
  -------------------

  Run "mvn install" in the "core" folder.