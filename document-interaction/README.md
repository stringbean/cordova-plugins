# Document Interaction for iOS

## Background

This plugin wraps the iOS `UIDocumentInteractionController` to preview documents.

## Usage

To show a document preview:
```javascript
window.plugins.documentInteraction.previewDocument(filePath, mimeType);
```

Arguments:

* `filePath` - file path to the file on the local system.
* `mimeType` - optional MIME type. If not specified then the plugin with make a best guess based on the file extension.
