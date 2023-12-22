<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [configure file](#configure-file)
- [Q&A](#qa)
  - [workaround for in-progress image float layer out](#workaround-for-in-progress-image-float-layer-out)
  - [`page-header` background color](#page-header-background-color)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## configure file
- `JENKINS_HOME/org.codefirst.SimpleThemeDecorator.xml`

## Q&A
### [workaround for in-progress image float layer out](https://github.com/afonsof/jenkins-material-theme/issues/183#issuecomment-806518351)
```css
svg[class*=anime] { visibility: collapse }
```

### `page-header` background color
```css
a.page-header__brand-link {
  background: #43a047 !important;
  color: white !important;
  font-size: large !important;
}
.page-header__brand-image {
    height: 3rem !important;
    width: 3rem !important;
}
```
