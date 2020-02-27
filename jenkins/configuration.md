<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Mailing format](#mailing-format)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Mailing format
- Show the logs after building
    - Format:
        <pre><code>${BUILD_LOG, maxLines, escapeHtml}
        maxLines: 250
        </code></pre>
    - For example:
        <pre><code>${BUILD_LOG, maxLines=8000, escapeHtml=true}
        </code></pre>


