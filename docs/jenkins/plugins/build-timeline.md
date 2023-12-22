<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [build](#build)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## build
- environment
  ```bash
  $ sudo dnf install npm maven
  ```

- downlaod code
  ```bash
  $ git clone git@github.com:tophat/jenkins-timeline-plugin.git
  $ cd jenkins-timeline-plugin
  ```

- build
  ```bash
  $ make build

  # verify
  $ ls target/*.hpi
  target/pipeline-timeline.hpi

  $ md5sum target/pipeline-timeline.hpi
  c5a0777425216fce644b5b374f878044  target/pipeline-timeline.hpi
  ```

  <!--sec data-title="logs" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ make build
  mvn install -e dependency:resolve-plugins dependency:go-offline
  [INFO] Error stacktraces are turned on.
  [INFO] Scanning for projects...
  [WARNING] The POM for org.jenkins-ci.tools:maven-hpi-plugin:jar:2.2 is missing, no dependency information available
  [WARNING] Failed to build parent project for io.jenkins.plugins:pipeline-timeline:hpi:1.0.1-SNAPSHOT
  [INFO]
  [INFO] ----------------< io.jenkins.plugins:pipeline-timeline >----------------
  [INFO] Building Pipeline timeline 1.0.1-SNAPSHOT
  [INFO] --------------------------------[ hpi ]---------------------------------
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:validate (default-validate) @ pipeline-timeline ---
  [INFO]
  [INFO] --- maven-enforcer-plugin:3.0.0-M1:display-info (display-info) @ pipeline-timeline ---
  [INFO] Maven Version: 3.5.4
  [INFO] JDK Version: 1.8.0_242 normalized as: 1.8.0-242
  [INFO] OS Info: Arch: amd64 Family: unix Name: linux Version: 4.18.0-147.8.1.el8_1.x86_64
  [INFO]
  [INFO] --- maven-enforcer-plugin:3.0.0-M1:enforce (display-info) @ pipeline-timeline ---
  [INFO] Ignoring requireUpperBoundDeps in com.google.guava:guava
  [INFO] Ignoring requireUpperBoundDeps in com.google.code.findbugs:jsr305
  [INFO]
  [INFO] --- frontend-maven-plugin:1.6:install-node-and-npm (install node and npm) @ pipeline-timeline ---
  [INFO] Installing node version v8.0.0
  [INFO] Unpacking /home/marslo/.m2/repository/com/github/eirslett/node/8.0.0/node-8.0.0-linux-x64.tar.gz into /home/marslo/jenkins-timeline-plugin/mvn_node/node/tmp
  [INFO] Copying node binary from /home/marslo/jenkins-timeline-plugin/mvn_node/node/tmp/node-v8.0.0-linux-x64/bin/node to /home/marslo/jenkins-timeline-plugin/mvn_node/node/node
  [INFO] Installed node locally.
  [INFO] Installing npm version 6.5.0
  [INFO] Unpacking /home/marslo/.m2/repository/com/github/eirslett/npm/6.5.0/npm-6.5.0.tar.gz into /home/marslo/jenkins-timeline-plugin/mvn_node/node/node_modules
  [INFO] Installed npm locally.
  [INFO]
  [INFO] --- frontend-maven-plugin:1.6:npm (npm install) @ pipeline-timeline ---
  [INFO] Running 'npm install' in /home/marslo/jenkins-timeline-plugin/webapp_src
  [INFO]
  [INFO] > styled-components@4.1.1 postinstall /home/marslo/jenkins-timeline-plugin/webapp_src/node_modules/styled-components
  [INFO] > node ./scripts/postinstall.js || exit 0
  [INFO]
  [INFO] Use styled-components at work? Consider supporting our development efforts at https://opencollective.com/styled-components
  [WARNING] npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.4 (node_modules/fsevents):
  [WARNING] npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
  [ERROR]
  [INFO] added 2370 packages from 1444 contributors and audited 2439 packages in 29.174s
  [INFO] found 865 vulnerabilities (36 low, 319 moderate, 402 high, 108 critical)
  [INFO]   run `npm audit fix` to fix them, or `npm audit` for details
  [INFO]
  [INFO] --- maven-localizer-plugin:1.24:generate (default) @ pipeline-timeline ---
  [INFO]
  [INFO] >>> maven-javadoc-plugin:2.10.4:javadoc (default) > generate-sources @ pipeline-timeline >>>
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:validate (default-validate) @ pipeline-timeline ---
  [INFO]
  [INFO] --- maven-enforcer-plugin:3.0.0-M1:display-info (display-info) @ pipeline-timeline ---
  [INFO] Maven Version: 3.5.4
  [INFO] JDK Version: 1.8.0_242 normalized as: 1.8.0-242
  [INFO] OS Info: Arch: amd64 Family: unix Name: linux Version: 4.18.0-147.8.1.el8_1.x86_64
  [INFO]
  [INFO] --- maven-enforcer-plugin:3.0.0-M1:enforce (display-info) @ pipeline-timeline ---
  [INFO] Ignoring requireUpperBoundDeps in com.google.guava:guava
  [INFO] Ignoring requireUpperBoundDeps in com.google.code.findbugs:jsr305
  [INFO]
  [INFO] --- frontend-maven-plugin:1.6:install-node-and-npm (install node and npm) @ pipeline-timeline ---
  [INFO] Node v8.0.0 is already installed.
  [INFO] NPM 6.5.0 is already installed.
  [INFO]
  [INFO] --- frontend-maven-plugin:1.6:npm (npm install) @ pipeline-timeline ---
  [INFO] Running 'npm install' in /home/marslo/jenkins-timeline-plugin/webapp_src
  [WARNING] npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.4 (node_modules/fsevents):
  [WARNING] npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
  [ERROR]
  [INFO] audited 2439 packages in 15.975s
  [INFO] found 865 vulnerabilities (36 low, 319 moderate, 402 high, 108 critical)
  [INFO]   run `npm audit fix` to fix them, or `npm audit` for details
  [INFO]
  [INFO] --- maven-localizer-plugin:1.24:generate (default) @ pipeline-timeline ---
  [INFO]
  [INFO] <<< maven-javadoc-plugin:2.10.4:javadoc (default) < generate-sources @ pipeline-timeline <<<
  [INFO]
  [INFO]
  [INFO] --- maven-javadoc-plugin:2.10.4:javadoc (default) @ pipeline-timeline ---
  [INFO]
  [INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ pipeline-timeline ---
  [INFO] Using 'UTF-8' encoding to copy filtered resources.
  [INFO] Copying 2 resources
  [INFO]
  [INFO] --- maven-compiler-plugin:3.6.1:compile (default-compile) @ pipeline-timeline ---
  [INFO] Changes detected - recompiling the module!
  [INFO] Compiling 2 source files to /home/marslo/jenkins-timeline-plugin/target/classes
  [INFO] /home/marslo/jenkins-timeline-plugin/src/main/java/io/jenkins/plugins/jenkinstl/MenuItemFactory.java: /home/marslo/jenkins-timeline-plugin/src/main/java/io/jenkins/plugins/jenkinstl/MenuItemFactory.java uses or overrides a deprecated API.
  [INFO] /home/marslo/jenkins-timeline-plugin/src/main/java/io/jenkins/plugins/jenkinstl/MenuItemFactory.java: Recompile with -Xlint:deprecation for details.
  [INFO]
  [INFO] --- frontend-maven-plugin:1.6:npm (Building webapp component) @ pipeline-timeline ---
  [INFO] Running 'npm run build-to-plugin' in /home/marslo/jenkins-timeline-plugin/webapp_src
  [INFO]
  [INFO] > jenkinstl@0.1.0 build-to-plugin /home/marslo/jenkins-timeline-plugin/webapp_src
  [INFO] > PUBLIC_URL=/plugin/pipeline-timeline npm run build && cp -r build/* ../src/main/webapp
  [INFO]
  [INFO]
  [INFO] > jenkinstl@0.1.0 build /home/marslo/jenkins-timeline-plugin/webapp_src
  [INFO] > react-scripts build
  [INFO]
  [INFO] Creating an optimized production build...
  [INFO] Compiled successfully.
  [INFO]
  [INFO] File sizes after gzip:
  [INFO]
  [INFO]   75.21 KB  build/static/js/1.eec3780e.chunk.js
  [INFO]   6.64 KB   build/static/js/main.467140c3.chunk.js
  [INFO]   775 B     build/static/js/runtime~main.f0028a2f.js
  [INFO]
  [INFO] The project was built assuming it is hosted at /plugin/pipeline-timeline/.
  [INFO] You can control this with the homepage field in your package.json.
  [INFO]
  [INFO] The build folder is ready to be deployed.
  [INFO]
  [INFO] Find out more about deployment here:
  [INFO]
  [INFO]   http://bit.ly/CRA-deploy
  [INFO]
  [INFO]
  [INFO] --- access-modifier-checker:1.8:enforce (default-enforce) @ pipeline-timeline ---
  [INFO]
  [INFO] --- animal-sniffer-maven-plugin:1.15:check (check) @ pipeline-timeline ---
  [INFO] Resolved signature org.codehaus.mojo.signature:java17 version as 1.0 from dependencyManagement
  [INFO] Checking unresolved references to org.codehaus.mojo.signature:java17:1.0
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:insert-test (default-insert-test) @ pipeline-timeline ---
  [INFO]
  [INFO] --- gmaven-plugin:1.5-jenkins-3:generateTestStubs (test-in-groovy) @ pipeline-timeline ---
  [INFO] No sources found for Java stub generation
  [INFO]
  [INFO] --- maven-resources-plugin:3.0.2:testResources (default-testResources) @ pipeline-timeline ---
  [INFO] Using 'UTF-8' encoding to copy filtered resources.
  [INFO] skip non existing resourceDirectory /home/marslo/jenkins-timeline-plugin/src/test/resources
  [INFO]
  [INFO] --- maven-compiler-plugin:3.6.1:testCompile (default-testCompile) @ pipeline-timeline ---
  [INFO] Changes detected - recompiling the module!
  [INFO] Compiling 3 source files to /home/marslo/jenkins-timeline-plugin/target/test-classes
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:test-hpl (default-test-hpl) @ pipeline-timeline ---
  [INFO] Generating /home/marslo/jenkins-timeline-plugin/target/test-classes/the.hpl
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:resolve-test-dependencies (default-resolve-test-dependencies) @ pipeline-timeline ---
  [INFO]
  [INFO] --- gmaven-plugin:1.5-jenkins-3:testCompile (test-in-groovy) @ pipeline-timeline ---
  [INFO] No sources found to compile
  [INFO]
  [INFO] --- maven-surefire-plugin:2.20:test (default-test) @ pipeline-timeline ---
  [INFO] Surefire report directory: /home/marslo/jenkins-timeline-plugin/target/surefire-reports
  [INFO]
  [INFO] -------------------------------------------------------
  [INFO]  T E S T S
  [INFO] -------------------------------------------------------
  [INFO] Running InjectedTest
  [INFO] Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 5.14 s - in InjectedTest
  [INFO] Running io.jenkins.plugins.jenkinstl.MenuItemFactoryTest
  [INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.467 s - in io.jenkins.plugins.jenkinstl.MenuItemFactoryTest
  [INFO] Running io.jenkins.plugins.jenkinstl.MenuItemTest
  [INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0 s - in io.jenkins.plugins.jenkinstl.MenuItemTest
  [INFO]
  [INFO] Results:
  [INFO]
  [INFO] Tests run: 7, Failures: 0, Errors: 0, Skipped: 0
  [INFO]
  [INFO]
  [INFO] --- maven-license-plugin:1.7:process (default) @ pipeline-timeline ---
  [INFO] Generated /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline/WEB-INF/licenses.xml
  [INFO]
  [INFO] --- maven-hpi-plugin:2.2:hpi (default-hpi) @ pipeline-timeline ---
  [INFO] Generating /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline/META-INF/MANIFEST.MF
  [INFO] Checking for attached .jar artifact ...
  [INFO] Generating jar /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.jar
  [INFO] Building jar: /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.jar
  [INFO] Exploding webapp...
  [INFO] Copy webapp webResources to /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline
  [INFO] Assembling webapp pipeline-timeline in /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline
  [INFO] Generating hpi /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.hpi
  [INFO] Building jar: /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.hpi
  [INFO]
  [INFO] --- maven-jar-plugin:3.0.2:test-jar (maybe-test-jar) @ pipeline-timeline ---
  [INFO] Skipping packaging of the test-jar
  [INFO]
  [INFO] >>> findbugs-maven-plugin:3.0.5:check (findbugs) > :findbugs @ pipeline-timeline >>>
  [INFO]
  [INFO] --- findbugs-maven-plugin:3.0.5:findbugs (findbugs) @ pipeline-timeline ---
  [INFO] Fork Value is true
  [INFO] Done FindBugs Analysis....
  [INFO]
  [INFO] <<< findbugs-maven-plugin:3.0.5:check (findbugs) < :findbugs @ pipeline-timeline <<<
  [INFO]
  [INFO]
  [INFO] --- findbugs-maven-plugin:3.0.5:check (findbugs) @ pipeline-timeline ---
  [INFO] BugInstance size is 0
  [INFO] Error size is 0
  [INFO] No errors/warnings found
  [INFO]
  [INFO] --- maven-install-plugin:2.5.2:install (default-install) @ pipeline-timeline ---
  [INFO] Installing /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.hpi to /home/marslo/.m2/repository/io/jenkins/plugins/pipeline-timeline/1.0.1-SNAPSHOT/pipeline-timeline-1.0.1-SNAPSHOT.hpi
  [INFO] Installing /home/marslo/jenkins-timeline-plugin/pom.xml to /home/marslo/.m2/repository/io/jenkins/plugins/pipeline-timeline/1.0.1-SNAPSHOT/pipeline-timeline-1.0.1-SNAPSHOT.pom
  [INFO] Installing /home/marslo/jenkins-timeline-plugin/target/pipeline-timeline.jar to /home/marslo/.m2/repository/io/jenkins/plugins/pipeline-timeline/1.0.1-SNAPSHOT/pipeline-timeline-1.0.1-SNAPSHOT.jar
  [INFO]
  [INFO] --- maven-dependency-plugin:3.0.0:resolve-plugins (default-cli) @ pipeline-timeline ---
  [INFO] Plugin Resolved: maven-jar-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-jar-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO] Plugin Resolved: maven-stapler-plugin-1.17.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.23.jar
  [INFO]     Plugin Dependency Resolved: txw2-20090102.jar
  [INFO]     Plugin Dependency Resolved: json-lib-2.1-jdk15.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.4.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.2.jar
  [INFO]     Plugin Dependency Resolved: taglib-xml-writer-1.5.jar
  [INFO]     Plugin Dependency Resolved: commons-fileupload-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: jellydoc-annotations-1.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-discovery-0.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.jar
  [INFO]     Plugin Dependency Resolved: tiger-types-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-api-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.7.jar
  [INFO]     Plugin Dependency Resolved: guava-r06.jar
  [INFO]     Plugin Dependency Resolved: maven-stapler-plugin-1.17.jar
  [INFO]     Plugin Dependency Resolved: ezmorph-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: stapler-1.100.jar
  [INFO]     Plugin Dependency Resolved: junit-4.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-dep-1.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: textile-j-2.2.864.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-jellydoc-plugin-1.5.jar
  [INFO] Plugin Resolved: maven-site-plugin-3.6.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.4.jar
  [INFO]     Plugin Dependency Resolved: parboiled-java-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: pegdown-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-site-plugin-3.6.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-analysis-4.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-util-6.1.25.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-util-4.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: xmlunit-1.5.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-integration-tools-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-markdown-1.7.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-exec-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-skin-model-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: parboiled-core-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.7.jar
  [INFO]     Plugin Dependency Resolved: jetty-6.1.25.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.3.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: asm-4.1.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.0.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.7.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-4.1.jar
  [INFO]     Plugin Dependency Resolved: servlet-api-2.5-20081211.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-10.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.7.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.0.1.jar
  [INFO]     Plugin Dependency Resolved: servlet-api-2.5.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-30.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.7.jar
  [INFO] Plugin Resolved: maven-release-plugin-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-integrity-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-providers-standard-1.9.4.pom
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-tfs-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: mksapi-jar-4.10.9049.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-bazaar-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-clearcase-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-vss-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.0.0.v20140518.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-accurev-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-gitexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-hg-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-jazz-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-starteam-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-api-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-svn-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: cvsclient-20060125.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-manager-plexus-1.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvsjava-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-perforce-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: groovy-all-1.7.6.jar
  [INFO]     Plugin Dependency Resolved: ganymed-ssh2-build210.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-release-plugin-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-synergy-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.0.0.v20140518.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1-beta-8.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvs-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-git-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-release-api-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-svnexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-release-manager-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvsexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-javadoc-plugin-2.10.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.4.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.4.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: log4j-1.2.14.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.2.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.3.04.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.2.2.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.3.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.3.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.9.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-javadoc-plugin-2.10.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.12.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-clean-plugin-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.4.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: maven-clean-plugin-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO] Plugin Resolved: maven-surefire-plugin-2.20.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: surefire-booter-2.20.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: surefire-api-2.20.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-annotations-3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-surefire-common-2.20.jar
  [INFO]     Plugin Dependency Resolved: surefire-logger-api-2.20.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: junit-4.12.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.5.15.jar
  [INFO]     Plugin Dependency Resolved: maven-surefire-plugin-2.20.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.1.jar
  [INFO] Plugin Resolved: maven-compiler-plugin-3.6.1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: qdox-2.0-M5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-6.0_ALPHA.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-manager-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-javac-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-incremental-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: maven-compiler-plugin-3.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-api-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO] Plugin Resolved: maven-resources-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.24.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-resources-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: maven-filtering-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO] Plugin Resolved: maven-localizer-plugin-1.24.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.24.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: annotation-indexer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-annotation-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-localizer-plugin-1.24.jar
  [INFO]     Plugin Dependency Resolved: codemodel-2.6.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.1.jar
  [INFO] Plugin Resolved: maven-deploy-plugin-2.8.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-deploy-plugin-2.8.2.jar
  [INFO] Plugin Resolved: gmaven-plugin-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: xbean-reflect-3.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.jar
  [INFO]     Plugin Dependency Resolved: file-management-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: google-collections-1.0.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-loader-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.10.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.4.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gshell-io-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: gmaven-feature-support-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-plugin-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.12.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: log4j-1.2.12.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-api-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-io-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-support-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-feature-api-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: gossip-1.2.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.0-alpha-10.jar
  [INFO] Plugin Resolved: frontend-maven-plugin-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: jsr305-1.3.9.jar
  [INFO]     Plugin Dependency Resolved: aopalliance-1.0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.2.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-3.1.0-no_aop.jar
  [INFO]     Plugin Dependency Resolved: frontend-maven-plugin-1.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: guava-10.0.1.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.inject-0.0.0.M2a.jar
  [INFO]     Plugin Dependency Resolved: commons-exec-1.3.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.4.3.jar
  [INFO]     Plugin Dependency Resolved: cdi-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: frontend-plugin-core-1.6.jar
  [INFO]     Plugin Dependency Resolved: javax.inject-1.jar
  [INFO]     Plugin Dependency Resolved: jsr250-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: asm-3.3.1.jar
  [INFO]     Plugin Dependency Resolved: jackson-mapper-asl-1.9.13.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.9.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.7.5.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.2.jar
  [INFO]     Plugin Dependency Resolved: jackson-core-asl-1.9.13.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-annotations-3.2.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.5.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.22.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.5.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.plexus-0.0.0.M2a.jar
  [INFO] Plugin Resolved: animal-sniffer-maven-plugin-1.15.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: java-boot-classpath-detector-1.15.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: animal-sniffer-1.15.jar
  [INFO]     Plugin Dependency Resolved: asm-all-5.0.3.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: junit-4.11.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: animal-sniffer-maven-plugin-1.15.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-license-plugin-1.7.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.23.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-8.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.jar
  [INFO]     Plugin Dependency Resolved: jline-0.9.94.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: asm-analysis-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.7.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.jar
  [INFO]     Plugin Dependency Resolved: asm-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: ant-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.0.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: asm-util-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-license-plugin-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.0.jar
  [INFO] Plugin Resolved: findbugs-maven-plugin-3.0.5.jar
  [INFO]     Plugin Dependency Resolved: jcip-annotations-1.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: groovy-xml-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.inject-0.3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-skin-model-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: ant-junit-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: cdi-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: asm-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-spi-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-compat-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: jsr250-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.5.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-util-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: guava-20.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: asm-commons-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: groovy-ant-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-impl-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.5.1.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.3.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.7.jar
  [INFO]     Plugin Dependency Resolved: ant-1.9.9.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: javax.inject-1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-2.12.jar
  [INFO]     Plugin Dependency Resolved: asm-debug-all-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-groovydoc-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-provider-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.6.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: findbugs-maven-plugin-3.0.5.jar
  [INFO]     Plugin Dependency Resolved: maven-builder-support-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: findbugs-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: google-collections-1.0.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: plexus-resources-1.1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jFormatString-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.7.jar
  [INFO]     Plugin Dependency Resolved: xmlunit-1.5.jar
  [INFO]     Plugin Dependency Resolved: xbean-reflect-3.7.jar
  [INFO]     Plugin Dependency Resolved: AppleJavaExtensions-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: bcel-findbugs-6.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.24.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.4.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: groovy-templates-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.0.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.7.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.plexus-0.3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-api-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.9.9.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.2.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: ant-antlr-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-doxia-tools-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.7.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.7.jar
  [INFO] Plugin Resolved: maven-enforcer-plugin-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-compat-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: bsh-2.0b4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: junit-4.11.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-tree-2.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-enforcer-plugin-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.5.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: enforcer-rules-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: enforcer-api-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO] Plugin Resolved: maven-eclipse-plugin-2.10.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.20.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: plexus-resources-1.0-alpha-7.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-jline-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-2.6.3.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.2.jar
  [INFO]     Plugin Dependency Resolved: resources-3.3.0-v20070604.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-eclipse-plugin-2.10.jar
  [INFO]     Plugin Dependency Resolved: jline-0.9.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-osgi-0.2.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: bndlib-0.0.145.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-hpi-plugin-2.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-2.1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-plugin-2.8.jar
  [INFO]     Plugin Dependency Resolved: json-lib-2.1-jdk15.jar
  [INFO]     Plugin Dependency Resolved: maven-doxia-tools-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: ecj-4.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: websocket-api-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: stapler-groovy-1.237.jar
  [INFO]     Plugin Dependency Resolved: jetty-jaas-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-tools-api-3.4.jar
  [INFO]     Plugin Dependency Resolved: asm-3.3.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-webapp-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-fileupload-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: websocket-client-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: javax.websocket-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.5.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: apache-el-8.5.9.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: xom-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: jellydoc-annotations-1.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-5.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.0.jar
  [INFO]     Plugin Dependency Resolved: javax-websocket-server-impl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.0.jar
  [INFO]     Plugin Dependency Resolved: ant-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.6.2.jar
  [INFO]     Plugin Dependency Resolved: jetty-jndi-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: websocket-server-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-plus-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: groovy-all-1.8.3.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.7.jar
  [INFO]     Plugin Dependency Resolved: guava-r06.jar
  [INFO]     Plugin Dependency Resolved: ezmorph-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.11.jar
  [INFO]     Plugin Dependency Resolved: stapler-1.100.jar
  [INFO]     Plugin Dependency Resolved: maven-compiler-plugin-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: xalan-2.6.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: javax.servlet-api-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-io-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.0.6.jar
  [INFO]     Plugin Dependency Resolved: xmlParserAPIs-2.6.2.jar
  [INFO]     Plugin Dependency Resolved: jetty-security-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: textile-j-2.2.864.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-api-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-manager-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: websocket-servlet-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.0.jar
  [INFO]     Plugin Dependency Resolved: taglibs-standard-impl-1.2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-stapler-plugin-1.16.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: commons-jexl-1.1-jenkins-20111212.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-servlet-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-jellydoc-plugin-1.5.jar
  [INFO]     Plugin Dependency Resolved: txw2-20090102.jar
  [INFO]     Plugin Dependency Resolved: apache-jsp-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: taglibs-standard-spec-1.2.5.jar
  [INFO]     Plugin Dependency Resolved: jetty-quickstart-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: stapler-jelly-1.237.jar
  [INFO]     Plugin Dependency Resolved: jetty-server-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: file-management-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-2.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0.jar
  [INFO]     Plugin Dependency Resolved: sezpoz-1.9.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-http-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: apache-jsp-8.5.9.1.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.0.11.jar
  [INFO]     Plugin Dependency Resolved: asm-commons-5.1.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.2.jar
  [INFO]     Plugin Dependency Resolved: icu4j-52.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: taglib-xml-writer-1.5.jar
  [INFO]     Plugin Dependency Resolved: jetty-io-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-hpi-plugin-2.2.jar
  [INFO]     Plugin Dependency Resolved: commons-jelly-1.1-jenkins-20120928.jar
  [INFO]     Plugin Dependency Resolved: jetty-xml-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-tree-2.1.jar
  [INFO]     Plugin Dependency Resolved: websocket-common-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-discovery-0.4.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1-jenkins-4.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.0.jar
  [INFO]     Plugin Dependency Resolved: tiger-types-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-client-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: javax-websocket-client-impl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: jetty-util-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: jetty-annotations-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: jetty-schemas-3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.9.4-no_aop.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: javax.annotation-api-1.2.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.11.jar
  [INFO]     Plugin Dependency Resolved: jetty-maven-plugin-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: apache-jstl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: javax.transaction-api-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-jmx-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.2.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-javac-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.9.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: asm-5.1.jar
  [INFO]     Plugin Dependency Resolved: codemodel-2.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-analyzer-1.4.jar
  [INFO] Plugin Resolved: maven-install-plugin-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-install-plugin-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO] Plugin Resolved: access-modifier-checker-1.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-checker-1.8.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.1.jar
  [INFO]     Plugin Dependency Resolved: annotation-indexer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.5.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: asm-debug-all-5.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-annotation-1.8.jar
  [INFO]
  [INFO] >>> maven-dependency-plugin:3.0.0:go-offline (default-cli) > :resolve-plugins @ pipeline-timeline >>>
  [INFO]
  [INFO] --- maven-dependency-plugin:3.0.0:resolve-plugins (resolve-plugins) @ pipeline-timeline ---
  [INFO] Plugin Resolved: maven-jar-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-jar-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO] Plugin Resolved: maven-stapler-plugin-1.17.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.23.jar
  [INFO]     Plugin Dependency Resolved: txw2-20090102.jar
  [INFO]     Plugin Dependency Resolved: json-lib-2.1-jdk15.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.4.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.2.jar
  [INFO]     Plugin Dependency Resolved: taglib-xml-writer-1.5.jar
  [INFO]     Plugin Dependency Resolved: commons-fileupload-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: jellydoc-annotations-1.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-discovery-0.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.jar
  [INFO]     Plugin Dependency Resolved: tiger-types-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-api-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.7.jar
  [INFO]     Plugin Dependency Resolved: guava-r06.jar
  [INFO]     Plugin Dependency Resolved: maven-stapler-plugin-1.17.jar
  [INFO]     Plugin Dependency Resolved: ezmorph-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: stapler-1.100.jar
  [INFO]     Plugin Dependency Resolved: junit-4.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-dep-1.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: textile-j-2.2.864.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-jellydoc-plugin-1.5.jar
  [INFO] Plugin Resolved: maven-site-plugin-3.6.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.4.jar
  [INFO]     Plugin Dependency Resolved: parboiled-java-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: pegdown-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-site-plugin-3.6.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-analysis-4.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-util-6.1.25.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-util-4.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: xmlunit-1.5.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-integration-tools-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-markdown-1.7.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-exec-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-skin-model-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: parboiled-core-1.1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.7.jar
  [INFO]     Plugin Dependency Resolved: jetty-6.1.25.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.3.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: asm-4.1.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.0.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.7.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-4.1.jar
  [INFO]     Plugin Dependency Resolved: servlet-api-2.5-20081211.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-10.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.7.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.0.1.jar
  [INFO]     Plugin Dependency Resolved: servlet-api-2.5.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-30.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.7.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.7.jar
  [INFO] Plugin Resolved: maven-release-plugin-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-integrity-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-providers-standard-1.9.4.pom
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-tfs-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: mksapi-jar-4.10.9049.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-bazaar-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-clearcase-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-vss-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.0.0.v20140518.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-accurev-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-gitexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-hg-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-jazz-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-starteam-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-api-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-svn-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: cvsclient-20060125.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-manager-plexus-1.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvsjava-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-perforce-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: groovy-all-1.7.6.jar
  [INFO]     Plugin Dependency Resolved: ganymed-ssh2-build210.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-release-plugin-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-synergy-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.0.0.v20140518.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1-beta-8.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvs-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-git-commons-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-release-api-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-svnexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-release-manager-2.5.3.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-scm-provider-cvsexe-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-javadoc-plugin-2.10.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.4.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.4.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: xz-1.5.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.4.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: log4j-1.2.14.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.2.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.3.04.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO]     Plugin Dependency Resolved: snappy-0.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.11.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.2.2.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.4.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.7.1.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-3.3.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.3.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.9.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.2.jar
  [INFO]     Plugin Dependency Resolved: maven-javadoc-plugin-2.10.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.12.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-clean-plugin-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.4.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: maven-clean-plugin-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO] Plugin Resolved: maven-surefire-plugin-2.20.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: surefire-booter-2.20.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: surefire-api-2.20.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-annotations-3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-surefire-common-2.20.jar
  [INFO]     Plugin Dependency Resolved: surefire-logger-api-2.20.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: junit-4.12.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.5.15.jar
  [INFO]     Plugin Dependency Resolved: maven-surefire-plugin-2.20.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.1.jar
  [INFO] Plugin Resolved: maven-compiler-plugin-3.6.1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: qdox-2.0-M5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: asm-6.0_ALPHA.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-manager-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-javac-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-incremental-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: maven-compiler-plugin-3.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-api-2.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO] Plugin Resolved: maven-resources-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.24.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-resources-plugin-3.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: maven-filtering-3.1.1.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO] Plugin Resolved: maven-localizer-plugin-1.24.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.24.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: ant-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: annotation-indexer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-annotation-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: maven-localizer-plugin-1.24.jar
  [INFO]     Plugin Dependency Resolved: codemodel-2.6.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.1.jar
  [INFO] Plugin Resolved: maven-deploy-plugin-2.8.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-deploy-plugin-2.8.2.jar
  [INFO] Plugin Resolved: gmaven-plugin-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: xbean-reflect-3.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.jar
  [INFO]     Plugin Dependency Resolved: file-management-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: google-collections-1.0.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-loader-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.10.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.4.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gshell-io-2.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.4.jar
  [INFO]     Plugin Dependency Resolved: gmaven-feature-support-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-plugin-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.12.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: log4j-1.2.12.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-api-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-io-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: gmaven-runtime-support-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: gmaven-feature-api-1.5-jenkins-3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: gossip-1.2.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.10.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.0-alpha-10.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-6.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.0-alpha-10.jar
  [INFO] Plugin Resolved: frontend-maven-plugin-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: jsr305-1.3.9.jar
  [INFO]     Plugin Dependency Resolved: aopalliance-1.0.jar
  [INFO]     Plugin Dependency Resolved: xz-1.2.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-3.1.0-no_aop.jar
  [INFO]     Plugin Dependency Resolved: frontend-maven-plugin-1.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: guava-10.0.1.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.inject-0.0.0.M2a.jar
  [INFO]     Plugin Dependency Resolved: commons-exec-1.3.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.4.3.jar
  [INFO]     Plugin Dependency Resolved: cdi-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.5.5.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: frontend-plugin-core-1.6.jar
  [INFO]     Plugin Dependency Resolved: javax.inject-1.jar
  [INFO]     Plugin Dependency Resolved: jsr250-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: asm-3.3.1.jar
  [INFO]     Plugin Dependency Resolved: jackson-mapper-asl-1.9.13.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.9.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.7.5.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.2.jar
  [INFO]     Plugin Dependency Resolved: jackson-core-asl-1.9.13.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-annotations-3.2.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.5.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.22.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.5.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.plexus-0.0.0.M2a.jar
  [INFO] Plugin Resolved: animal-sniffer-maven-plugin-1.15.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-toolchain-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: java-boot-classpath-detector-1.15.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: animal-sniffer-1.15.jar
  [INFO]     Plugin Dependency Resolved: asm-all-5.0.3.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: junit-4.11.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: animal-sniffer-maven-plugin-1.15.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.4.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-license-plugin-1.7.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.23.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-8.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.0.jar
  [INFO]     Plugin Dependency Resolved: jline-0.9.94.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: asm-analysis-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.7.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.jar
  [INFO]     Plugin Dependency Resolved: asm-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: ant-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.2.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.0.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: asm-util-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-license-plugin-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.0.jar
  [INFO] Plugin Resolved: findbugs-maven-plugin-3.0.5.jar
  [INFO]     Plugin Dependency Resolved: jcip-annotations-1.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: groovy-xml-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.inject-0.3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-skin-model-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-tools-2.0.jar
  [INFO]     Plugin Dependency Resolved: struts-tiles-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: ant-junit-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-3.0.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: cdi-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: sslext-1.2-0.jar
  [INFO]     Plugin Dependency Resolved: asm-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-spi-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-compat-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: jsr250-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.5.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-util-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: guava-20.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: asm-commons-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: groovy-ant-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-impl-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.5.1.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.3.jar
  [INFO]     Plugin Dependency Resolved: struts-core-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: antlr-2.7.2.jar
  [INFO]     Plugin Dependency Resolved: commons-chain-1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.7.jar
  [INFO]     Plugin Dependency Resolved: ant-1.9.9.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: javax.inject-1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-2.12.jar
  [INFO]     Plugin Dependency Resolved: asm-debug-all-5.0.2.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: groovy-groovydoc-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-provider-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.6.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: findbugs-maven-plugin-3.0.5.jar
  [INFO]     Plugin Dependency Resolved: maven-builder-support-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: findbugs-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: struts-taglib-1.3.8.jar
  [INFO]     Plugin Dependency Resolved: google-collections-1.0.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: plexus-resources-1.1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jFormatString-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.7.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.7.jar
  [INFO]     Plugin Dependency Resolved: xmlunit-1.5.jar
  [INFO]     Plugin Dependency Resolved: xbean-reflect-3.7.jar
  [INFO]     Plugin Dependency Resolved: AppleJavaExtensions-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.5.0.jar
  [INFO]     Plugin Dependency Resolved: bcel-findbugs-6.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-build-api-0.0.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.24.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.8.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.4.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: groovy-templates-2.4.12.jar
  [INFO]     Plugin Dependency Resolved: httpclient-4.0.2.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.7.jar
  [INFO]     Plugin Dependency Resolved: org.eclipse.sisu.plexus-0.3.3.jar
  [INFO]     Plugin Dependency Resolved: maven-resolver-api-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: ant-launcher-1.9.9.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.2.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: ant-antlr-1.9.4.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-doxia-tools-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.7.jar
  [INFO]     Plugin Dependency Resolved: httpcore-4.0.1.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.7.jar
  [INFO] Plugin Resolved: maven-enforcer-plugin-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-compat-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.7.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-model-3.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-1.4.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.14.jar
  [INFO]     Plugin Dependency Resolved: bsh-2.0b4.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-3.0.jar
  [INFO]     Plugin Dependency Resolved: junit-4.11.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-tree-2.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.2.3.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-3.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-enforcer-plugin-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.7.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: hamcrest-core-1.3.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-lang3-3.5.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.24.jar
  [INFO]     Plugin Dependency Resolved: enforcer-rules-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.1.7-noaop.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: enforcer-api-3.0.0-M1.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.7.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO] Plugin Resolved: maven-eclipse-plugin-2.10.jar
  [INFO]     Plugin Dependency Resolved: maven-error-diagnostics-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-api-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: commons-compress-1.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-webdav-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-external-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.2.jar
  [INFO]     Plugin Dependency Resolved: jcl-over-slf4j-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-monitor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-file-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: xercesMinimal-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.20.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.5.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-lightweight-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: plexus-resources-1.0-alpha-7.jar
  [INFO]     Plugin Dependency Resolved: jsch-0.1.38.jar
  [INFO]     Plugin Dependency Resolved: jackrabbit-jcr-commons-1.5.0.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-jline-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-common-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-webdav-jackrabbit-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: commons-httpclient-3.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-cli-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-nop-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-parameter-documenter-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-2.6.3.jar
  [INFO]     Plugin Dependency Resolved: commons-io-2.2.jar
  [INFO]     Plugin Dependency Resolved: resources-3.3.0-v20070604.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-eclipse-plugin-2.10.jar
  [INFO]     Plugin Dependency Resolved: jline-0.9.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-ssh-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-osgi-0.2.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-logging-api-1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: slf4j-jdk14-1.5.6.jar
  [INFO]     Plugin Dependency Resolved: bndlib-0.0.145.jar
  [INFO]     Plugin Dependency Resolved: wagon-http-shared-1.0-beta-6.jar
  [INFO] Plugin Resolved: maven-hpi-plugin-2.2.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: aether-util-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-plexus-2.1.1.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-plugin-2.8.jar
  [INFO]     Plugin Dependency Resolved: json-lib-2.1-jdk15.jar
  [INFO]     Plugin Dependency Resolved: maven-doxia-tools-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: ecj-4.4.2.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-api-3.0.jar
  [INFO]     Plugin Dependency Resolved: websocket-api-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: stapler-groovy-1.237.jar
  [INFO]     Plugin Dependency Resolved: jetty-jaas-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-tools-api-3.4.jar
  [INFO]     Plugin Dependency Resolved: asm-3.3.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-webapp-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-fileupload-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-builder-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: websocket-client-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: javax.websocket-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: commons-io-1.3.1.jar
  [INFO]     Plugin Dependency Resolved: maven-core-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-reporting-impl-2.0.5.jar
  [INFO]     Plugin Dependency Resolved: aether-util-0.9.0.M2.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: apache-el-8.5.9.1.jar
  [INFO]     Plugin Dependency Resolved: jaxen-1.1.1.jar
  [INFO]     Plugin Dependency Resolved: xom-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-cipher-1.4.jar
  [INFO]     Plugin Dependency Resolved: jellydoc-annotations-1.5.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: asm-tree-5.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-fml-1.0.jar
  [INFO]     Plugin Dependency Resolved: javax-websocket-server-impl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xdoc-1.0.jar
  [INFO]     Plugin Dependency Resolved: ant-1.6.5.jar
  [INFO]     Plugin Dependency Resolved: xercesImpl-2.6.2.jar
  [INFO]     Plugin Dependency Resolved: jetty-jndi-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: websocket-server-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-lang-2.6.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: jetty-plus-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: groovy-all-1.8.3.jar
  [INFO]     Plugin Dependency Resolved: localizer-1.7.jar
  [INFO]     Plugin Dependency Resolved: guava-r06.jar
  [INFO]     Plugin Dependency Resolved: ezmorph-1.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-descriptor-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: aether-impl-1.11.jar
  [INFO]     Plugin Dependency Resolved: stapler-1.100.jar
  [INFO]     Plugin Dependency Resolved: maven-compiler-plugin-2.0.2.jar
  [INFO]     Plugin Dependency Resolved: xalan-2.6.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.2.jar
  [INFO]     Plugin Dependency Resolved: javax.servlet-api-3.1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-io-1.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-io-2.0.6.jar
  [INFO]     Plugin Dependency Resolved: xmlParserAPIs-2.6.2.jar
  [INFO]     Plugin Dependency Resolved: jetty-security-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: textile-j-2.2.864.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-archiver-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-aether-provider-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-api-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-manager-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: websocket-servlet-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: doxia-decoration-model-1.0.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-apt-1.0.jar
  [INFO]     Plugin Dependency Resolved: taglibs-standard-impl-1.2.5.jar
  [INFO]     Plugin Dependency Resolved: maven-stapler-plugin-1.16.jar
  [INFO]     Plugin Dependency Resolved: oro-2.0.8.jar
  [INFO]     Plugin Dependency Resolved: commons-jexl-1.1-jenkins-20111212.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-servlet-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-digester-1.6.jar
  [INFO]     Plugin Dependency Resolved: maven-jellydoc-plugin-1.5.jar
  [INFO]     Plugin Dependency Resolved: txw2-20090102.jar
  [INFO]     Plugin Dependency Resolved: apache-jsp-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: taglibs-standard-spec-1.2.5.jar
  [INFO]     Plugin Dependency Resolved: jetty-quickstart-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: plexus-velocity-1.1.7.jar
  [INFO]     Plugin Dependency Resolved: stapler-jelly-1.237.jar
  [INFO]     Plugin Dependency Resolved: jetty-server-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: file-management-1.2.1.jar
  [INFO]     Plugin Dependency Resolved: sisu-inject-bean-2.1.1.jar
  [INFO]     Plugin Dependency Resolved: doxia-core-1.0.jar
  [INFO]     Plugin Dependency Resolved: sezpoz-1.9.jar
  [INFO]     Plugin Dependency Resolved: xml-apis-1.0.b2.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-http-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-model-builder-3.0.3.jar
  [INFO]     Plugin Dependency Resolved: plexus-component-annotations-1.6.jar
  [INFO]     Plugin Dependency Resolved: apache-jsp-8.5.9.1.jar
  [INFO]     Plugin Dependency Resolved: maven-invoker-2.0.11.jar
  [INFO]     Plugin Dependency Resolved: asm-commons-5.1.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.2.jar
  [INFO]     Plugin Dependency Resolved: icu4j-52.1.jar
  [INFO]     Plugin Dependency Resolved: velocity-1.5.jar
  [INFO]     Plugin Dependency Resolved: taglib-xml-writer-1.5.jar
  [INFO]     Plugin Dependency Resolved: jetty-io-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-hpi-plugin-2.2.jar
  [INFO]     Plugin Dependency Resolved: commons-jelly-1.1-jenkins-20120928.jar
  [INFO]     Plugin Dependency Resolved: jetty-xml-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: aether-api-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-tree-2.1.jar
  [INFO]     Plugin Dependency Resolved: websocket-common-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-discovery-0.4.jar
  [INFO]     Plugin Dependency Resolved: dom4j-1.6.1-jenkins-4.jar
  [INFO]     Plugin Dependency Resolved: jdom-1.0.jar
  [INFO]     Plugin Dependency Resolved: tiger-types-1.1.jar
  [INFO]     Plugin Dependency Resolved: commons-beanutils-1.7.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-client-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: commons-logging-1.0.4.jar
  [INFO]     Plugin Dependency Resolved: commons-collections-3.2.1.jar
  [INFO]     Plugin Dependency Resolved: javax-websocket-client-impl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: nekohtml-1.9.6.2.jar
  [INFO]     Plugin Dependency Resolved: plexus-archiver-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: plexus-classworlds-2.4.jar
  [INFO]     Plugin Dependency Resolved: jetty-util-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: jetty-annotations-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: jetty-schemas-3.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-interactivity-api-1.0-alpha-4.jar
  [INFO]     Plugin Dependency Resolved: sisu-guice-2.9.4-no_aop.jar
  [INFO]     Plugin Dependency Resolved: doxia-site-renderer-1.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-i18n-1.0-beta-7.jar
  [INFO]     Plugin Dependency Resolved: javax.annotation-api-1.2.jar
  [INFO]     Plugin Dependency Resolved: aether-spi-1.11.jar
  [INFO]     Plugin Dependency Resolved: jetty-maven-plugin-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: plexus-sec-dispatcher-1.3.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: apache-jstl-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: qdox-1.6.1.jar
  [INFO]     Plugin Dependency Resolved: javax.transaction-api-1.2.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.0.jar
  [INFO]     Plugin Dependency Resolved: jetty-jmx-9.4.5.v20170502.jar
  [INFO]     Plugin Dependency Resolved: commons-validator-1.2.0.jar
  [INFO]     Plugin Dependency Resolved: plexus-compiler-javac-1.5.3.jar
  [INFO]     Plugin Dependency Resolved: maven-common-artifact-filters-1.4.jar
  [INFO]     Plugin Dependency Resolved: doxia-sink-api-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.9.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: asm-5.1.jar
  [INFO]     Plugin Dependency Resolved: codemodel-2.6.jar
  [INFO]     Plugin Dependency Resolved: doxia-module-xhtml-1.0.jar
  [INFO]     Plugin Dependency Resolved: maven-dependency-analyzer-1.4.jar
  [INFO] Plugin Resolved: maven-install-plugin-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: jsr305-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-beta-6.jar
  [INFO]     Plugin Dependency Resolved: maven-shared-utils-0.4.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-settings-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-install-plugin-2.5.2.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-3.0.15.jar
  [INFO]     Plugin Dependency Resolved: plexus-interpolation-1.11.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-registry-2.2.1.jar
  [INFO]     Plugin Dependency Resolved: commons-codec-1.6.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9-stable-1.jar
  [INFO]     Plugin Dependency Resolved: backport-util-concurrent-3.1.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.2.1.jar
  [INFO] Plugin Resolved: access-modifier-checker-1.8.jar
  [INFO]     Plugin Dependency Resolved: plexus-container-default-1.0-alpha-9.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-manager-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-checker-1.8.jar
  [INFO]     Plugin Dependency Resolved: maven-project-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-plugin-api-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: metainf-services-1.1.jar
  [INFO]     Plugin Dependency Resolved: annotation-indexer-1.4.jar
  [INFO]     Plugin Dependency Resolved: maven-model-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: maven-repository-metadata-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: classworlds-1.1-alpha-2.jar
  [INFO]     Plugin Dependency Resolved: junit-3.8.1.jar
  [INFO]     Plugin Dependency Resolved: plexus-utils-1.0.5.jar
  [INFO]     Plugin Dependency Resolved: maven-artifact-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: asm-debug-all-5.0.3.jar
  [INFO]     Plugin Dependency Resolved: maven-profile-2.0.1.jar
  [INFO]     Plugin Dependency Resolved: wagon-provider-api-1.0-alpha-5.jar
  [INFO]     Plugin Dependency Resolved: access-modifier-annotation-1.8.jar
  [INFO]
  [INFO] <<< maven-dependency-plugin:3.0.0:go-offline (default-cli) < :resolve-plugins @ pipeline-timeline <<<
  [INFO]
  [INFO]
  [INFO] --- maven-dependency-plugin:3.0.0:go-offline (default-cli) @ pipeline-timeline ---
  [INFO] Resolved: workflow-job-2.0.jar
  [INFO] Resolved: workflow-support-1.15.jar
  [INFO] Resolved: workflow-api-1.15.jar
  [INFO] Resolved: durable-task-1.5.jar
  [INFO] Resolved: script-security-1.16.jar
  [INFO] Resolved: groovy-sandbox-1.10.jar
  [INFO] Resolved: jboss-marshalling-river-1.4.9.Final.jar
  [INFO] Resolved: jboss-marshalling-1.4.9.Final.jar
  [INFO] Resolved: workflow-step-api-2.1.jar
  [INFO] Resolved: structs-1.1.jar
  [INFO] Resolved: annotations-3.0.0.jar
  [INFO] Resolved: jcip-annotations-1.0.jar
  [INFO] Resolved: animal-sniffer-annotations-1.14.jar
  [INFO] Resolved: javax.servlet-api-3.1.0.jar
  [INFO] Resolved: jenkins-core-2.7.3.jar
  [INFO] Resolved: icon-set-1.0.5.jar
  [INFO] Resolved: remoting-2.60.jar
  [INFO] Resolved: constant-pool-scanner-1.2.jar
  [INFO] Resolved: cli-2.7.3.jar
  [INFO] Resolved: version-number-1.1.jar
  [INFO] Resolved: crypto-util-1.1.jar
  [INFO] Resolved: jtidy-4aug2000r7-dev-hudson-1.jar
  [INFO] Resolved: guice-4.0-beta.jar
  [INFO] Resolved: javax.inject-1.jar
  [INFO] Resolved: aopalliance-1.0.jar
  [INFO] Resolved: jna-posix-1.0.3-jenkins-1.jar
  [INFO] Resolved: jnr-posix-3.0.1.jar
  [INFO] Resolved: jnr-ffi-1.0.7.jar
  [INFO] Resolved: jffi-1.2.7.jar
  [INFO] Resolved: jffi-1.2.7-native.jar
  [INFO] Resolved: asm-4.0.jar
  [INFO] Resolved: asm-commons-4.0.jar
  [INFO] Resolved: asm-analysis-4.0.jar
  [INFO] Resolved: asm-tree-4.0.jar
  [INFO] Resolved: asm-util-4.0.jar
  [INFO] Resolved: jnr-x86asm-1.0.2.jar
  [INFO] Resolved: jnr-constants-0.8.5.jar
  [INFO] Resolved: trilead-putty-extension-1.2.jar
  [INFO] Resolved: trilead-ssh2-build217-jenkins-8.jar
  [INFO] Resolved: stapler-groovy-1.243.jar
  [INFO] Resolved: stapler-jelly-1.243.jar
  [INFO] Resolved: commons-jelly-1.1-jenkins-20120928.jar
  [INFO] Resolved: dom4j-1.6.1-jenkins-4.jar
  [INFO] Resolved: stapler-jrebel-1.243.jar
  [INFO] Resolved: stapler-1.243.jar
  [INFO] Resolved: javax.annotation-api-1.2.jar
  [INFO] Resolved: commons-discovery-0.4.jar
  [INFO] Resolved: tiger-types-2.2.jar
  [INFO] Resolved: windows-package-checker-1.2.jar
  [INFO] Resolved: stapler-adjunct-zeroclipboard-1.3.5-1.jar
  [INFO] Resolved: stapler-adjunct-timeline-1.4.jar
  [INFO] Resolved: stapler-adjunct-codemirror-1.3.jar
  [INFO] Resolved: bridge-method-annotation-1.13.jar
  [INFO] Resolved: json-lib-2.4-jenkins-2.jar
  [INFO] Resolved: commons-logging-1.2.jar
  [INFO] Resolved: ezmorph-1.0.6.jar
  [INFO] Resolved: commons-httpclient-3.1.jar
  [INFO] Resolved: args4j-2.0.31.jar
  [INFO] Resolved: annotation-indexer-1.11.jar
  [INFO] Resolved: bytecode-compatibility-transformer-1.8.jar
  [INFO] Resolved: asm5-5.0.1.jar
  [INFO] Resolved: task-reactor-1.4.jar
  [INFO] Resolved: localizer-1.23.jar
  [INFO] Resolved: antlr-2.7.6.jar
  [INFO] Resolved: xstream-1.4.7-jenkins-1.jar
  [INFO] Resolved: jfreechart-1.0.9.jar
  [INFO] Resolved: jcommon-1.0.12.jar
  [INFO] Resolved: ant-1.8.4.jar
  [INFO] Resolved: ant-launcher-1.8.4.jar
  [INFO] Resolved: commons-io-2.4.jar
  [INFO] Resolved: commons-lang-2.6.jar
  [INFO] Resolved: commons-digester-2.1.jar
  [INFO] Resolved: commons-beanutils-1.8.3.jar
  [INFO] Resolved: commons-compress-1.10.jar
  [INFO] Resolved: mail-1.4.4.jar
  [INFO] Resolved: activation-1.1.1-hudson-1.jar
  [INFO] Resolved: jaxen-1.1-beta-11.jar
  [INFO] Resolved: commons-jelly-tags-fmt-1.0.jar
  [INFO] Resolved: commons-jelly-tags-xml-1.1.jar
  [INFO] Resolved: commons-jelly-tags-define-1.0.1-hudson-20071021.jar
  [INFO] Resolved: commons-jexl-1.1-jenkins-20111212.jar
  [INFO] Resolved: acegi-security-1.0.7.jar
  [INFO] Resolved: spring-jdbc-1.2.9.jar
  [INFO] Resolved: spring-dao-1.2.9.jar
  [INFO] Resolved: oro-2.0.8.jar
  [INFO] Resolved: log4j-1.2.17.jar
  [INFO] Resolved: groovy-all-2.4.7.jar
  [INFO] Resolved: jline-2.12.jar
  [INFO] Resolved: jansi-1.11.jar
  [INFO] Resolved: spring-webmvc-2.5.6.SEC03.jar
  [INFO] Resolved: spring-beans-2.5.6.SEC03.jar
  [INFO] Resolved: spring-context-2.5.6.SEC03.jar
  [INFO] Resolved: spring-context-support-2.5.6.SEC03.jar
  [INFO] Resolved: spring-web-2.5.6.SEC03.jar
  [INFO] Resolved: spring-core-2.5.6.SEC03.jar
  [INFO] Resolved: spring-aop-2.5.6.SEC03.jar
  [INFO] Resolved: xpp3-1.1.4c.jar
  [INFO] Resolved: jstl-1.1.0.jar
  [INFO] Resolved: txw2-20110809.jar
  [INFO] Resolved: stax-api-1.0-2.jar
  [INFO] Resolved: relaxngDatatype-20020414.jar
  [INFO] Resolved: commons-collections-3.2.1.jar
  [INFO] Resolved: winp-1.22.jar
  [INFO] Resolved: memory-monitor-1.9.jar
  [INFO] Resolved: wstx-asl-3.2.9.jar
  [INFO] Resolved: stax-api-1.0.1.jar
  [INFO] Resolved: jmdns-3.4.0-jenkins-3.jar
  [INFO] Resolved: jna-4.2.1.jar
  [INFO] Resolved: akuma-1.10.jar
  [INFO] Resolved: libpam4j-1.8.jar
  [INFO] Resolved: libzfs-0.5.jar
  [INFO] Resolved: embedded_su4j-1.1.jar
  [INFO] Resolved: sezpoz-1.11.jar
  [INFO] Resolved: j-interop-2.0.6-kohsuke-1.jar
  [INFO] Resolved: j-interopdeps-2.0.6-kohsuke-1.jar
  [INFO] Resolved: jcifs-1.2.19.jar
  [INFO] Resolved: robust-http-client-1.2.jar
  [INFO] Resolved: symbol-annotation-1.1.jar
  [INFO] Resolved: commons-codec-1.8.jar
  [INFO] Resolved: access-modifier-annotation-1.4.jar
  [INFO] Resolved: commons-fileupload-1.3.1-jenkins-1.jar
  [INFO] Resolved: jbcrypt-0.3m.jar
  [INFO] Resolved: guava-11.0.1.jar
  [INFO] Resolved: jsr305-1.3.9.jar
  [INFO] Resolved: jzlib-1.1.3-kohsuke-1.jar
  [INFO] Resolved: jenkins-war-2.7.3.war
  [INFO] Resolved: instance-identity-1.5.1.jar
  [INFO] Resolved: bcpkix-jdk15on-1.54.jar
  [INFO] Resolved: bcprov-jdk15on-1.54.jar
  [INFO] Resolved: ssh-cli-auth-1.2.jar
  [INFO] Resolved: slave-installer-1.5.jar
  [INFO] Resolved: windows-slave-installer-1.6.jar
  [INFO] Resolved: launchd-slave-installer-1.2.jar
  [INFO] Resolved: upstart-slave-installer-1.1.jar
  [INFO] Resolved: systemd-slave-installer-1.1.jar
  [INFO] Resolved: sshd-1.6.jar
  [INFO] Resolved: sshd-core-0.8.0.jar
  [INFO] Resolved: mina-core-2.0.5.jar
  [INFO] Resolved: jquery-detached-1.2.1-core-assets.jar
  [INFO] Resolved: bootstrap-1.3.2-core-assets.jar
  [INFO] Resolved: jquery-detached-1.2.jar
  [INFO] Resolved: handlebars-1.1.1-core-assets.jar
  [INFO] Resolved: jenkins-test-harness-2.34.jar
  [INFO] Resolved: jetty-webapp-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-xml-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-util-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-servlet-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-security-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-server-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-http-9.4.5.v20170502.jar
  [INFO] Resolved: jetty-io-9.4.5.v20170502.jar
  [INFO] Resolved: hamcrest-library-1.3.jar
  [INFO] Resolved: jenkins-test-harness-htmlunit-2.18-1.jar
  [INFO] Resolved: xalan-2.7.2.jar
  [INFO] Resolved: serializer-2.7.2.jar
  [INFO] Resolved: commons-lang3-3.4.jar
  [INFO] Resolved: xercesImpl-2.11.0.jar
  [INFO] Resolved: xml-apis-1.4.01.jar
  [INFO] Resolved: nekohtml-1.9.22.jar
  [INFO] Resolved: cssparser-0.9.16.jar
  [INFO] Resolved: sac-1.3.jar
  [INFO] Resolved: websocket-client-9.2.12.v20150709.jar
  [INFO] Resolved: websocket-common-9.2.12.v20150709.jar
  [INFO] Resolved: websocket-api-9.2.12.v20150709.jar
  [INFO] Resolved: embedded-rhino-debugger-1.2.jar
  [INFO] Resolved: org-netbeans-insane-RELEASE72.jar
  [INFO] Resolved: findbugs-annotations-1.3.9-1.jar
  [INFO] Resolved: test-annotations-1.2.jar
  [INFO] Resolved: junit-4.12.jar
  [INFO] Resolved: hamcrest-core-1.3.jar
  [INFO] Resolved: slf4j-api-1.7.25.jar
  [INFO] Resolved: log4j-over-slf4j-1.7.25.jar
  [INFO] Resolved: jcl-over-slf4j-1.7.25.jar
  [INFO] Resolved: slf4j-jdk14-1.7.25.jar
  [INFO] ------------------------------------------------------------------------
  [INFO] BUILD SUCCESS
  [INFO] ------------------------------------------------------------------------
  [INFO] Total time: 01:19 min
  [INFO] Finished at: 2023-07-21T20:22:39-07:00
  [INFO] ------------------------------------------------------------------------
  ```
  <!--endsec-->
