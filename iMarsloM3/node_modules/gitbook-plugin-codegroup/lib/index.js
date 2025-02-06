const codeBlocks = require('gfm-code-blocks');
const merge = require('lodash/merge');
const includes = require('lodash/includes');
const get = require('lodash/get');
const trim = require('lodash/trim');
const md5 = require('blueimp-md5');

const self = {};

self.parseBlock = (content) => {
    const parsedCodeBlocks = codeBlocks(content);
    return parsedCodeBlocks;
};

self.getHash = (str) => {
    return md5(str);
};

self.getTabContents = (tabs) => {
    const contents = tabs.map((tab) => {
        const content = tab.tabContent || '';
        return `<div>
        <h3 class="gbcg-tabname ${tab.tabId}">${tab.printTitle}</h3>
        ${content}
        </div>`
    });
    return contents.join('\n');
};

self.getTabSelectors = (tabs) => {
    const selectors = tabs.map((tab) => {
        return tab.tabSelector || '';
    });
    return selectors.join('\n');
};

self.parseDescriptor = (langName, opts = {}) => {
    if (includes(langName, opts.tabNameSeperator)) {
        const split = langName.split(opts.tabNameSeperator);
        return {
            langName: trim(get(split, '[0]', langName)),
            tabName: trim(get(split, '[1]', '')),
            printTitle: trim(get(split, '[2]', ''))
        }
    }
    return { langName };
};

self.getLangName = (lang, opts = {}) => {
    return self.parseDescriptor(lang, opts).langName;
};

self.getTabName = (lang, opts = {}) => {
    return self.parseDescriptor(lang, opts).tabName;
};

self.getPrintTitle = (lang, opts = {}) => {
    return self.parseDescriptor(lang, opts).printTitle;
};

module.exports = self;