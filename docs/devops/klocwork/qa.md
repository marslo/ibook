<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [kwauth doesn't properly set HTTP/1.1 header](#kwauth-doesnt-properly-set-http11-header)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## [kwauth doesn't properly set HTTP/1.1 header](https://ssd-titania-fw-klocwork.marvell.com/documentation/help/en-us/concepts/kwlimitations.htm)

> [!TIP]
> Sometimes when the Klocwork Server IP address is associated with multiple host names or located behind a reverse proxy, kwauth does not properly resolve the FDQN of the Klocwork Server.
>
> Workaround: To resolve this problem, we added a conditional host resolution based on a parameter in a specified configuration file. If you set it to 'false', then you can specify FQDN for the URL of the remote server. To set host resolution to 'false', you need to create a configuration file on the client side with the following address:
> ```bash
> {client_tools_install_folder}\config\client_config.xml
> ```
> The file must have the following structure:
> ```bash
> <?xml version="1.0" encoding="UTF-8"?><params>   <host resolveHost="false" /></params>
> ```