<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [monitor](#monitor)
  - [monitor for controller](#monitor-for-controller)
  - [monitor for agents](#monitor-for-agents)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:get sizer dynamically]
> ```groovy
> Closure sizer = { long size ->
>   List units    = [ 'bytes', 'KB', 'MB', 'GB', 'TB', 'PB' ]
>   String result = bits > 0 ? "${bits.round(2)} bytes" : '0'
>   double bits   = size
>   units.eachWithIndex { unit, index ->
>     if ( bits < 1024 ) return
>     bits   = bits / 1024
>     result = "${bits.round(2)} ${units.get(index+1)}"
>   }
>   result
> }
> ```

## monitor

> [!NOTE|label:references:]
> - [Jenkins : Monitoring Scripts](https://wiki.jenkins.io/display/JENKINS/Monitoring+Scripts)
> - [Monitoring dashboard for Jenkins memory usage analysis.](https://medium.com/@maheshd7878/monitoring-dashboard-for-jenkins-memory-usage-analysis-31f4a70285b5)
> - [Documentation of JavaMelody](https://github.com/javamelody/javamelody/wiki/UserGuide)
> - [Class index](https://javadoc.io/doc/net.bull.javamelody/javamelody-core/1.68.1/index-all.html)
>   - [Class JavaInformations](https://javadoc.io/static/net.bull.javamelody/javamelody-core/1.68.1/net/bull/javamelody/internal/model/JavaInformations.html)
>   - [Class MemoryInformations](https://javadoc.io/static/net.bull.javamelody/javamelody-core/1.68.1/net/bull/javamelody/internal/model/MemoryInformations.html)

### monitor for controller

- memory
  ```groovy

  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  Closure sizer = { long size ->
    List units    = [ 'bytes', 'KB', 'MB', 'GB', 'TB', 'PB' ]
    String result = bits > 0 ? "${bits.round(2)} bytes" : '0'
    double bits   = size
    units.eachWithIndex { unit, index ->
      if ( bits < 1024 ) return
      bits   = bits / 1024
      result = "${bits.round(2)} ${units.get(index+1)}"
    }
    result
  }

  memory = new MemoryInformations()
  println """
             used memory : ${sizer(memory.usedMemory)}
              max memory : ${sizer(memory.maxMemory)}
           used perm gen : ${sizer(memory.usedPermGen)}
            max perm gen : ${sizer(memory.maxPermGen)}
           used non heap : ${sizer(memory.usedNonHeapMemory)}
    used physical memory : ${sizer(memory.usedPhysicalMemorySize)}
         used swap space : ${sizer(memory.usedSwapSpaceSize)}
  """
  ```

- http sessions
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  println SessionListener.getSessionCount() + " sessions:"
  sessions = SessionListener.getAllSessionsInformations()
  sessions.each { session ->
    println session
  }
  ```

- thread dumps
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  java = new JavaInformations(Parameters.getServletContext(), true)
  threads = java.getThreadInformationsList()
  println threads.size() + " threads (" + java.activeThreadCount + " http threads active):"
  threads.each { thread ->
    println "\n${thread}"
    thread.getStackTrace().each { s ->
      println "    " + s
    }
  }
  ```

- deadlock threads
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  java = new JavaInformations(Parameters.getServletContext(), true)
  threads = java.getThreadInformationsList()
  deadlocked = new java.util.ArrayList()
  for (thread in threads) {
    if (thread.deadlocked)
      deadlocked.add(thread)
  }
  println deadlocked.size() + " deadlocked threads / " + threads.size() + " threads (" + java.activeThreadCount + " http threads active)"
  deadlocked.each { thread ->
    println "\n${thread}"
    thread.getStackTrace().each { s ->
      println "    " + s
    }
  }
  ```

- JVM data
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  java = new JavaInformations( Parameters.getServletContext(), true )
  println """
                          sessions count : ${java.sessionCount}
               active HTTP threads count : ${java.activeThreadCount}
                           threads count : ${java.threadCount}
                     system load average : ${java.systemLoadAverage}
                         system cpu load : ${java.systemCpuLoad}
                    available processors : ${java.availableProcessors}
                                    host : ${java.host}
                                      os : ${java.os}
                            java version : ${java.javaVersion}
                             jvm version : ${java.jvmVersion}
                                     pid : ${java.pid}
                             server info : ${java.serverInfo}
                            context path : ${java.contextPath}
                              start date : ${java.startDate}
    free disk space in Jenkins directory : ${Math.round(java.freeDiskSpaceInTemp / 1024 / 1024)} Mb
  """
  ```

  - result
    ```groovy
                          sessions count : 10
               active HTTP threads count : 1
                           threads count : 551
                     system load average : 0.23
                         system cpu load : 0.21985650348135538
                    available processors : 72
                                    host : devops-jenkins-bf57ddfbc-26mjz@10.244.13.138
                                      os : Linux, 4.19.12-1.el7.elrepo.x86_64 , amd64/64
                            java version : OpenJDK Runtime Environment, 11.0.18+10
                             jvm version : OpenJDK 64-Bit Server VM, 11.0.18+10, mixed mode
                                     pid : 7
                             server info : jetty/10.0.13
                            context path :
                              start date : Wed May 10 23:45:43 PDT 2023
    free disk space in Jenkins directory : 1709602 Mb
    ```
- heap histogram ( dangerous )
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  classes = VirtualMachine.createHeapHistogram().getHeapHistogram()
  println "class    instances    bytes    source"
  println "====================================="
  classes.each { c ->
    println c.name + "    " + c.instancesCount + "    " + c.bytes + "    " + c.source
  }
  ```

- heap dump ( dangerous )
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  if (System.getProperty("java.vendor").contains("IBM")) {
    Action.HEAP_DUMP.ibmHeapDump()
    println I18N.getString("heap_dump_genere_ibm")
  } else {
    heapDumpPath = Action.HEAP_DUMP.heapDump().getPath()
    println I18N.getFormattedString("heap_dump_genere", heapDumpPath)
  }
  ```

- MBean attribute value
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  exampleAttribute = "java.lang:type=OperatingSystem.ProcessCpuTime"
  println exampleAttribute + " = " + MBeans.getConvertedAttributes(exampleAttribute)
  ```

- stats of builds and build steps having mean time greater than severe threshold

  > [!NOTE|label:by default:]
  > By default, severe threshold = 2 x stddev of all durations and warning threshold = 1 x stddev

  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  buildCounter = CounterRunListener.getBuildCounter()
  aggreg = new CounterRequestAggregation(buildCounter)
  aggreg.getRequests().findAll{ request ->
    request.getMean() >= aggreg.getSevereThreshold() ||
    request.getCpuTimeMean() >= aggreg.getSevereThreshold()
  }.each { request ->
    println """
      ${request.getName()} :
                         hits = ${request.getHits()}
                         mean = ${request.getMean()}
                          max = ${request.getMaximum()}
                       stddev = ${request.getStandardDeviation()}
                  cpuTimeMean = ${request.getCpuTimeMean()}
        systemErrorPercentage = ${request.getSystemErrorPercentage()}
    """
  }
  ```

- GC
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  before = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()
  System.gc()
  after = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()

  println I18N.getFormattedString( "ramasse_miette_execute", Math.round((before - after) / 1024) )
  ```

- alerts
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  Closure sizer = { long size ->
    List units    = [ 'bytes', 'KB', 'MB', 'GB', 'TB', 'PB' ]
    double bits   = size
    String result = bits > 0 ? "${bits.round(2)} bytes" : '0'
    units.eachWithIndex { unit, index ->
      if ( bits < 1024 ) return
      bits   = bits / 1024
      result = "${bits.round(2)} ${units.get(index+1)}"
    }
    result
  }

  java = new JavaInformations(Parameters.getServletContext(), true)
  memory = java.memoryInformations

  println """
                             used memory = ${sizer(memory.usedMemory)}
               active HTTP threads count = ${java.activeThreadCount}
                     system load average = ${java.systemLoadAverage}
    free disk space in Jenkins directory = ${sizer(java.freeDiskSpaceInTemp)}
  """

  threads = java.getThreadInformationsList()
  deadlocked = new java.util.ArrayList()
  threads.each { thread ->
    if ( thread.deadlocked ) deadlocked.add(thread)
  }
  println deadlocked.size() + " deadlocked threads / " + threads.size() + " threads"
  deadlocked.each { thread ->
    println """
      ${thread} :
        ${thread.getStackTrace().collect { it }.join('\n' + ' '*10)}
    """
  }

  if (java.systemLoadAverage > 50                    ) throw new Exception( "Alert for Jenkins: systemLoadAverage is " + java.systemLoadAverage )
  if (java.activeThreadCount > 100                   ) throw new Exception( "Alert for Jenkins: activeThreadCount is " + java.activeThreadCount )
  if (deadlocked.size() > 0                          ) throw new Exception( "Alert for Jenkins: " + deadlocked.size( ) + " deadlocked threads"  )
  if (java.freeDiskSpaceInTemp / 1024 / 1024 < 10000 ) throw new Exception( "Alert for Jenkins: only " + Math.round(java.freeDiskSpaceInTemp / 1024 / 1024 ) + " Mb free disk space left"                                  )
  ```

### monitor for agents
- jvm data, memory data, deadlocked threads
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  Closure sizer = { long size ->
    List units    = [ 'bytes', 'KB', 'MB', 'GB', 'TB', 'PB' ]
    String result = bits > 0 ? "${bits.round(2)} bytes" : '0'
    double bits   = size
    units.eachWithIndex { unit, index ->
      if ( bits < 1024 ) return
      bits   = bits / 1024
      result = "${bits.round(2)} ${units.get(index+1)}"
    }
    result
  }

  // null for all nodes, not null for a particular node
  String nodeName   = null
  Map mapByNodeName = new RemoteCallHelper(nodeName).collectJavaInformationsListByName()

  mapByNodeName.keySet().each { node ->
    java = mapByNodeName.get(node)
    println """
      Node : ${node} :
                   sessions count : ${java.sessionCount}
        active HTTP threads count : ${java.activeThreadCount}
                    threads count : ${java.threadCount}
              system load average : ${java.systemLoadAverage}
                  system cpu load : ${java.systemCpuLoad}
             available processors : ${java.availableProcessors}
                             host : ${java.host}
                               os : ${java.os}
                     java version : ${java.javaVersion}
                      jvm version : ${java.jvmVersion}
                              pid : ${java.pid}
                      server info : ${java.serverInfo}
                     context path : ${java.contextPath}
                       start date : ${java.startDate}
    """

    memory = java.memoryInformations
    println """
                      used memory : ${sizer(memory.usedMemory)}
                       max memory : ${sizer(memory.maxMemory)}
                    used perm gen : ${sizer(memory.usedPermGen)}
                     max perm gen : ${sizer(memory.maxPermGen)}
                    used non heap : ${sizer(memory.usedNonHeapMemory)}
             used physical memory : ${sizer(memory.usedPhysicalMemorySize)}
                  used swap space : ${sizer(memory.usedSwapSpaceSize)}
    """

    threads = java.getThreadInformationsList()
    List deadlocked = threads.findAll{ it.deadlocked }
    println """
                           thread : ${deadlocked.size()} deadlocked threads / ${threads.size()} threads ( ${java.activeThreadCount} threads active )
    """
    deadlocked.collectEntries { thread -> [ "${thread}" : ${thread.getStackTrace().collect{ t}} ] }
              .each { thread, s ->
                 println """
                   ${thread} :
                   ${s.join('\n' + ' '*20)}
                 """
              }
    println ' '*10 + '*'*60
  }
  ```

- aa
  ```groovy
  import net.bull.javamelody.*
  import net.bull.javamelody.internal.model.*
  import net.bull.javamelody.internal.common.*

  String exampleAttributes = "java.lang:type=OperatingSystem.ProcessCpuTime|java.lang:type=Memory.HeapMemoryUsage"
  // null for all nodes, not null for a particular node
  String nodeName = null
  List values = new RemoteCallHelper(nodeName).collectJmxValues(exampleAttributes)
  values.each { value ->
    println exampleAttributes + " = " + value
  }
  ```

