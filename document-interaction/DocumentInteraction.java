package com.phonegap.plugins.documentinteraction;

import java.io.IOException;

import android.webkit.MimeTypeMap;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.net.Uri;

import org.apache.cordova.api.*;

public class DocumentInteraction extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
t        PluginResult.Status status = PluginResult.Status.OK;
        String result = "";
        PluginResult pluginResult;

        try {
            if (action.equals("previewDocument")) {
                openFile(args.getString(0));
            }
            else {
                status = PluginResult.Status.INVALID_ACTION;
            }
            pluginResult = new PluginResult(status, result);
            callbackContext.sendPluginResult(pluginResult);
            return true;
        } catch (JSONException e) {
            pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION);
            callbackContext.sendPluginResult(pluginResult);
            return false;
        } catch (IOException e) {
            pluginResult = new PluginResult(PluginResult.Status.IO_EXCEPTION);
            callbackContext.sendPluginResult(pluginResult);
            return false;
        } catch (Throwable t) {
            pluginResult = new PluginResult(PluginResult.Status.ERROR);
            callbackContext.sendPluginResult(pluginResult);
            LOG.e("DocumentInteraction", "previewDocument failed", t);
            return false;
        }
    }

    private void openFile(String url) throws IOException {
        Uri uri = Uri.parse(url);

        Intent intent = new Intent(Intent.ACTION_VIEW);

        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
        String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);

        intent.setDataAndType(uri, mimeType);

        this.cordova.getActivity().startActivity(intent);
    }

}
