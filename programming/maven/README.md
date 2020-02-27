<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Compile and Execute java file by manual](#compile-and-execute-java-file-by-manual)
- [Compile and Execute by maven](#compile-and-execute-by-maven)
  - [Scaffold in Maven](#scaffold-in-maven)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Compile and Execute java file by manual
- Compile

        [16:59:13.56 C:\hello-world\src\main\java]
        $ javac com\juvenxu\mvnbook\helloworld\HelloWorld.java

- Execute

        [16:59:20.89 C:\hello-world\src\main\java]
        $ java com.juvenxu.mvnbook.helloworld.HelloWorld
        Hello Maven

## Compile and Execute by maven
- Compile

        [16:55:49.04 C:\hello-world]
        $ mvn clean compile
        [INFO] Scanning for projects...
        [INFO]
        [INFO] ------------------------------------------------------------------------
        [INFO] Building Maven Hello World Project 1.0-SNAPSHOT
        [INFO] ------------------------------------------------------------------------
        [INFO]
        [INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello-world ---
        [INFO] Deleting C:\Marslo\Study\Codes\Maven\hello-world\target
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory C:\Marslo\Study\Codes\Maven\hello-world\src\main\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to C:\Marslo\Study\Codes\Maven\hello-world\target\classes
        [INFO] ------------------------------------------------------------------------
        [INFO] BUILD SUCCESS
        [INFO] ------------------------------------------------------------------------
        [INFO] Total time: 1.916 s
        [INFO] Finished at: 2014-11-28T17:02:36+08:00
        [INFO] Final Memory: 12M/150M
        [INFO] ------------------------------------------------------------------------

- Test

        [17:02:39.17 C:\hello-world]
        $ mvn clean test
        [INFO] Scanning for projects...
        [INFO]
        [INFO] ------------------------------------------------------------------------
        [INFO] Building Maven Hello World Project 1.0-SNAPSHOT
        [INFO] ------------------------------------------------------------------------
        [INFO]
        [INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello-world ---
        [INFO] Deleting C:\Marslo\Study\Codes\Maven\hello-world\target
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory C:\Marslo\Study\Codes\Maven\hello-world\src\main\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to C:\Marslo\Study\Codes\Maven\hello-world\target\classes
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory C:\Marslo\Study\Codes\Maven\hello-world\src\test\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to C:\Marslo\Study\Codes\Maven\hello-world\target\test-classes
        [INFO]
        [INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ hello-world ---
        [INFO] Surefire report directory: C:\Marslo\Study\Codes\Maven\hello-world\target\surefire-reports

        -------------------------------------------------------
         T E S T S
        -------------------------------------------------------
        Running com.juvenxu.mvnbook.helloworld.HelloWorldTest
        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.06 sec

        Results :

        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

        [INFO] ------------------------------------------------------------------------
        [INFO] BUILD SUCCESS
        [INFO] ------------------------------------------------------------------------
        [INFO] Total time: 4.639 s
        [INFO] Finished at: 2014-11-28T17:03:42+08:00
        [INFO] Final Memory: 13M/159M
        [INFO] ------------------------------------------------------------------------

- Package

        [18:36:28.23 C:\hello-world]
        $ mvn clean package
        [INFO] Scanning for projects...
        [WARNING]
        [WARNING] Some problems were encountered while building the effective model for com.juvenxu.mvnbook:hello-world:jar:1.0-SNAPSHOT
        [WARNING] 'build.plugins.plugin.version' for org.apache.maven.plugins:maven-compiler-plugin is missing. @ line 21, column 15
        [WARNING]
        [WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
        [WARNING]
        [WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
        [WARNING]
        [INFO]
        [INFO] ------------------------------------------------------------------------
        [INFO] Building Maven Hello World Project 1.0-SNAPSHOT
        [INFO] ------------------------------------------------------------------------
        [INFO]
        [INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello-world ---
        [INFO] Deleting C:\Marslo\Study\Codes\Maven\hello-world\target
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory C:\Marslo\Study\Codes\Maven\hello-world\src\main\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to C:\Marslo\Study\Codes\Maven\hello-world\target\classes
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory C:\Marslo\Study\Codes\Maven\hello-world\src\test\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to C:\Marslo\Study\Codes\Maven\hello-world\target\test-classes
        [INFO]
        [INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ hello-world ---
        [INFO] Surefire report directory: C:\Marslo\Study\Codes\Maven\hello-world\target\surefire-reports

        -------------------------------------------------------
         T E S T S
        -------------------------------------------------------
        Running com.juvenxu.mvnbook.helloworld.HelloWorldTest
        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.06 sec

        Results :

        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

        [INFO]
        [INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello-world ---
        [INFO] Building jar: C:\Marslo\Study\Codes\Maven\hello-world\target\hello-world-1.0-SNAPSHOT.jar
        [INFO] ------------------------------------------------------------------------
        [INFO] BUILD SUCCESS
        [INFO] ------------------------------------------------------------------------
        [INFO] Total time: 5.571 s
        [INFO] Finished at: 2014-11-28T18:36:41+08:00
        [INFO] Final Memory: 15M/201M
        [INFO] ------------------------------------------------------------------------

- Install

        [19:02:40.49 c:\hello-world]
        $ mvn clean install
        [INFO] Scanning for projects...
        [WARNING]
        [WARNING] Some problems were encountered while building the effective model for com.juvenxu.mvnbook:hello-world:jar:1.0-SNAPSHOT
        [WARNING] 'build.plugins.plugin.version' for org.apache.maven.plugins:maven-compiler-plugin is missing. @ line 21, column 15
        [WARNING]
        [WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
        [WARNING]
        [WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
        [WARNING]
        [INFO]
        [INFO] ------------------------------------------------------------------------
        [INFO] Building Maven Hello World Project 1.0-SNAPSHOT
        [INFO] ------------------------------------------------------------------------
        [INFO]
        [INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello-world ---
        [INFO] Deleting c:\Marslo\Study\Codes\Maven\hello-world\target
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory c:\Marslo\Study\Codes\Maven\hello-world\src\main\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to c:\Marslo\Study\Codes\Maven\hello-world\target\classes
        [INFO]
        [INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ hello-world ---
        [WARNING] Using platform encoding (Cp1252 actually) to copy filtered resources, i.e. build is platform dependent!
        [INFO] skip non existing resourceDirectory c:\Marslo\Study\Codes\Maven\hello-world\src\test\resources
        [INFO]
        [INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ hello-world ---
        [INFO] Changes detected - recompiling the module!
        [WARNING] File encoding has not been set, using platform encoding Cp1252, i.e. build is platform dependent!
        [INFO] Compiling 1 source file to c:\Marslo\Study\Codes\Maven\hello-world\target\test-classes
        [INFO]
        [INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ hello-world ---
        [INFO] Surefire report directory: c:\Marslo\Study\Codes\Maven\hello-world\target\surefire-reports

        -------------------------------------------------------
         T E S T S
        -------------------------------------------------------
        Running com.juvenxu.mvnbook.helloworld.HelloWorldTest
        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.05 sec

        Results :

        Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

        [INFO]
        [INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello-world ---
        [INFO] Building jar: c:\Marslo\Study\Codes\Maven\hello-world\target\hello-world-1.0-SNAPSHOT.jar
        [INFO]
        [INFO] --- maven-shade-plugin:1.2.1:shade (default) @ hello-world ---
        [INFO] Replacing original artifact with shaded artifact.
        [INFO] Replacing c:\Marslo\Study\Codes\Maven\hello-world\target\hello-world-1.0-SNAPSHOT.jar with c:\Marslo\Study\Codes\Maven\hello-world\target\hello-world-1.0-SNAPSHOT-shaded.jar
        [INFO]
        [INFO] --- maven-install-plugin:2.4:install (default-install) @ hello-world ---
        [INFO] Installing c:\Marslo\Study\Codes\Maven\hello-world\target\hello-world-1.0-SNAPSHOT.jar to C:\Users\marslo_jiao\.m2\repository\com\juvenxu\mvnbook\hello-world\1.0-SNAPSHOT\hello-world-1.0-SNAPSHOT.jar
        [INFO] Installing c:\Marslo\Study\Codes\Maven\hello-world\pom.xml to C:\Users\marslo_jiao\.m2\repository\com\juvenxu\mvnbook\hello-world\1.0-SNAPSHOT\hello-world-1.0-SNAPSHOT.pom
        [INFO] ------------------------------------------------------------------------
        [INFO] BUILD SUCCESS
        [INFO] ------------------------------------------------------------------------
        [INFO] Total time: 5.429 s
        [INFO] Finished at: 2014-11-28T19:03:44+08:00
        [INFO] Final Memory: 16M/201M
        [INFO] ------------------------------------------------------------------------

- Verification

        [19:09:52.90 c:\hello-world\target]
        $ java -jar hello-world-1.0-SNAPSHOT.jar
        Hello Maven
        [19:09:57.52 c:\hello-world\target]
        $ jar xf hello-world-1.0-SNAPSHOT.jar
        [19:10:46.36 c:\hello-world\target]
        $ cat META-INF\MANIFEST.MF
        Manifest-Version: 1.0
        Archiver-Version: Plexus Archiver
        Built-By: Marslo_Jiao
        Created-By: Apache Maven 3.2.3
        Build-Jdk: 1.8.0_25
        Main-Class: com.juvenxu.mvnbook.helloworld.HelloWorld

### Scaffold in Maven
- Maven 3.x

          [13:05:17.08 C:\archetype]
          $ mvn archetype:generate
          ...
          Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): 502:
          Choose org.apache.maven.archetypes:maven-archetype-quickstart version:
          1: 1.0-alpha-1
          2: 1.0-alpha-2
          3: 1.0-alpha-3
          4: 1.0-alpha-4
          5: 1.0
          6: 1.1
          Choose a number: 6:
          Define value for property 'package':  com.juvenxu.mvnbook: : com.juvenxu.mvnbook.helloworld
          Confirm properties configuration:
          groupId: com.juvenxu.mvnbook
          artifactId: hello-world
          version: 1.0-SNAPSHOT
          package: com.juvenxu.mvnbook.helloworld
           Y: : Y
           ...

- Maven 2.x

          $ mvn org.apache.maven.plugins:maven-archetype-plugin:2.0-alpha-5:generate
