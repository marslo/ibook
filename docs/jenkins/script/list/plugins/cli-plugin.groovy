// https://support.cloudbees.com/hc/en-us/articles/216351528-How-Do-I-Analyse-Plugins-and-Dependencies-for-an-Instance

def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
plugins.each {println "${it.getShortName()}: ${it.getVersion()}"}
