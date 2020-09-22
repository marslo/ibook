def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()

// println "Jenkins Instance : " + Jenkins.getInstance().getComputer('').getHostName() + " - " + Jenkins.getInstance().getRootUrl()
println "Installed Plugins: "
println "=================="
plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
   println "${plugin.getShortName()}:${plugin.getVersion()} | ${plugin.getDisplayName()} "
}

println ""
println "Plugins Dependency tree (...: dependencies; +++: dependants) :"
println "======================="
plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
   println "${plugin.getShortName()}:${plugin.getVersion()} | ${plugin.getDisplayName()} "
   println "+++ ${plugin.getDependants()}"
   println "... ${plugin.getDependencies()}"
   println ''
}
