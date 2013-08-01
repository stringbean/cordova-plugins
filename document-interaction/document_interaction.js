(function() {
    DocumentInteraction = {
        previewDocument: function(path, mime) {
            cordova.exec(function(winParam) {},
                function(error) {},
                "DocumentInteraction",
                "previewDocument",
                [path, mime]);
        }
    };

    if (!window.plugins) {
        window.plugins = {};
    }

    window.plugins.documentInteraction = DocumentInteraction;
})();