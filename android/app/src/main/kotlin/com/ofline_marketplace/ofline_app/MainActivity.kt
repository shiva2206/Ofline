package com.ofline_marketplace.ofline_app
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.DocumentsContract
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.app/share"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.action == Intent.ACTION_SEND) {
            if (intent.type?.startsWith("image/") == true) {
                val imageUri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM)
                imageUri?.let {
                    val filePath = getFilePathFromUri(this, it)
                    filePath?.let { path ->
                        Log.d("MainActivity", "Received image file path: $path")
                        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL).invokeMethod("receiveImage", path)
                    }
                }
            }
        }
    }

    private fun getFilePathFromUri(context: Context, uri: Uri): String? {
        // Use DocumentFile API for better compatibility
        val documentFile = DocumentFile.fromSingleUri(context, uri) ?: return null
        val fileName = documentFile.name ?: return null

        // Create a temp file in the cache directory
        val tempFile = File(context.cacheDir, fileName)
        context.contentResolver.openInputStream(uri)?.use { inputStream ->
            tempFile.outputStream().use { outputStream ->
                inputStream.copyTo(outputStream)
            }
        }
        return tempFile.absolutePath
    }
}
