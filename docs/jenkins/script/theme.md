

> [!NOTE|label:references:]
> - [Themes for user interface](https://basilcrow.com/docs/user-handbook/stable-2.361/managing/ui-themes.html)
> - [User Experience](https://www.jenkins.io/sigs/ux/)
> - [`io.jenkins.plugins.thememanager.ThemeManagerSimplePageDecorator`](https://javadoc.jenkins.io/plugin/theme-manager/io/jenkins/plugins/thememanager/ThemeManagerSimplePageDecorator.html)
>   - `getThemeKey()`
> - [io.jenkins.plugins.thememanager.ThemeManagerFactory](https://javadoc.jenkins.io/plugin/theme-manager/io/jenkins/plugins/thememanager/ThemeManagerFactory.html)
>   - `getThemes()`
> - [io.jenkins.plugins.thememanager.ThemeManagerFactoryDescriptor](48;30;106;2040;339248;30;106;2040;3392https://javadoc.jenkins.io/plugin/theme-manager/io/jenkins/plugins/thememanager/ThemeManagerFactoryDescriptor.html)
>   - `getThemeId()`
>   - `getThemeKey()`

```groovy
import jenkins.model.*

// Check if Simple Theme Plugin is installed
def themeManager = Jenkins.instance.getExtensionList('org.codefirst.SimpleThemeDecorator')
println  "getCategory()                           : ${themeManager[0].getCategory()}"
println  "getClass()                              : ${themeManager[0].getClass()}"
println  "getConfigPage()                         : ${themeManager[0].getConfigPage()}"
println  "getCssRules()                           : ${themeManager[0].getCssRules()}"
println  "getCssUrl()                             : ${themeManager[0].getCssUrl()}"
println  "getCurrentDescriptorByNameUrl()         : ${themeManager[0].getCurrentDescriptorByNameUrl()}"
println  "getDescriptor()                         : ${themeManager[0].getDescriptor()}"
println  "getDescriptorFullUrl()                  : ${themeManager[0].getDescriptorFullUrl()}"
println  "getDescriptorUrl()                      : ${themeManager[0].getDescriptorUrl()}"
println  "getDisplayName()                        : ${themeManager[0].getDisplayName()}"
println  "getElements()                           : ${themeManager[0].getElements()}"
println  "getFaviconUrl()                         : ${themeManager[0].getFaviconUrl()}"
println  "getGlobalConfigPage()                   : ${themeManager[0].getGlobalConfigPage()}"
println  "getGlobalPropertyType()                 : ${themeManager[0].getGlobalPropertyType()}"
println  "getHeaderHtml()                         : ${themeManager[0].getHeaderHtml()}"
println  "getHelpFile()                           : ${themeManager[0].getHelpFile()}"
println  "getId()                                 : ${themeManager[0].getId()}"
println  "getJsUrl()                              : ${themeManager[0].getJsUrl()}"
println  "getJsonSafeClassName()                  : ${themeManager[0].getJsonSafeClassName()}"
println  "getKlass()                              : ${themeManager[0].getKlass()}"
println  "getRequiredGlobalConfigPagePermission() : ${themeManager[0].getRequiredGlobalConfigPagePermission()}"
println  "getT()                                  : ${themeManager[0].getT()}"
println  "getUrl()                                : ${themeManager[0].getUrl()}"
```

- console output
  ```
  getCategory()                           : jenkins.appearance.AppearanceCategory@45d6e6af
  getClass()                              : class org.codefirst.SimpleThemeDecorator
  getConfigPage()                         : config.jelly
  getCssRules()                           : null
  getCssUrl()                             : null
  getCurrentDescriptorByNameUrl()         :
  getDescriptor()                         : org.codefirst.SimpleThemeDecorator@58af505
  getDescriptorFullUrl()                  : /descriptorByName/org.codefirst.SimpleThemeDecorator
  getDescriptorUrl()                      : descriptorByName/org.codefirst.SimpleThemeDecorator
  getDisplayName()                        : SimpleThemeDecorator
  getElements()                           : []
  getFaviconUrl()                         : null
  getGlobalConfigPage()                   : /org/codefirst/SimpleThemeDecorator/global.groovy
  getGlobalPropertyType()                 : null
  getHeaderHtml()                         :
  getHelpFile()                           : null
  getId()                                 : org.codefirst.SimpleThemeDecorator
  getJsUrl()                              : null
  getJsonSafeClassName()                  : org-codefirst-SimpleThemeDecorator
  getKlass()                              : class org.codefirst.SimpleThemeDecorator
  getRequiredGlobalConfigPagePermission() : Permission[class hudson.model.Hudson,Administer]
  getT()                                  : class hudson.model.PageDecorator
  getUrl()                                : descriptor/org.codefirst.SimpleThemeDecorator
  ```

  ```groovy
  import jenkins.model.*

  def theme = null

  // Check if Simple Theme Plugin is installed
  def themeManager = Jenkins.instance.getExtensionList( 'org.codefirst.SimpleThemeDecorator' )
  if ( themeManager && themeManager.size() > 0 ) {
    theme = themeManager[0].getUrl()
    println("Current theme URL: ${theme}")
  } else {
    println("No theme plugin detected, using default Jenkins theme.")
  }

  // Example logic to infer Dark Theme
  if ( theme && theme.toLowerCase().contains("dark") ) {
    println("Jenkins is using a Dark Theme.")
  } else {
    println("Jenkins is not using a Dark Theme.")
  }
  ```

- [`io.jenkins.plugins.thememanager.ThemeManagerFactory`](https://javadoc.jenkins.io/plugin/theme-manager/io/jenkins/plugins/thememanager/ThemeManagerFactory.html)
  ```groovy
  import jenkins.model.*
  import hudson.PluginManager

  // Check if the Material Theme Plugin is installed
  def plugin = Jenkins.instance.pluginManager.getPlugin('material-theme')
  if (plugin) {
    println "Material Theme Plugin is installed: Version ${plugin.getVersion()}"

    // Inspect global settings for Material Theme
    def themeManager = Jenkins.instance.getExtensionList('io.jenkins.plugins.thememanager.ThemeManagerFactory')
    if (themeManager && themeManager.size() > 0) {
      def currentTheme = themeManager[0].getThemes().find { it.name.contains('Material') } // Find Material Theme
      if (currentTheme) {
        println "Currently active theme: ${currentTheme.name}"
      } else {
        println "No Material theme is currently active."
      }
    } else {
      println "Theme settings are not exposed via the API."
    }
  } else {
    println "Material Theme Plugin is not installed."
  }
  ```

## get

```groovy
import jenkins.model.Jenkins

Jenkins jenkins = Jenkins.get()
def themeDecorator = jenkins.getExtensionList(org.codefirst.SimpleThemeDecorator.class).first()
themeDecorator.metaClass.methods*.name.sort().unique()

// -- result --:
// [all, bindJSON, calcAutoCompleteSettings, calcFillSettings, configure, doHelp, equals, find, findByDescribableClassName, findById, getCategory, getCheckMethod, getCheckUrl, getClass, getConfigPage, getCssRules, getCssUrl, getCurrentDescriptorByNameUrl, getDescriptor, getDescriptorFullUrl, getDescriptorUrl, getDisplayName, getElements, getFaviconUrl, getGlobalConfigPage, getGlobalPropertyType, getHeaderHtml, getHelpFile, getId, getJsUrl, getJsonSafeClassName, getKlass, getPropertyType, getPropertyTypeOrDie, getRequiredGlobalConfigPagePermission, getStaticHelpUrl, getT, getUrl, hashCode, isInstance, isSubTypeOf, load, newInstance, newInstancesFromHeteroList, notify, notifyAll, save, setCssRules, setCssUrl, setElements, setFaviconUrl, setJsUrl, shouldInjectCss, toArray, toList, toMap, toString, wait]
```

```groovy
import jenkins.model.Jenkins

Jenkins jenkins = Jenkins.get()
def themeDecorator = jenkins.getExtensionList(org.codefirst.SimpleThemeDecorator.class).first()
themeDecorator.getDescriptor().metaClass.methods*.name.sort().unique()

// -- result --:
// [all, bindJSON, calcAutoCompleteSettings, calcFillSettings, configure, doHelp, equals, find, findByDescribableClassName, findById, getCategory, getCheckMethod, getCheckUrl, getClass, getConfigPage, getCssRules, getCssUrl, getCurrentDescriptorByNameUrl, getDescriptor, getDescriptorFullUrl, getDescriptorUrl, getDisplayName, getElements, getFaviconUrl, getGlobalConfigPage, getGlobalPropertyType, getHeaderHtml, getHelpFile, getId, getJsUrl, getJsonSafeClassName, getKlass, getPropertyType, getPropertyTypeOrDie, getRequiredGlobalConfigPagePermission, getStaticHelpUrl, getT, getUrl, hashCode, isInstance, isSubTypeOf, load, newInstance, newInstancesFromHeteroList, notify, notifyAll, save, setCssRules, setCssUrl, setElements, setFaviconUrl, setJsUrl, shouldInjectCss, toArray, toList, toMap, toString, wait]
```

## set theme

- [Possible to create seed job without repo? #66](https://github.com/jenkinsci/kubernetes-operator/issues/66)
  ```groovy
  // 1-configure-theme.groovy

  import jenkins.*
  import jenkins.model.*
  import hudson.*
  import hudson.model.*
  import org.jenkinsci.plugins.simpletheme.ThemeElement
  import org.jenkinsci.plugins.simpletheme.CssTextThemeElement
  import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement

  Jenkins jenkins = Jenkins.getInstance()

  def decorator = Jenkins.instance.getDescriptorByType(org.codefirst.SimpleThemeDecorator.class)

  List<ThemeElement> configElements = new ArrayList<>();
  configElements.add(new CssTextThemeElement("DEFAULT"));
  configElements.add(new CssUrlThemeElement("https://cdn.rawgit.com/afonsof/jenkins-material-theme/gh-pages/dist/material-light-green.css"));
  decorator.setElements(configElements);
  decorator.save();

  jenkins.save()
  ```

  ```groovy
  // 2-configure-global-lib.groovy

  import jenkins.model.Jenkins
  import jenkins.plugins.git.GitSCMSource
  import jenkins.plugins.git.traits.BranchDiscoveryTrait
  import org.jenkinsci.plugins.workflow.libs.GlobalLibraries
  import org.jenkinsci.plugins.workflow.libs.LibraryConfiguration
  import org.jenkinsci.plugins.workflow.libs.SCMSourceRetriever

  List libraries = [] as ArrayList

  def remote = 'https://github.com/evry-ace/jenkins-ace-library'
  def credentialsId = null

  name = 'ace'
  defaultVersion = '_VERSION_'

  if (remote != null) {

      def scm = new GitSCMSource(remote)
      if (credentialsId != null) {
          scm.credentialsId = credentialsId
      }

      scm.traits = [new BranchDiscoveryTrait()]
      def retriever = new SCMSourceRetriever(scm)

      def library = new LibraryConfiguration(name, retriever)
      library.defaultVersion = defaultVersion
      library.implicit = false
      library.allowVersionOverride = true
      library.includeInChangesets = false

      libraries << library

      def global_settings = Jenkins.instance.getExtensionList(GlobalLibraries.class)[0]
      global_settings.libraries = libraries
      global_settings.save()
      println 'Configured Pipeline Global Shared Libraries:\n    ' + global_settings.libraries.collect { it.name }.join('\n    ')
  }
  ```

- [How to update URL of theme CSS in jenkins via groovy?](https://stackoverflow.com/a/53338114/2940319)
  ```groovy
  import jenkins.model.Jenkins;
  import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement;

  Jenkins jenkins = Jenkins.get()

  def themeDecorator = jenkins.getExtensionList(org.codefirst.SimpleThemeDecorator.class).first()

  themeDecorator.setElements([
    new CssUrlThemeElement('https://some.dummy/url.css')
  ])

  jenkins.save()
  ```
