package com.ofline_marketplace.ofline_app

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.app/share"

    // List of known payment app package names
    private val paymentAppPackageNames = listOf(
    "com.google.android.apps.nbu.paisa.user",  // Google Pay (GPay)
    "net.one97.paytm",                         // Paytm
    "com.phonepe.app",                         // PhonePe
    // "in.org.npci.upiapp",                      // BHIM UPI
    // "com.sbi.upi",                             // SBI Pay
    // "com.icicibank.upi",                       // ICICI Bank UPI
    // "com.freecharge.android",                  // FreeCharge
    // "com.mobikwik_new",                        // MobiKwik
              // Amazon Pay
    "in.amazon.mShop.android.shopping",             //Amazon
    "com.samsung.android.spay.payment",
    // "com.samsung.android.spaymini",     // Samsung Wallet (Samsung Pay)
    // "com.apple.wallet"                         // Apple Wallet (Apple Pay)
    // Add other known payment app package names here
)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.action == Intent.ACTION_SEND && intent.type?.startsWith("image/") == true) {
            val imageUri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM)
            println("--------------------UUUURRRIIII")
            println(imageUri);
            // println(intent.EXTRA_STREAM);
             println("--------------------UUUURRRIIII")
              println("Intent extras keys:")
        intent.extras?.keySet()?.forEach { key ->
            println("$key: ${intent.extras?.get(key)}")
        }
            if (imageUri != null && isPaymentAppUri(imageUri)) {
                val filePath = getFilePathFromUri(this, imageUri)
                filePath?.let { path ->
                    val sourceAppPackageName = imageUri.authority // or use some method to get the app package name if necessary
                    println("Received image file path: $path")
                    println("Source application package name: $sourceAppPackageName")
                    MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL).invokeMethod("receiveImage", mapOf(
                        "filePath" to path,
                        "sourceApp" to sourceAppPackageName
                    ))
                }
            } else {
                println("The URI is not from a known payment app or the URI is null.")
            }
        }
    }

    private fun isPaymentAppUri(uri: Uri): Boolean {
        // Check if the URI's authority contains any known payment app package name
        return paymentAppPackageNames.any { uri.authority?.contains(it) == true }
    }

    private fun getFilePathFromUri(context: Context, uri: Uri): String? {
        val documentFile = DocumentFile.fromSingleUri(context, uri) ?: return null
        val fileName = documentFile.name ?: return null
        val tempFile = File(context.cacheDir, fileName)
        context.contentResolver.openInputStream(uri)?.use { inputStream ->
            tempFile.outputStream().use { outputStream ->
                inputStream.copyTo(outputStream)
            }
        }
        return tempFile.absolutePath
    }
}
