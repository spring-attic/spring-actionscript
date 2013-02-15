Maven build
-----------
A cairngorm dependency not available in any maven repository is needed. To be able to build this project it
has to be installed with the following procedure. 

To be able to use them, please ensure that maven is configured in the path, and then position yourself in 
lib subdirectory and issue this command:

mvn install:install-file -Dfile=Cairngorm.swc -DpomFile=cairngorm-2.2.1-pom.xml

To be able to run tests, make sure that Flash Player executable is in path, or configure its location by passing
  -DflashPlayer.command=[path-to-flashplayer]/FlashPlayer.exe
