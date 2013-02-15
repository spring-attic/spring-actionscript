Maven build
-----------
A cairngorm and a puremvc dependency not available in any maven repository are needed in order to build 
all modules. Please see instructions in readme.txt of each specific module in order to install
these dependencies.

For a complete generation of all libraries, sample applications, website and API documetnation use the following Maven commands in this order:

In the root folder:
* mvn clean install
* mvn site
* mvn post-site
In the spring-actionscript-samples folder:
*mvn clean package site