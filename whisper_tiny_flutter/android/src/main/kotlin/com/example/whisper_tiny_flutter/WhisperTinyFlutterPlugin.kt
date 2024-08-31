package com.example.whisper_tiny_flutter

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.example.whisper_tiny_flutter.asr.IRecorderListener
import com.example.whisper_tiny_flutter.asr.IWhisperListener
import com.example.whisper_tiny_flutter.asr.Recorder
import com.example.whisper_tiny_flutter.asr.Whisper
import com.example.whisper_tiny_flutter.utils.WaveUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


/** WhisperTinyFlutterPlugin */
class WhisperTinyFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware , EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private val mTAG = "Whisper"
  private var mWhisper: Whisper? = null
  private var mRecorder: Recorder? = null
  private var activity: Activity? = null
  private lateinit var context: Context
  private var eventSink: EventChannel.EventSink? = null


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "whisper_tiny_flutter")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "whisper_result_channel")
    eventChannel.setStreamHandler(this)
    Log.d("whisper","this is a onMethodCall message")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  @RequiresApi(Build.VERSION_CODES.M)
  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d("whisper","this is a onMethodCall message")
    when (call.method) {
      "startRecording" -> {
        startRecording(result)
        //result.success("Recording started")
      }

      "stopRecording" -> {
        stopRecording(result)
        //result.success("Recording stopped")
      }

      "startTranscription" -> {
        val filePath = call.argument<String>("filePath")
        if (filePath != null) {
          startTranscription(filePath)
          result.success("Transcription started")
        } else {
          result.error("INVALID_ARGUMENT", "File path is missing", null)
        }
      }

      "stopTranscription" -> {
        stopTranscription()
        result.success("Transcription stopped")
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  @RequiresApi(Build.VERSION_CODES.M)
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.v("init", "onAttachedToActivity")
    Log.d("init","onAttachedToActivity")
    activity = binding.activity;
    mWhisper = Whisper(activity)
    mRecorder = Recorder(activity)
    checkRecordPermission()
    val extensionsToCopy = arrayOf("pcm", "bin", "wav", "tflite")
    copyAssetsWithExtensionsToDataFolder(extensionsToCopy)

    val modelPath: String
    val vocabPath: String
    val useMultilingual = true

    if (useMultilingual) {
      modelPath = getAssetFilePath("whisper-tiny.tflite")
      vocabPath = getAssetFilePath("filters_vocab_multilingual.bin")
    } else {
      modelPath = getAssetFilePath("whisper-tiny-en.tflite")
      vocabPath = getAssetFilePath("filters_vocab_en.bin")
    }

    mWhisper?.loadModel(modelPath, vocabPath, useMultilingual)
    mWhisper?.setListener(object : IWhisperListener {
      override fun onUpdateReceived(message: String) {
        //Log.d(mTAG, "Update received: $message")
      }

      override fun onResultReceived(result: String) {
        //eventSink?.success(result)
        activity?.runOnUiThread {
          eventSink?.success(result)
        }
      }
    })

    mRecorder?.setListener(object : IRecorderListener {
      override fun onUpdateReceived(message: String) {
        //Log.d(mTAG, "Update received: $message")
      }

      override fun onDataReceived(samples: FloatArray) {
        mWhisper?.writeBuffer(samples)
      }
    })
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  @RequiresApi(Build.VERSION_CODES.M)
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activity = null
    mWhisper = null
    mRecorder = null
  }

  @RequiresApi(Build.VERSION_CODES.M)
  private fun checkRecordPermission(): Boolean {
    val permission = ContextCompat.checkSelfPermission(activity!!, Manifest.permission.RECORD_AUDIO)
    return if (permission == PackageManager.PERMISSION_GRANTED) {
      true
    } else {
      activity?.requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), 0)
      false
    }
  }

  @RequiresApi(Build.VERSION_CODES.M)
  private fun startRecording(result:Result) {
    if (checkRecordPermission()) {
      result.success("permission granted")
      mRecorder?.start()
    }else{
      result.error("","permission denied","please grant permission")
    }
  }

  private fun stopRecording(result: Result) {
    mRecorder?.stop()
    result.success("recording stopped")
  }

  private fun startTranscription(waveFilePath: String) {
    mWhisper?.setFilePath(waveFilePath)
    mWhisper?.setAction(Whisper.ACTION_TRANSCRIBE)
    mWhisper?.start()
  }

  private fun stopTranscription() {
    mWhisper?.stop()
  }

  private fun getAssetFilePath( assetName: String): String {
    val assetManager = context.assets
    val outFile = File(context.filesDir, assetName)

    if (!outFile.exists()) {
      try {
        // Make sure to include the subdirectory in the asset path if necessary
        val assetPath = "model/$assetName"
        val inputStream = assetManager.open(assetPath)
        val outputStream = FileOutputStream(outFile)
        val buffer = ByteArray(1024)
        var length = inputStream.read(buffer)
        while (length != -1) {
          outputStream.write(buffer, 0, length)
          length = inputStream.read(buffer)
        }
        outputStream.close()
        inputStream.close()
      } catch (e: IOException) {
        Log.e(mTAG, "Failed to copy asset file: $assetName", e)
      }
    }

    Log.d(mTAG, "Returned asset path: ${outFile.absolutePath}")
    return outFile.absolutePath
  }


  // TODO: switch to download
  private fun copyAssetsWithExtensionsToDataFolder(extensions: Array<String>) {
    val assetManager = context.assets
    try {
      val destFolder = context.filesDir.absolutePath
      for (extension in extensions) {
        val assetFiles = assetManager.list("") ?: continue
        for (assetFileName in assetFiles) {
          if (assetFileName.endsWith(".$extension")) {
            val outFile = File(destFolder, assetFileName)
            if (outFile.exists()) continue

            assetManager.open(assetFileName).use { inputStream ->
              FileOutputStream(outFile).use { outputStream ->
                val buffer = ByteArray(1024)
                var read: Int
                while (inputStream.read(buffer).also { read = it } != -1) {
                  outputStream.write(buffer, 0, read)
                }
                outputStream.flush()
              }
            }
          }
        }
      }
    } catch (e: IOException) {
      e.printStackTrace()
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
}
