<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [badge plugin](#badge-plugin)
  - [addBadge](#addbadge)
  - [addSummary](#addsummary)
- [symbols](#symbols)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [badge](https://plugins.jenkins.io/badge/)

## badge plugin

> [!TIP|label:references]
> - [#184 - Add a font-awesome example](https://github.com/jenkinsci/badge-plugin/pull/184)
> - [README.md](https://github.com/jenkinsci/badge-plugin/blob/55e3f5a9f4547e26262f4cb54757bc56a97ab272/README.md)
> - [Badge Steps](https://www.jenkins.io/doc/pipeline/steps/badge/#addbadge-add-badge)


### addBadge

```groovy
// regular badge
addBadge icon: 'symbol-regular/thumbs-up plugin-font-awesome-api', text: '<code>symbol-regular/thumbs-up plugin-font-awesome-api</code>'

// warning badge
addWarningBadge(text: 'Houston, we have a problem ...', link: 'https://youtu.be/2Q_ZzBGPdqE')

// error badge
addErrorBadge(text: 'Transmission failed!')
```

### addSummary

```groovy
addSummary icon: 'symbol-brands/git plugin-font-awesome-api', text: '<code>symbol-brands/git plugin-font-awesome-api</code>'
```

## symbols

> [!TIP|label:references:]
> - [* iMarslo: appearance](../appearance.md#badge)
